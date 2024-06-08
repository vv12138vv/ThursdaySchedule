
import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Course from '../models/Course';
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