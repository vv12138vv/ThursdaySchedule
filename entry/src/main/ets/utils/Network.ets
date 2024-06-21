import axios from '@ohos/axios'
import Course from '../database/models/Course'
import Grade from '../database/models/Grade'
import Exam from '../database/models/Exam'
import {URL} from  '../constants/URL'

export class Network{
  static readonly baseURL = URL.baseURL

  // 获取验证码图片，返回值为string类型的base64编码
  /*
   * 需要异步调用
   * 例如：async showVerifyCode():Promise<void>{ const imgSrc = await getVerifyCode(); }
   * */
  static async getVerifyCode():Promise<string>{
    let imgSrc = ''
    const response = await axios.get(`${Network.baseURL}/verifycode`);
    if(response.status === 200){
      let imageBase64 = response.data['imageBase64']
      imgSrc = `data:image/jpeg;base64,${imageBase64}`
    } else {
      console.error("---verifyCode connection error")
    }
    return imgSrc
  }

  // 登录，正确登录则返回用户姓名和学号，例如王一涵(123456),登录错误则返回"error"
  static async userLogin(uid:string, upwd:string,verifyCode:string):Promise<string>{
    let result: string =''
    const response = await axios.post(`${this.baseURL}/login`,{
      'USERNAME':uid,
      'PASSWORD':upwd,
      'RANDOMCODE':verifyCode
    })
      if(response.status === 200) {
        result = response.data.data;
      } else {
        result = "error"
      }
    return result
  }

  static async getLesson():Promise<Course[]>{
    let lessons:Course[] = []
    const response = await axios.get(`${Network.baseURL}/lessons`)
    if (response.status === 200) {
      const jsonArray = JSON.parse(response.data.lessons); // JSON array对象
      // console.log("---jsonArray type",typeof(jsonArray))
      jsonArray.forEach((jsonObj:any)=>{
        let course:Course = {
          courseId : jsonObj.courseId,
          name : jsonObj.name,
          teacher : jsonObj.teacher,
          credit : Number(jsonObj.credit),
          location : jsonObj.location,
          courseType : jsonObj.courseType,
          startWeek : Number(jsonObj.startWeek),
          endWeek : Number(jsonObj.endWeek),
          time : jsonObj.time,
        }
        lessons.push(course);
      })
    }
    return lessons
  }

  // 获取当前学期，如‘2023-2024-1’
  static async getCurrentSemester():Promise<string>{
    const response = await axios.get(`${Network.baseURL}/semester`)
    if (response.status === 200) {
      const semester = JSON.stringify(response.data.semester)
      return semester
    } else {
      return 'get semester error'
    }
  }

  static async getScore():Promise<Grade[]>{
    let grades:Grade[] = [];
    const response = await axios.get(`${Network.baseURL}/score`)
    if(response.status === 200){
      const jsonArray = JSON.parse(response.data.score);
      jsonArray.forEach((jsonObj:any)=>{
        let g:Grade = {
          id:jsonObj.id,
          courseId:jsonObj.courseId,
          courseName:jsonObj.courseName,
          credit:Number(jsonObj.credit),
          grade:jsonObj.grade,
          testType:jsonObj.testType,
          courseType:jsonObj.courseType,
          gpa: null,
          time:jsonObj.time
        }
        grades.push(g);
      })
    }
    return grades
  }

  //time:查询学期，如”2023-2024-2“
  static async getExam(time:string):Promise<Exam[]>{
    let exams:Exam[] = []
    const response = await axios.post(`${Network.baseURL}/exam`,{'time':time})
    if (response.status === 200){
      const jsonArray = JSON.parse(response.data.exams)
      jsonArray.forEach((jsonObj:any)=>{
        let e:Exam = {
          id:jsonObj.id,
          examId:jsonObj.examId,
          examName:jsonObj.examName,
          courseId:jsonObj.courseId,
          location:jsonObj.location,
          seatId:Number(jsonObj.seatId),
          time:jsonObj.time,
        }
        exams.push(e)
      })
    }
    return exams
  }
}