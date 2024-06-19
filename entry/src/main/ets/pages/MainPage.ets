import BottomBar from '../components/BottomBar'
import TodayCourseView from '../components/TodayCourseView'
import router from '@ohos.router';
import RecentExamView from '../components/RecentExamView';
import TaskList from '../components/TaskList';
@Entry
@Component
struct MainPage {
  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Swiper() {
        TodayCourseView()
        TaskList({taskList: $taskList, taskTable: $taskTable})
        RecentExamView()
      }
      .backgroundColor(Color.Pink)
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
    .height('100%')
    .width('100%')
  }

  pageTransition(){
    PageTransitionExit({type:RouteType.Push,duration:300})
      .slide(SlideEffect.Top)
    PageTransitionEnter({type:RouteType.Pop,duration:300})
      .slide(SlideEffect.Top)
  }
}