/**
 * StarRating - 星级评分组件
 */

import { COLOR_PRIMARY, COLOR_BORDER } from '../utils/constants'

/**
 * @Component - StarRating
 */
@Component
export struct StarRating {
  @Prop rating: number = 0
  @Prop starSize: number = 24
  @Prop editable: boolean = false
  onChange?: (rating: number) => void

  build() {
    Row({ space: 4 }) {
      ForEach([1, 2, 3, 4, 5], (star: number) => {
        Text(star <= this.rating ? '\u2605' : '\u2606')
          .fontSize(this.starSize)
          .fontColor(star <= this.rating ? COLOR_PRIMARY : COLOR_BORDER)
          .onClick(() => {
            if (this.editable && this.onChange) {
              this.onChange(star)
            }
          })
      })
    }
  }
}
