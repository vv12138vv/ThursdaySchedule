import Course, { CourseView, courseDemo } from '../database/models/Course'
import DateUtils from '../utils/DateUtils';
import {CourseType} from '../database/models/Course';

@CustomDialog
struct TodayCourseDetailDialog {
  dialogController?: CustomDialogController;
  @Link courseView: CourseView;

  build() {
    Column() {
      Row() {
        Text(this.courseView.courseType == CourseType.Required ? "必修" : "选修")
        Text(this.courseView.name)
          .fontSize(32)
        Button() {
          Image($r('app.media.icon_showless'))
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
    .width("70%")
    .height("25%")
    .backgroundColor($r('app.color.course_cube_detail_dialog_background_color'))
  }
}

@Component
export default struct TodayCourseView {
  courses: Course[] = [];
  courseViews: CourseView[] = [];
  private todayDateInfo: Date;
  curWeek: number;
  termStartDate = new Date('2024-02-26');
  @State forDetailCourseView: CourseView | null = null;
  //课程详细对话框控制器
  courseDetailDialogController: CustomDialogController = new CustomDialogController({
    builder: TodayCourseDetailDialog({
      courseView: $forDetailCourseView
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  aboutToAppear() {
    //日期相关初始化
    //今日日期
    this.todayDateInfo = DateUtils.getStartOfDay(new Date());
    //
    let weekDiff = DateUtils.getWeekDiff(this.termStartDate, this.todayDateInfo);
    this.curWeek = weekDiff + 1;
    //数据请求
    this.courseViews = CourseView.fromCourse(courseDemo);
    this.courseViews = this.courseViews.filter((value: CourseView, index: number) => {
      let day = this.todayDateInfo.getDay() + 1;
      return value.weekday === (this.todayDateInfo.getDay() + 1);
    })
  }

  @Builder CourseCard(courseView: CourseView) {
    Column() {
      Text(courseView.name)
        .fontSize(22)
        .margin({ left: 10, top: 16 })
      Column() {
        Text(CourseView.courseSeqToTimeString(courseView.courseSeq))
          .fontSize(18)
        Text(courseView.location)
          .fontSize(18)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10, top: 16 })
      .height(52)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(280)
    .height(128)
    .borderWidth(0.5)
    .borderRadius(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.forDetailCourseView = courseView;
      this.courseDetailDialogController.open();
    })
  }

  build() {
    Column() {
      Row() {
        Text('Lesson')
          .fontSize(48)
      }
      .margin({ top: 80, bottom: 48 })
      .width(300)

      List({ space: 24 }) {
        ForEach(this.courseViews, (item: CourseView, index: number) => {
          ListItem() {
            this.CourseCard(item)
          }
        })
      }
      .alignListItem(ListItemAlign.Center)
      .height(512)
    }
    .height("100%")
    .width("100%")
    .alignItems(HorizontalAlign.Center)
  }
}

@Preview
@Component
struct TodayCourseViewPreview {
  build() {
    TodayCourseView()
      .backgroundColor(Color.Pink)
  }
}