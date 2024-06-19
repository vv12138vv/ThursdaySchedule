
@Observed
export default class Exam{
  id?:number;//非业务主键
  examId:string;//考试id
  courseId:string;//课程好
  examName:string//考试名称
  location:string;//考试地点
  seatId:number;//座位号
  time:string;//考试时间
}

export let examDemo:Exam={
  examId:'10014',//业务主键
  courseId:'10012',
  examName:'计算机体系结构',
  location:'Ⅳ-C205',
  seatId:49,//座位号
  time:'2024-6-26 13:30~15:30'
}

export class ExamView {

  id:number;//非业务主键
  examId:string;//业务主键
  courseId:string;//
  examName:string
  location:string;
  seatId:number;//座位号
  time:string;
  restTime:number//还剩几天

  static fromExam(exam: Exam): ExamView[] {
    let res: ExamView[] = [];
    res.push({
      id : exam.id,
      examId:exam.examId,
      courseId:exam.courseId,
      examName:exam.examName,
      location:exam.location,
      seatId:exam.seatId,
      time:exam.time,
      restTime:0
    })
    return res;
  }

}