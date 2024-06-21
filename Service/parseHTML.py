import json
from bs4 import BeautifulSoup


# 解析课程表html
def parse_lesson(html):
    soup = BeautifulSoup(html, 'html.parser')


    courses = []

    # Part 1: Parsing the first table with id="dataList"
    data_list_table = soup.find('table', id='dataList')
    if data_list_table:
        rows = data_list_table.find_all('tr')[1:]  # Skip header row

        for row in rows:
            columns = row.find_all('td')
            courseId = columns[1].get_text(strip=True)
            name = columns[3].get_text(strip=True)
            teacher = columns[4].get_text(strip=True)
            time = columns[5].get_text(strip=True)
            credit = columns[6].get_text(strip=True)
            location = columns[7].get_text(strip=True).split(",")[0]
            courseType = 'Required' if columns[8].get_text(strip=True) == '必修' else 'Elective'

            # Default startWeek and endWeek to None (to be updated in Part 2)
            course = {
                'courseId': courseId,
                'name': name,
                'teacher': teacher,
                'credit': credit,
                'location': location,
                'courseType': courseType,
                'time': time,
                'startWeek': None,
                'endWeek': None
            }
            courses.append(course)

    # Part 2: Parsing the second table with id="kbtable"
    kb_table = soup.find('table', id='kbtable')
    if kb_table:
        rows = kb_table.find_all('tr')[1:]  # Skip header row
        for course in courses:
            name = course['name']
            # print(name)
            for row in rows:
                columns = row.find_all('td')
                for column in columns:
                    kb_divs = column.find('div', class_='kbcontent1')
                    if kb_divs:
                        # print(kb_divs.get_text)
                        course_name = column.find(string=name)
                        if course_name:
                            week_tag = course_name.find_next('font')
                            week = process_weeks(week_tag.text)
                            course['startWeek'] = week[0]
                            course['endWeek'] = week[1]

    return json.dumps(courses, ensure_ascii=False)


# 处理开课周数
def process_weeks(input_str):
    # print(input_str)
    if '-' in input_str:
        start_week, end_week = input_str.split('-')[0], input_str.split('-')[1].split('(')[0]
        return [int(start_week), int(end_week)]
    else:
        week = int(input_str.split('(')[0])
        return [week, week]


# 解析成绩html
def parse_score(html):
    soup = BeautifulSoup(html, 'html.parser')
    title_tag = soup.find('title')
    if title_tag is None or "学生个人考试成绩" not in title_tag.text:
        return json.dumps({"error": "查询失败，标题不匹配"})

    scores = []

    # 查找指定的<table>元素
    table = soup.find('table', id='dataList', class_='Nsb_r_list Nsb_table')
    if table:
        rows = table.find_all('tr')[1:]

        for row in rows:
            columns = row.find_all('td')
            id = columns[0].get_text(strip=True)
            courseId = columns[2].get_text(strip=True)
            courseName = columns[3].get_text(strip=True)
            credit = columns[6].get_text(strip=True)
            grade = columns[4].get_text(strip=True)
            testType = columns[8].get_text(strip=True)
            courseType = columns[10].get_text(strip=True)
            time = columns[1].get_text(strip=True)

            score = {
                'id': id,
                'courseId': courseId,
                'courseName': courseName,
                'credit': credit,
                'grade': grade,
                'testType': testType,
                'courseType': courseType,
                'time': time
            }
            scores.append(score)
        return json.dumps(scores, ensure_ascii=False)
    else:
        return json.dumps({"error": "未找到指定的表格"})


# 解析考试查询html
def parse_exam(html):
    soup = BeautifulSoup(html, 'html.parser')
    title_tag = soup.find('title')
    if title_tag is None or "我的考试 - 考试安排查询" not in title_tag.text:
        return json.dumps({"error": "查询失败，标题不匹配"})

    exams = []

    table = soup.find('table', id='dataList', class_='Nsb_r_list Nsb_table')

    if table:
        rows = table.find_all('tr')[1:]
        for row in rows:
            columns = row.find_all('td')
            id = columns[0].get_text(strip=True)
            examId = columns[1].get_text(strip=True)
            courseId = columns[2].get_text(strip=True)
            examName = columns[3].get_text(strip=True)
            location = columns[5].get_text(strip=True)
            seatId = columns[6].get_text(strip=True)
            time = columns[4].get_text(strip=True)

            exam = {
                'id': id,
                'examId': examId,
                'courseId': courseId,
                'examName': examName,
                'location': location,
                'seatId': seatId,
                'time': time
            }
            exams.append(exam)
        return json.dumps(exams, ensure_ascii=False)
    else:
        return json.dumps({"error": "未找到指定的表格"})


# 解析教学周历查询的html
def parse_semester(html):
    soup = BeautifulSoup(html,'html.parser')
    title_tag = soup.find('title')
    if title_tag is None or '教学周历查看' not in title_tag.text:
        return json.dumps({"error": "查询失败，标题不匹配"})
    else:
        # 查找包含学期信息的 <center> 元素
        center_font = soup.find('center').find('font', {'size': '4'})

        if center_font:
            text = center_font.get_text(strip=True)
            parts = text.split()
            if len(parts) >= 6:
                year_range = parts[0]
                semester_number = parts[3]
                return f"{year_range}-{semester_number}"

