@Observed
export default class Task{
  id?:number;//主键
  content:string;
  isFinished:number;//是否完成
  priority:number;//优先级
  alertTime:number;//提醒时间
  startTime:number;//开始时间
  endTime:number;//结束时间
  createTime:number;//创建时间
  updateTime:number;//更新时间
}