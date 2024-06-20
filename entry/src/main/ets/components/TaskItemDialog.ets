import promptAction from '@ohos.promptAction'
import { TaskListItemData } from '../database/models/Task'
import Logger from '../utils/Logger'



@CustomDialog
export struct TaskItemDialog {
  @Link taskItem: TaskListItemData
  @Link dialogIsAddNew: boolean
  controller: CustomDialogController
  confirm: (dialogIsAddNew: boolean, newTask: TaskListItemData) => void

  private taskName: string
  private taskSubject: number
  private startDate: Date
  private taskDate: Date
  private taskDetailText: string
  private taskDdlDetail: string = '0.3-0.5-0.9'


  @State startTask: string[] = ['', '']
  @State endTask: string[] = ['', '']
  @State handlePopup: boolean = false

  @Builder DatePickerMenu($$:{date: Date, str: string[]}) {
    Menu() {
      MenuItem() {
        DatePicker({
          start: new Date('1970-01-01'),
          selected: $$.date,
          end: new Date('2100-01-01')
        })
          .onChange((value: DatePickerResult) => {
            Logger.debug(`TaskItemDialog date = ${JSON.stringify(value)}`)
            $$.date.setFullYear(value.year, value.month, value.day)
            Logger.debug(`TaskItemDialog res = ${JSON.stringify($$.date)}, str = ${$$.date.toLocaleString()}`)
            $$.str[0] = getDateString($$.date.getTime())
          })
          .backgroundColor($r('app.color.start_window_background'))
      }
    }
  }
  @Builder TimePickerMenu($$:{date: Date, str: string[]}) {
    Menu() {
      MenuItem() {
        TimePicker({
          // start: new Date('1970-01-01'),
          selected: $$.date,
          // end: new Date('2100-01-01')
        })
          .onChange((value: TimePickerResult) => {
            Logger.debug(`TaskItemDialog date = ${JSON.stringify(value)}`)
            $$.date.setHours(value.hour, value.minute)
            Logger.debug(`TaskItemDialog res = ${JSON.stringify($$.date)}, str = ${$$.date.toLocaleString()}`)
            $$.str[1] = getTimeString($$.date.getTime())
          })
          .backgroundColor($r('app.color.start_window_background'))
          .width('80%')
      }
    }
  }


  aboutToAppear() {
    this.taskName = this.taskItem.task_name
    this.taskSubject = this.taskItem.subject
    this.taskDetailText = this.taskItem.detail
    this.taskDdlDetail = this.taskItem.ddl_detail
    this.taskDate = new Date()
    this.startDate = new Date()
    this.taskDate.setSeconds(0)
    this.startDate.setSeconds(0)
    Logger.debug('TaskItemDialog new date = ' + this.taskDate.toLocaleString())
    if (this.taskItem.start_date_stamp) this.startDate.setTime(this.taskItem.start_date_stamp)
    if (this.taskItem.due_date_stamp) this.taskDate.setTime(this.taskItem.due_date_stamp)
    this.startTask[0] = getDateString(this.startDate.getTime())
    this.startTask[1] = getTimeString(this.startDate.getTime())
    this.endTask[0] = getDateString(this.taskDate.getTime())
    this.endTask[1] = getTimeString(this.taskDate.getTime())

  }

  build() {
    Column() {
      Image($r('app.media.half'))     //向下的一个箭头
        .width(64)
        .height(24)
        .onClick(() => {
          this.controller?.close();
        })
      .margin({top: 5})
      Column() {
        Column() {
          Row() {
            Text((this.dialogIsAddNew ? '添加' : '修改') + '事项')
              .fontSize(20)
              .alignSelf(ItemAlign.Start)

          }
          .margin({ left: 24, bottom: 20, right: 24 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          TextInput({
            placeholder: '待办名称',
            text: this.taskName
          })
            .onChange((value: string) => {
              this.taskName = value
            })
            // .backgroundColor("#73cdf5")
            .margin({ bottom: 10 })
            .height(50)
          TextArea({ placeholder: '详细信息', text: this.taskDetailText })
            .onChange((value: string) => {
              this.taskDetailText = value
            })
            .height(50 * 3)
          .margin({ bottom: 10 })

        }.padding({ left: 16, right: 16})
        .margin({ bottom: 16})
        Row() {
          Button('添加日期：' + this.startTask[0])
            .bindMenu(this.DatePickerMenu({date: this.startDate, str: this.startTask}))
            .backgroundColor($r('app.color.basic_background'))
            .fontColor($r('app.color.basic_word'))
            .margin({right: 10})

          Button(this.startTask[1])
            .bindMenu(this.TimePickerMenu({date: this.startDate, str: this.startTask}))
            .backgroundColor($r('app.color.basic_background'))
            .fontColor($r('app.color.basic_word'))
        }.margin({bottom: 8})
        Row() {
          Button('截止日期：' + this.endTask[0])
            .bindMenu(this.DatePickerMenu({date: this.taskDate, str: this.endTask}))
            .backgroundColor($r('app.color.basic_background'))
            .fontColor($r('app.color.basic_word'))
            .margin({right: 10})

          Button(this.endTask[1])
            .bindMenu(this.TimePickerMenu({date: this.taskDate, str: this.endTask}))
            .backgroundColor($r('app.color.basic_background'))
            .fontColor($r('app.color.basic_word'))
        }
      }.margin({bottom: 16})

      Row() {
        Button('取消')
          .margin({ right: 10 })
          .onClick(() => {
            this.controller.close()
          })
        Button('保存')
          .onClick(() => {
            if (this.taskName == '') {
              promptAction.showToast({message: '任务名称不能为空'})
              return
            }
            if (this.taskDate.getTime() < this.startDate.getTime()) {
              promptAction.showToast({message: '结束日期不能在开始日期之前'})
            }
            this.taskItem.subject = this.taskSubject
            this.taskItem.task_name = this.taskName
            this.taskItem.detail = this.taskDetailText
            this.taskItem.due_date_stamp = this.taskDate.getTime()
            this.taskItem.start_date_stamp = this.startDate.getTime()
            this.taskItem.ddl_detail = this.taskDdlDetail

            this.confirm(this.dialogIsAddNew, this.taskItem)
            this.controller.close()
          })
      }.margin({ bottom: 20 })
    }.backgroundColor($r('app.color.blue_background'))
    .width('100%')
    // .height('60%')
    .borderRadius(24)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

function getTimeString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, time = ${date.toLocaleTimeString()}`)
  return date.toLocaleTimeString()
}

function getDateString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleDateString()}`)
  let ds: string[] = date.toLocaleDateString().split('/')
  let res: string = `${ds[2]}/${ds[0]}/${ds[1]}`
  return res
}

