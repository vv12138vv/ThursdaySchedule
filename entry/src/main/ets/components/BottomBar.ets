@Component
export default struct BottomBar {
  onClickLeftButton: (event?: ClickEvent) => void;
  onClickRightButton: (event?: ClickEvent) => void;


  build() {
    Row() {
      Button({ type: ButtonType.Normal,stateEffect:true }) {
        Image($r('app.media.icon_nav_course'))
          .width($r('app.float.bottom_bar_icon_width'))
          .height($r('app.float.bottom_bar_icon_height'))
      }
      .backgroundColor(Color.Transparent)
      .onClick(this.onClickLeftButton)
      .type(ButtonType.Circle)
      .width(48)
      .height(48)

      Button({ type: ButtonType.Normal,stateEffect:true }) {
        Image($r("app.media.icon_nav_score"))
          .width($r('app.float.bottom_bar_icon_width'))
          .height($r('app.float.bottom_bar_icon_height'))
      }
      .backgroundColor(Color.Transparent)
      .onClick(this.onClickRightButton)
      .type(ButtonType.Circle)
      .width(48)
      .height(48)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width($r('app.float.bottom_bar_width'))
    .height($r('app.float.bottom_bar_height'))
  }
}


@Preview
@Component
struct BottomBarPreview {
  build() {
    BottomBar()
  }
}