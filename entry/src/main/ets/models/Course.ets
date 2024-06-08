export enum CourseType {//课程属性
  Required = "Required",
  Elective = "Elective"
}

//Todo:更好的命名
export enum TestType{//考察方式
  Exam="Exam",//考试
  Evaluation="Evaluation"//考察
}


export default class Course {
  id: string;
  name: string;
  teacher: string;
  credit: number;//学分
  location: string;
  courseType: string;//课程类型
  time: string;//时间有多种，这里使用 string，后面做中间层适配
  testType:string;//考察方式
  grade:string;
}

