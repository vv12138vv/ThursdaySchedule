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
import Course from '../models/Course';
import User from '../models/User';
import Rdb from '../rdb';

export default class courseTable {
  private courseTable = new Rdb(DataBaseConfig.COURSE_TABLE.tableName, DataBaseConfig.COURSE_TABLE.sqlCreate, DataBaseConfig.COURSE_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.courseTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.courseTable.getRdbStore(callback);
  }

}


function generateBucket(course:Course):relationalStore.ValuesBucket{
  let obj:relationalStore.ValuesBucket={
    courseId:course.courseId,
    name:course.name,
    teacher:course.teacher,
    credit:course.credit,
    location:course.location,
    courseType:course.courseType,
    time:course.time,
    testType:course.testType,
    grade:course.grade
  };
  return obj;
}