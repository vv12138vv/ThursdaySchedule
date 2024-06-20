import router from '@ohos.router'
import { CommonTopBar } from '../../components/CommonTopBar'
import { HelpPage } from './HelpPage'
import { BgPage } from './BgPage'
import { theme } from '../../components/theme'
// import { FocusPage } from '../find/focus/FocusPage'
// import { TopicPage } from '../find/topic/TopicPage'

@Entry
@Component
struct ContainerPage {
  @State containerType: string = 'focus'
  @State title: string = "设置"
  @Provide findCurrentIndex: number = -1
  @Provide homeTabSelected: number = -1
  @StorageLink('bgpage') bgpage: number = 1;

  aboutToAppear() {
    this.containerType = router.getParams()["containerType"]
    this.convertTitle()
  }

  build() {
    Stack() {
      Image(theme.getBackground(this.bgpage))
      Column() {
        CommonTopBar({ title: this.title, alpha: 1 })
        Stack() {
          this.buildContent()
        }.layoutWeight(1)

      }
    }
    .width("100%")
    .height("100%")
  }

  @Builder
  buildContent() {
    if (this.containerType == 'help') {
      HelpPage()
    } else if (this.containerType == 'topic') {
      Text("功能暂未开发，敬请期待")
      // TopicPage({ hasInit: true })
    } else if (this.containerType == 'bg_setting') {
      BgPage()
    } else {
      Text('设置界面')
    }
  }

  convertTitle() {
    if (this.containerType == 'bg_setting') {
      this.title = "背景设置"
    } else if (this.containerType == 'category') {
      this.title = "主题颜色搭配"
    } else if (this.containerType == 'topic') {
      this.title = "桌面小组件选项"
    } else if (this.containerType == 'help') {
      this.title = "使用帮助"
    }
  }
}