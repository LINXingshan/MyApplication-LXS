/**
 * CustomTabBar - 底部 Tab 栏组件
 * 5个Tab，选中/未选中样式切换，动画过渡
 */

import { COLOR_PRIMARY, COLOR_CARD_BG, COLOR_TEXT_SECONDARY, SIZE_TABBAR_H, SIZE_ICON_TAB } from '../utils/constants'

interface TabItemData {
  name: string
  icon: string
  activeIcon: string
}

const TAB_DATA: TabItemData[] = [
  { name: '首页', icon: '\u2302', activeIcon: '\u2302' },
  { name: '校园信息', icon: '\uD83C\uDFEB', activeIcon: '\uD83C\uDFEB' },
  { name: '学习助手', icon: '\uD83D\uDCDA', activeIcon: '\uD83D\uDCDA' },
  { name: '生活服务', icon: '\uD83C\uDF54', activeIcon: '\uD83C\uDF54' },
  { name: '我的', icon: '\uD83D\uDC64', activeIcon: '\uD83D\uDC64' }
]

/**
 * @Component - CustomTabBar
 */
@Component
export struct CustomTabBar {
  @Prop currentIndex: number = 0
  onTabChange?: (index: number) => void

  build() {
    Row() {
      ForEach(TAB_DATA, (item: TabItemData, index: number) => {
        Column() {
          Text(item.icon)
            .fontSize(SIZE_ICON_TAB)
            .fontColor(this.currentIndex === index ? COLOR_PRIMARY : COLOR_TEXT_SECONDARY)
            .animation({ duration: 300 })

          Text(item.name)
            .fontSize(22)
            .fontColor(this.currentIndex === index ? COLOR_PRIMARY : COLOR_TEXT_SECONDARY)
            .animation({ duration: 300 })
        }
        .layoutWeight(1)
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.currentIndex = index
          if (this.onTabChange) {
            this.onTabChange(index)
          }
        })
      })
    }
    .width('100%')
    .height(SIZE_TABBAR_H)
    .backgroundColor(COLOR_CARD_BG)
  }
}
