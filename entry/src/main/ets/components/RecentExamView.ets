
import Exam, { examDemo, ExamView } from '../database/models/Exam';
import DateUtils from '../utils/DateUtils';


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
          Image($r('app.media.icon_showless'))
            .width(16)
            .height(16)
            .margin({ right: 16 })
            .onClick(() => {
              this.dialogController.close();
            })
        }
        .backgroundColor(Color.Transparent)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")

      Divider()
        .color($r('app.color.exam_divider'))
        .height(1)
        .margin({ left: 16, right: 16 })

      Column() {
        Text('课程序号: ' +this.examView.courseId)
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
    .backgroundColor($r('app.color.exam_detail_bbackground'))
    .padding({ left: 0, right: 0, top: 16, bottom: 16 })
  }
}

@Component
export default struct RecentExamView {
  exams:Exam[] = [];
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
    this.examViews = ExamView.fromExam(examDemo);

  }

  @Builder CourseCard(examView: ExamView) {
    Column() {
      // 标题内容
      Text('['+DateUtils.getDayOfWeek(examView.time)+']'+examView.examName)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, top: 16 })
        .fontColor($r('app.color.basic_word'))
        .textAlign(TextAlign.Start)

      // 分隔线
      Divider()
        .color($r('app.color.basic_word'))
        .height(1)
        .margin({ left: 16, right: 16, top: 8 })

      Column() {
        // 剩余天数
        Text('还剩 ' + DateUtils.getDaysFromNow(examView.time) + ' 天')
          .fontSize(16)
          .fontColor($r('app.color.basic_word'))
          .margin({ top: 8, bottom: 8 })

        // 时间
        Text(examView.time)
          .fontSize(18)
          .fontColor($r('app.color.basic_word'))
          .margin({ top: 8, bottom: 8 })


        // 地点
        Text(examView.location)
          .fontSize(18)
          .fontColor($r('app.color.basic_word'))
          .margin({ top: 8, bottom: 8 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16, right: 16, top: 8 })
      .justifyContent(FlexAlign.Start)
    }
    .width(280)
    .height(180)
    .borderWidth(1)
    .borderRadius(16)
    .borderColor($r('app.color.basic_word'))
    .backgroundColor($r('app.color.exam_card_background'))
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .onClick(() => {
      this.forDetailExamView = examView;
      this.courseDetailDialogController.open();
    })
  }


  build() {
    Column() {
      Row() {
        Text('近期考试')
          .fontSize(40)
      }
      .margin({ top: 80, bottom: 48 })
      .width(300)

      List({ space: 24 }) {
        ForEach(this.examViews, (item: ExamView, index: number) => {
          ListItem() {
            if(DateUtils.CompareDaysFromNow(item.time)){
              this.CourseCard(item)
            }
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
struct RecentExamViewPreview {
  build() {
    RecentExamView()
  }
}