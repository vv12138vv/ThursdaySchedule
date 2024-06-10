import GradeTable from '../database/tables/GradeTable';
import Grade, { gradeToGPA, transToGradeNum } from '../database/models/Grade';
import GradeSummary from './GradeSummary';

@Component
export default struct GradeBlock {
  termInNumber: string;
  termInString: string;
  grades: Grade[];
  @State selectedCredit: number = 0;
  @State selectedGradeWithWeight: number = 0;
  @State selectedGPAWithWeight: number = 0;
  @State selectedAverageGrade: number = 0;
  @State selectedAverageGPA: number = 0;
  totalCredit: number = 0;
  totalGradeWithWeight: number = 0;
  totalGPAWithWeight: number = 0;
  requiredCredit: number = 0;
  requiredGradeWithWeight: number = 0;
  requiredGPAWithWeight: number = 0;
  electiveCredit: number = 0;
  electiveGradeWithWeight: number = 0;
  electiveGPAWithWeight: number = 0;

  //被勾选的 grade 的 id。
  selectedId: Set<number> = new Set();

  initTotalInfo(grades: Grade[]) {
    grades.forEach((item: Grade, index: number) => {
      this.totalCredit += item.credit;
      let gradeNum = transToGradeNum(item.grade);
      this.totalGradeWithWeight += gradeNum * item.credit;
      this.totalGPAWithWeight += gradeToGPA(item.grade) * item.credit;
    });
  }

  initSelectedInfo(grades: Grade[]) {
    grades.forEach((item: Grade, index: number) => {
      this.selectedId.add(item.id);
      this.selectedCredit += item.credit;
      let gradeNum = transToGradeNum(item.grade);
      this.selectedGradeWithWeight += gradeNum * item.credit;
      this.selectedGPAWithWeight += gradeToGPA(item.grade) * item.credit;
    });
    this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
    this.selectedAverageGPA = this.selectedAverageGPA / this.selectedCredit;
  }

  //required以及 elective 视爬虫而定。

  aboutToAppear() {
    GradeTable.selectDataByTime('2021-2022-1', (result: Grade[]) => {
      this.grades = result;
    });
    this.initTotalInfo(this.grades);
    this.initSelectedInfo(this.grades);

  }

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
        .select(true)
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

  @Builder GradeBlockRow(grade: Grade, onChange: (selected: boolean) => void) {
    Row() {
      Checkbox()
        .select(true)
        .selectedColor($r('app.color.grade_block_row_checkbox_selected_color'))
        .onChange(onChange)

      Text(grade.courseName)
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))

      Text(grade.grade)
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))

      Text(grade.credit.toFixed(1))
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))

      Text(grade.testType)
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))

      Text(grade.gpa.toFixed(3))
        .fontSize($r('app.float.grade_block_row_font_size'))
        .fontColor($r('app.color.grade_block_row_font_color'))
    }
    .width($r('app.float.grade_block_row_width'))
    .height($r('app.float.grade_block_row_height'))
  }

  build() {
    Column() {

      this.TermBar({ termInNumber: this.termInNumber, termInString: this.termInString })
      this.GradeBlockHeader()
      //Todo 等待爬虫数据
      ForEach(this.grades, (item: Grade, index: number) => {
        this.GradeBlockRow(item, (selected: boolean) => {
          if (selected) {
            if (!(this.selectedId.has(item.id))) {
              this.selectedId.add(item.id);
              let gradeNum = transToGradeNum(item.grade);
              this.selectedCredit += item.credit;
              this.selectedGradeWithWeight += gradeNum * item.credit;
              this.selectedGPAWithWeight += gradeToGPA(item.grade) * item.credit;
              this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
              this.selectedAverageGPA = this.selectedGPAWithWeight / this.selectedCredit;
            }
          } else {
            if ((this.selectedId.has(item.id))) {
              this.selectedId.delete(item.id);
              let gradeNum = transToGradeNum(item.grade);
              this.selectedCredit -= item.credit;
              this.selectedGradeWithWeight -= gradeNum * item.credit;
              this.selectedGPAWithWeight -= gradeNum * item.credit;
              this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
              this.selectedAverageGPA = this.selectedGPAWithWeight / this.selectedCredit;
            }
          }
        })
      })

      GradeSummary({
        totalCredit:this.totalCredit,
        totalAverageGrade:this.totalGradeWithWeight/this.totalCredit,
        totalGPA:this.totalGPAWithWeight/this.totalCredit,
        requiredCourseCredit:this.requiredCredit,
        requiredCourseAverageGrade:this.requiredGradeWithWeight/this.requiredCredit,
        requireCourseGPA:this.requiredGPAWithWeight/this.requiredCredit,
        electiveCourseCredit:this.electiveCredit,
        electiveCourseAverageGrade:this.electiveGradeWithWeight/this.electiveCredit,
        electiveCourseGPA:this.electiveGPAWithWeight/this.electiveCredit,
        selectedCredit:$selectedCredit,
        selectedAverageGrade:$selectedAverageGrade,
        selectedGPA:$selectedAverageGPA
      })
    }
  }
}

@Preview
@Component
struct GradeBlockPreview {
  build() {
    GradeBlock()
  }
}