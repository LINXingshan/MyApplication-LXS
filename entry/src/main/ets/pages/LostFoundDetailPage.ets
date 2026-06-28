/**
 * LostFoundDetailPage - 失物/拾物详情页
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { LostFoundItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER,
  TYPO_PAGE_TITLE, TYPO_H2, TYPO_H3, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * LostFoundDetailPage page
 */
@Entry
@Component
struct LostFoundDetailPage {
  @State item: LostFoundItem | null = null
  private itemId: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params && params['id']) { this.itemId = params['id']; this.load() }
  }

  async load(): Promise<void> {
    const items = await StorageManager.loadJsonFile<LostFoundItem>('lost_found_items')
    this.item = items.find(i => i.id === this.itemId) || null
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44).textAlign(TextAlign.Center).onClick(() => router.back())
        Text('详情').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.item) {
        Column() {
          Column() {
            Text(this.item.type === 'lost' ? '\uD83D\uDD0D 失物信息' : '\u2705 拾物信息')
              .fontSize(TYPO_H2.fontSize).fontWeight(FontWeight.Bold)
              .fontColor(this.item.type === 'lost' ? COLOR_PRIMARY : '#52C41A')
            Text(this.item.itemName).fontSize(TYPO_H3.fontSize + 4).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).margin({ top: SPACING_SM })
          }
          .width('100%').padding({ top: SPACING_LG, bottom: SPACING_LG }).backgroundColor('#F0F9FF').alignItems(HorizontalAlign.Center)

          Column() {
            this.infoRow('分类', this.item.category === 'campus_card' ? '校园卡' : this.item.category === 'bag' ? '包' : this.item.category === 'electronic' ? '电子产品' : '其他')
            Divider().color(COLOR_BORDER)
            this.infoRow('地点', this.item.location)
            Divider().color(COLOR_BORDER)
            this.infoRow('日期', this.item.date)
            Divider().color(COLOR_BORDER)
            this.infoRow('描述', this.item.description)
            Divider().color(COLOR_BORDER)
            this.infoRow('联系电话', this.item.contactPhone)
          }
          .width('90%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG).padding(SPACING_MD).margin({ top: SPACING_MD })
        }
        .width('100%').layoutWeight(1)
      }
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder infoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
      Text(value).fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1)
    }.width('100%').padding({ top: 8, bottom: 8 })
  }
}
