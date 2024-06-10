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

// function canBeNumber(gradeString: string) {
//   return !isNaN(Number(gradeString));
// }
//
// export function gradeToGPA(gradeString: string): number {
//   if (canBeNumber(gradeString)) {
//     let grade: number = Number(gradeString);
//     if (grade >= 90) {
//       return 4.0;
//     } else if (grade < 90 && grade >= 85) {
//       return 3.7;
//     } else if (grade < 85 && grade >= 80) {
//       return 3.3;
//     }else if(grade>=75&&grade)
//   }else {
//
//   }
// }



