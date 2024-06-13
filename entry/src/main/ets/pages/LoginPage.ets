import router from '@ohos.router'
import prompt from '@ohos.prompt'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct LoginPage {
  @State password: string = ''
  @State username: string = ''

  build() {

    Column() {
      Text("登录")
        .fontSize($r('app.float.Login_login_text_font'))
        .fontWeight(FontWeight.Bold).margin({
        bottom: $r('app.float.Login_login_text_bottom')
      })
      Row() {
        Text("用户名")
          .fontSize($r('app.float.Login_title_text_font'))
          .fontWeight(FontWeight.Bold)
      }.width("100%")

      Row() {
        Image($r("app.media.icon")).width($r('app.float.Login_icon_width'))

        TextInput({
          placeholder: "请输入用户名"
        }).width($r('app.float.Login_input_token_width')).onChange((val: string) => {
          this.username = val


        })
      }.margin({
        bottom: $r('app.float.Login_bottom_margin'),
        top: $r('app.float.Login_bottom_margin')
      }).width("100%")

      Divider().strokeWidth(4)

      Row() {
        Text("密码")
          .fontSize($r('app.float.Login_title_text_font'))
          .fontWeight(FontWeight.Bold).margin({
          bottom: $r('app.float.Login_bottom_margin'),
          top: $r('app.float.Login_bottom_margin')
        })
      }.width("100%")

      Row() {
        Image($r("app.media.icon")).width($r('app.float.Login_icon_width'))

        TextInput({
          placeholder: "请输入密码"
        }).width($r('app.float.Login_input_token_width')).onChange((val: string) => {
          this.password = val


        }).type(InputType.Password)
      }.width("100%")

      Divider().strokeWidth(4)
      Row() {
        Blank()
        Text("忘记密码？")
          .fontSize($r('app.float.Login_title_text_font'))
          .fontWeight(FontWeight.Bold)
      }.width("100%")

      Button("登陆").width("90%").height($r('app.float.Login_button_height')).backgroundColor(Color.Orange).onClick(() => {

        if (this.username == "admin" && this.password == "admin") {

          router.pushUrl({
            url: "pages/PersonalPage"
          })
        }
        else {
          promptAction.showToast({
            message:"密码或用户名错误，请重新输入"
          })
        }
      })

      // Text("第三方登陆")
      //   .fontSize(18).margin({
      //   bottom: 40,
      //   top: 60
      // })
      // Row({ space: 8 }) {
      //   Image($r("app.media.icon")).width(60)
      //   Image($r("app.media.icon")).width(60)
      //   Image($r("app.media.icon")).width(60)
      //
      // }
      //
      // Text("立即注册")
      //   .fontSize(18).margin({
      //   top: 20,
      // })

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({
      left: 20,
      right: 20
    })
  }
}
