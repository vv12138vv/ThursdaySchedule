import Exam, { examDemo, ExamView } from '../database/models/Exam';
import DateUtils from '../utils/DateUtils';
import DataPool from '../utils/DataPool';

@CustomDialog
struct ExamDetailDialog {
  dialogController?: CustomDialogController;
  @Link examView: ExamView;

  build() {
    Column() {
      Row() {
        Text(this.examView.examName)
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.basic_word'))
          .margin({ left: 16, top: 16, bottom: 16 })

        Button() {
          Image($r('app.media.icon_close'))
            .width(16)
            .height(16)
            .margin({ right: 16 })
            .onClick(() => {
              this.dialogController.close();
            })
        }
        .type(ButtonType.Circle)
        .backgroundColor(Color.Transparent)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")

      Divider()
        .color($r('app.color.exam_divider'))
        .height(1)
        .margin({ left: 16, right: 16 })

      Column() {
        Text('课程序号: ' + this.examView.courseId)
          .fontSize(18)
          .fontColor($r('app.color.exam_infor'))
          .margin({ top: 16, bottom: 8, left: 16, right: 16 })

        Text('考试时间: ' + this.examView.time)
          .fontSize(18)
          .fontColor($r('app.color.exam_infor'))
          .margin({ top: 8, bottom: 8, left: 16, right: 16 })

        Text('地点: ' + this.examView.location)
          .fontSize(18)
          .fontColor($r('app.color.exam_infor'))
          .margin({ top: 8, bottom: 8, left: 16, right: 16 })

        Text('座位号: ' + this.examView.seatId)
          .fontSize(18)
          .fontColor($r('app.color.exam_infor'))
          .margin({ top: 8, bottom: 16, left: 16, right: 16 })
      }
      .layoutWeight(6)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
    }
    .width("80%")
    .height("40%")
    .borderRadius(16)
    .backgroundColor(Color.White)
    .padding({ left: 0, right: 0, top: 16, bottom: 16 })
  }
}

@Component
export default struct RecentExamView {
  exams: Exam[] = [];
  examViews: ExamView[] = [];
  curWeek: number;
  termStartDate = new Date('2024-02-26');
  @State forDetailExamView: ExamView | null = null;
  courseDetailDialogController: CustomDialogController = new CustomDialogController({
    builder: ExamDetailDialog({
      examView: $forDetailExamView
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  aboutToAppear() {
    //数据请求
    let exams: Exam[] = DataPool.exams;
    let examViewTemp: ExamView[] = [];
    exams.forEach((exam: Exam, index: number) => {
      let temp = ExamView.fromExam(exam);
      examViewTemp = examViewTemp.concat(temp);
    })

    examViewTemp=examViewTemp.filter((examView:ExamView,index:number)=>{
      return DateUtils.CompareDaysFromNow(examView.time);
    })
    this.examViews = examViewTemp;


  }

  // @Builder CourseCard(examView: ExamView) {
  //   Row() {
  //     Column() {
  //       // 标题内容
  //       Text('[' + DateUtils.getDayOfWeek(examView.time) + '] ' + examView.examName)
  //         .fontSize(20)
  //         .fontWeight(FontWeight.Bold)
  //         .fontColor($r('app.color.basic_word'))
  //         .textAlign(TextAlign.Start)
  //
  //
  //       Column() {
  //         // // 剩余天数
  //         // Text('还剩 ' + DateUtils.getDaysFromNow(examView.time) + ' 天')
  //         //   .fontSize(16)
  //         //   .fontColor($r('app.color.basic_word'))
  //
  //         // 时间
  //         Text(examView.time)
  //           .fontSize(18)
  //           .fontColor($r('app.color.basic_word'))
  //
  //
  //         // 地点
  //         Text(examView.location)
  //           .fontSize(18)
  //           .fontColor($r('app.color.basic_word'))
  //       }
  //       .alignItems(HorizontalAlign.Start)
  //       .justifyContent(FlexAlign.Start)
  //     }
  //     .justifyContent(FlexAlign.SpaceBetween)
  //     .height('100%')
  //     .margin({ left: 20, right: 20 })
  //     // Image($r('app.media.icon_right_arrow_black'))
  //   }
  //   .width(300)
  //   .height(105)
  //   .borderRadius(16)
  //   .justifyContent(FlexAlign.Start)
  //   .backgroundColor($r('app.color.card_transparent'))
  //   .padding({ left: 12, right: 12, top: 12, bottom: 12 })
  //   .onClick(() => {
  //     this.forDetailExamView = examView;
  //     this.courseDetailDialogController.open();
  //   })
  //
  // }

  @Builder CourseCard(examView: ExamView) {
    Column() {
      Text('[' + DateUtils.getDayOfWeek(examView.time) + '] ' + examView.examName)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 20, top: 20 })
      Row() {
        // // 剩余天数
        Text('还剩 ' + DateUtils.getDaysFromNow(examView.time) + ' 天')
          .fontSize(16)
          .fontColor($r('app.color.basic_word'))
        // // 时间
        // Text(examView.time)
        //   .fontSize(18)
        //   .fontColor($r('app.color.basic_word'))
        // 地点
        Text(examView.location)
          .fontSize(18)
          .fontColor($r('app.color.basic_word'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(200)
      .margin({ left: 20, right: 20 })
      .height(52)
    }
    .width(300)
    .height(105)
    // .borderWidth(0.5)
    .borderRadius(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.forDetailExamView = examView;
      this.courseDetailDialogController.open();
    })
  }

  build() {
    Column() {
      Column() {
        if (this.examViews.length != 0) {
          List({ space: 12 }) {
            ForEach(this.examViews, (item: ExamView, index: number) => {
              ListItem() {
                  this.CourseCard(item)
              }
            })
          }
          .alignListItem(ListItemAlign.Center)
          .height(512)
        } else {
          Text('最近没有考试哦')
            .fontSize(32)
            .margin({ top: 48 })
            .fontColor(Color.White)
        }
      }
      .height(512)
    }
    .height("100%")
    .width("100%")
    .alignItems(HorizontalAlign.Center)
  }
}

@Preview
@Component
struct RecentExamViewPreview {
  build() {
    RecentExamView()
      .backgroundColor('#ffd6c262')
  }
}