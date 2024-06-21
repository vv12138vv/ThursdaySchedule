import BottomBar from '../components/BottomBar'
import TodayCourseView from '../components/TodayCourseView'
import router from '@ohos.router';
import RecentExamView from '../components/RecentExamView';
import TaskList from '../components/TaskList';
import TaskTable from '../database/tables/TaskTable';
import { TaskListItemData } from '../database/models/Task';
import {Network} from '../utils/Network';
import DataPool from '../utils/DataPool';
@Entry
@Component
struct MainPage {
  @State currentView: number = 1;
  isLogin:boolean=false;
  updateView(index:number){
    this.currentView = index;
  }

  switchColor(index: number):string{
    if (index == 1){ // lesson
      return '#ffae9292'
    } else if (index == 0){ //to do
      return '#ff4766a4'
    } else {
      return '#ffd6c262'
    }
  }


  build() {
    Stack(){
      Column(){

        // 用户头像以及title
        Row(){
          Text( this.currentView === 0 ? '我的待办' :
                this.currentView === 1 ? '今日课程' :
                '近期考试'
              )
            .fontSize(36)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .animation({duration:300,curve:Curve.Friction})
            .margin({top:40,left:40})
          Button(){
            Image($r('app.media.icon_user'))
          }
          .onClick(()=>{
            this.isLogin=DataPool.isLogin;
            if(this.isLogin===false){
              router.pushUrl({
                url:'pages/LoginPage'
              })
            }else{
              router.pushUrl({
                url:"pages/PersonalPage",
              })
            }

          }).height('40vp')
          .width('40vp')
          .margin({right:30})
          .backgroundColor('#00ffffff')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height('15%')

        Stack({ alignContent: Alignment.Bottom }) {
          Swiper(){
            TaskList()
            TodayCourseView()

            RecentExamView()
          }
          .onChange((index:number)=> this.updateView(index))
          .loop(false)
          .index(1)
          BottomBar({
            onClickLeftButton:()=>{
              router.pushUrl({
                url:'pages/AllCoursePage'
              })
            },
            onClickRightButton:()=>{
              router.pushUrl({
                url:'pages/GradePage'
              })
            }
          })

        }
        .height('85%')
        .width('100%')

      }
      .height('100%')
    }
    .height('100%')
    .backgroundColor(this.switchColor(this.currentView))
    .animation({duration:500,curve:Curve.Ease})

  }

  pageTransition(){
    PageTransitionExit({type:RouteType.Push,duration:200,curve:Curve.Friction})
      .slide(SlideEffect.Top)
    PageTransitionEnter({type:RouteType.Pop,duration:200,curve:Curve.Friction})
      .slide(SlideEffect.Top)
  }
}