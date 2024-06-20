import router from '@ohos.router'
import prompt from '@ohos.prompt'
import promptAction from '@ohos.promptAction'
import { Network } from '../utils/Network'

@Entry
@Component
struct LoginPage {
  @State password: string = ''
  @State username: string = ''
  @State verifyCode: string = ''

  @State imgCode:string = ''

  icon_input_space:number = 20

  //todo 这里要加上全局的状态，是否登录
  @State isLogin:Boolean = false
  onPageShow(){
    this.showVerifyCode()
  }


  async showVerifyCode():Promise<void>{
    const network = new Network();
     this.imgCode = await network.getVerifyCode();
  }

  async  login(uid:string, pwd:string, verify:string):Promise<void>{
    const network = new Network();
    const userInfo = await network.userLogin(uid, pwd, verify);
    if(userInfo === "error"){
      promptAction.showToast({
        message:"密码或用户名错误，请重新输入"
      })
      this.username = '';
      this.password = '';
      this.verifyCode = '';
      this.showVerifyCode();
    } else {
      this.isLogin = true;


      router.pushUrl({
        url: "pages/PersonalPage"
      })
    }
  }

  build() {
  Stack(){
    Video({
      src:$rawfile('login_video.mp4')
    })
    .autoPlay(true)
    .controls(false)
    .loop(true)

    Column() {
      Text("登  录")
        .fontSize($r("app.float.login_login_text_font"))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_fff'))
        .margin({
        bottom: $r("app.float.login_login_text_bottom")
      })
      Stack(){
        Column(){
          Row({space:this.icon_input_space}) {
            Image($r("app.media.icon_login_user")).width($r("app.float.login_icon_width"))

            TextInput({
              placeholder: "请输入学号"
            })
              .width($r("app.float.login_input_token_width")).onChange((val: string) => {
              this.username = val
            })
              .backgroundColor($r('app.color.placeHolder_white'))
              .placeholderColor($r('app.color.font_gray_white'))
          }.width("100%")
          .input_line_style()



          Row({space:this.icon_input_space}) {
            Image($r("app.media.icon_login_pwd")).width($r("app.float.login_icon_width"))

            TextInput({
              placeholder: "请输入密码"
            }).width($r("app.float.login_input_token_width"))
              .backgroundColor($r('app.color.placeHolder_white'))
              .placeholderColor($r('app.color.font_gray_white'))
              .onChange((val: string) => {
                this.password = val


              })
              .type(InputType.Password)
          }.width("100%")
          .input_line_style()


          Row({space:this.icon_input_space}) {
            Image($r("app.media.icon_login_verify")).width($r("app.float.login_icon_width"))

            TextInput({
              placeholder: "验证码"
            })
              .width('130vp').onChange((val: string) => {
              this.verifyCode = val
            })
              .backgroundColor($r('app.color.placeHolder_white'))
              .placeholderColor($r('app.color.font_gray_white'))

            Image(this.imgCode)
              .width('98vp')
              .height('35vp')
              .onClick(()=>{
                this.showVerifyCode()
              })
          }.width("100%")
          .input_line_style()

          Button("Login")
            .width("55%")
            .height($r("app.float.login_button_height"))
            .backgroundColor('#a899c494')
            .onClick(() => {
              this.login(this.username, this.password, this.verifyCode)
            })
            .fontSize('25vp')
            .input_line_style()
            .margin({
              top:'50vp'
            })
        }.margin({
          top:'30vp',
          bottom:'30vp',
          right:5
        })
        .padding({left:20})
      }
      .backgroundColor('#2fffffff')

      .borderRadius('16vp')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#59000000')
    .borderRadius('10vp')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({
      left: 20,
      right: 20
    })
  }
  }

  @Styles input_line_style(){
    .margin({
      bottom: $r("app.float.login_bottom_margin"),
      top: $r("app.float.login_bottom_margin")
    })
  }
}
