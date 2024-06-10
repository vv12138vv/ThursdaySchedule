import relationalStore from '@ohos.data.relationalStore';

export default class DataBaseConfig {
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'ThursdaySchedule.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };
  static readonly USER_TABLE = {
    tableName: "users",
    sqlCreate: `CREATE TABLE IF NOT EXISTS users (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  studentId TEXT NOT NULL UNIQUE,
                  name TEXT NOT NULL,
                  password TEXT NOT NULL,
                  lastUpdateTime INTEGER NOT NULL
                )`,
    columns: ["id", "studentId", "name", "password", "lastUpdateTime"]
  };
  static readonly TASK_TABLE = {
    tableName: "tasks",
    sqlCreate: `CREATE TABLE IF NOT EXISTS tasks (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  content TEXT NOT NULL,
                  isFinished INTEGER NOT NULL,
                  priority INTEGER NOT NULL,
                  alertTime INTEGER，
                  startTime INTEGER,
                  endTime INTEGER,
                  createTime INTEGER NOT NULL,
                  updateTime INTEGER NOT NULL
                )`,
    columns: ["id", "content", "isFinished", "priority", "alertTime", "startTime", "endTime", "createTime", "updateTime"]
  };

  static readonly  COURSE_TABLE={
    tableName: "courses",
    sqlCreate: `CREATE TABLE IF NOT EXISTS courses (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  courseId TEXT NOT NULL UNIQUE,
                  name TEXT NOT NULL,
                  teacher TEXT NOT NULL,
                  credit REAL NOT NULL，
                  location TEXT NOT NULL,
                  courseType TEXT NOT NULL,
                  time TEXT NOT NULL
                )`,
    columns: ["id","courseId","name","teacher","credit","location","courseType","time"]
  };

  static readonly  EXAM_TABLE={
    tableName: "exams",
    sqlCreate: `CREATE TABLE IF NOT EXISTS exams (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  examId TEXT NOT NULL UNIQUE,
                  courseId TEXT NOT NULL UNIQUE,
                  location TEXT NOT NULL,
                  seatId INTEGER NOT NULL,
                  time INTEGER NOT NULL,
                )`,
    columns:["id","examId","courseId","location","seatId","time"]
  };

  static readonly  GRADE_TABLE={
    tableName: "grades",
    sqlCreate: `CREATE TABLE IF NOT EXISTS grades (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  courseId TEXT NOT NULL UNIQUE,
                  courseName TEXT NOT NULL UNIQUE,
                  credit REAL NOT NULL,
                  grade TEXT NOT NULL,
                  testType TEXT NOT NULL,
                  gpa REAL NOT NULL,
                  time INTEGER NOT NULL
                )`,
    columns:["id","courseId","courseName","credit","grade","testType","gpa","time"]
  };

}

