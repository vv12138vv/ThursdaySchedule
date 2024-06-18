import BottomBar from '../components/BottomBar'
import TodayCourseView from '../components/TodayCourseView'
import router from '@ohos.router';
@Entry
@Component
struct MainPage {
  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Swiper() {
        TodayCourseView()
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
    PageTransitionEnter({type:RouteType.Pop,duration:400})
      .slide(SlideEffect.Top)
  }
}