import CommonUI from '../constants/CommonUIConstants'
import Course from '../database/models/Course'
import CourseTable from '../database/tables/CourseTable'
import relationalStore from '@ohos.data.relationalStore'
import { CommonConstants } from '../constants/CommonConstants';


@Entry
@Component

struct CoursePage {
  @State currentIndex: number = 0
  @State courseList: Array<Course> = []
  private courseTable = new CourseTable(() => {});
  private controller: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {     //首页按钮点击效果
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
        .fillColor(this.currentIndex === targetIndex ? $r('app.color.current_index') : $r('app.color.target_index'))
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r('app.color.current_index') : $r('app.color.target_index'))
        .fontSize(12)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.controller.changeIndex(targetIndex)
    })
  }


  aboutToAppear() { //看开发者指南，组件即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其build()函数之前执行   我把加载数据放这里了
    this.courseTable.getRdbStore(() => { // 获取数据库
      let predicates = new relationalStore.RdbPredicates("CourseTable");
      predicates.equalTo("is_today", 1)
      this.courseTable.queryData(predicates, (result: Course[]) => { // 查询数据库中的全部账目
        this.courseList = result;
      });
    });
  }


  build() {
    Column() {
      //Tabs组件的页面组成包含两个部分，分别是TabContent和TabBar。TabContent是内容页，TabBar是导航页签栏，清单我写了，剩下两个待定
      Tabs({ barPosition: (BarPosition.End), controller: this.controller }) {
        TabContent() {
          List() {
            ForEach(this.courseList, (item: Course, index) => {
              ListItem() {
                Row() {
                  Image($r('app.media.icon'))
                    .width(40)
                    .aspectRatio(CommonConstants.FULL_SIZE)
                    .margin({ right: 16 })

                  Text("??")
                    .height(22)
                    .fontSize(16)

                  Blank()
                    .layoutWeight(1)

                }
                .width("100%")
                .padding({ left: 12, right: 12 })
              }
              .width("100%")
              .height(56)
            })
          }
          .width('100%')
          .borderRadius(20)
          .divider({ strokeWidth: 1 })
          .margin({ bottom: 20 })

        }.tabBar(this.TabBuilder("我的待办", 0, $r('app.media.ic_public_home_filled'), $r('app.media.ic_public_home')))
        TabContent() {

        }.tabBar(this.TabBuilder("待定", 1, $r('app.media.ic_public_home_filled'), $r('app.media.ic_public_home')))
        TabContent() {

        }.tabBar(this.TabBuilder("待定", 2, $r('app.media.ic_public_home_filled'), $r('app.media.ic_public_home')))
      }.onChange((index: number) => {
        this.currentIndex = index
      })
      .scrollable(false)
      // .height(50)
      // .width('100%')
    }.width('100%')
    .height('100%')
    .backgroundColor(CommonUI.COLOR_DEFAULT.background)
  }

}