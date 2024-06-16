import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import User from '../models/User';
import Rdb from '../rdb';

export default class UserTable {
  private userTable = new Rdb(DataBaseConfig.USER_TABLE.tableName, DataBaseConfig.USER_TABLE.sqlCreate, DataBaseConfig.USER_TABLE.columns);

  constructor(callback: ()=>void = () => {
  }) {
    this.userTable.getRdbStore(callback);
  }

  getRdbStore(callback: ()=>void = () => {
  }) {
    this.userTable.getRdbStore(callback);
  }

  insertData(user: User, callback: (succeed: boolean) => void) {
    const value = generateBucket(user);
    this.userTable.insertData(value, callback);
  }

  updateData(user: User, callback: (succeed: boolean) => void) {
    const value = generateBucket(user);
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.USER_TABLE.tableName);
    predicates.equalTo('studentId', user.studentId);
    this.userTable.updateData(predicates, value, callback);
  }

  private queryData(predicates: relationalStore.RdbPredicates, callback: (result: User[]) => void) {
    this.userTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: User[] = [];
        for (let i = 0; i < count; i += 1) {
          let temp: User = {
            id: resultSet.getLong(resultSet.getColumnIndex('id')),
            studentId: resultSet.getString(resultSet.getColumnIndex('studentId')),
            name: resultSet.getString(resultSet.getColumnIndex('name')),
            password: resultSet.getString(resultSet.getColumnIndex('password')),
            lastUpdateTime: resultSet.getLong(resultSet.getColumnIndex('lastUpdateTime'))
          };
          result.push(temp);
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  deleteDataByStudentId(studentId: number, callback: (succeed: boolean) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.USER_TABLE.tableName);
    predicates.equalTo('studentId', studentId);
    this.userTable.deleteData(predicates, callback);
  }

  selectDataByStudentId(studentId: string, callback: (result: User[]) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.USER_TABLE.tableName);
    predicates.equalTo('studentId', studentId);
    this.queryData(predicates, callback);
  }
  selectDataAll(callback: (result: User[]) => void){
    let predicates=new relationalStore.RdbPredicates(DataBaseConfig.USER_TABLE.tableName);
    this.queryData(predicates,callback);
  }
}


function generateBucket(user: User): relationalStore.ValuesBucket {
  // let obj: relationalStore.ValuesBucket = {
  //   studentId: user.studentId,
  //   name: user.name,
  //   password: user.password,
  //   lastUpdateTime: user.lastUpdateTime
  // };
  let obj:relationalStore.ValuesBucket={};
  obj.studentId=user.studentId;
  obj.name=user.name;
  obj.password=user.password;
  obj.lastUpdateTime=user.lastUpdateTime;
  return obj;
}

