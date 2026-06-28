/**
 * SearchBar - 搜索栏组件
 * 圆角24vp，白色背景，95%宽，居中
 */

import { promptAction } from '@kit.ArkUI'
import { COLOR_PRIMARY, COLOR_CARD_BG, COLOR_TEXT_SECONDARY, RADIUS_SEARCH, TYPO_B2 } from '../utils/constants'

/**
 * @Component - SearchBar
 */
@Component
export struct SearchBar {
  @Prop placeholder: string = '搜索校园信息/课程/美食'
  onSearch?: (keyword: string) => void
  @State keyword: string = ''
  @State isActive: boolean = false
  showVoiceIcon: boolean = true

  build() {
    Row() {
      // 搜索图标
      Text('\uD83D\uDD0D')
        .fontSize(24)
        .fontColor(COLOR_PRIMARY)
        .margin({ left: 16 })

      // 输入区
      TextInput({ placeholder: this.placeholder, text: this.keyword })
        .layoutWeight(1)
        .height(44)
        .backgroundColor(Color.Transparent)
        .fontSize(TYPO_B2.fontSize)
        .placeholderColor(COLOR_TEXT_SECONDARY)
        .borderRadius(0)
        .onChange((value: string) => {
          this.keyword = value
        })
        .onSubmit(() => {
          if (this.onSearch) {
            this.onSearch(this.keyword)
          }
        })
        .onFocus(() => {
          this.isActive = true
        })
        .onBlur(() => {
          this.isActive = false
        })

      // 语音图标（装饰性）
      if (this.showVoiceIcon) {
        Text('\uD83C\uDFA4')
          .fontSize(24)
          .fontColor(COLOR_PRIMARY)
          .margin({ right: 16 })
          .onClick(() => {
            promptAction.showToast({ message: '\u8BED\u97F3\u8BC6\u522B\u529F\u80FD\u5F00\u53D1\u4E2D', duration: 1500 })
          })
      }
    }
    .width('95%')
    .height(44)
    .borderRadius(RADIUS_SEARCH)
    .backgroundColor(COLOR_CARD_BG)
    .border({ width: this.isActive ? 1.5 : 0, color: this.isActive ? COLOR_PRIMARY : Color.Transparent })
    .alignSelf(ItemAlign.Center)
    .onClick(() => {
      if (this.onSearch) {
        this.onSearch(this.keyword)
      }
    })
  }
}
