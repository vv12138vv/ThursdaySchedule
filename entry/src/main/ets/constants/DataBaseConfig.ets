import relationalStore from '@ohos.data.relationalStore';

export default class DataBaseConfig {
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };
  static readonly USER_TABLE = {
    tableName: "users",
    sqlCreate: `CREATE TABLE IF NOT EXISTS users (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  studentId TEXT NOT NULL UNIQUE,
                  name TEXT NOT NULL,password TEXT NOT NULL,
                  lastUpdateTime INTEGER NOT NULL
                 )`,
    columns: ["id", "studentId", "name", "password", "lastUpdateTime"]
  };
  static readonly TASK_TABLE = {
    tableName: 'taskTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS taskTable' +
    '(id INTEGER PRIMARY KEY AUTOINCREMENT, task_name TEXT, ' +
    'subject INTEGER, start_date_stamp INTEGER, due_date_stamp INTEGER, ' +
    'is_completed BOOLEAN, detail TEXT, ddl_detail TEXT, category INTEGER, topped BOOLEAN)',
    columns: ['id', 'due_date_stamp', 'start_date_stamp', 'subject', 'detail', 'task_name', 'is_completed', 'ddl_detail', 'category', 'topped']
  };
  static readonly COURSE_TABLE = {
    tableName: "courses",
    sqlCreate: `CREATE TABLE IF NOT EXISTS courses (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  courseId TEXT NOT NULL UNIQUE,
                  name TEXT NOT NULL UNIQUE,
                  teacher TEXT NOT NULL,
                  credit REAL NOT NULL,
                  location TEXT NOT NULL,
                  courseType TEXT NOT NULL,
                  startWeek INTEGER NOT NULL,
                  endWeek INTEGER NOT NULL,
                  time TEXT NOT NULL
                )`,
    columns: ["id", "courseId", "name", "teacher", "credit", "location", "courseType", "startWeek", "endWeek", "time"]
  };
  static readonly EXAM_TABLE = {
    tableName: "exams",
    sqlCreate: `CREATE TABLE IF NOT EXISTS exams (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  examId TEXT NOT NULL UNIQUE,
                  courseId TEXT NOT NULL UNIQUE,
                  location TEXT NOT NULL,
                  seatId INTEGER NOT NULL,
                  time TEXT NOT NULL
                )`,
    columns: ["id", "examId", "courseId", "location", "seatId", "time"]
  };
  static readonly GRADE_TABLE = {
    tableName: "grades",
    sqlCreate: `CREATE TABLE IF NOT EXISTS grades (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  courseId TEXT NOT NULL UNIQUE,
                  courseName TEXT NOT NULL UNIQUE,
                  credit REAL NOT NULL,
                  grade TEXT NOT NULL,
                  testType TEXT NOT NULL,
                  courseType TEXT NOT NULL,
                  gpa REAL NOT NULL,
                  time TEXT NOT NULL
                )`,
    columns: ["id", "courseId", "courseName", "credit", "grade", "testType","courseType", "gpa", "time"]
  };
}

