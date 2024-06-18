import Course, { CourseView, courseDemo } from '../database/models/Course'
import DateUtils from '../utils/DateUtils';

@Component
export default struct TodayCourseView {
  courses: Course[] = [];
  courseViews: CourseView[] = [];
  private todayDateInfo: Date;
  curWeek: number;
  termStartDate = new Date('2024-02-26');

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
  }

  build() {
    Column() {
      Row() {
        Text('Lesson')
          .fontSize(48)
      }
      .margin({ top: 80,bottom:48 })
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
  }
}