/**
 * InfoCard - 信息卡片容器组件
 * 白色背景，圆角8vp，95%宽，内边距16vp，阴影
 */

import { COLOR_PRIMARY, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, RADIUS_COMPONENT, SPACING_SM, TYPO_H2, TYPO_B2 } from '../utils/constants'

/**
 * @Component - InfoCard
 */
@Component
export struct InfoCard {
  @Prop title: string = ''
  @Prop showMore: boolean = false
  onMoreClick?: () => void
  @BuilderParam content: () => void = this.defaultContent

  @Builder
  defaultContent() {
    Text('')
  }

  build() {
    Column() {
      // 标题行
      if (this.title !== '') {
        Row() {
          Text(this.title)
            .fontSize(TYPO_H2.fontSize)
            .fontWeight(TYPO_H2.fontWeight)
            .fontColor(COLOR_PRIMARY)

          Blank()

          if (this.showMore) {
            Text('更多 >')
              .fontSize(TYPO_B2.fontSize)
              .fontColor(COLOR_PRIMARY)
              .onClick(() => {
                if (this.onMoreClick) {
                  this.onMoreClick()
                }
              })
          }
        }
        .width('100%')
        .padding({ bottom: SPACING_SM })
      }

      // 内容插槽
      this.content()
    }
    .width('95%')
    .borderRadius(RADIUS_COMPONENT)
    .backgroundColor(COLOR_CARD_BG)
    .alignSelf(ItemAlign.Center)
    .padding(SPACING_SM)
    .shadow({
      radius: 8,
      color: '#000000',
      offsetY: 2
    })
  }
}
