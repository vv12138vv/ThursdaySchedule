@Component
export default struct GradeSummary {
  @Link totalCredit: number;
  @Link totalAverageGrade: number;
  @Link totalGPA: number;
  @Link requiredCourseCredit: number;
  @Link requiredCourseAverageGrade: number;
  @Link requireCourseGPA: number;
  @Link electiveCourseCredit: number;
  @Link electiveCourseAverageGrade: number;
  @Link electiveCourseGPA: number;
  @Link selectedCredit: number;
  @Link selectedAverageGrade: number;
  @Link selectedGPA: number;

  //Todo header 与 row 还有些对齐问题
  @Builder GradeSummaryHeader() {
    Row() {
      Text($r('app.string.grade_summary_header_column1_label'))
        .fontColor($r('app.color.grade_summary_header_font_color'))
        .fontSize($r('app.float.grade_summary_header_font_size'))

      Text($r('app.string.grade_summary_header_column2_label'))
        .fontColor($r('app.color.grade_summary_header_font_color'))
        .fontSize($r('app.float.grade_summary_header_font_size'))

      Text($r('app.string.grade_summary_header_column3_label'))
        .fontColor($r('app.color.grade_summary_header_font_color'))
        .fontSize($r('app.float.grade_summary_header_font_size'))

      Text($r('app.string.grade_summary_header_column4_label'))
        .fontColor($r('app.color.grade_summary_header_font_color'))
        .fontSize($r('app.float.grade_summary_header_font_size'))

    }
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
    .width($r('app.float.grade_summary_header_width'))
    .height($r('app.float.grade_summary_header_height'))
  }

  @Builder GradeSummaryRow(rowLabel: string, $$: {
    selectedCredit: number,
    selectedAverageGrade: number,
    selectedGPA: number
  }) {
    Row() {
      Text(rowLabel)
        .fontColor($r('app.color.grade_summary_row_font_color'))
        .fontSize($r('app.float.grade_summary_row_font_size'))
      Text($$.selectedCredit.toFixed(1))
        .fontColor($r('app.color.grade_summary_row_font_color'))
        .fontSize($r('app.float.grade_summary_row_font_size'))


      Text($$.selectedAverageGrade.toFixed(3))
        .fontColor($r('app.color.grade_summary_row_font_color'))
        .fontSize($r('app.float.grade_summary_row_font_size'))

      Text($$.selectedGPA.toFixed(3))
        .fontColor($r('app.color.grade_summary_row_font_color'))
        .fontSize($r('app.float.grade_summary_row_font_size'))

    }
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
    .width($r('app.float.grade_summary_row_width'))
    .height($r('app.float.grade_summary_row_height'))
    .backgroundColor(Color.Pink)
  }

  build() {
    Column() {
      this.GradeSummaryHeader()
      this.GradeSummaryRow("全部课程", {
        selectedCredit: this.totalCredit,
        selectedAverageGrade: this.totalAverageGrade,
        selectedGPA: this.totalGPA
      })
      this.GradeSummaryRow("必修课程", {
        selectedCredit: this.requiredCourseCredit,
        selectedAverageGrade: this.requiredCourseAverageGrade,
        selectedGPA: this.requireCourseGPA
      })
      this.GradeSummaryRow("选修课程", {
        selectedCredit: this.electiveCourseCredit,
        selectedAverageGrade: this.electiveCourseAverageGrade,
        selectedGPA: this.electiveCourseGPA
      })
      this.GradeSummaryRow("已选课程", {
        selectedCredit: this.selectedCredit,
        selectedAverageGrade: this.selectedAverageGrade,
        selectedGPA: this.selectedGPA
      })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
    .height(200)
  }
}

@Preview
@Component
struct GradeSummaryPreview {
  @State totalCredit: number = 90;
  @State totalAverageGrade: number = 93.3;
  @State totalGPA: number = 3.9;
  @State requiredCourseCredit: number = 60;
  @State requiredCourseAverageGrade: number = 94;
  @State requireCourseGPA: number = 3.95;
  @State electiveCourseCredit: number = 30;
  @State electiveCourseAverageGrade: number = 91;
  @State electiveCourseGPA: number = 3.82;
  @State selectedCredit: number = 34;
  @State selectedAverageGrade: number = 92;
  @State selectedGPA: number = 3.89;

  build() {
    GradeSummary({
      totalCredit: $totalCredit,
      totalAverageGrade: $totalAverageGrade,
      totalGPA: $totalGPA,
      requiredCourseCredit: $requiredCourseCredit,
      requiredCourseAverageGrade: $requiredCourseAverageGrade,
      requireCourseGPA: $requireCourseGPA,
      electiveCourseCredit: $electiveCourseCredit,
      electiveCourseAverageGrade: $electiveCourseAverageGrade,
      electiveCourseGPA: $electiveCourseGPA,
      selectedCredit: $selectedCredit,
      selectedAverageGrade: $selectedAverageGrade,
      selectedGPA: $selectedGPA
    })
  }
}