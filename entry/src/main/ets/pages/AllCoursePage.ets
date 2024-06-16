import Course, { CourseType } from '../database/models/Course';
import NavBar, { NavBarConfig } from '../components/NavBar';
import router from '@ohos.router';
import Logger from '../utils/Logger';


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

  //滚动控制器
  private swiperController=new SwiperController();

  //日期相关
  readonly weekDaysString: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  private todayDateInfo: Date;
  @State weekDates: Date [] = [];
  @State curShowWeek:string="第十六周";
  private courses: Course[] = [];
  coursesInWeek: (Course | null)[] = Array.from({ length: 120 }, () => null);

  aboutToAppear() {
    this.todayDateInfo = new Date();
    this.weekDates = this.getWeekDates(this.todayDateInfo);
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


  //表示时间的ui，课表顶部使用
  @Builder DateCube(date: Date) {
    Column() {
      Text(this.weekDaysString[date.getDay()])
        .fontColor(date.getDate() == this.todayDateInfo.getDate() ? Color.Blue : Color.Black)
      Text((date.getMonth() + 1).toString() + '/' + date.getDate().toString())
        .fontColor(date.getDate() == this.todayDateInfo.getDate() ? Color.Blue : Color.Black)
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

  @Builder EmptyCourseCube(idx: number | null) {
    Column() {
      if (idx != null) {
        Text(idx.toString())
          .fontSize(20)
      }
    }
    .height(64)
    .justifyContent(FlexAlign.Center)
  }

  //课表核心主主体
  @Builder CourseTable(coursesInWeek: (Course | null)[]) {
    Row() {
      Grid() {
        ForEach(coursesInWeek, (value: Course | null, index: number) => {
          GridItem() {
            if (index % 8 === 0) {
              this.EmptyCourseCube(Math.floor(index / 8) + 1)
            } else if (value === null) {
              this.EmptyCourseCube(null)
            } else {
              this.EmptyCourseCube(index)
            }
          }
          .border({ width: { bottom: 0.5 }, })
        })
      }
      .columnsTemplate('1fr '.repeat(8).trim())
      .columnsGap(5)
    }
    .layoutWeight(1)
    .width("100%")
  }


  //课表底部
  @Builder CourseTableFooter() {
    Row() {
      Stack() {
        Text(this.weekDaysString[this.todayDateInfo.getDay()])
      }
      .layoutWeight(1)

      Stack() {
        Row(){
          Button(){
            Image($r('app.media.icon_back'))
              .width(16)
          }
          .backgroundColor(Color.Transparent)
          .onClick((event?:ClickEvent)=>{
            this.swiperController.showPrevious();
          })
          Text(this.curShowWeek)
          Button(){
            Image($r('app.media.icon_forward'))
              .width(16)
          }
          .backgroundColor(Color.Transparent)
          .onClick((event?:ClickEvent)=>{
            this.swiperController.showNext();
          })
        }
        .width(100)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(6)

      Stack() {
      }
      .layoutWeight(1)

    }
    .width("100%")
    .height($r("app.float.nav_bar_height"))
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.nav_bar_background_color'))
    .alignItems(VerticalAlign.Center)
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Column() {
        this.DateBar()
        Swiper(this.swiperController) {
          this.CourseTable(this.coursesInWeek)
          this.CourseTable(this.coursesInWeek)
          this.CourseTable(this.coursesInWeek)
        }
        .loop(false)
        .index(0)
        .layoutWeight(1)
        .indicator(false)
        this.CourseTableFooter()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
  }
}