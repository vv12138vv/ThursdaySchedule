import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Rdb from '../rdb';
import Task from '../models/Task'
import call from '@ohos.telephony.call';

export default class TaskTable {
  private taskTable = new Rdb(DataBaseConfig.TASK_TABLE.tableName, DataBaseConfig.TASK_TABLE.sqlCreate, DataBaseConfig.TASK_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.taskTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.taskTable.getRdbStore(callback);
  }

  //插入任务
  insertData(task: Task, callback: (succeed:boolean)=>void) {
    const value = generateBucket(task);
    this.taskTable.insertData(value, callback);
  }


  updateData(task: Task, callback: (succeed:boolean)=>void) {
    const value = generateBucket(task);
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName);
    predicates.equalTo('id', task.id);
    this.taskTable.updateData(predicates, value, callback);
  }

  private queryData(predicates: relationalStore.RdbPredicates, callback: (result: Task[]) => void) {
    this.taskTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: Task[] = [];
        for (let i = 0; i < count; i += 1) {
          let temp: Task = {
            id: resultSet.getLong(resultSet.getColumnIndex('id')),
            content: resultSet.getString(resultSet.getColumnIndex('content')),
            isFinished: resultSet.getLong(resultSet.getColumnIndex('isFinished')),
            priority: resultSet.getLong(resultSet.getColumnIndex('priority')),
            alertTime: resultSet.getLong(resultSet.getColumnIndex('alertTime')),
            startTime: resultSet.getLong(resultSet.getColumnIndex('startTime')),
            endTime: resultSet.getLong(resultSet.getColumnIndex('endTime')),
            createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
            updateTime: resultSet.getLong(resultSet.getColumnIndex('updateTime'))
          };
          result.push(temp);
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  deleteDataById(id: number, callback: (succeed:boolean)=>void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName);
    predicates.equalTo('id', id);
    this.taskTable.deleteData(predicates, callback);
  }

  selectDataById(id: number, callback: (result: Task[]) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName);
    predicates.equalTo('id', id);
    this.queryData(predicates, callback);
  }

  selectDataByIsFinished(isFinished: number, callback: (result: Task[]) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName);
    predicates.equalTo('isFinished', isFinished === 0 ? 0 : 1);
    this.queryData(predicates, callback);
  }

  selectDataByPriority(priority: number, callback: (result: Task[]) => void){
    let predicates=new relationalStore.RdbPredicates(DataBaseConfig.TASK_TABLE.tableName);
    predicates.equalTo('priority',priority);
    this.queryData(predicates,callback);
  }
  //如有需要，参考上文。

}


function generateBucket(task: Task): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {
    content: task.content,
    isFinished: task.isFinished,
    priority: task.priority,
    alertTime: task.alertTime,
    startTime: task.startTime,
    endTime: task.endTime,
    createTime: task.createTime,
    updateTime: task.updateTime
  };
  return obj;
}