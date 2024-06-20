import { LogUtils } from '../../utils/LogUtils';
import {theme} from '../../components/theme';
@Component
export struct BgPage{

  @StorageLink('bgpage') bgpage: number = 1;

  build(){
    Column() {
      Stack() {
        Row() {
          Image($r('app.media.back_mine1'))
            .width(100)
            .height(130)
            .margin(10)
            .onClick(() => {
              this.bgpage = 1;
              // this.controller.close()
            })
          Image($r('app.media.back_mine2'))
            .width(100)
            .height(130)
            .margin(10)
            .onClick(() => {
              LogUtils.debug("click");
              this.bgpage = 2;
              // this.controller.close()
            })
         }
        }
        Stack() {
          Row() {
            Image($r('app.media.back_mine3'))
              .width(100)
              .height(130)
              .margin(10)
              .onClick(() => {
                this.bgpage = 3;
                // this.controller.close()
              })
            Image($r('app.media.back_mine4'))
              .width(100)
              .height(130)
              .margin(10)
              .onClick(() => {
                LogUtils.debug("click");
                this.bgpage = 4;
                // this.controller.close()
              })
          }
        }
        Stack() {
          Row() {
            Image($r('app.media.back_mine5'))
              .width(100)
              .height(130)
              .margin(10)
              .onClick(() => {
                this.bgpage = 5;
                // this.controller.close()
              })
            Image($r('app.media.back_mine6'))
              .width(100)
              .height(130)
              .margin(10)
              .onClick(() => {
                LogUtils.debug("click");
                this.bgpage = 6;
                // this.controller.close()
              })
          }
        }
        Stack() {
          Row() {
            Image($r('app.media.back_mine7'))
              .width(100)
              .height(130)
              .margin(10)
              .onClick(() => {
                this.bgpage = 7;
                // this.controller.close()
              })
            Image($r('app.media.back_mine8'))
              .width(100)
              .height(130)
              .margin(10)
              .onClick(() => {
                LogUtils.debug("click");
                this.bgpage = 8;
                // this.controller.close()
              })
          }
        }
      }
    }

}