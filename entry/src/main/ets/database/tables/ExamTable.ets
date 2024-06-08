import relationalStore from '@ohos.data.relationalStore';
import DataBaseConfig from '../../constants/DataBaseConfig';
import Exam from '../models/Exam';
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