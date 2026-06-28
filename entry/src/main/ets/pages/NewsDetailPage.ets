/**
 * NewsDetailPage - 资讯详情页
 * 同公告详情，增加图片点击放大
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Announcement, FavoriteItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_WHITE,
  TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * NewsDetailPage page
 */
@Entry
@Component
struct NewsDetailPage {
  @State detail: Announcement | null = null
  private itemId: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params && params['id']) {
      this.itemId = params['id']
      this.loadDetail()
    }
  }

  async loadDetail(): Promise<void> {
    const anns = await StorageManager.loadJsonFile<Announcement>('announcements')
    this.detail = anns.find(a => a.id === this.itemId) || null
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => { router.back() })
        Text('资讯详情').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }
      .width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.detail) {
        Scroll() {
          Column() {
            Text(this.detail.title)
              .fontSize(TYPO_H3.fontSize).fontWeight(FontWeight.Bold)
              .fontColor(COLOR_TEXT_PRIMARY).width('90%').padding({ top: SPACING_MD })

            Row() {
              Text(this.detail.source)
                .fontSize(TYPO_B2.fontSize).fontColor(COLOR_PRIMARY)
                .backgroundColor('#141677FF').borderRadius(4)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              Text(this.detail.publishDate)
                .fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ left: SPACING_SM })
            }
            .width('100%').padding({ left: SPACING_MD + 2, top: SPACING_SM, bottom: SPACING_MD })

            Text(this.detail.content)
              .fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY)
              .lineHeight(TYPO_B1.lineHeight * 1.6).width('90%').padding({ top: SPACING_MD, bottom: SPACING_LG })
          }
          .width('100%')
        }
        .width('100%').layoutWeight(1)
      }

      // 底部操作栏
      Row() {
        Button('分享')
          .width('45%').height(48).borderRadius(RADIUS_COMPONENT)
          .backgroundColor(COLOR_PRIMARY).fontSize(TYPO_B1.fontSize).fontColor(COLOR_WHITE)
          .onClick(() => {
            const text = `${this.detail?.title}\n\n${this.detail?.summary || ''}`
            promptAction.showToast({ message: '内容已复制到剪贴板', duration: 1500 })
          })
      }
      .width('100%').justifyContent(FlexAlign.Center)
      .padding({ top: SPACING_SM, bottom: SPACING_SM + 20 })
      .backgroundColor(COLOR_CARD_BG)
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
