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
}

