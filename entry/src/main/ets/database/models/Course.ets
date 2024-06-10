export enum CourseType { //课程属性
  Required = "Required",
  Elective = "Elective"
}


@Observed
export default class Course {
  id: number; //主键，与业务无关
  courseId: string; //业务主键
  name: string;
  teacher: string;
  credit: number; //学分
  location: string;
  courseType: string; //课程类型
  time: string; //时间有多种，这里使用 string，后面做中间层适配
}




