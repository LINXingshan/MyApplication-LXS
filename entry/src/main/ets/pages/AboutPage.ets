/**
 * AboutPage - 关于我们
 */

import { router } from '@kit.ArkUI'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER,
  TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2, SPACING_SM, SPACING_MD, SPACING_LG, SPACING_XL }
  from '../utils/constants'

/**
 * AboutPage page
 */
@Entry
@Component
struct AboutPage {
  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('关于我们').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      Column() {
        Text('\uD83C\uDFEB').fontSize(64).margin({ top: SPACING_XL })
        Text('高校校园助手').fontSize(TYPO_H3.fontSize + 4).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY).margin({ top: SPACING_MD })
        Text('HarmonyOS NEXT 版').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_SM })
        Text('版本号 V1.0.0').fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_LG })

        Divider().width('80%').color(COLOR_BORDER).margin({ top: SPACING_XL, bottom: SPACING_XL })

        Text('开发团队').fontSize(TYPO_H3.fontSize).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT_PRIMARY)
        Text('校园助手开发团队').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 8 })
        Text('本项目为 HarmonyOS NEXT 课程综合实训项目').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 8 })
        Text('覆盖 ArkTS + ArkUI + Stage 模型完整技术栈').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 4 })

        Divider().width('80%').color(COLOR_BORDER).margin({ top: SPACING_XL, bottom: SPACING_XL })

        Text('\u00A92026 高校校园助手 保留所有权利').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY)
      }
      .width('100%').layoutWeight(1).alignItems(HorizontalAlign.Center)
    }.width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
