import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import User from '../models/User';
import Rdb from '../rdb';

export default class UserTable {
  private userTable = new Rdb(DataBaseConfig.TASK_TABLE.tableName, DataBaseConfig.TASK_TABLE.sqlCreate, DataBaseConfig.TASK_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.userTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.userTable.getRdbStore(callback);
  }
}


function generateBucket(user: User): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {
    studentId: user.studentId,
    name: user.name,
    password: user.password,
    lastUpdateTime: user.lastUpdateTime
  };
  return obj;
}