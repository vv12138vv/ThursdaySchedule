import GradeSummary from '../components/GradeSummary';
import GradeBlock from '../components/GradeBlock';
import router from '@ohos.router';
import NavBar, { NavBarConfig } from '../components/NavBar';
import Grade, { gradeToGPA, transToGradeNum } from '../database/models/Grade';
import GradeTable from '../database/tables/GradeTable';

@Entry
@Component
struct GradePage {
  navBarConfig: NavBarConfig = {
    leftIcon: $r('app.media.icon_back'),
    title: "成绩查询",
    onClickLeftButton: () => {
      router.back();
    }
  }
  grades: Grade[] = [];
  selectedGradeId: Set<number> = new Set();
  totalCredit: number = 0;
  totalGradeWithWeight: number = 0;
  totalGPAWithWeight: number = 0;
  selectedCredit: number = 0;
  selectedGradeWithWeight: number = 0;
  selectedGPAWithWeight: number = 0;

  initGradeInfo(grades: Grade[]) {
    grades.forEach((item: Grade, index: number) => {
      this.totalCredit += item.credit;
      let gradeNum = transToGradeNum(item.grade);
      this.totalGradeWithWeight += gradeNum * item.credit;
      this.totalGPAWithWeight += gradeToGPA(item.grade) * item.credit;
      this.selectedGradeId.add(item.id);
    });
    //默认全选
    this.selectedCredit = this.totalCredit;
    this.selectedGradeWithWeight = this.totalGradeWithWeight;
    this.selectedGPAWithWeight = this.totalGPAWithWeight;
  }


  aboutToAppear() {
    GradeTable.selectDataAll((result: Grade[]) => {
      this.grades = result;
      this.initGradeInfo(this.grades);
    })

  }


  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Scroll() {
        Column() {
          GradeSummary({
            totalCredit: this.totalCredit,
            totalGradeWithWeight: this.totalGradeWithWeight,
            totalGPAWithWeight: this.totalGPAWithWeight,
            selectedCredit: $selectedCredit,
            selectedGradeWithWeight: $selectedGradeWithWeight,
            selectedGPAWithWeight: $selectedGPAWithWeight
          })
        }
      }
    }
  }
}

