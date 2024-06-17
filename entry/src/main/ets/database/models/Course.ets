export enum CourseType { //课程属性
  Required = "Required",
  Elective = "Elective"
}


@Observed
export default class Course {
  id?: number; //主键，与业务无关
  courseId: string; //业务主键
  name: string;
  teacher: string;
  credit: number; //学分
  location: string;
  courseType: string; //课程类型
  startWeek:number;//开课周
  endWeek:number;//结课周
  time: string; //时间有多种，这里使用 string，后面做中间层适配
}



export let courseDemo:Course={
  courseId:'06036101',
  name:'高性能计算引论',
  teacher:'李翔宇',
  credit:2,
  location:'I-206',
  courseType:CourseType.Required,
  time:"星期一(02-04小节);星期五(02-04小节)",
  startWeek:9,
  endWeek:16
}
