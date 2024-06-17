import Course, { CourseView,courseDemo } from '../database/models/Course'
import DateUtils from '../utils/DateUtils';
@Component
export default struct TodayCourseView{

  courses:Course[]=[];
  courseViews:CourseView[]=[];
  private todayDateInfo:Date;
  curWeek:number;
  termStartDate=new Date('2024-02-26');

  aboutToAppear(){
    //日期相关初始化
    //今日日期
    this.todayDateInfo=DateUtils.getStartOfDay(new Date());
    //
    let weekDiff=DateUtils.getWeekDiff(this.termStartDate,this.todayDateInfo);
    this.curWeek=weekDiff+1;
    //数据请求
    this.courseViews = CourseView.fromCourse(courseDemo);
    this.courseViews=this.courseViews.filter((value:CourseView,index:number)=>{
      let day=this.todayDateInfo.getDay()+1;
      return value.weekday===(this.todayDateInfo.getDay()+1);
    })
    let i=1;
  }

  @Builder CourseCard(courseView:CourseView){
    Column(){
      Text(courseView.name)
      Row(){
        Text(CourseView.courseSeqToTimeString(courseView.courseSeq))
        Text(courseView.location)
      }
    }
  }

  build(){
    Column(){
      Image($r('app.media.logo'))
        .width(16)
      Text('Lesson')
      List(){
        ForEach(this.courseViews,(item:CourseView,index:number)=>{
          ListItem(){
            this.CourseCard(item)
          }
        })
      }
    }
  }
}

@Preview
@Component
struct TodayCourseViewPreview{
  build(){
    TodayCourseView()
  }
}