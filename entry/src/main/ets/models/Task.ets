export default class Task{
  id:string;
  content:string;
  isFinished:number;//是否完成
  priority:number;//优先级
  alertTime:Date;//提醒时间
  startTime:Date;//开始时间
  endTime:Date;//结束时间
  createdTime:Date;//创建时间
  updatedTime:Date;//更新时间
}