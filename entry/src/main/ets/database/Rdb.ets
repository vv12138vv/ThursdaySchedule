import relationalStore from '@ohos.data.relationalStore'
import CommonConstants from '../constants/CommonConstants'
import DataBaseConfig from '../constants/DataBaseConfig'
import Logger from '../utils/Logger'

export default class Rdb {
  //抽象数据库
  private rdbStore: relationalStore.RdbStore | null = null;
  //表名称
  private tableName: string;
  //建表语句
  private sqlCreateTable: string;
  //各列
  private columns: Array<string>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(callback: ()=>void = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'getRdbStore() has no callback!');
      return;
    }
    if (this.rdbStore !== null) {
      Logger.info(CommonConstants.RDB_TAG, 'The rdbStore exists.');
      callback();
      return;
    }
    let context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, DataBaseConfig.STORE_CONFIG, (err, rdb) => {
      if (err) {
        Logger.error(CommonConstants.RDB_TAG, `gerRdbStore() failed, err: ${err}`);
        return;
      }
      this.rdbStore = rdb;
      this.rdbStore.executeSql(this.sqlCreateTable);
      Logger.info(CommonConstants.RDB_TAG, 'getRdbStore() finished.');
      callback();
    });
  }

  updateColumns(newColumn: string, newColumnData: string) {
    this.rdbStore.executeSql(`ALTER TABLE ${this.tableName} ADD COLUMN ${newColumn} ${newColumnData}`)
  }

  insertData(data: relationalStore.ValuesBucket, callback: (succeed:boolean)=>void = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'insertData() has no callback!');
      return;
    }
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          let error=err;
          Logger.error(CommonConstants.RDB_TAG, `insertData() failed, err: ${err.code} ${err.name} ${err.message}`);
          callback(false);
          return;
        }
        Logger.info(CommonConstants.RDB_TAG, `insertData() finished: ${ret}`);
        callback(true);
      });
    }
  }

  deleteData(predicates: relationalStore.RdbPredicates, callback: (succeed: boolean) => void = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'deleteData() has no callback!');
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          Logger.error(CommonConstants.RDB_TAG, `deleteData() failed, err: ${err}`);
          callback(false);
          return;
        }
        Logger.info(CommonConstants.RDB_TAG, `deleteData() finished: ${ret}`);
        callback(true);
      });
    }
  }

  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: (succeed: boolean) => void = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'updateDate() has no callback!');
      return;
    }
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.update(valueBucket, predicates, (err, ret) => {
        if (err) {
          Logger.error(CommonConstants.RDB_TAG, `updateData() failed, err: ${err}`);
          callback(false);
          return;
        }
        Logger.info(CommonConstants.RDB_TAG, `updateData() finished: ${ret}`);
        callback(true);
      });
    }
  }

  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'query() has no callback!');
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          Logger.error(CommonConstants.RDB_TAG, `query() failed, err:  ${err}`);
          return;
        }
        Logger.info(CommonConstants.RDB_TAG, 'query() finished.');
        callback(resultSet);
        resultSet.close();
      });
    }
  }
}