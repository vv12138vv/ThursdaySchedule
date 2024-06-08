export default class User{
  id:number;//主键，与业务无关
  studentId:string;//学号也即用户名。
  name:string;
  password:string;
  lastUpdateTime:number;

  //Todo: 有些拓展功能还需添加字段。
}