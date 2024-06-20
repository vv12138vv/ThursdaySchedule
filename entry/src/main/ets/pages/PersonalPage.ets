import { CommonDialog } from '../components/CommonDialog'
import { CommonDialog2 } from '../components/CommonDialog2'
import { RoutePath } from '../constants/RoutePath'
import { Router } from '../utils/Router'
import { theme } from '../components/theme'


@Entry
@Component
struct PersonalPage {
  @State dialogTitle1: Resource = $r('app.string.dialog_about_title1')
  @State dialogTitle2: Resource = $r('app.string.dialog_about_title2')
  @State dialogContent1: Resource = $r('app.string.project_desc')
  @StorageLink('bgpage') bgpage: number = 1;
  dialogController1: CustomDialogController = new CustomDialogController({
    builder: CommonDialog({ title: $dialogTitle1, description: $dialogContent1, showPositive: false })
  })
  dialogController2: CustomDialogController = new CustomDialogController({
    builder: CommonDialog2({ title: $dialogTitle2, showPositive: false })
  })


  build() {
    Stack(){
      Image(theme.getBackground(this.bgpage))

      Column() {
        Column() {
          Image($r('app.media.default_avatar'))
            .height($r('app.float.avatar_height'))
            .width($r('app.float.avatar_width'))
            .border({ radius: $r('app.float.avatar_border') })
          Text("Harmony-周四课表")
            .fontColor($r('app.color.color_black'))
            .fontSize($r('app.float.personal_size'))
            .margin({ top: $r('app.float.personal_margin') })
        }
        .width("100%")
        .height($r('app.float.personal_avatar_title_height'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)


        Column(){
          this.itemBuilder("背景设置", $r('app.media.icon_focus'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "bg_setting" })
          })
          this.itemBuilder("主题颜色搭配", $r('app.media.icon_type'), () => {
            this.dialogController2.open()
          })
          this.itemBuilder("桌面小组件选项", $r('app.media.icon_topic'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "topic" })
          })
          this.itemBuilder("使用帮助", $r('app.media.icon_sel_find'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "help" })
          })
          this.itemBuilder("关于", $r('app.media.icon_about'), () => {
            this.dialogController1.open()
          })
        }
        .width("90%")
        .height($r('app.float.personal_options_height'))
        // .backgroundColor('#ffffff')
        // .opacity(0.9)
        .borderColor('#ffffff')
        .borderWidth(1)
        .borderRadius(10)

      }
      .width("100%")
      .height("100%")
      // .justifyContent(FlexAlign.Start).height("100%")
    }
  }



  @Builder
  itemBuilder(title: string, icon: Resource, onItemClick?: () => void) {
    Stack({ alignContent: Alignment.Bottom }) {
      Row() {
        Image(icon).width($r('app.float.icon_width')).height($r('app.float.icon_height'))
        Text(title)
          .fontSize($r('app.float.title_size'))
          .fontColor($r('app.color.color_333'))
          .margin({ left: $r('app.float.title_margin') })
      }
      .height($r('app.float.personal_option_height'))
      .width("100%")
      .alignItems(VerticalAlign.Center)
      .padding({ left: $r('app.float.personal_padding') })

      Divider()
        .color($r('app.color.color_f5f5f5'))
        .width("100%")
    }
    .height($r('app.float.personal_itembuilder_height'))
    .width("100%")
    .onClick(() => {
      onItemClick?.()
    })
  }
}