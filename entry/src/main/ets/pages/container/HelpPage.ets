@Component
export struct HelpPage{

  build(){
    Column() {
      Stack() {
        Text('周四课表是一款基于HarmonyOS打造的大学生课表管理软件，可实现课表信息一键导入、教务信息获取、课程提醒、课程多端同步等实用功能；同时附加了日程、待办、专注等三大学生常用功能模块，为大学生提供一套清晰的课业管理方案，帮助提升学习效率；并且软件 0 广告、0 收费，全功能开放。')
          .width(300)
          .fontSize(15)
          .padding(10)
          .margin(5)
      }

      Stack() {
        Image($r('app.media.icon'))
          .height($r('app.float.avatar_height'))
          .width($r('app.float.avatar_width'))
          .border({ radius: $r('app.float.avatar_border') })
      }

      Stack() {
        Text('周四课表界面采取极简UI风格绘制，简约但不简陋，信息集中有效。具体特色功能如下：')
          .width(300)
          .fontSize(15)
          .padding(10)
          .margin(5)
      }

      Stack() {
        Text('1. 内嵌高校教务系统，教务信息即刻获取，同时可以方便的查看考试科目和考试成绩，并且支持excel课表一键导入')
          .width(300)
          .fontSize(15)
          .padding(10)
          .margin(5)
      }

      Stack() {
        Text('2. 它不仅仅是课表，课程表、日程表、待办表等实用功能一应俱全，满足学生课业管理所需。')
          .width(300)
          .fontSize(15)
          .padding(10)
          .margin(5)
      }
    }
  }

}