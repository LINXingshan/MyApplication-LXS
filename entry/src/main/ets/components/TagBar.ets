/**
 * TagBar - 横向滚动标签栏组件
 * 选中：鸿蒙蓝背景+白色文字，未选中：浅灰背景+主色文字
 */

import { COLOR_PRIMARY, COLOR_BG, COLOR_WHITE, COLOR_TEXT_PRIMARY, RADIUS_COMPONENT, TYPO_B2 } from '../utils/constants'

/**
 * @Component - TagBar
 */
@Component
export struct TagBar {
  @Prop tags: string[] = []
  @Link selectedIndex: number

  build() {
    Scroll() {
      Row({ space: 8 }) {
        ForEach(this.tags, (tag: string, index: number) => {
          Text(tag)
            .fontSize(TYPO_B2.fontSize)
            .fontColor(this.selectedIndex === index ? COLOR_WHITE : COLOR_TEXT_PRIMARY)
            .backgroundColor(this.selectedIndex === index ? COLOR_PRIMARY : COLOR_BG)
            .borderRadius(RADIUS_COMPONENT)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .height(36)
            .textAlign(TextAlign.Center)
            .animation({ duration: 200 })
            .onClick(() => {
              this.selectedIndex = index
            })
        })
      }
      .padding({ left: 16, right: 16 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .padding({ top: 12, bottom: 12 })
  }
}
