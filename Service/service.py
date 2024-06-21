from flask import Flask, request, jsonify, session as flask_session
import requests
import base64
import parseHTML as parse
from bs4 import BeautifulSoup
import JWC_URL as api
app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Change to a secure key

verifyCode_url = api.JWC_URL.verifyCode_url
login_url = api.JWC_URL.login_url
lesson_url = api.JWC_URL.lesson_url
score_url = api.JWC_URL.score_url
exam_url = api.JWC_URL.exam_url
semester_url = api.JWC_URL.semester_url
home_url = api.JWC_URL.home_url


s = requests.Session()

@app.route("/verifycode", methods=['GET'])
def verifycode():
    response = s.get(verifyCode_url)
    if response.status_code == 200:
        image_base64 = base64.b64encode(response.content).decode('utf-8')
        return jsonify({'imageBase64': image_base64})
    else:
        return jsonify({'error': 'query error'}), 500


@app.route('/login', methods=['POST'])
def login():
    data = request.json
    userID = data.get('USERNAME')
    password = data.get('PASSWORD')
    verifyCode = data.get('RANDOMCODE')

    if not all([userID, password, verifyCode]):
        return jsonify({'error': 'Missing parameters'}), 400

    login_payload = {
        'USERNAME': userID,
        'PASSWORD': password,
        'useDogCode': '',
        'RANDOMCODE': verifyCode
    }

    response = s.post(login_url, data=login_payload)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        if checkLogin(soup,"学生个人中心"):
            username = soup.find('div', id='Top1_divLoginName').contents[0]
            return jsonify({'message': 'Login successful', 'data': username}), 200
        else:
            return jsonify({'error': 'not Login'}), 400
    else:
        return jsonify({'error': 'query failed'}), 401


@app.route('/home', methods=['GET'])
def home():
    response = s.get(home_url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        title_tag = soup.find('title')
        if checkLogin(soup,"学生个人中心"):
            username = soup.find('div', id='Top1_divLoginName').contents[0]
            return jsonify({'message': 'Login successful', 'data': username}), 200
        else:
            return jsonify({'error': 'not Login'}), 400
    else:
        return jsonify({'error': 'query failed'}), 401


@app.route("/lessons", methods=['GET'])
def lessons():
    response = s.get(lesson_url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        if checkLogin(soup, "学期理论课表"):
            result = parse.parse_lesson(response.text)
            return jsonify({'status': 'success', 'lessons': result}), 200
        else:
            return jsonify({'error': 'please Login first!'}), 400
    else:
        return jsonify({'error': 'query failed'}), 401


@app.route("/score", methods=['GET'])
def getScore():
    response = s.post(score_url, data={
        'kksj':'',
        'kcxz':'',
        'kcmc':'',
        'xsfs': max
    })
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        if checkLogin(soup, "学生个人考试成绩"):
            result = parse.parse_score(response.text)
            return jsonify({'status':'success', 'score':result}), 200
        else:
            return jsonify({'error': 'please Login first!'}), 400
    else:
        return jsonify({'error': 'query error'}), 400


@app.route('/exam', methods=['POST'])
def exams():
    data = request.json
    time = data['time']

    if not time:
        return jsonify({'error': 'missing time'}), 400

    payload = {
        'xnxqid':time
    }
    response = s.post(exam_url, data=payload)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        if checkLogin(soup,"我的考试 - 考试安排查询"):
            result = parse.parse_exam(response.text)
            return jsonify({'status':'success', 'exams':result}), 200
        else:
            return jsonify({'error': 'please Login first!'}), 400
    else:
        return jsonify({'error': 'query error'}), 401


# 查询当前所在学期
@app.route("/semester", methods=['GET'])
def semester():
    response = s.get(semester_url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        if checkLogin(soup,"教学周历查看"):
            result = parse.parse_semester(response.text)
            return jsonify({'status':'success', 'semester':result}), 200
        else:
            return jsonify({'error': 'please Login first!'}), 400
    else:
        return jsonify({'error': 'query error'}), 401


def checkLogin(soup,exception_string):
    title_tag = soup.find('title')
    if title_tag is None or exception_string not in title_tag.text:
        return False
    else:
        return True


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6005)
