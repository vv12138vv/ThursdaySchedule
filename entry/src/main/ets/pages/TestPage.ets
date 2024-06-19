import CourseTable from '../database/tables/CourseTable';
import ExamTable from '../database/tables/ExamTable';
import GradeTable from '../database/tables/GradeTable';
import TaskTable from '../database/tables/TaskTable';
import UserTable from '../database/tables/UserTable';
import Course, { CourseType } from '../database/models/Course';
import Exam from '../database/models/Exam';
import Grade from '../database/models/Grade';
import Task from '../database/models/Task';
import User from '../database/models/User';

//用于测试数据库相关
@Entry
@Component
struct TestPage {
  // private courseTable = new CourseTable(() => {
  // });
  // private examTable = new ExamTable(() => {
  // });
  // private gradeTable = new GradeTable(() => {
  // });
  // private taskTable = new TaskTable(() => {
  // });
  // private userTable = new UserTable(() => {
  // });

  aboutToAppear() {
    // this.courseTable.getRdbStore();
    // this.examTable.getRdbStore();
    // this.gradeTable.getRdbStore();
    // this.taskTable.getRdbStore();
    // this.userTable.getRdbStore();
  }

  courseDemo: Course = {
    courseId: '123435',
    name: 'test_cla4ss',
    teacher: 'test_tea4cher',
    credit: 1.5,
    location: 'test_locat5ion',
    courseType: 'Required',
    startWeek:1,
    endWeek:2,
    time: "test_ti6me"
  };
  examDemo: Exam = {
    examId: '12234',
    courseId: '222222',
    location: 'test_place',
    seatId: 12,
    time: '1111'
  };
  gradeDemo: Grade = {
    courseId: '11211',
    courseName: 'test3_name',
    credit: 1.5,
    grade: '92',
    testType: "Exam",
    courseType:CourseType.Required,
    gpa: 4,
    time: '2222'
  };
  taskDemo: Task = {
    content: 'ta222sk',
    isFinished: 0,
    priority: 1,
    alertTime: 1233,
    startTime: 123333,
    endTime: 2222,
    createTime: 222,
    updateTime: 1111
  };
  userDemo: User = {
    studentId: '11113231',
    name: 'ww4w',
    password: '1111321',
    lastUpdateTime: 1123
  };

  build() {
    Row() {

      Column() {
        Button() {
          Text('add course')
        }
        .onClick(() => {
          CourseTable.getRdbStore(() => {
            CourseTable.insertData(this.courseDemo, (succeed: boolean) => {
              if (succeed) {
                let i = 1;
              } else {
                let i = 0;
              }
            })
          })
        })

        Button() {
          Text('add exam')
        }
        .onClick(() => {
          ExamTable.getRdbStore(() => {
            ExamTable.insertData(this.examDemo, (succeed: boolean) => {
              if (succeed) {
                let i = 1;
              } else {
                let i = 0;
              }
            })
          })
        })

        Button() {
          Text('add grade')
        }
        .onClick(() => {
          GradeTable.insertData(this.gradeDemo, (succeed: boolean) => {
            if (succeed) {
              let i = 1;
            } else {
              let i = 0;
            }
          })
        })

        Button() {
          Text('add task')
        }
        .onClick(() => {
          TaskTable.insertData(this.taskDemo, (succeed: boolean) => {
            if (succeed) {
              let i = 1;
            } else {
              let i = 0;
            }
          })
        })

        Button() {
          Text('add user')
        }
        .onClick(() => {
          UserTable.insertData(this.userDemo, (succeed: boolean) => {
            if (succeed) {
              let i = 1;
            } else {
              let i = 0;
            }
          })
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height("100%")

      Column() {
        Button() {
          Text('select course')
        }
        .onClick(() => {
          let course: Course[];
          CourseTable.selectDataAll((result: Course[]) => {
            course = result;
          })
        })

        Button() {
          Text('select exam')
        }
        .onClick(() => {
          let exam: Exam[];
          ExamTable.selectDataAll((result: Exam[]) => {
            exam = result;
          })
        })

        Button() {
          Text('select grade')
        }
        .onClick(() => {
          let grade: Grade[];
          GradeTable.selectDataAll((result: Grade[]) => {
            grade = result;
          })
        })

        Button() {
          Text('select task')
        }
        .onClick(() => {
          let task: Task[];
          TaskTable.selectDataAll((result: Task[]) => {
            task = result;
          })
        })

        Button() {
          Text('select user')
        }
        .onClick(() => {
          let user: User[];
          UserTable.selectDataAll((result: User[]) => {
            user = result;
          })
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height("100%")
    }
  }
}