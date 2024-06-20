
import CommonConstants from '../constants/CommonConstants'
import { TaskListItemData } from '../database/models/Task'
import TaskTable from '../database/tables/TaskTable'

import Logger from '../utils/Logger'
import { TaskItemDialog } from './TaskItemDialog'
import { TaskItemDialog_ViewOnly } from './TaskItemDialog_ViewOnly'

@Component

export default struct TaskList {
  @State taskList: Array<TaskListItemData> = []
  @State taskTable: TaskTable = new TaskTable(() => {});

  @State isEditing: boolean = false
  @State dialogIsAddNew: boolean = true
  @State taskItem: TaskListItemData = new TaskListItemData()
  private dialogSelectedIndex: number = -1
  private deleteTarget: Array<TaskListItemData> = []

  // ----------------------------------------------------------------编辑弹窗 Dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TaskItemDialog({
      dialogIsAddNew: $dialogIsAddNew,
      taskItem: $taskItem,
      confirm: (dialogIsAddNew: boolean, taskItem: TaskListItemData) => {
        if (dialogIsAddNew) {
          this.submitNewTask(taskItem)
        } else {
          this.updateExistingTask(taskItem)
        }
        dialogIsAddNew = true
      },

    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })
  dialogController_view: CustomDialogController = new CustomDialogController({
    builder: TaskItemDialog_ViewOnly({
      taskItem: $taskItem,
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })


  @Builder TaskList_ListItem(item: TaskListItemData, index: number) {
    Row() {
      if (!this.isEditing) {
        Checkbox()
          .select(item.is_completed)
          .onChange((value: boolean) => {
            animateTo({duration: 300, curve: Curve.EaseInOut}, () => {
              item.is_completed = value
              this.dialogSelectedIndex = index
              this.updateExistingTask(item)
            })
          })
          .margin({ right: 10 })
      }
      Text(item.task_name)
        .textOverflow({overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .width('40%')
      Blank()
        .layoutWeight(1)
      Row() {
        Text(getTimeString(item.due_date_stamp))
          .margin({right: 10})

        if (!item.is_completed)
          Button({type: ButtonType.Circle, }) {
            Text(' ')
          }
          .backgroundColor(CommonConstants.DDL_COLOR[item.getDDLState()])
          .height(12)
          .width(12)
      }.margin({right: 8})
      if (this.isEditing) {
        Toggle({ type: ToggleType.Checkbox, isOn: false })
          .onChange((isOn: Boolean) => {
            if (isOn) this.deleteTarget.push(item)
            else {
              let this_id_index = this.deleteTarget.indexOf(item)
              this.deleteTarget.splice(this_id_index, 1)
            }
          })
      }
    }.justifyContent(FlexAlign.SpaceBetween)
    .height(80)
    .width('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor(item.topped ? '#80B6C5D1' : "#73cdf5")
    .gesture(
      LongPressGesture()
        .onAction(() => {
          Logger.debug(`Drag Start`)
          item.topped = !item.topped
          this.dialogSelectedIndex = index
          this.updateExistingTask(item)
        })
    )
  }

  sortItems() {
    this.taskList.sort((a, b) => {
      return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
    })
  }

  // 数据库----------------------------------------------------------------------------
  submitNewTask(taskData: TaskListItemData) {
    this.taskTable.insertData(taskData, (succeed:Boolean) => {
      // taskData.id = id

      this.taskList.push(taskData)
    })
  }
  updateExistingTask(taskData: TaskListItemData) {
    this.taskTable.updateData(taskData, () => {})

    let new_task = this.taskList
    this.taskList = new Array<TaskListItemData>()
    new_task[this.dialogSelectedIndex] = taskData
    new_task.sort((a, b) => {
      return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
    })
    new_task.forEach((val) => {
      this.taskList.push((val))
    })
    this.dialogSelectedIndex = -1
  }
  deleteSelectedTasks() {
    if (this.deleteTarget.length == 0) return;
    for (let i = 0; i < this.deleteTarget.length; ++i) {
      let target = this.deleteTarget[i]
      this.taskTable.deleteData(target, (ret) => {
        if (ret) {
          let targetIndex = this.taskList.indexOf(target)
          this.taskList.splice(targetIndex, 1)
        }
      })
    }
    this.deleteTarget = []
  }


  async aboutToAppear() { //看开发者指南，组件即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其build()函数之前执行   我把加载数据放这里了
    this.taskTable.getRdbStore(() => {
      this.taskTable.queryTaskName('', (result: TaskListItemData[]) => {
        result.sort((a, b) => {
          return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
        })
        this.taskList = result
        Logger.debug(`TaskListItemData = ${JSON.stringify(this.taskList)}`)
      }, true)
    })
  }

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Stack({ alignContent: (this.isEditing ? Alignment.Bottom : Alignment.BottomEnd) }) { // 主界面与悬浮按钮叠放主界面与悬浮按钮叠放，在层叠布局中，如果后面子元素尺寸大于前面子元素尺寸，则前面子元素完全隐藏
        Navigation() { // ----------------标题栏

          Column() {
            Column() {
              // ---------------待办事项界面，不满一屏仍然滚动
              Scroll() {
                Column() {
                  Text('我的未办')
                    .textTitle()

                    List() {
                      ForEach(this.taskList, (item: TaskListItemData, index) => {
                        if (!item.is_completed) ListItem() {
                          this.TaskList_ListItem(item, index)
                        }.width('100%')
                        .backgroundColor($r('app.color.start_window_background'))
                        .onClick(() => {
                          if (this.isEditing) {
                            this.taskItem = item
                            this.dialogIsAddNew = false
                            this.dialogSelectedIndex = this.taskList.indexOf(item)
                            this.dialogController.open()
                          } else {
                            this.taskItem = item
                            this.dialogController_view.open()
                          }
                        })
                      })
                    }
                    .width('100%')
                    .borderRadius(20)
                    .divider({ strokeWidth: 1 })
                    .margin({ bottom: 20 })

                  Text('我的已办')
                    .textTitle()

                  List() {
                    ForEach(this.taskList, (item: TaskListItemData, index) => {
                      if (item.is_completed) ListItem() {
                        this.TaskList_ListItem(item, index)
                      }.width('100%')
                      .backgroundColor($r('app.color.start_window_background'))
                      .onClick(() => {
                        if (this.isEditing) {
                          this.taskItem = item
                          this.dialogIsAddNew = false
                          this.dialogSelectedIndex = this.taskList.indexOf(item)
                          this.dialogController.open()
                        } else {
                          this.taskItem = item
                          this.dialogController_view.open()
                        }
                      })
                    })
                  }
                  .width('100%')
                  .borderRadius(24)
                  .divider({ strokeWidth: 1 })
                  .margin({bottom: 40})
                }
                // .justifyContent(FlexAlign.Start)
                .margin({top: 0})
              }
              .edgeEffect(EdgeEffect.Spring)
              .scrollBar(BarState.Off)
            }
          }.height('100%')
        }.titleMode(NavigationTitleMode.Full)
        .title('ToDo')
        .menus([
          {
            value: "",
            icon: (this.isEditing ? '../../../resources/base/media/ic_public_edit_filled.svg' : '../../../resources/base/media/ic_public_edit.svg'),
            action: () => {
              animateTo({duration: 200, curve: Curve.EaseOut}, () => {
                this.deleteTarget = []
                this.isEditing = !this.isEditing
              })
            }
          }])
        .height('90%')
        .mode(NavigationMode.Stack)

        // -------------------------右下角的按钮
        Button({ type: ButtonType.Circle }) {
          if (!this.isEditing) Image($r("app.media.icon_public_list_add_light"))
          else {
            Image($r("app.media.icon_public_delete"))
              .height(28)
              .width(28)
          }
        }
        .backgroundColor(!this.isEditing ? $r('app.color.add_button') : $r('app.color.delete_button'))
        .width(60)
        .height(60)
        .margin({ bottom: 12, right: (this.isEditing ? 0 : 12) })
        .onClick(() => {
          animateTo({duration: 200, curve: Curve.EaseOut}, () => {
            if (!this.isEditing) {
              this.dialogIsAddNew = true
              this.taskItem = new TaskListItemData()
              this.dialogController.open()
            } else {
              if (this.deleteTarget.length != 0) {
                this.deleteSelectedTasks()
                this.isEditing = false
              }
            }
          })
        })
      }.padding(CommonConstants.DEFAULT_PADDING)
      .backgroundColor('#9DDCEE')
    }
  }
}

@Extend(Text) function textTitle() {
  .fontSize(20)
  .width('100%')
  .margin({ left: 12, bottom: 10, top: 20 })
  .textAlign(TextAlign.Start)
}

function getTimeString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleDateString()}`)
  let ds: string[] = date.toLocaleDateString().split('/')
  let res: string = `${ds[2]}/${ds[0]}/${ds[1]}`
  return res
}