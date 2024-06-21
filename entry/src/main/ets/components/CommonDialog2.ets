import {theme} from './theme'
/**
 *通用Dialog弹窗组件
 */
@CustomDialog
export struct CommonDialog2 {

  //自定义加载的内容
  @BuilderParam contentBuilder?: () => void
  //标题
  @Link title: Resource
  //确认按钮文案
  private positiveText = "确认"
  //取消按钮文案
  private negativeText = "取消"
  //确认按钮回调
  private positiveCallback: () => void
  //取消按钮回调
  private negativeCallback: () => void
  //展示确认按钮
  private showPositive = true
  //展示取消按钮
  private showNegative = true
  //弹窗控制器
  controller: CustomDialogController

  @StorageLink('SystemColor') Sys_color: number = 1

  @State theme: number = 1;

  aboutToAppear() {

  }

  build() {

    Stack() {
      Column() {
        Text(this.title)
          .fontSize($r('app.float.commondialog_size'))
          .fontColor($r('app.color.color_red'))
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .height($r('app.float.commondialog_height'))
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Divider().color($r('app.color.color_f5f5f5'))

        Row(){
          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0xd81e06)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 1;
              this.controller.close()
            })

          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0xff6100)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 2;
              this.controller.close()
            })

          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0xffff00)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 3;
              this.controller.close()
            })

          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0x228b22)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 4;
              this.controller.close()
            })
        }

        Row(){
          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0x03a89e)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 5;
              this.controller.close()
            })

          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0x0000ff)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 6;
              this.controller.close()
            })

          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0xa020f0)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 7;
              this.controller.close()
            })

          Button('', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(15)
            .backgroundColor(0xffc0cb)
            .width(30)
            .height(30)
            .margin(10)
            .onClick(() => {
              this.Sys_color = 8;
              this.controller.close()
            })
        }

        Divider().color($r('app.color.color_f5f5f5')).padding(0)

        Row() {
          Text(this.negativeText)
            .flexShrink(1)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
            .visibility(this.showNegative ? Visibility.Visible : Visibility.None)
            .onClick(() => {
              this.negativeCallback?.()
              this.controller.close()
            })
          Divider()
            .color($r('app.color.color_f5f5f5'))
            .vertical(true)
            .visibility((this.showPositive && this.showNegative) ? Visibility.Visible : Visibility.None)
          Text(this.positiveText)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
            .fontColor($r('app.color.color_red'))
            .visibility(this.showPositive ? Visibility.Visible : Visibility.None)
            .onClick(() => {
              this.positiveCallback?.()
              this.controller.close()
            })
        }
        .height($r('app.float.commondialog_cancel_button_height'))
        .width("100%")
      }
      .backgroundColor($r('app.color.color_white'))
      .border({ radius: $r('app.float.commondialog_border') })
      .alignItems(HorizontalAlign.Center)
    }
    .width("100%")
  }
}