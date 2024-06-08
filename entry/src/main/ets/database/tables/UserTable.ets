/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import relationalStore from '@ohos.data.relationalStore';
import AccountData from '../../../viewmodel/AccountData';
import CommonConstants from '../../constants/CommonConstants';
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