import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Rdb from '../rdb';
import Task from '../models/Task'
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

}


function generateBucket(task:Task):relationalStore.ValuesBucket{
  let obj:relationalStore.ValuesBucket={
    content:task.content,
    isFinished:task.isFinished,
    priority:task.priority,
    alertTime:task.alertTime,
    startTime:task.startTime,
    endTime:task.endTime,
    createTime:task.createTime,
    updateTime:task.updateTime
  };
  return obj;
}