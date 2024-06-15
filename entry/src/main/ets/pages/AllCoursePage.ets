import Course from '../database/models/Course';
import NavBar, { NavBarConfig } from '../components/NavBar';
import router from '@ohos.router';
import Logger from '../utils/Logger';
import systemDateTime from '@ohos.systemDateTime';

@CustomDialog
struct CourseDetailDialog {
  dialogController?: CustomDialogController;
  course: Course;

  build() {
    Column() {
      Text()
      Text()
      Row() {
        Text()
        Column() {
          Text()
          Text()
          Text()
          Text()
        }
      }
    }
  }
}


@Entry
@Component
struct AllCoursePage {
  //导航栏控制条
  navBarConfig: NavBarConfig = {
    leftIcon: $r('app.media.icon_back'),
    title: "课表查询",
    onClickLeftButton: () => {
      router.back();
    }
  }

  //课程详细控制器
  courseDetailDialogController: CustomDialogController = new CustomDialogController({
    builder: CourseDetailDialog({}),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })
  readonly weekDaysString: string[] = ['周日','周一', '周二', '周三', '周四', '周五', '周六'];
  private dateInfo: Date;
  private weekDates: Date [];

  aboutToAppear() {
    this.dateInfo = new Date();
    this.weekDates=this.getWeekDates(this.dateInfo);

  }

  //获得所在日一周的日期
  getWeekDates(date: Date): Date[] {
    const startOfWeek: Date = new Date(date);
    const dayOfWeek: number = startOfWeek.getDay(); // 获取给定日期是星期几
    const diff: number = (dayOfWeek === 0 ? 6 : dayOfWeek - 1); // 计算需要向前调整的天数

    startOfWeek.setDate(date.getDate() - diff); // 将日期调整到本周的第一天 (周一为一周的起始)

    const weekDates: Date[] = [];

    // 循环生成本周的日期
    for (let i = 0; i < 7; i++) {
      const currentDate: Date = new Date(startOfWeek);
      currentDate.setDate(startOfWeek.getDate() + i);
      weekDates.push(currentDate);
    }

    return weekDates;
  }


  //单个课程的可点击块
  @Builder CourseCube(course: Course) {
    Column() {
      //Todo 时间还可能需要处理
      Text(course.time)
      Text(course.location)
      Text(course.name)
    }
    .onClick(() => {

    })
  }

  //表示时间的ui，课表顶部使用
  @Builder DateCube(date:Date) {
    Column() {
      Text(this.weekDaysString[date.getDay()])
        .fontColor(date.getDate()==this.dateInfo.getDate()?Color.Blue:Color.Black)
      Text((date.getMonth()+1).toString()+'/'+date.getDate().toString())
        .fontColor(date.getDate()==this.dateInfo.getDate()?Color.Blue:Color.Black)

    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  //课表顶部的时间 bar
  @Builder DateBar() {
    Grid() {
      GridItem() {
        Column() {
          Text('星期')
          Text('日期')
        }
      }

      ForEach(this.weekDates, (item: Date, index: number) => {
        GridItem() {
          this.DateCube(item)
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
  }

  //课表核心主主体
  @Builder CourseTable() {
    Grid() {
      GridItem() {
        Text('1')
      }
      .backgroundColor(Color.Black)
      .rowStart(1)
      .rowEnd(2)
      .columnStart(1)
      .columnEnd(2)

      GridItem() {
        Text('2')
      }
      .rowStart(4)
      .rowEnd(5)
      .columnStart(4)
      .columnEnd(5)
      .backgroundColor(Color.Black)
    }
    .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsTemplate('0.25fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsGap(4)
    .rowsGap(2)
  }

  //课表底部
  @Builder CourseTableFooter() {
    Row() {
      Text()
    }
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      this.DateBar()
    }
  }
}



