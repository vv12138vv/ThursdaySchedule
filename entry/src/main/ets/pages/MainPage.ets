import BottomBar from '../components/BottomBar'
import TodayCourseView from '../components/TodayCourseView'
@Entry
@Component
struct MainPage{
  build(){
    Stack(){
      Tabs(){
        TabContent(){
          TodayCourseView()
        }
      }
      BottomBar()
    }
  }
}