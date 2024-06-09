import Course from '../database/models/Course'
@Component
export default struct GradeBlock {
  @Builder TermBar($$: {
    termInNumber: string,
    termInString: string
  }) {
    Row() {
      Text($$.termInNumber)
      Text($$.termInString)
    }
  }

  @Builder GradeBlockHeader() {
    Row() {
      Checkbox()
      Text($r('app.string.grade_block_header_column1_label'))
        .fontColor($r('app.color.grade_block_header_font_color'))
        .fontSize($r('app.float.grade_block_header_font_size'))
      Text($r('app.string.grade_block_header_column2_label'))
        .fontColor($r('app.color.grade_block_header_font_color'))
        .fontSize($r('app.float.grade_block_header_font_size'))
      Text($r('app.string.grade_block_header_column3_label'))
        .fontColor($r('app.color.grade_block_header_font_color'))
        .fontSize($r('app.float.grade_block_header_font_size'))
      Text($r('app.string.grade_block_header_column4_label'))
        .fontColor($r('app.color.grade_block_header_font_color'))
        .fontSize($r('app.float.grade_block_header_font_size'))
      Text($r('app.string.grade_block_header_column5_label'))
        .fontColor($r('app.color.grade_block_header_font_color'))
        .fontSize($r('app.float.grade_block_header_font_size'))
    }
    .width($r('app.float.grade_block_header_width'))
    .height($r('app.float.grade_block_header_height'))
  }

  @Builder GradeBlockRow(course:Course){
    Row(){
      Checkbox()
      Text(course.name)
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))
      Text(course.grade)
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))
      Text(course.credit.toFixed(1))
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))
      Text(course.courseType)
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))
      Text(course.gpa.toFixed(3))
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))
    }
    .width($r('app.float.grade_block_row_width'))
    .height($r('app.float.grade_block_row_height'))

  }

  build() {
    this.GradeBlockHeader()
  }
}

@Preview
@Component
struct GradeBlockPreview {
  build() {
    GradeBlock()
  }
}