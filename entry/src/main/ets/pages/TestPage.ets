import CourseTable from '../database/tables/CourseTable';
import ExamTable from '../database/tables/ExamTable';
import GradeTable from '../database/tables/GradeTable';
import TaskTable from '../database/tables/TaskTable';
import UserTable from '../database/tables/UserTable';
import Course from '../database/models/Course';
import Exam from '../database/models/Exam';
import Grade from '../database/models/Grade';
import Task from '../database/models/Task';
import User from '../database/models/User';

@Entry
@Component
struct TestPage {
  private courseTable = new CourseTable(() => {
  });
  private examTable = new ExamTable(() => {
  });
  private gradeTable = new GradeTable(() => {
  });
  private taskTable = new TaskTable(() => {
  });
  private userTable = new UserTable(() => {
  });

  aboutToAppear() {
    this.courseTable.getRdbStore();
    this.examTable.getRdbStore();
    this.gradeTable.getRdbStore();
    this.taskTable.getRdbStore();
    this.userTable.getRdbStore();
  }

  courseDemo: Course = {
    courseId: '12345',
    name: 'test_class',
    teacher: 'test_teacher',
    credit: 1.5,
    location: 'test_location',
    courseType: 'Required',
    time: "test_time"
  };
  examDemo: Exam = {
    examId: '1234',
    courseId: '222222',
    location: 'test_place',
    seatId: 12,
    time: 1111
  };
  gradeDemo: Grade = {
    courseId: '1111',
    courseName: 'test_name',
    credit: 1.5,
    grade: '92',
    testType: "Exam",
    gpa: 4,
    time: 12333
  };
  taskDemo: Task = {
    content: 'task',
    isFinished: 0,
    priority: 1,
    alertTime: 1233,
    startTime: 123333,
    endTime: 2222,
    createTime: 222,
    updateTime: 1111
  };
  userDemo: User = {
    studentId: '11111',
    name: 'www',
    password: '11111',
    lastUpdateTime: 1123
  };

  build() {
    Column() {
      Button() {
        Text('test courseTable')
      }
      .onClick(() => {
        this.courseTable.getRdbStore(() => {
          this.courseTable.insertData(this.courseDemo, (succeed: boolean) => {
            if (succeed) {
              let i = 1;
            } else {
              let i = 0;
            }
          })
        })
      })

      Button() {
        Text('test examTable')
      }
      .onClick(() => {
        this.examTable.getRdbStore(() => {
          this.examTable.insertData(this.examDemo, (succeed: boolean) => {
            if (succeed) {
              let i = 1;
            } else {
              let i = 0;
            }
          })
        })
      })

      Button() {
        Text('test gradeTable')
      }
      .onClick(() => {
        this.gradeTable.insertData(this.gradeDemo, (succeed: boolean) => {
          if (succeed) {
            let i = 1;
          } else {
            let i = 0;
          }
        })
      })

      Button() {
        Text('test taskTable')
      }
      .onClick(() => {
        this.taskTable.insertData(this.taskDemo, (succeed: boolean) => {
          if (succeed) {
            let i = 1;
          } else {
            let i=0;
          }
        })
      })

      Button() {
        Text('test userTable')
      }
      .onClick(() => {
        this.userTable.insertData(this.userDemo,(succeed:boolean)=>{
          if(succeed){
            let i=1;
          }else{
            let i=0;
          }
        })
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height("100%")
  }
}