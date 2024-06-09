@Component
export default struct BottomBar {
  onClickLeftButton: (event?: ClickEvent) => void;
  onClickMiddleButton: (event?: ClickEvent) => void;
  onClickRightButton: (event?: ClickEvent) => void;

//Todo 有些效果得等实装才能调整，Preview 不支持

  build() {
    Row() {
      Button({ type: ButtonType.Normal,stateEffect:true }) {
        Image($r('app.media.icon_schedule'))
          .width($r('app.float.bottom_bar_icon_width'))
          .height($r('app.float.bottom_bar_icon_height'))
      }
      .backgroundColor(Color.Transparent)
      .onClick(this.onClickLeftButton)

      Button({ type: ButtonType.Normal,stateEffect:true }) {
        Image($r('app.media.icon_exam'))
          .width($r('app.float.bottom_bar_icon_width'))
          .height($r('app.float.bottom_bar_icon_height'))
      }
      .backgroundColor(Color.Transparent)
      .onClick(this.onClickMiddleButton)

      Button({ type: ButtonType.Normal,stateEffect:true }) {
        Image($r("app.media.icon_grade"))
          .width($r('app.float.bottom_bar_icon_width'))
          .height($r('app.float.bottom_bar_icon_height'))
      }
      .backgroundColor(Color.Transparent)
      .onClick(this.onClickRightButton)

    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
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