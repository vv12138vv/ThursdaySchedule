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
  //课程详细对话框控制器
  courseDetailDialogController: CustomDialogController = new CustomDialogController({
    builder: CourseDetailDialog({}),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  //滚动控制器
  private swiperController = new SwiperController();

  //日期相关
  readonly weekDaysString: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  private todayDateInfo: Date;
  //当前周数
  curWeek: number;
  showWeek: number;
  //当前学期的起始日期
  termStartDate: Date = new Date('2024-02-26');
  //所有周的日期
  allWeekStartDates: Date[][] = [];
  @State showWeekDates: Date [] = [];
  @State showWeekString: string = "第1周";
  coursesInWeek: (Course | null)[] = Array.from({ length: 120 }, () => null);

  aboutToAppear() {
    //获得自学期开始时 25周的起始日期
    this.allWeekStartDates = this.getAllWeekStartDates(this.termStartDate, 25);
    //今日日期
    this.todayDateInfo = this.getStartOfDay(new Date());
    //今日所属周的偏移
    let weekDiff = this.getWeekDiff(this.termStartDate, this.todayDateInfo);
    this.curWeek = weekDiff + 1;
    this.showWeek = this.curWeek;
    //当前显示的周数据
    this.showWeekDates = this.allWeekStartDates[weekDiff];
    //当前显示第几周
    this.showWeekString = '第' + this.showWeek.toString() + '周';
  }

  //获得某日的起始点
  getStartOfDay(date: Date): Date {
    // 创建一个新的 Date 对象，设置为指定日期的年、月、日的 00:00:00
    const startOfDay = new Date(date.getFullYear(), date.getMonth(), date.getDate());
    return startOfDay;
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

  getWeekDiff(startDate: Date, endDate: Date): number {
    // 计算日期之间的毫秒数差
    const timeDifference = endDate.getTime() - startDate.getTime();
    // 将毫秒数差转换为天数差，再转换为周数差
    const daysDifference = Math.ceil(timeDifference / (1000 * 3600 * 24));
    const weeksDifference = Math.floor(daysDifference / 7);
    return weeksDifference;
  }

  getAllWeekStartDates(start: Date, weekNum: number): Date[][] {
    let startDate = new Date(start);
    let weeksDates: Date [][] = [];

    // 循环获取 20 个周的日期数据
    for (let i = 0; i < weekNum; i++) {
      // 计算当前周的起始日期和结束日期
      const dayOfWeek = startDate.getDay(); // 获取当前日期是星期几
      const diffDays = dayOfWeek === 0 ? 6 : dayOfWeek - 1; // 计算当前日期距离上一个星期一的天数差

      // 获取当前周的起始日期（星期一）
      const currentStartDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() - diffDays);

      let weekDate = this.getWeekDates(currentStartDate);
      // 添加到结果数组
      weeksDates.push(weekDate);

      // 将 startDate 设置为下一周的起始日期
      startDate.setDate(startDate.getDate() + 7);
    }
    return weeksDates;
  }

  //表示时间的ui，课表顶部使用
  @Builder DateCube(date: Date) {
    Column() {
      Text(this.weekDaysString[date.getDay()])
        .fontColor(date.getTime() === this.todayDateInfo.getTime() ? Color.Blue : Color.Black)
      Text((date.getMonth() + 1).toString() + '/' + date.getDate().toString())
        .fontColor(date.getTime() === this.todayDateInfo.getTime() ? Color.Blue : Color.Black)
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

        ForEach(this.showWeekDates, (item: Date, index: number) => {
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
      Stack(){

      }
      .layoutWeight(1)
      Stack() {
        Row() {
          Button() {
            Image($r('app.media.icon_back'))
              .width(16)
          }
          .backgroundColor(Color.Transparent)
          .onClick((event?: ClickEvent) => {
            this.swiperController.showPrevious();
          })

          Text(this.showWeekString)
          Button() {
            Image($r('app.media.icon_forward'))
              .width(16)
          }
          .backgroundColor(Color.Transparent)
          .onClick((event?: ClickEvent) => {
            this.swiperController.showNext();
          })
        }
        .width(100)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(6)
      Stack(){

      }
      .layoutWeight(1)

    }
    .width("100%")
    .height($r("app.float.nav_bar_height"))
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.nav_bar_background_color'))
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Column() {
        this.DateBar()
        Swiper(this.swiperController) {
          ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20], (item: number, index: number) => {
            this.CourseTable(this.coursesInWeek)
          })
        }
        .loop(false)
        .index(this.curWeek - 1)
        .layoutWeight(1)
        .indicator(false)
        .cachedCount(3)
        .autoPlay(false)
        .onChange((index: number) => {
          this.showWeek = index + 1;
          this.showWeekDates = this.allWeekStartDates[index];
          this.showWeekString = '第' + this.showWeek.toString() + '周';
        })
        this.CourseTableFooter()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
  }
}