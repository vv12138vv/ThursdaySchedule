import router from '@ohos.router';
import CommonConstants from '../constants/CommonConstants';
// import { DetailListComponent } from '../view/DetailListComponent';

/**
 * Detail page to display more information.
 */
@Entry
@Component
struct LaunchPage {
  private titleParam: Resource = $r('app.string.detail_default_title');

  aboutToAppear() {
    if (router.getParams()) {
      this.titleParam = router.getParams()[CommonConstants.KEY_PARAM_DATA] as Resource;
    }
  }

  build() {
    Stack(){
      Image($r('app.media.back_mine1'))

      Column() {
        Image($r('app.media.logo'))
          .width($r("app.float.launch_logo_width"))
          .height($r("app.float.launch_logo_height"))
          .borderRadius($r("app.float.launch_logo_radius"))
          .margin({top:$r("app.float.launch_logo_margin")})
        Column(){
          Button('教务处账号登录')
            .width($r("app.float.launch_login_button_width"))
            .height($r("app.float.launch_login_button_height"))
            .borderRadius($r("app.float.launch_login_button_border_radius"))
            .fontColor('#C20C0C')
            .backgroundColor('#fff')
            .onClick(()=>{
              router.pushUrl({
                url: CommonConstants.LOGIN_PAGE
              });
              console.log('ok')
            })
          Button('立即体验')
            .width($r("app.float.launch_login_button_width"))
            .height($r("app.float.launch_login_button_height"))
            .borderRadius($r("app.float.launch_login_button_border_radius"))
            .fontColor('#000')
            .backgroundColor('transparent')
            .border({
              width:$r("app.float.launch_button_border_width"),
              color:"#fff"
            })
            .margin({
              top:$r("app.float.launch_button_border_margin")
            })
            .onClick(()=>{
              router.pushUrl({
                url: CommonConstants.PERSONAL_PAGE
              });
              console.log('ok')
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .position({
          x:0,
          y:'80%'
        })

      }
      .width("100%")
      .height("100%")
      // .width('100%')
      // .height(CommonConstants.DETAIL_COLUMN_HEIGHT_PERCENT)
      // .backgroundColor($r('app.color.theme_background'))
    }
  }
}