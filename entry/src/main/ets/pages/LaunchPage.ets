import router from '@ohos.router';
import CommonUI from '../constants/CommonUIConstants'
import { CommonConstants } from '../constants/CommonConstants';
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
    Column() {
      Image($r('app.media.icon'))
        .width($r('app.float.Launch_logo_width'))
        .height($r('app.float.Launch_logo_height'))
        .borderRadius($r('app.float.Launch_logo_radius'))
        .margin({top:$r('app.float.Launch_logo_margin')})
      Column(){
        Button('教务处账号登录')
          .width($r('app.float.Launch_login_button_width'))
          .height($r('app.float.Launch_login_button_height'))
          .borderRadius($r('app.float.Launch_login_button_border_radius'))
          .fontColor('#000')
          .backgroundColor('#fff')
          .onClick(()=>{
            router.pushUrl({
              url: CommonConstants.LOGIN_PAGE
            });
            console.log('ok')
          })
        Button('立即体验')
          .width($r('app.float.Launch_login_button_width'))
          .height($r('app.float.Launch_login_button_height'))
          .borderRadius($r('app.float.Launch_login_button_border_radius'))
          .fontColor('#000')
          .backgroundColor('transparent')
          .border({
            width:$r('app.float.Launch_button_border_width'),
            color:"#fff"
          })
          .margin({
            top:$r('app.float.Launch_button_border_margin')
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
    .backgroundColor(CommonUI.COLOR_DEFAULT.background)
  }
}