import Course, { CourseType } from '../database/models/Course';
import NavBar, { NavBarConfig } from '../components/NavBar';
import router from '@ohos.router';
import Logger from '../utils/Logger';
import { courseDemo } from '../database/models/Course';
import { CourseView } from '../database/models/Course';
import DateUtils from '../utils/DateUtils';
import CourseTable from '../database/tables/CourseTable';
import DataPool from '../utils/DataPool';
import {theme} from '../components/theme';

@CustomDialog
export struct CourseDetailDialog {
  dialogController?: CustomDialogController;
  @Link courseView: CourseView;

  build() {
    Column() {
      Row() {
        Text(this.courseView.courseType == CourseType.Required ? "必修" : "选修")
        Text(this.courseView.name)
          .fontSize(32)
        Button() {
          Image($r("app.media.icon_show_less"))
            .width(16)
            .onClick(() => {
              this.dialogController.close();
            })
        }
        .backgroundColor(Color.Transparent)
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width("100%")

      Column() {
        Text(CourseView.courseSeqToTimeString(this.courseView.courseSeq))
        Text(this.courseView.teacher + ' (任课教师)')
        Text(this.courseView.location + ' (上课地点) ')
        Text(this.courseView.startWeek + '-' + this.courseView.endWeek + ' (课程周数) ')
        Text(this.courseView.credit + ' (课程学分) ')
      }
      .layoutWeight(6)
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(HorizontalAlign.Start)
    }
    .width("100%")
    .height("25%")
    .backgroundColor($r('app.color.course_cube_detail_dialog_background_color'))
  }
}


function generateHash(input: string): number {
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    hash = ((hash << 5) - hash) + input.charCodeAt(i);
    hash |= 0; // Convert to 32bit integer
  }
  return hash;
}


@Entry
@Component
struct AllCoursePage {

  @StorageLink('bgpage') bgpage: number = 1;
  @StorageLink('SystemColor') Sys_color: number = 1
  //导航栏控制条
  navBarConfig: NavBarConfig = {
    leftIcon: $r("app.media.icon_show_less"),
    title: "课表查询",
    onClickLeftButton: () => {
      router.back();
    }
  }
  //课程详细对话框控制器
  courseDetailDialogController: CustomDialogController = new CustomDialogController({
    builder: CourseDetailDialog({
      courseView: $forDetailCourseView
    }),
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
  readonly TOTAL_COURSE_CUBE: number = 112;

  //课程相关
  coursesInWeek: (CourseView | null)[] = Array(this.TOTAL_COURSE_CUBE).fill(null);
  private courseViews: CourseView[] = [];
  courseSchedule: (CourseView | null)[][] = Array.from({ length: 24 }, () => Array(this.TOTAL_COURSE_CUBE).fill(null));
  @State forDetailCourseView: CourseView | null = null;
  //Todo 这里需要几个 rgb 值
  readonly courseCubeColors: string[] = ['#569EBD', '#D3A384', '#BA8B6D', '#3B86A5', '#55AD9B', '#E88D67', '#FFDA78', '#7469B6'];
  private courses: Course[] = [];
  courseColorMap: Map<string, string> = new Map();

  aboutToAppear() {
    //获得自学期开始时 25周的起始日期
    this.allWeekStartDates = DateUtils.getAllWeekDates(this.termStartDate, 24);
    //今日日期
    this.todayDateInfo = DateUtils.getStartOfDay(new Date());
    //今日所属周的偏移
    let weekDiff = DateUtils.getWeekDiff(this.termStartDate, this.todayDateInfo);
    this.curWeek = weekDiff + 1;
    this.showWeek = this.curWeek;
    //当前显示的周数据
    this.showWeekDates = this.allWeekStartDates[weekDiff];
    //当前显示第几周
    this.showWeekString = '第' + this.showWeek.toString() + '周';

    this.courses = DataPool.courses;

    this.courses.forEach((value:Course,index:number)=>{
      this.courseColorMap.set(value.courseId,this.courseCubeColors[index%this.courseCubeColors.length]);
    })

    this.courses.forEach((course: Course, index: number) => {
      let courseViewTemp: CourseView[] = CourseView.fromCourse(course);
      this.courseViews = this.courseViews.concat(courseViewTemp);
    })
    this.courseViews.forEach((item: CourseView, index: number) => {
      for (let i = item.startWeek;i <= item.endWeek; i += 1) {
        let idx = item.weekday + (item.courseSeq - 1) * 8;
        this.courseSchedule[i-1][idx] = item;
      }
    })
  }


  //表示时间的ui，课表顶部使用
  @Builder DateCube(date: Date) {
    Column() {
      Text(this.weekDaysString[date.getDay()])
        .fontColor(date.getTime() === this.todayDateInfo.getTime() ? '#ff1d1d1d' : '#ff696969')
        .fontWeight(date.getTime() === this.todayDateInfo.getTime() ? FontWeight.Bolder : FontWeight.Regular)
      Text((date.getMonth() + 1).toString() + '/' + date.getDate().toString())
        .fontColor(date.getTime() === this.todayDateInfo.getTime() ? '#ff1d1d1d' : '#ff696969')
        .fontSize('14vp')
    }.margin({ top: '5vp' })

  }

  //课表顶部的DateBar
  @Builder DateBar() {
    Row() {
      Grid() {
        GridItem() {
          Column() {
            Text('星期').fontSize('12vp')
            Text('日期').fontSize('12vp')
          }.justifyContent(FlexAlign.SpaceAround)
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
      Text(`${courseView.name}@${courseView.location}`)
        .fontSize('12vp')
      // Text(CourseView.courseSeqToTime.get(courseView.courseSeq)[0])
      //   .fontSize(10)
      //   .alignSelf(ItemAlign.Center)
      // Text(courseView.name+"@"+courseView.location)
      //   .fontSize('13vp')
      //.alignSelf(ItemAlign.Center)
      // Text(courseView.location)
      //   .fontSize('12vp')
      //   //.alignSelf(ItemAlign.Center)
      //
      //   .height(72)
    }
    .width("100%")
    .height('72vp')
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.courseColorMap.get(courseView.courseId))
    .onClick(() => {
      this.forDetailCourseView = courseView;
      this.courseDetailDialogController.open();
    })
  }

  @Builder EmptyCourseCube(idx: number | null) {
    Column() {
      if (idx != null) {
        Text(CourseView.getCourseSeqStartTime(idx))
          .fontSize(12)
        Text(idx.toString())
          .fontSize(20)
        Text(CourseView.getCourseSeqEndTime(idx))
          .fontSize(12)
      }
    }
    .height(72)
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
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
          .border({ width: { bottom: 0.5 }, color: '#ff969696' })

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
              .width(20)
          }
          .backgroundColor(Color.Transparent)
          .onClick((event?: ClickEvent) => {
            this.swiperController.showPrevious();
          })

          Text(this.showWeekString)
            .fontColor(Color.White)
          Button() {
            Image($r('app.media.icon_forward'))
              .width(20)
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
    // .backgroundColor($r('app.color.nav_bar_background_color'))
    .backgroundColor(theme.getTheme(this.Sys_color))
  }

  build() {
    Stack(){
      Image(theme.getBackground(this.bgpage))
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
    .width("100%")
    .height("100%")
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Push, duration: 300 })
      .slide(SlideEffect.Bottom)
    PageTransitionExit({ type: RouteType.Pop, duration: 300 })
      .slide(SlideEffect.Bottom)
  }
}