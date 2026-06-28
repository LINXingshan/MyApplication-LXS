/**
 * LostFoundPublishPage - 失物/拾物发布页
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { LostFoundItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_WHITE,
  TYPO_PAGE_TITLE, TYPO_B2, TYPO_B1, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * LostFoundPublishPage page
 */
@Entry
@Component
struct LostFoundPublishPage {
  @State itemType: string = 'lost'
  @State itemName: string = ''
  @State category: string = 'other'
  @State location: string = ''
  @State date: string = new Date().toISOString().split('T')[0]
  @State description: string = ''
  @State contactPhone: string = ''

  get isActive(): boolean {
    return this.itemName.trim() !== '' && this.location.trim() !== '' && this.contactPhone.trim() !== ''
  }

  async publish(): Promise<void> {
    if (!this.isActive) { promptAction.showToast({ message: '请填写必填项', duration: 1500 }); return }
    const items = await StorageManager.loadJsonFile<LostFoundItem>('lost_found_items')
    items.push({
      id: `lf_${Date.now()}`, type: this.itemType, itemName: this.itemName.trim(),
      category: this.category, location: this.location.trim(), date: this.date,
      description: this.description, contactPhone: this.contactPhone.trim(),
      imagePaths: [], createdAt: new Date().toISOString().split('T')[0]
    })
    await StorageManager.saveJsonFile('lost_found_items', items)
    promptAction.showToast({ message: '发布成功', duration: 1500 })
    setTimeout(() => { router.back() }, 500)
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44).textAlign(TextAlign.Center).onClick(() => router.back())
        Text('发布信息').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('发布').fontSize(TYPO_B1.fontSize).fontColor(this.isActive ? COLOR_PRIMARY : COLOR_TEXT_SECONDARY).width(50).onClick(() => { this.publish() })
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      Scroll() {
        Column() {
          // 类型选择
          Row() {
            Text('类型').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
            Row({ space: 16 }) {
              ForEach(['失物', '拾物'], (label: string, idx: number) => {
                Text(label)
                  .fontSize(TYPO_B2.fontSize)
                  .fontColor(this.itemType === (idx === 0 ? 'lost' : 'found') ? COLOR_WHITE : COLOR_TEXT_PRIMARY)
                  .backgroundColor(this.itemType === (idx === 0 ? 'lost' : 'found') ? COLOR_PRIMARY : COLOR_BG)
                  .borderRadius(12).padding({ left: 16, right: 16, top: 6, bottom: 6 })
                  .onClick(() => { this.itemType = idx === 0 ? 'lost' : 'found' })
              })
            }
          }.width('90%').padding({ top: SPACING_MD })

          this.formItem('物品名称', this.itemName, (v: string) => { this.itemName = v }, '如 校园卡')
          this.formItem('地点', this.location, (v: string) => { this.location = v }, '如 教学楼A区')
          this.formItem('日期', this.date, (v: string) => { this.date = v }, 'YYYY-MM-DD')
          this.formItem('描述', this.description, (v: string) => { this.description = v }, '物品详细描述')
          this.formItem('联系电话', this.contactPhone, (v: string) => { this.contactPhone = v }, '手机号码')

          Blank().height(SPACING_MD)
        }
        .width('95%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG).alignSelf(ItemAlign.Center).margin({ top: SPACING_MD })
      }
      .width('100%').layoutWeight(1)
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder formItem(label: string, value: string, onChange: (v: string) => void, placeholder: string) {
    Row() {
      Text(label).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
      TextInput({ text: value, placeholder: placeholder }).layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize).onChange(onChange)
    }
    .width('90%').padding({ top: 12, bottom: 12 })
  }
}
