import Course, { CourseType } from '../database/models/Course';
import NavBar, { NavBarConfig } from '../components/NavBar';
import router from '@ohos.router';
import Logger from '../utils/Logger';

class CourseView{

}


@CustomDialog
struct CourseDetailDialog {
  dialogController?: CustomDialogController;
  course: Course;

  build() {
    Column() {
      Text()
      Text()
      Row() {
        Text()
        Column() {
          Text()
          Text()
          Text()
          Text()
        }
      }
    }
  }
}


@Entry
@Component
struct AllCoursePage {
  //导航栏控制条
  navBarConfig: NavBarConfig = {
    leftIcon: $r('app.media.icon_back'),
    title: "课表查询",
    onClickLeftButton: () => {
      router.back();
    }
  }

  //课程详细控制器
  courseDetailDialogController: CustomDialogController = new CustomDialogController({
    builder: CourseDetailDialog({}),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  //日期相关
  readonly weekDaysString: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  private dateInfo: Date;
  private weekDates: Date [];
  private courses: Course[]=[];

  aboutToAppear() {
    this.dateInfo = new Date();
    this.weekDates = this.getWeekDates(this.dateInfo);
  }

  onPageShow() {

  }

  //获得所在日一周的日期
  getWeekDates(date: Date): Date[] {
    const startOfWeek: Date = new Date(date);
    const dayOfWeek: number = startOfWeek.getDay(); // 获取给定日期是星期几
    const diff: number = (dayOfWeek === 0 ? 6 : dayOfWeek - 1); // 计算需要向前调整的天数
    startOfWeek.setDate(date.getDate() - diff); // 将日期调整到本周的第一天 (周一为一周的起始)
    const weekDates: Date[] = [];
    // 循环生成本周的日期
    for (let i = 0; i < 7; i++) {
      const currentDate: Date = new Date(startOfWeek);
      currentDate.setDate(startOfWeek.getDate() + i);
      weekDates.push(currentDate);
    }
    return weekDates;
  }


  //单个课程的可点击块
  @Builder CourseCube(course: Course) {
    Column() {
      //Todo 时间还可能需要处理
      Text(course.time)
      Text(course.location)
      Text(course.name)
    }
    .onClick(() => {

    })
  }

  //表示时间的ui，课表顶部使用
  @Builder DateCube(date: Date) {
    Column() {
      Text(this.weekDaysString[date.getDay()])
        .fontColor(date.getDate() == this.dateInfo.getDate() ? Color.Blue : Color.Black)
      Text((date.getMonth() + 1).toString() + '/' + date.getDate().toString())
        .fontColor(date.getDate() == this.dateInfo.getDate() ? Color.Blue : Color.Black)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  //课表顶部的DateBar
  @Builder DateBar() {
    Row() {

      Grid() {
        GridItem() {
          Column() {
            Text('星期')
            Text('日期')
          }
        }

        ForEach(this.weekDates, (item: Date, index: number) => {
          GridItem() {
            this.DateCube(item)
          }
        })
      }
      .columnsTemplate('1fr '.repeat(8).trim())
    }
    .height(40)

  }

  //课表核心主主体
  @Builder CourseTable() {
    Row() {
      Swiper() {
        List() {

        }
      }

    }
    .layoutWeight(1)
    .width("100%")
  }

  @Builder CourseLine(){
    Row(){
      Grid(){
        ForEach([1,2,3,4,5,6,7,8],(item:number,index:number)=>{
          GridItem(){
            CourseCube
          }
        })
      }
      .width('100%')
      .columnsTemplate('1fr '.repeat(8).trim())
    }
  }

  //课表底部
  @Builder CourseTableFooter() {
    Row() {
      Text('test database')
    }
    .width("100%")
    .backgroundColor(Color.Pink)
    .justifyContent(FlexAlign.Center)
    .height(40)
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Column() {
        this.DateBar()
        this.CourseTable()
        this.CourseTableFooter()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
  }
}