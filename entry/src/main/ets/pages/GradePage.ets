import GradeSummary from '../components/GradeSummary';
import GradeBlock from '../components/GradeBlock';
import router from '@ohos.router';
import NavBar, { NavBarConfig } from '../components/NavBar';

@Entry
@Component
struct GradePage {
  totalCredit: number = 0;
  navBarConfig: NavBarConfig = {
    leftIcon: $r('app.media.icon_back'),
    title: "成绩查询",
    onClickLeftButton: () => {
      router.back();
    }
  }

  build() {
    Column() {
      NavBar({ navBarConfig: this.navBarConfig })
      Scroll() {
        Column() {
          // GradeSummary({
          //
          // })
          // GradeBlock()
        }
      }
    }
  }
}

