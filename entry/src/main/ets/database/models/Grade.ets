export enum TestType { //考察方式
  Exam = "Exam", //考试
  Evaluation = "Evaluation" //考察
}

export default class Grade{
  id?:number;
  courseId:string;
  courseName:string;
  credit:number;
  grade:string;
  testType: string; //考察方式
  gpa: number;
  time:string;
}

export let gradeDemo:Grade={
  id:1,
  courseId:'test',
  courseName:'test',
  credit:1.5,
  grade:'98',
  testType:TestType.Exam,
  gpa:4.0,
  time:'test_time'
};

function canBeNumber(gradeString: string) {
  return !isNaN(Number(gradeString));
}

export function transToGradeNum(gradeString:string):number{
  let gradeNum=0;
  if(canBeNumber(gradeString)){
    return Number(gradeString);
  }else{
    if(gradeString==="优"){
      gradeNum=90;
    }else if(gradeString==="良"){
      gradeNum =80;
    }else if(gradeString==="中"){
      gradeNum=70;
    }else if(gradeString==="及格"){
      gradeNum=60;
    }
  }
  return gradeNum;
}

export function gradeToGPA(gradeString: string): number {
  let gradeNum=transToGradeNum(gradeString);
  let gpa:number=0;
  if(gradeNum>=90){
    gpa=4.0;
  }else if(gradeNum<90&&gradeNum>=85){
    gpa=3.7;
  }else if(gradeNum<85&&gradeNum>=82){
    gpa=3.3;
  }else if(gradeNum<82&&gradeNum>=78){
    gpa=3.0;
  }else if(gradeNum<78&&gradeNum>=75){
    gpa=2.7;
  }else if(gradeNum<75&&gradeNum>=72){
    gpa=2.3;
  }else if(gradeNum<72&&gradeNum>=68){
    gpa=2.0;
  }else if(gradeNum<68&&gradeNum>=64){
    gpa=1.5;
  }else if(gradeNum<64&&gradeNum>=60){
    gpa=1.0;
  }else if(gradeNum<60){
    gpa=0;
  }
  return gpa;
}

