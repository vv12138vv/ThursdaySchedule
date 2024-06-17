import GradeTable from '../database/tables/GradeTable';
import Grade, { gradeToGPA, transToGradeNum } from '../database/models/Grade';
import GradeSummary from './GradeSummary';
import { gradeDemo } from '../database/models/Grade';

@Component
export default struct GradeBlock {
  termInString: string;
  termInNumber: string;
  grades: Grade[] = [];
  @State selectedCredit: number = 0;
  @State selectedGradeWithWeight: number = 0;
  @State selectedGPAWithWeight: number = 0;
  @State selectedAverageGrade: number = 0;
  @State selectedAverageGPA: number = 0;
  @State blockTotalCredit: number = 0;

  blockTotalGradeWithWeight: number = 0;
  blockTotalGPAWithWeight: number = 0;
  @State blockAverageGrade:number=0;
  @State blockAverageGPA:number=0;
  @Consume('allSelectedGradeId') allSelectedGradeId: number[];
  @Consume('allGrades') allGrades: Grade[];
  //被勾选的 grade 的 id。
  blockSelectedId: number[] = [];

  @Consume totalCredit:number;
  @Consume totalGradeWithWeight:number;
  @Consume totalGPAWithWeight:number;
  @Consume totalAverageGrade:number;
  @Consume totalAverageGPA:number;

  initGradeInfo(grades: Grade[]) {
    grades.forEach((item: Grade, index: number) => {
      this.allGrades.push(item);
      let gradeNum = transToGradeNum(item.grade);

      this.totalCredit+=item.credit
      this.totalGradeWithWeight+=gradeNum*item.credit;
      this.totalGPAWithWeight+=gradeToGPA(item.grade)*item.credit;

      this.blockTotalCredit += item.credit;
      this.blockTotalGradeWithWeight += gradeNum * item.credit;
      this.blockTotalGPAWithWeight += gradeToGPA(item.grade) * item.credit;

      if (!this.blockSelectedId.includes(item.id)) {
        this.blockSelectedId.push(item.id);
      }
      if (!this.allSelectedGradeId.includes(item.id)) {
        this.allSelectedGradeId.push(item.id);
      }
    });
    this.totalAverageGrade=this.totalGradeWithWeight/this.totalCredit;
    this.totalGPAWithWeight=this.totalGPAWithWeight/this.totalCredit;

    this.blockAverageGrade=this.blockTotalGradeWithWeight/this.blockTotalCredit;
    this.blockAverageGPA=this.blockTotalGPAWithWeight/this.blockTotalCredit;

    //默认全选
    this.selectedCredit = this.blockTotalCredit;
    this.selectedGradeWithWeight = this.blockTotalGradeWithWeight;
    this.selectedGPAWithWeight = this.blockTotalGPAWithWeight;
    this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
    this.selectedAverageGPA = this.selectedAverageGPA / this.selectedCredit;
  }

  aboutToAppear() {
    // GradeTable.selectDataByTime(this.termInString, (result: Grade[]) => {
    //   this.grades = result;
    //   this.initGradeInfo(this.grades);
    // });
    this.grades.push(gradeDemo);
    this.initGradeInfo(this.grades);
  }

  @Builder TermBar($$: {
    termInNumber: string,
    termInString: string
  }) {
    Row() {
      Text($$.termInNumber)
      Text($$.termInString)
    }
    .width($r('app.float.grade_block_header_width'))
  }

  @Builder GradeBlockHeader() {
    Grid() {
      GridItem() {
        // Checkbox()
        //   .select(true)
        //   .width(12)
      }

      GridItem() {
        Text($r('app.string.grade_block_header_column1_label'))
          .fontColor($r('app.color.grade_block_header_font_color'))
          .fontSize($r('app.float.grade_block_header_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($r('app.string.grade_block_header_column2_label'))
          .fontColor($r('app.color.grade_block_header_font_color'))
          .fontSize($r('app.float.grade_block_header_font_size'))
      }
      .height("100%")


      GridItem() {
        Text($r('app.string.grade_block_header_column3_label'))
          .fontColor($r('app.color.grade_block_header_font_color'))
          .fontSize($r('app.float.grade_block_header_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($r('app.string.grade_block_header_column4_label'))
          .fontColor($r('app.color.grade_block_header_font_color'))
          .fontSize($r('app.float.grade_block_header_font_size'))
      }
      .height("100%")

      GridItem() {
        Text($r('app.string.grade_block_header_column5_label'))
          .fontColor($r('app.color.grade_block_header_font_color'))
          .fontSize($r('app.float.grade_block_header_font_size'))
      }
      .height("100%")

    }
    .columnsTemplate('1fr 3fr 1fr 1fr 1fr 1fr')
    .width($r('app.float.grade_block_header_width'))
    .height($r('app.float.grade_block_header_height'))
    .backgroundColor(Color.Pink)
  }

  @Builder GradeBlockRow(grade: Grade) {
    Grid() {
      GridItem() {
        Checkbox()
          .select(true)
          .selectedColor($r('app.color.grade_block_row_checkbox_selected_color'))
          .width(12)
          .onChange((selected: boolean) => {
            if (selected) {
              if (!(this.blockSelectedId.includes(grade.id))) {
                this.blockSelectedId.push(grade.id);
                let gradeNum = transToGradeNum(grade.grade);
                this.selectedCredit += grade.credit;
                this.selectedGradeWithWeight += gradeNum * grade.credit;
                this.selectedGPAWithWeight += gradeToGPA(grade.grade) * grade.credit;
                this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
                this.selectedAverageGPA = this.selectedGPAWithWeight / this.selectedCredit;
              }
              //更新全局的数据
              if (!(this.allSelectedGradeId.includes(grade.id))) {
                this.allSelectedGradeId.push(grade.id);
              }
            } else {
              if ((this.blockSelectedId.includes(grade.id))) {
                let idx = this.blockSelectedId.indexOf(grade.id);
                this.blockSelectedId.splice(idx, 1);
                let gradeNum = transToGradeNum(grade.grade);
                this.selectedCredit -= grade.credit;
                this.selectedGradeWithWeight -= gradeNum * grade.credit;
                this.selectedGPAWithWeight -= gradeToGPA(grade.grade) * grade.credit;
                this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
                this.selectedAverageGPA = this.selectedGPAWithWeight / this.selectedCredit;
              }
              //更新全局的选中数据
              if (this.allSelectedGradeId.includes(grade.id)) {
                let idx = this.allSelectedGradeId.indexOf(grade.id);
                this.allSelectedGradeId.splice(idx, 1);
              }
            }
          })
      }
      .height("100%")

      GridItem() {
        Text(grade.courseName)
          .fontSize($r('app.float.grade_block_row_font_size'))
          .fontColor($r('app.color.grade_block_row_font_color'))
      }
      .height("100%")

      GridItem() {
        Text(grade.grade)
          .fontSize($r('app.float.grade_block_row_font_size'))
          .fontColor($r('app.color.grade_block_row_font_color'))
      }
      .height("100%")

      GridItem() {
        Text(grade.credit.toFixed(1))
          .fontSize($r('app.float.grade_block_row_font_size'))
          .fontColor($r('app.color.grade_block_row_font_color'))
      }
      .height("100%")

      GridItem() {
        Text(grade.testType)
          .fontSize($r('app.float.grade_block_row_font_size'))
          .fontColor($r('app.color.grade_block_row_font_color'))
      }
      .height("100%")

      GridItem() {
        Text(grade.gpa.toFixed(1))
          .fontSize($r('app.float.grade_block_row_font_size'))
          .fontColor($r('app.color.grade_block_row_font_color'))
      }
      .height("100%")
    }
    .columnsTemplate('1fr 3fr 1fr 1fr 1fr 1fr')
    .width($r('app.float.grade_block_row_width'))
    .height($r('app.float.grade_block_row_height'))
  }

  build() {
    Column({ space: 12 }) {
      this.TermBar({ termInNumber: this.termInNumber, termInString: this.termInString })
      Column() {
        this.GradeBlockHeader()
        ForEach(this.grades, (item: Grade, index: number) => {
          this.GradeBlockRow(item)
        })
      }
      .border({ width: { top: 0.5, bottom: 0.5 } })

      GradeSummary({
        totalCredit: $blockTotalCredit,
        totalAverageGrade:$blockAverageGrade,
        totalAverageGPA: $blockAverageGPA,
        selectedCredit: $selectedCredit,
        selectedAverageGrade: $selectedAverageGrade,
        selectedAverageGPA: $selectedAverageGPA
      })
    }
    .borderWidth(0.5)
  }
}

@Preview
@Component
struct GradeBlockPreview {
  build() {
    GradeBlock()
  }
}