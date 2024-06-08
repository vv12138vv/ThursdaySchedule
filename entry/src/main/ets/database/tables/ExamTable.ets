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
import Exam from '../models/Exam';
import User from '../models/User';
import Rdb from '../rdb';

export default class ExamTable {
  private examTable = new Rdb(DataBaseConfig.EXAM_TABLE.tableName, DataBaseConfig.EXAM_TABLE.sqlCreate, DataBaseConfig.EXAM_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.examTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.examTable.getRdbStore(callback);
  }

}


function generateBucket(exam:Exam):relationalStore.ValuesBucket{
  let obj:relationalStore.ValuesBucket={
    examId:exam.examId,
    courseId:exam.courseId,
    location:exam.location,
    seatId:exam.seatId,
    time:exam.time
  };
  return obj;
}