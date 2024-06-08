import { CommonDialog } from '../views/CommonDialog'
import { RoutePath } from '../route/RoutePath'
import { Router } from '../route/Router'


@Entry
@Component
struct Index {
  @State dialogTitle: Resource = $r('app.string.dialog_about_title')
  @State dialogContent: Resource = $r('app.string.project_desc')
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CommonDialog({ title: $dialogTitle, description: $dialogContent, showPositive: false })
  })

  build() {
    Stack(){
      Image($r('app.media.back_mine1'))

      Column() {
        Column() {
          Image($r('app.media.default_avatar'))
            .height($r('app.float.size_70'))
            .width($r('app.float.size_70'))
            .border({ radius: $r('app.float.size_35') })
          Text("Harmony-周四课表")
            .fontColor($r('app.color.color_black'))
            .fontSize($r('app.float.size_text_20'))
            .margin({ top: $r('app.float.size_15') })
        }
        .width("100%")
        .height($r('app.float.size_350'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)


        Column(){
          this.itemBuilder("背景设置", $r('app.media.icon_focus'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "focus" })
          })
          this.itemBuilder("主题颜色搭配", $r('app.media.icon_type'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "category" })
          })
          this.itemBuilder("桌面小组件选项", $r('app.media.icon_topic'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "topic" })
          })
          this.itemBuilder("使用帮助", $r('app.media.icon_sel_find'), () => {
            Router.push(RoutePath.ContainerPage, { "containerType": "help" })
          })
          this.itemBuilder("关于", $r('app.media.icon_about'), () => {
            this.dialogController.open()
          })
        }
        .width("90%")
        .height($r('app.float.size_270'))
        .borderColor('#000000')
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
        Image(icon).width($r('app.float.size_25')).height($r('app.float.size_25'))
        Text(title)
          .fontSize($r('app.float.size_text_15'))
          .fontColor($r('app.color.color_333'))
          .margin({ left: $r('app.float.size_10') })
      }
      .height($r('app.float.size_50'))
      .width("100%")
      .alignItems(VerticalAlign.Center)
      .padding({ left: $r('app.float.size_10') })

      Divider()
        .color($r('app.color.color_f5f5f5'))
        .width("100%")
    }
    .height($r('app.float.size_50'))
    .width("100%")
    .onClick(() => {
      onItemClick?.()
    })
  }
}