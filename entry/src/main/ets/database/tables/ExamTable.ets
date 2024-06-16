import relationalStore from '@ohos.data.relationalStore';
import call from '@ohos.telephony.call';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Exam from '../models/Exam';
import Rdb from '../rdb';

class ExamTable {
  private examTable = new Rdb(DataBaseConfig.EXAM_TABLE.tableName, DataBaseConfig.EXAM_TABLE.sqlCreate, DataBaseConfig.EXAM_TABLE.columns);

  constructor(callback: () => void = () => {
  }) {
    this.examTable.getRdbStore(callback);
  }

  getRdbStore(callback: () => void = () => {
  }) {
    this.examTable.getRdbStore(callback);
  }

  insertData(exam: Exam, callback: (succeed: boolean) => void) {
    const value = generateBucket(exam);
    this.examTable.insertData(value, callback);
  }

  updateData(exam: Exam, callback: (succeed: boolean) => void) {
    const value = generateBucket(exam);
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.EXAM_TABLE.tableName);
    predicates.equalTo('id', exam.id);
    this.examTable.updateData(predicates, value, callback);
  }

  private queryData(predicates: relationalStore.RdbPredicates, callback: (result: Exam[]) => void) {
    this.examTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: Exam[] = [];
        for (let i = 0; i < count; i += 1) {
          let temp: Exam = {
            id: resultSet.getLong(resultSet.getColumnIndex('id')),
            examId: resultSet.getString(resultSet.getColumnIndex('examId')),
            courseId: resultSet.getString(resultSet.getColumnIndex('courseId')),
            location: resultSet.getString(resultSet.getColumnIndex('location')),
            seatId: resultSet.getLong(resultSet.getColumnIndex('seatId')),
            time: resultSet.getLong(resultSet.getColumnIndex('time'))
          };
          result.push(temp);
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  deleteDataById(id: number, callback: (succeed: boolean) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.EXAM_TABLE.tableName);
    predicates.equalTo('id', id);
    this.examTable.deleteData(predicates, callback);
  }

  selectDataByCourseId(courseId: string, callback: (result: Exam[]) => void) {
    let predicates = new relationalStore.RdbPredicates(DataBaseConfig.EXAM_TABLE.tableName);
    predicates.equalTo('courseId', courseId);
    this.queryData(predicates, callback);
  }

  selectDataAll(callback: (result: Exam[]) => void){
    let predicates=new relationalStore.RdbPredicates(DataBaseConfig.EXAM_TABLE.tableName);
    this.queryData(predicates,callback);
  }
}


function generateBucket(exam: Exam): relationalStore.ValuesBucket {
  let obj:relationalStore.ValuesBucket={};
  obj.examId=exam.examId;
  obj.courseId=exam.courseId;
  obj.location=exam.location;
  obj.seatId=exam.seatId;
  obj.time=exam.time;
  return obj;
}

export default new ExamTable(()=>{}) as ExamTable;

