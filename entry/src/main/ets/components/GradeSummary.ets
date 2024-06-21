import { theme } from '../components/theme'

@Component
export default struct GradeSummary {
  @Prop totalCredit: number;
  @Prop totalAverageGrade: number;
  @Prop totalAverageGPA: number;
  @Link selectedCredit: number;
  @Link selectedAverageGrade: number;
  @Link selectedAverageGPA: number;
  @StorageLink('SystemColor') Sys_color: number = 1

  @Builder GradeSummaryHeader() {
    Grid() {
      GridItem() {
        Text($r('app.string.grade_summary_header_column1_label'))
          .fontColor($r('app.color.grade_summary_header_font_color'))
          .fontSize($r('app.float.grade_summary_header_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($r('app.string.grade_summary_header_column2_label'))
          .fontColor($r('app.color.grade_summary_header_font_color'))
          .fontSize($r('app.float.grade_summary_header_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($r('app.string.grade_summary_header_column3_label'))
          .fontColor($r('app.color.grade_summary_header_font_color'))
          .fontSize($r('app.float.grade_summary_header_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($r('app.string.grade_summary_header_column4_label'))
          .fontColor($r('app.color.grade_summary_header_font_color'))
          .fontSize($r('app.float.grade_summary_header_font_size'))
      }
      .height("100%")

    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .width($r('app.float.grade_summary_header_width'))
    .height($r('app.float.grade_summary_header_height'))
    // .backgroundColor($r('app.color.nav_bar_background_color'))
    .backgroundColor(theme.getTheme(this.Sys_color))
  }

  @Builder GradeSummaryRow($$: {
    rowLabel: string,
    selectedCredit: number,
    selectedAverageGrade: number,
    selectedGPA: number
  }) {
    Grid() {
      GridItem() {
        Text($$.rowLabel)
          .fontColor($r('app.color.grade_summary_row_font_color'))
          .fontSize($r('app.float.grade_summary_row_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($$.selectedCredit.toFixed(1))
          .fontColor($r('app.color.grade_summary_row_font_color'))
          .fontSize($r('app.float.grade_summary_row_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($$.selectedAverageGrade.toFixed(3))
          .fontColor($r('app.color.grade_summary_row_font_color'))
          .fontSize($r('app.float.grade_summary_row_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($$.selectedGPA.toFixed(3))
          .fontColor($r('app.color.grade_summary_row_font_color'))
          .fontSize($r('app.float.grade_summary_row_font_size'))
      }
      .height("100%")
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .width($r('app.float.grade_summary_row_width'))
    .height($r('app.float.grade_summary_row_height'))
  }

  build() {
    Column() {
      this.GradeSummaryHeader()
      Column(){
        this.GradeSummaryRow({
          rowLabel: "全部课程",
          selectedCredit: this.totalCredit,
          selectedAverageGrade: this.totalAverageGrade,
          selectedGPA: this.totalAverageGPA
        })
        this.GradeSummaryRow({
          rowLabel: "已选课程",
          selectedCredit: this.selectedCredit,
          selectedAverageGrade: this.selectedAverageGrade,
          selectedGPA: this.selectedAverageGPA
        })
      }
      .backgroundColor(Color.White)
      .borderRadius({
        bottomLeft:'10vp',
        bottomRight:'10vp'
      })

    }

    .width($r('app.float.grade_summary_row_width'))

  }
}

// @Preview
// @Component
// struct GradeSummaryPreview {
//   @State totalCredit: number = 90;
//   @State totalAverageGrade: number = 93.3;
//   @State totalGPA: number = 3.9;
//   @State requiredCourseCredit: number = 60;
//   @State requiredCourseAverageGrade: number = 94;
//   @State requireCourseGPA: number = 3.95;
//   @State electiveCourseCredit: number = 30;
//   @State electiveCourseAverageGrade: number = 91;
//   @State electiveCourseGPA: number = 3.82;
//   @State selectedCredit: number = 34;
//   @State selectedAverageGrade: number = 92;
//   @State selectedGPA: number = 3.89;
//
//   build() {
//     GradeSummary({
//       totalCredit: this.totalCredit,
//       totalAverageGrade: this.totalAverageGrade,
//       totalGPA: this.totalGPA,
//       requiredCourseCredit: this.requiredCourseCredit,
//       requiredCourseAverageGrade: this.requiredCourseAverageGrade,
//       requireCourseGPA: this.requireCourseGPA,
//       electiveCourseCredit: this.electiveCourseCredit,
//       electiveCourseAverageGrade: this.electiveCourseAverageGrade,
//       electiveCourseGPA: this.electiveCourseGPA,
//       selectedCredit: $selectedCredit,
//       selectedAverageGrade: $selectedAverageGrade,
//       selectedGPA: $selectedGPA
//     })
//   }
// }