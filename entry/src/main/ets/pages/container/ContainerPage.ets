import router from '@ohos.router'
import { CommonTopBar } from '../../components/CommonTopBar'
// import { CategoryPage } from '../find/category/CategoryPage'
// import { FocusPage } from '../find/focus/FocusPage'
// import { TopicPage } from '../find/topic/TopicPage'

@Entry
@Component
struct ContainerPage {
  @State containerType: string = 'focus'
  @State title: string = "设置"
  @Provide findCurrentIndex: number = -1
  @Provide homeTabSelected: number = -1

  aboutToAppear() {
    this.containerType = router.getParams()["containerType"]
    this.convertTitle()
  }

  build() {
    Column() {
      CommonTopBar({ title: this.title, alpha: 1 })
      Stack() {
        this.buildContent()
      }.layoutWeight(1)

    }
  }

  @Builder
  buildContent() {
    // if (this.containerType == 'focus') {
    //   FocusPage({ hasInit: true })
    // } else if (this.containerType == 'topic') {
    //   TopicPage({ hasInit: true })
    // } else if (this.containerType == 'category') {
    //   CategoryPage({ hasInit: true })
    // } else {
      Text("设置页面")
    // }

  }

  convertTitle() {
    if (this.containerType == 'focus') {
      this.title = "背景设置"
    } else if (this.containerType == 'category') {
      this.title = "主题颜色搭配"
    } else if (this.containerType == 'topic') {
      this.title = "桌面小组件选项"
    }
    else if (this.containerType == 'help') {
      this.title = "使用帮助"
    }
  }
}