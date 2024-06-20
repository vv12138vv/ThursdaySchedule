export default class DateUtils{
  //获得某日的起始点
  public static getStartOfDay(date: Date): Date {
    // 创建一个新的 Date 对象，设置为指定日期的年、月、日的 00:00:00
    const startOfDay = new Date(date.getFullYear(), date.getMonth(), date.getDate());
    return startOfDay;
  }

  //获得所在日一周的日期
  public static getWeekDates(date: Date): Date[] {
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

  //计算两天之间周的差距
  public static getWeekDiff(startDate: Date, endDate: Date): number {
    // 计算日期之间的毫秒数差
    const timeDifference = endDate.getTime() - startDate.getTime();
    // 将毫秒数差转换为天数差，再转换为周数差
    const daysDifference = Math.ceil(timeDifference / (1000 * 3600 * 24));
    const weeksDifference = Math.floor(daysDifference / 7);
    return weeksDifference;
  }

  //获取以某日所在周为第一周，向后 weeknum 个周的信息
  public static getAllWeekDates(start: Date, weekNum: number): Date[][] {
    let startDate = new Date(start);
    let weeksDates: Date [][] = [];

    // 循环获取 20 个周的日期数据
    for (let i = 0; i < weekNum; i++) {
      // 计算当前周的起始日期和结束日期
      const dayOfWeek = startDate.getDay(); // 获取当前日期是星期几
      const diffDays = dayOfWeek === 0 ? 6 : dayOfWeek - 1; // 计算当前日期距离上一个星期一的天数差

      // 获取当前周的起始日期（星期一）
      const currentStartDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() - diffDays);

      let weekDate = this.getWeekDates(currentStartDate);
      // 添加到结果数组
      weeksDates.push(weekDate);

      // 将 startDate 设置为下一周的起始日期
      startDate.setDate(startDate.getDate() + 7);
    }
    return weeksDates;
  }
  //计算给定字符串中起始时间距离现在的天数。不满 24 小时将按 0 天计算。
  public static getDaysFromNow(dateTimeRange: string): number {
    // 将字符串按空格和 ~ 分隔
    const [date, timeRange] = dateTimeRange.split(' ');
    const [startTime, _] = timeRange.split('~');
    // 将日期和起始时间拼接成完整的时间字符串
    const startDateTimeString = `${date} ${startTime}`;
    // 将时间字符串转换为 Date 对象
    const startDateTime = new Date(startDateTimeString);
    const now = new Date();
    // 计算起始时间与当前时间的差值，单位为毫秒
    const diffInMs = startDateTime.getTime() - now.getTime();
    // 将差值转换为天数
    const diffInDays = Math.floor(diffInMs / (1000 * 60 * 60 * 24));
    // 不满24小时按0天处理
    return diffInDays > 0 ? diffInDays : 0;
  }
  //比较这个时间的起始时间和当前时间，如果还没有到，返回1，否则返回0
  public static CompareDaysFromNow(dateTimeRange: string): number {
    const [date, timeRange] = dateTimeRange.split(' ');
    const [startTime, _] = timeRange.split('~');

    const startDateTimeString = `${date} ${startTime}`;

    const startDateTime = new Date(startDateTimeString);
    const now = new Date();
    const diffInMs = startDateTime.getTime() - now.getTime();
    const diffInDays = Math.floor(diffInMs / (1000 * 60 * 60 * 24));

    return diffInDays > 0 ? diffInDays : 0;
  }
  //获取当前日期是周几
  public static getDayOfWeek(dateTimeRange: string): string {

    const [date, timeRange] = dateTimeRange.split(' ');
    const [startTime, endTime] = timeRange.split('~');
    const startDateString = `${date} ${startTime}`;

    const startDate = new Date(startDateString);

    const daysOfWeek = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    const dayOfWeek = daysOfWeek[startDate.getDay()];

    return dayOfWeek;
  }
}

