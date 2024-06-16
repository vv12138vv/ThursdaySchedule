export class NavBarConfig {
  leftIcon?: Resource | null = null;
  leftLabel?: string | null = null;
  title: string;
  rightIcon?: Resource | null = null;
  rightLabel?: string | null = null;
  onClickLeftButton?: (event?: ClickEvent) => void = () => {
  };
  onClickRightButton?: (event?: ClickEvent) => void = () => {
  };
}

@Component
export default struct NavBar {
  navBarConfig: NavBarConfig;

  build() {
    Row() {
      Stack() {
        if (this.navBarConfig.leftIcon) {
          Image(this.navBarConfig.leftIcon)
            .width(16)
            .onClick(this.navBarConfig.onClickLeftButton)
        } else if (this.navBarConfig.leftLabel) {
          Text(this.navBarConfig.leftLabel)
            .width(16)
            .onClick(this.navBarConfig.onClickLeftButton)
        }
      }
      .layoutWeight(1)

      Stack() {
        if (this.navBarConfig.title) {
          Text(this.navBarConfig.title)
            .fontColor("#FFFFFF")
        }
      }
      .layoutWeight(6)

      Stack() {
        if (this.navBarConfig.rightIcon) {
          Image(this.navBarConfig.rightIcon)
            .width(16)
            .onClick(this.navBarConfig.onClickRightButton)
        } else if (this.navBarConfig.rightLabel) {
          Text(this.navBarConfig.rightLabel)
            .onClick(this.navBarConfig.onClickRightButton)
            .fontColor("#FFFFFF")
        }
      }
      .layoutWeight(1)

    }
    .width("100%")
    .height($r("app.float.nav_bar_height"))
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.nav_bar_background_color'))
    .alignItems(VerticalAlign.Center)
  }
}

@Preview
@Component
struct NavBarPreview {
  build() {
    NavBar({
      navBarConfig: {
        title:"课程查询",
        leftIcon:$r('app.media.icon_back')
      }
    })
  }
}