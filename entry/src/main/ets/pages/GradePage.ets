import GradeSummary from '../components/GradeSummary';
import GradeBlock from '../components/GradeBlock';
import router from '@ohos.router';
import NavBar, { NavBarConfig } from '../components/NavBar';
import Grade, { gradeToGPA, transToGradeNum } from '../database/models/Grade';
import GradeTable from '../database/tables/GradeTable';
import { WindowMode } from '@ohos.UiTest';
import { gradeDemo } from '../database/models/Grade';
import { DataProcess } from '../utils/DataProcess';
import DataPool from '../utils/DataPool';
@Entry
@Component
struct GradePage {
  navBarConfig: NavBarConfig = {
    leftIcon: $r("app.media.icon_show_less"),
    title: "成绩查询",
    onClickLeftButton: () => {
      router.back();
    }
  }

  //所有成绩信息
  allGrades: Grade[] = [];
  //页面中被选中的所有 GradeId
  @Provide('allSelectedGradeId') @Watch('onAllSelectedGradeIdChange') allSelectedGradeId: number[] = [];
  //学期信息
  @State terms: string[] = [];
  //每个学期对应的成绩
  termGrades: Map<string, Grade[]> = new Map();


  //页面总成绩信息
  totalCredit: number = 0;
  totalGradeWithWeight: number = 0;
  totalGPAWithWeight: number = 0;
  totalAverageGrade: number = 0;
  totalAverageGPA: number = 0;
  //页面总选择成绩信息
  @State selectedCredit: number = 0;
  selectedGradeWithWeight: number = 0;
  selectedGPAWithWeight: number = 0;
  @State selectedAverageGrade: number = 0;
  @State selectedAverageGPA: number = 0;


  //当选择的课程变化后，全局的数据变化。
  onAllSelectedGradeIdChange() {
    this.selectedCredit = 0;
    this.selectedGradeWithWeight = 0;
    this.selectedGPAWithWeight = 0;
    this.allGrades.forEach((value: Grade, index: number) => {
      if (!this.allSelectedGradeId.includes(value.id)) {
        return;
      }
      this.selectedCredit += value.credit;
      let gradeNum = transToGradeNum(value.grade);
      this.selectedGradeWithWeight += gradeNum * value.credit;
      this.selectedGPAWithWeight += gradeToGPA(value.grade) * value.credit;
    })
    this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
    this.selectedAverageGPA = this.selectedGPAWithWeight / this.selectedCredit;
  }

  initGradeInfo(grades: Grade[]) {
    let initSelectedGradeId: number[] = [];
    grades.forEach((item: Grade, index: number) => {
      this.totalCredit += item.credit;
      let gradeNum = transToGradeNum(item.grade);
      this.totalGradeWithWeight += gradeNum * item.credit;
      this.totalGPAWithWeight += gradeToGPA(item.grade) * item.credit;
      initSelectedGradeId.push(item.id);
    });

    this.totalAverageGrade = this.totalGradeWithWeight / this.totalCredit;
    this.totalAverageGPA = this.totalGPAWithWeight / this.totalCredit;
    this.allSelectedGradeId = initSelectedGradeId;
  }

  aboutToAppear() {
    let termsTemp:string[] = DataProcess.generateSemesterArray('921107810232')
    this.allGrades=DataPool.grades;
    GradeTable.selectDataAll((result: Grade[]) => {
      this.allGrades = result;
      this.initGradeInfo(this.allGrades)
      termsTemp.forEach((term: string, index: number) => {
        let termGrade: Grade[] = [];
        termGrade = this.allGrades.filter((grade: Grade, index: number) => {
          return grade.time === term;
        })
        this.termGrades.set(term, termGrade);
      })
      this.terms=termsTemp;
    })
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Scroll() {
        Column({ space: 32 }) {
          GradeSummary({
            totalCredit: this.totalCredit,
            totalAverageGrade: this.totalAverageGrade,
            totalAverageGPA: this.totalAverageGPA,
            selectedCredit: $selectedCredit,
            selectedAverageGrade: $selectedAverageGrade,
            selectedAverageGPA: $selectedAverageGPA
          })
            .border({ width: { left: 0.5, right: 0.5 } })
          if (this.terms.length != 0) {
            ForEach(this.terms, (value: string, index: number) => {
              GradeBlock({
                termInString: value,
                grades: this.termGrades.get(value)
              })
            })
          }
        }
      }
      .margin({ top: 10 })
    }
  }

  //配置页面切换动画
  pageTransition() {
    PageTransitionEnter({ type: RouteType.Push, duration: 300 })
      .slide(SlideEffect.Bottom)
    PageTransitionExit({ type: RouteType.Pop, duration: 300 })
      .slide(SlideEffect.Bottom)
  }
}

