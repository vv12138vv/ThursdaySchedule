import Course, { CourseType } from '../database/models/Course';
import NavBar, { NavBarConfig } from '../components/NavBar';
import router from '@ohos.router';
import Logger from '../utils/Logger';
import { courseDemo } from '../database/models/Course';

class CourseView {
  id: number;
  courseId: string;
  name: string;
  teacher: string;
  credit: number;
  location: string;
  courseType: string;
  startWeek: number;
  endWeek: number;
  weekday: number;//周几
  courseSeq: number;//当天课序号

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

  static parseScheduleString(scheduleString: string): [number, number][] {
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

  static courseSeqToTime: Map<number, string> = new Map([
    [1,'08:00'],
    [2,'08:50'],
    [3,'09:40'],
    [4,'10:40'],
    [5,'11:30'],
    [6,'14:00'],
    [7,'14:50'],
    [8,'15:50'],
    [9,'16:40'],
    [10,'17:30'],
    [11,'19:00'],
    [12,'19:50'],
    [13,'20:40']
  ]);
}

//Todo Dialog
@CustomDialog
struct CourseDetailDialog {
  dialogController?: CustomDialogController;
  courseView: CourseView;

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
  readonly TOTAL_COURSE_CUBE:number=112;
  coursesInWeek: (CourseView | null)[] = Array(this.TOTAL_COURSE_CUBE).fill(null);
  private courseViews: CourseView[] = [];
  courseSchedule: (CourseView | null)[][] = Array.from({ length: 24 }, () => Array(this.TOTAL_COURSE_CUBE).fill(null));

  aboutToAppear() {
    //获得自学期开始时 25周的起始日期
    this.allWeekStartDates = this.getAllWeekStartDates(this.termStartDate, 24);
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


    //预载课程
    this.courseViews = CourseView.fromCourse(courseDemo);
    this.courseViews.forEach((item: CourseView, index: number) => {
      for (let i = item.startWeek;i <= item.endWeek; i += 1) {
        let idx = item.weekday + (item.courseSeq - 1) * 8;
        this.courseSchedule[i-1][idx] = item;
      }
    })
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
  @Builder CourseCube(courseView: CourseView) {
    Column() {
      Text(CourseView.courseSeqToTime.get(courseView.courseSeq))
        .fontSize(10)
      Text(courseView.location)
        .fontSize(10)
      Text(courseView.name)
        .fontSize(10)
    }
    .height(72)
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Pink)
    .onClick(() => {
      this.courseDetailDialogController.open();
    })
  }

  @Builder EmptyCourseCube(idx: number | null) {
    Column() {
      if (idx != null) {
        Text(idx.toString())
          .fontSize(20)
      }
    }
    .height(72)
    .width("100%")
    .justifyContent(FlexAlign.Center)
  }

  //课表核心主主体
  @Builder CourseTable(coursesInWeek: (CourseView | null)[]) {
    Row() {
      Grid() {
        ForEach(coursesInWeek, (value: CourseView | null, index: number) => {
          GridItem() {
            if (index % 8 === 0) {
              this.EmptyCourseCube(Math.floor(index / 8) + 1)
            } else if (value === null) {
              this.EmptyCourseCube(null)
            } else {
              this.CourseCube(value)
            }
          }
          .border({ width: { bottom: 0.5 } })
        })
      }
      .columnsTemplate('1fr '.repeat(8).trim())
      .columnsGap(5)
      .rowsGap(2)
    }
    .layoutWeight(1)
    .width("100%")
  }


  //课表底部
  @Builder CourseTableFooter() {
    Row() {
      Stack() {

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

      Stack() {

      }
      .layoutWeight(1)

    }
    .width("100%")
    .height($r("app.float.course_page_footer_height"))
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.nav_bar_background_color'))
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Column() {
        this.DateBar()
        Swiper(this.swiperController) {
          ForEach(this.courseSchedule, (item: (CourseView | null)[], index: number) => {
            this.CourseTable(item)
          })
        }
        .loop(false)
        .index(this.curWeek - 1)
        .layoutWeight(1)
        .indicator(false)
        .cachedCount(4)
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