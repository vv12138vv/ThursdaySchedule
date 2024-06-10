import GradeSummary from '../components/GradeSummary';
import GradeBlock from '../components/GradeBlock';

@Entry
@Component
export default struct GradePage {
  totalCredit:number=0;

  build() {
    Scroll() {
      Column() {
        GradeSummary({

        })
        GradeBlock()
      }
    }
  }
}

