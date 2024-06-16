import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Grade from '../models/Grade';
import Rdb from '../rdb';

export default class GradeTable {
  private gradeTable = new Rdb(DataBaseConfig.GRADE_TABLE.tableName, DataBaseConfig.GRADE_TABLE.sqlCreate, DataBaseConfig.GRADE_TABLE.columns);

  constructor(callback: () => void = () => {
  }) {
    this.gradeTable.getRdbStore(callback);
  }

  getRdbStore(callback: () => void = () => {
  }) {
    this.gradeTable.getRdbStore(callback);
  }

  insertData(grade: Grade, callback: (succeed: boolean) => void) {
    const value = generateBucket(grade);
    this.gradeTable.insertData(value, callback);
  }

  updateData(grade: Grade, callback: (succeed: boolean) => void) {
    const value = generateBucket(grade);
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.GRADE_TABLE.tableName);
    predicates.equalTo('courseId', grade.courseId);
    this.gradeTable.updateData(predicates, value, callback);
  }

  private queryData(predicates: relationalStore.RdbPredicates, callback: (result: Grade[]) => void) {
    this.gradeTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: Grade[] = [];
        for (let i = 0; i < count; i += 1) {
          let temp: Grade = {
            id: resultSet.getLong(resultSet.getColumnIndex('id')),
            courseId: resultSet.getString(resultSet.getColumnIndex('courseId')),
            courseName: resultSet.getString(resultSet.getColumnIndex('courseName')),
            credit: resultSet.getDouble(resultSet.getColumnIndex('credit')),
            grade: resultSet.getString(resultSet.getColumnIndex('grade')),
            testType: resultSet.getString(resultSet.getColumnIndex('testType')),
            gpa: resultSet.getDouble(resultSet.getColumnIndex('gpa')),
            time: resultSet.getLong(resultSet.getColumnIndex('time'))
          };
          result.push(temp);
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  // deleteDataByCourseId(courseId: string, callback: (succeed: boolean) => void) {
  //   let predicates = new relationalStore.RdbPredicates(DataBaseConfig.COURSE_TABLE.tableName);
  //   predicates.equalTo('courseId', courseId);
  //   this.gradeTable.deleteData(predicates, callback);
  // }
  //

  selectDataByTime(time: string, callback: (result: Grade[]) => void) {
    let predicates=new relationalStore.RdbPredicates(DataBaseConfig.GRADE_TABLE.tableName);
    predicates.equalTo('time',time);
    this.queryData(predicates,callback);
  }

  selectDataAll(callback: (result: Grade[]) => void){
    let predicates=new relationalStore.RdbPredicates(DataBaseConfig.GRADE_TABLE.tableName);
    this.queryData(predicates,callback);
  }
}


function generateBucket(grade: Grade): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {
    courseId: grade.courseId,
    courseName: grade.courseName,
    credit: grade.credit,
    grade: grade.grade,
    testType: grade.testType,
    gpa: grade.gpa,
    time: grade.time
  };
  return obj;
}

