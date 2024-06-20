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
  startWeek: number; //开课周
  endWeek: number; //结课周
  time: string; //时间有多种，这里使用 string，后面做中间层适配
}


export let courseDemo: Course = {
  courseId: '06036101',
  name: '高性能计算引论',
  teacher: '李翔宇',
  credit: 2,
  location: 'I-206',
  courseType: CourseType.Required,
  time: "星期二(02-03小节);星期四(02-03小节)",
  startWeek: 9,
  endWeek: 16
}

//展示层 CourseView
export class CourseView {
  id: number;
  courseId: string;
  name: string;
  teacher: string;
  credit: number;
  location: string;
  courseType: string;
  startWeek: number;
  endWeek: number;
  weekday: number; //周几
  courseSeq: number; //当天课序号

  static fromCourse(course: Course): CourseView[] {
    let res: CourseView[] = [];
    const parseRes = CourseView.parseScheduleString(course.time);
    parseRes.forEach((time: [number, number], index: number) => {
      res.push({
        id: course.id,
        courseId: course.courseId,
        name: course.name,
        teacher: course.teacher,
        credit: course.credit,
        location: course.location,
        courseType: course.courseType,
        startWeek: course.startWeek,
        endWeek: course.endWeek,
        weekday: time[0],
        courseSeq: time[1]
      })
    })
    return res;
  }

  private static parseScheduleString(scheduleString: string): [number, number][] {
    const result: [number, number][] = [];
    // 映射星期到数字
    const dayMap: { [key: string]: number } = {
      "星期一": 1,
      "星期二": 2,
      "星期三": 3,
      "星期四": 4,
      "星期五": 5,
      "星期六": 6,
      "星期日": 7
    };
    // 按分号拆分字符串以获取每个单独的时间段
    const parts = scheduleString.split(';');

    for (const part of parts) {
      // 使用正则表达式匹配星期和小节部分
      const match = part.match(/(星期[一二三四五六日])\((\d{2})-(\d{2})小节\)/);
      if (match) {
        const dayString = match[1];
        const startPeriod = parseInt(match[2], 10);
        const endPeriod = parseInt(match[3], 10);
        // 将星期转换为对应的数字
        const day = dayMap[dayString];
        // 生成小节范围数组
        for (let period = startPeriod; period <= endPeriod; period++) {
          result.push([day, period]);
        }
      }
    }
    return result;
  }

  static readonly courseSeqToTime: Map<number, string[]> = new Map([
    [1, ['08:00', '08:45']],
    [2, ['08:50', '09:35']],
    [3, ['09:40', '10:25']],
    [4, ['10:40', '11:25']],
    [5, ['11:30', '12:15']],
    [6, ['14:00', '14:45']],
    [7, ['14:50', '15:35']],
    [8, ['15:50', '16:35']],
    [9, ['16:40', '17:25']],
    [10, ['17:30', '18:15']],
    [11, ['19:00', '19:45']],
    [12, ['19:50', '20:35']],
    [13, ['20:40', '21:25']],
    [14, ['21:30', "21:30"]]
  ]);

  static getCourseSeqStartTime(courseSeq: number): string {
    return CourseView.courseSeqToTime.get(courseSeq)[0];
  }

  static getCourseSeqEndTime(courseSeq: number): string {
    return CourseView.courseSeqToTime.get(courseSeq)[1];
  }

  static courseSeqToTimeString(courseSeq: number): string {
    let res: string = "";
    res = CourseView.getCourseSeqStartTime(courseSeq) + '-' + CourseView.getCourseSeqEndTime(courseSeq);
    return res;
  }
}