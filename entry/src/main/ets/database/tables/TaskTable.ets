
import relationalStore from '@ohos.data.relationalStore';
import CommonConstants from '../../constants/CommonConstants';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Logger from '../../utils/Logger';
import { TaskListItemData } from '../models/Task';
import Rdb from '../rdb';




export default class TaskTable {
  private taskTable = new Rdb(DataBaseConfig.TASK_TABLE.tableName, DataBaseConfig.TASK_TABLE.sqlCreate,
    DataBaseConfig.TASK_TABLE.columns)

  constructor(callback: ()=>void = () => {}) {
    this.taskTable.getRdbStore(callback);
  }

  getRdbStore(callback: ()=>void = () => {}) {
    this.taskTable.getRdbStore(callback)
  }

  updateColumns(newColumn: string, newColumnType: string) {
    let newColumnData: string = ''
    switch (newColumnType) {
      case 'double':
        newColumnData = 'INTEGER'
        break;
      case 'string':
        newColumnData = 'TEXT'
        break;
      case 'boolean':
        newColumnData = 'BOOLEAN'
      default:
        newColumnData = 'INTEGER'
    }
    Logger.debug(`UpdateColumns: ${newColumn} ${newColumnData}`)
    this.taskTable.updateColumns(newColumn, newColumnData)
  }

  insertData(taskData: TaskListItemData, callback: (succeed:boolean)=>void) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(taskData)
    this.taskTable.insertData(valueBucket, callback)
  }

  deleteData(taskData: TaskListItemData, callback: (succeed:boolean)=>void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName)
    predicates.equalTo('id', taskData.id)
    this.taskTable.deleteData(predicates, callback)
  }

  updateData(taskData: TaskListItemData, callback: (succeed:boolean)=>void) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(taskData)
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName)
    predicates.equalTo('id', taskData.id)
    this.taskTable.updateData(predicates, valueBucket, callback)
  }

  queryTaskName(task_name: string, callback: Function, isAll: boolean = true) {
    let submit: TaskListItemData = new TaskListItemData(); submit.task_name = task_name
    this.basic_query("task_name", submit, callback, isAll)

  }

  basic_query(query_type: string, queryData: TaskListItemData, callback: Function, isAll: boolean = true) {
    Logger.debug(`TaskTable query_type: ${query_type}, query_data: ${JSON.stringify(queryData)}, visit: ${queryData[query_type]}`)
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName)
    if (!isAll) {
      if (CommonConstants.COLUMN_TYPE[query_type] == 'string') predicates.like(query_type, queryData[query_type])
      else predicates.equalTo(query_type, queryData[query_type])
    }
    this.taskTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount
      Logger.debug(`TaskTable number: ${count}`)
      if (count === 0 || typeof count === 'string') {
        callback([])
      } else {
        resultSet.goToFirstRow()
        const result: TaskListItemData[] = []
        for (let i = 0; i < count; ++i) {
          let tmp: TaskListItemData = new TaskListItemData()
          for (let t = 0; t < DataBaseConfig.TASK_TABLE.columns.length; ++t) {
            let nowColumn = DataBaseConfig.TASK_TABLE.columns[t]
            let nowIndex = resultSet.getColumnIndex(nowColumn)

            switch (CommonConstants.COLUMN_TYPE[nowColumn]) {
              case 'double':
                tmp[nowColumn] = resultSet.getDouble(nowIndex)
                break
              case 'string':
                tmp[nowColumn] = resultSet.getString(nowIndex)
                break
              case 'boolean':
                tmp[nowColumn] = Boolean(resultSet.getDouble(nowIndex))
            }

            Logger.debug(`TaskTable READING: nowC = ${nowColumn}, data = ${tmp[nowColumn]}`)
          }
          result[i] = tmp
          Logger.debug(`TaskTable Reading DATA: ${JSON.stringify(tmp)}`)
          resultSet.goToNextRow()
        }
        callback(result)
      }
    })
  }
}

function generateBucket(taskData: TaskListItemData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {}
  for (let i = 1; i < DataBaseConfig.TASK_TABLE.columns.length; ++i) {
    let nowCol = DataBaseConfig.TASK_TABLE.columns[i]
    obj[nowCol] = taskData[nowCol]
  }
  return obj
}
