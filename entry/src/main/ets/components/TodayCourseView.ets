import Course, { CourseView, courseDemo } from '../database/models/Course'
import DateUtils from '../utils/DateUtils';
import { CourseType } from '../database/models/Course';
import CourseTable from '../database/tables/CourseTable';
import DataPool from '../utils/DataPool';
import GradeTable from '../database/tables/GradeTable';
import Grade from '../database/models/Grade';
@CustomDialog
struct TodayCourseDetailDialog {
  dialogController?: CustomDialogController;
  @Link courseView: CourseView;

  build() {
    Column() {
      Row() {
        Text(this.courseView.name)
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .margin({top:10})

        Button() {
          Image($r("app.media.icon_close"))
            .width(20)
            .onClick(() => {
              this.dialogController.close();
            })
        }
        .backgroundColor(Color.Transparent)
        .type(ButtonType.Circle)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")



      Row() {
        Text(this.courseView.courseType == CourseType.Required ? "必修" : "选修").fontSize(18)
        Text(this.courseView.startWeek + '-' + this.courseView.endWeek + '周').fontSize(18)
        Text(this.courseView.teacher).fontSize(18)
      }
      .margin({top:15,bottom:25})
      .width('80%')
      .justifyContent(FlexAlign.SpaceBetween)

      Text(CourseView.courseSeqToTimeString(this.courseView.courseSeq)).fontSize(26) .fontWeight(FontWeight.Medium)

      Row(){
        Text(this.courseView.location).fontSize(20).fontWeight(FontWeight.Bold)
        Text(`${this.courseView.credit}`).fontSize(55).fontWeight(FontWeight.Bold)
      }
      .width('85%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .width("80%")
    .height("30%")
    .padding({
      bottom:40,
      left:30,
      right:20,
      top:20
    })
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
export default struct TodayCourseView {
  courses: Course[] = [];
  @State courseViews: CourseView[] = [];
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

  async aboutToAppear() {
    //日期相关初始化
    //今日日期
    this.todayDateInfo = DateUtils.getStartOfDay(new Date('2024-04-01'));
    //
    let weekDiff = DateUtils.getWeekDiff(this.termStartDate, this.todayDateInfo);
    this.curWeek = weekDiff + 1;
    //数据请求
    let courses:Course[];
    let coursesViewTemp:CourseView[]=[];
    CourseTable.getRdbStore(()=>{
      CourseTable.selectDataByWeek(this.curWeek,(result:Course[])=>{
        courses=result;
        courses.forEach((course:Course,index:number)=>{
          let temp=CourseView.fromCourse(course);
          coursesViewTemp=coursesViewTemp.concat(temp);
        })
        coursesViewTemp = coursesViewTemp.filter((value: CourseView, index: number) => {
          let day = this.todayDateInfo.getDay();
          day = (day === 0 ? 7 : day);
          return value.weekday === day;
        })
        this.courseViews=coursesViewTemp;
      });
      CourseTable.selectDataAll((result:Course[])=>{
        DataPool.courses=result;
      });
    })
    GradeTable.getRdbStore(()=>{
      GradeTable.selectDataAll((result:Grade[])=>{
        DataPool.grades=result;
      })
    })
  }





  @Builder CourseCard(courseView: CourseView) {
    Column() {
      Text(courseView.name)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 20, top: 20 })
      Row() {
        Text(CourseView.courseSeqToTimeString(courseView.courseSeq))
          .fontSize(18)
        Text(courseView.location)
          .fontSize(18)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(200)
      .margin({ left: 20, right: 20 })
      .height(52)
    }
    .width(300)
    .height(105)
    //.borderWidth(0.5)
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
      Column() {
        if (this.courseViews.length != 0) {
          List({ space: 12 }) {
            ForEach(this.courseViews, (item: CourseView, index: number) => {
              ListItem() {
                this.CourseCard(item)
              }
            })
          }
          .alignListItem(ListItemAlign.Center)
          .height(600)
        } else {
          Text('今天没有课哦')
            .fontSize(32)
            .margin({top:48})
            .fontColor(Color.White)
        }
      }
      .height(600)
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