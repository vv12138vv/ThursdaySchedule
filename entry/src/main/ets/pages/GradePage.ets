import GradeSummary from '../components/GradeSummary';
import GradeBlock from '../components/GradeBlock';
import router from '@ohos.router';
import NavBar, { NavBarConfig } from '../components/NavBar';
import Grade, { gradeToGPA, transToGradeNum } from '../database/models/Grade';
import GradeTable from '../database/tables/GradeTable';
import { WindowMode } from '@ohos.UiTest';

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

  //所有成绩信息
  @Provide('allGrades') @Watch('onAddToAllGrades')allGrades: Grade[] = [];
  //页面中被选中的所有 GradeId
  @Provide('allSelectedGradeId')@Watch('onAllSelectedGradeIdChange') allSelectedGradeId: number[] = [];
  //页面总成绩信息
  @Provide totalCredit:number=0;
  @Provide totalGradeWithWeight: number = 0;
  @Provide totalGPAWithWeight: number = 0;
  @Provide totalAverageGrade:number=0;
  @Provide totalAverageGPA:number=0;

  @State selectedCredit: number = 0;
  @State selectedGradeWithWeight: number = 0;
  @State selectedGPAWithWeight: number = 0;
  @State selectedAverageGrade: number = 0;
  @State selectedAverageGPA: number = 0;
  //学期信息
  terms:string[]=['2021-2022-1'];

  onAddToAllGrades(){
    this.totalCredit=0;
    this.totalGradeWithWeight=0;
    this.totalGPAWithWeight=0;
  }

  //当选择的课程变化后，全局的数据变化。
  onAllSelectedGradeIdChange(){
    this.selectedCredit=0;
    this.selectedGradeWithWeight=0;
    this.selectedGPAWithWeight=0;
    //todo 应该有更好的解决方案
    this.allGrades.forEach((value:Grade,index:number)=>{
      if(!this.allSelectedGradeId.includes(value.id)){
        return;
      }
      this.selectedCredit+=value.credit;
      let gradeNum=transToGradeNum(value.grade);
      this.selectedGradeWithWeight+=gradeNum*value.credit;
      this.selectedGPAWithWeight+=gradeToGPA(value.grade)*value.credit;
    })
    this.selectedAverageGrade=this.selectedGradeWithWeight/this.selectedCredit;
    this.selectedAverageGPA=this.selectedGPAWithWeight/this.selectedCredit;
  }


  initGradeInfo(grades: Grade[]) {
    grades.forEach((item: Grade, index: number) => {
      this.totalCredit += item.credit;
      let gradeNum = transToGradeNum(item.grade);
      this.totalGradeWithWeight += gradeNum * item.credit;
      this.totalGPAWithWeight += gradeToGPA(item.grade) * item.credit;
      //若无则添加
      if (!this.allSelectedGradeId.includes(item.id)) {
        this.allSelectedGradeId.push(item.id);
      }
    });
    //默认全选,更新 selected 数据
    this.selectedCredit = this.totalCredit;
    this.selectedGradeWithWeight = this.totalGradeWithWeight;
    this.selectedGPAWithWeight = this.totalGPAWithWeight;
    this.selectedAverageGrade = this.selectedGradeWithWeight / this.selectedCredit;
    this.selectedAverageGPA = this.selectedAverageGPA / this.selectedCredit;
  }

  aboutToAppear() {

  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Scroll() {
        Column({space:32}) {
          GradeSummary({
            totalCredit: $totalCredit,
            totalAverageGrade: $totalAverageGrade,
            totalAverageGPA: $totalGPAWithWeight,
            selectedCredit: $selectedCredit,
            selectedAverageGrade: $selectedAverageGrade,
            selectedAverageGPA: $selectedAverageGPA
          })
            .border({width:{left:0.5,right:0.5}})
          ForEach(this.terms,(value:string,index:number)=>{
            GradeBlock({
              termInString:value
            })
          })
        }
      }
      .margin({top:10})
    }
  }
}

