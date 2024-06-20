import Grade from '../database/models/Grade';
import Exam from '../database/models/Exam';
import Course from '../database/models/Course';

class DataPool{
  public courses:Course[]=[];
  public grades:Grade[]=[];
  public exams:Exam[]=[];
}

export default new DataPool() as DataPool;