export class DataProcess{
  // 解析学号第2-3位，返回所有允许的学期
  generateSemesterArray(studentId: string): string[] {
    const entryYearSuffix = studentId.substring(1, 3);
    const entryYear = parseInt(`20${entryYearSuffix}`);
    const semesters: string[] = [];

    for (let year = entryYear; year < entryYear + 4; year++) {
      semesters.push(`${year}-${year + 1}-1`);
      semesters.push(`${year}-${year + 1}-2`);
    }
    return semesters;
  }

  // 根据学号和当前学期确定所属阶段,例如‘921107’、‘2023-2024-2’ => ‘大三下’
  getSemesterDescription(studentId: string, semester: string): string {
    const entryYearSuffix = studentId.substring(1, 3);
    const entryYear = parseInt(`20${entryYearSuffix}`);

    const startYear = Number(semester.split('-')[0]);
    const term = Number(semester.split('-')[2]);
    const yearDifference = startYear - entryYear;

    let yearDesc: string;
    switch (yearDifference) {
      case 0:
        yearDesc = "大一";
        break;
      case 1:
        yearDesc = "大二";
        break;
      case 2:
        yearDesc = "大三";
        break;
      case 3:
        yearDesc = "大四";
        break;
      default:
        throw new Error("Invalid semester or student ID");
    }

    let termDesc: string;
    switch (term) {
      case 1:
        termDesc = "上";
        break;
      case 2:
        termDesc = "下";
        break;
      default:
        throw new Error("Invalid term in semester string");
    }

    return `${yearDesc}${termDesc}`;
  }

}