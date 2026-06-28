/**
 * MyLostFoundPage - 我的失物发布页
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { LostFoundItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  TYPO_PAGE_TITLE, TYPO_H3, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'

/**
 * MyLostFoundPage page
 */
@Entry
@Component
struct MyLostFoundPage {
  @State items: LostFoundItem[] = []
  aboutToAppear(): void { this.load() }
  async load(): Promise<void> { this.items = await StorageManager.loadJsonFile<LostFoundItem>('lost_found_items') }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('失物发布').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.items.length === 0) {
        Column() {
          Text('\uD83D\uDCE6').fontSize(48)
          Text('暂无发布').fontSize(TYPO_H3.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_SM })
        }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.items, (item: LostFoundItem) => {
            ListItem() {
              Row() {
                Text(item.type === 'lost' ? '\uD83D\uDD0D' : '\u2705').fontSize(28)
                Column() {
                  Text(item.itemName).fontSize(TYPO_H3.fontSize).fontColor(COLOR_TEXT_PRIMARY)
                  Text(`${item.location} | ${item.date}`).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 4 })
                }.alignItems(HorizontalAlign.Start).layoutWeight(1).margin({ left: SPACING_SM })
              }.width('100%').padding(SPACING_SM)
            }.backgroundColor(COLOR_CARD_BG).margin({ left: SPACING_MD, right: SPACING_MD, bottom: 1 }).borderRadius(8)
          })
        }.width('100%').layoutWeight(1)
      }
    }.width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
