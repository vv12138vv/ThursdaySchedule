//Todo:更好的命名
export enum TestType { //考察方式
  Exam = "Exam", //考试
  Evaluation = "Evaluation" //考察
}


export default class Grade{
  id:number;
  courseId:string;
  courseName:string;
  grade:string;
  testType: string; //考察方式
  gpa: number;
  time:number;
}