import Course from '../database/models/Course';
import NavBar, { NavBarConfig } from '../components/NavBar';
import router from '@ohos.router';


@CustomDialog
struct CourseDetailDialog{
  dialogController?: CustomDialogController;
  course:Course;

  build(){
    Column(){
      Text()
      Text()
      Row(){
        Text()
        Column(){
          Text()
          Text()
          Text()
          Text()
        }
      }
    }
  }
}



@Entry
@Component
struct AllCoursePage {
  //导航栏控制条
  navBarConfig: NavBarConfig = {
    leftIcon: $r('app.media.icon_back'),
    title: "课表查询",
    onClickLeftButton: () => {
      router.back();
    }
  };
  //课程详细控制器
  courseDetailDialogController:CustomDialogController=new CustomDialogController({
    builder:CourseDetailDialog({

    }),
    autoCancel:true,
    alignment:DialogAlignment.Bottom,
    customStyle:true
  })

  //单个课程的可点击块
  @Builder CourseCube(course: Course) {
    Column() {
      //Todo 时间还可能需要处理
      Text(course.time)
      Text(course.location)
      Text(course.name)
    }
    .onClick(() => {

    })
  }

  //表示时间的ui，课表顶部使用
  @Builder DateCube(date: number) {
    Column() {
      Text()
      Text()
    }
  }

  //课表顶部的时间 bar
  @Builder DateBar() {
    Row() {
      Text()

    }
  }

  //课表核心主主体
  @Builder CourseTable() {
    Grid(){
      GridItem(){
        Text('1')
      }
      .backgroundColor(Color.Black)
      .rowStart(1)
      .rowEnd(2)
      .columnStart(1)
      .columnEnd(2)
      GridItem(){
        Text('2')
      }
      .rowStart(4)
      .rowEnd(5)
      .columnStart(4)
      .columnEnd(5)
      .backgroundColor(Color.Black)
    }
    .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsTemplate('0.25fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsGap(4)
    .rowsGap(2)
  }

  //课表底部
  @Builder CourseTableFooter() {
    Row() {
      Text()
    }
  }

  build() {
    Column(){
      NavBar({navBarConfig:this.navBarConfig})
      this.CourseTable()
    }
  }
}



