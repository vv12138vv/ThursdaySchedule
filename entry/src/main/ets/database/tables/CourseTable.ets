import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Course from '../models/Course';
import Rdb from '../rdb';

class CourseTable {
  private courseTable = new Rdb(DataBaseConfig.COURSE_TABLE.tableName, DataBaseConfig.COURSE_TABLE.sqlCreate, DataBaseConfig.COURSE_TABLE.columns);

  constructor(callback: () => void = () => {
  }) {
    this.courseTable.getRdbStore(callback);
  }

  getRdbStore(callback: () => void = () => {
  }) {
    this.courseTable.getRdbStore(callback);
  }

  insertData(course: Course, callback: (succeed: boolean) => void) {
    const value = generateBucket(course);
    this.courseTable.insertData(value, callback);
  }

  updateData(course: Course, callback: (succeed: boolean) => void) {
    const value = generateBucket(course);
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.COURSE_TABLE.tableName);
    predicates.equalTo('courseId', course.courseId);
    this.courseTable.updateData(predicates, value, callback);
  }

  private queryData(predicates: relationalStore.RdbPredicates, callback: (result: Course[]) => void) {
    this.courseTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: Course[] = [];
        for (let i = 0; i < count; i += 1) {
          let temp: Course = {
            id: resultSet.getLong(resultSet.getColumnIndex('id')),
            courseId: resultSet.getString(resultSet.getColumnIndex('courseId')),
            name: resultSet.getString(resultSet.getColumnIndex('name')),
            teacher: resultSet.getString(resultSet.getColumnIndex('teacher')),
            credit: resultSet.getDouble(resultSet.getColumnIndex('credit')),
            location: resultSet.getString(resultSet.getColumnIndex('location')),
            courseType: resultSet.getString(resultSet.getColumnIndex('courseType')),
            time: resultSet.getString(resultSet.getColumnIndex('time')),
          };
          result.push(temp);
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  deleteDataByCourseId(courseId: string, callback: (succeed: boolean) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.COURSE_TABLE.tableName);
    predicates.equalTo('courseId', courseId);
    this.courseTable.deleteData(predicates, callback);
  }

  selectDataByCourseId(courseId: string, callback: (result: Course[]) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.COURSE_TABLE.tableName);
    predicates.equalTo('courseId', courseId);
    this.queryData(predicates, callback);
  }
  selectDataAll(callback:(result:Course[])=>void){
    let predicates=new relationalStore.RdbPredicates(DataBaseConfig.COURSE_TABLE.tableName);
    this.queryData(predicates,callback);
  }
}


function generateBucket(course: Course): relationalStore.ValuesBucket {
  // let obj: relationalStore.ValuesBucket = {
  //   courseId: course.courseId,
  //   name: course.name,
  //   teacher: course.teacher,
  //   credit: course.credit,
  //   location: course.location,
  //   courseType: course.courseType,
  //   time: course.time,
  // };
  let obj:relationalStore.ValuesBucket={};
  obj.courseId=course.courseId;
  obj.name=course.name;
  obj.teacher=course.teacher;
  obj.credit=course.credit;
  obj.location=course.location;
  obj.courseType=course.courseType;
  obj.time=course.time;
  return obj;
}

export default new CourseTable(()=>{}) as CourseTable;
