/**
 * AnnouncementDetailPage - 公告详情页
 * 完整正文 + 底部收藏/分享按钮
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Announcement, FavoriteItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  COLOR_BORDER, COLOR_WHITE, TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * AnnouncementDetailPage page
 */
@Entry
@Component
struct AnnouncementDetailPage {
  @State announcement: Announcement | null = null
  @State isFavorited: boolean = false
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
    this.announcement = anns.find(a => a.id === this.itemId) || null
    // 检查是否已收藏
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    this.isFavorited = favs.some(f => f.sourceId === this.itemId && f.type === 'announcement')
  }

  async toggleFavorite(): Promise<void> {
    if (!this.announcement) return
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')

    if (this.isFavorited) {
      const filtered = favs.filter(f => !(f.sourceId === this.itemId && f.type === 'announcement'))
      await StorageManager.saveJsonFile('favorites', filtered)
      this.isFavorited = false
      promptAction.showToast({ message: '已取消收藏', duration: 1500 })
    } else {
      const newFav: FavoriteItem = {
        id: `fav_${Date.now()}`,
        type: 'announcement',
        title: this.announcement.title,
        summary: this.announcement.summary,
        imagePath: '',
        sourceId: this.itemId,
        createdAt: new Date().toISOString().split('T')[0]
      }
      favs.push(newFav)
      await StorageManager.saveJsonFile('favorites', favs)
      this.isFavorited = true
      promptAction.showToast({ message: '已收藏', duration: 1500 })
    }
  }

  shareAnnouncement(): void {
    if (!this.announcement) return
    const text = `${this.announcement.title}\n\n${this.announcement.summary}`
    promptAction.showToast({ message: '已复制到剪贴板', duration: 1500 })
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Text('\u2190')
          .fontSize(28)
          .fontColor(COLOR_PRIMARY)
          .width(44)
          .height(44)
          .textAlign(TextAlign.Center)
          .onClick(() => { router.back() })

        Text('公告详情')
          .fontSize(TYPO_PAGE_TITLE.fontSize)
          .fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(44)
      }
      .width('100%')
      .height(56)
      .backgroundColor(COLOR_CARD_BG)
      .padding({ left: SPACING_SM })

      if (this.announcement) {
        Scroll() {
          Column() {
            // 标题
            Text(this.announcement.title)
              .fontSize(TYPO_H3.fontSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLOR_TEXT_PRIMARY)
              .width('100%')
              .padding({ left: SPACING_MD, right: SPACING_MD, top: SPACING_MD })

            // 来源和时间
            Row() {
              Text(this.announcement.source)
                .fontSize(TYPO_B2.fontSize)
                .fontColor(COLOR_PRIMARY)
                .backgroundColor('#141677FF').borderRadius(4)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })

              Text(this.announcement.publishDate)
                .fontSize(TYPO_B2.fontSize)
                .fontColor(COLOR_TEXT_SECONDARY)
                .margin({ left: SPACING_SM })
            }
            .width('100%')
            .padding({ left: SPACING_MD, right: SPACING_MD, top: SPACING_SM, bottom: SPACING_MD })

            Divider().color(COLOR_BORDER).width('90%')

            // 正文
            Text(this.announcement.content)
              .fontSize(TYPO_B1.fontSize)
              .fontColor(COLOR_TEXT_PRIMARY)
              .lineHeight(TYPO_B1.lineHeight * 1.6)
              .width('90%')
              .padding({ top: SPACING_MD, bottom: SPACING_LG })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .layoutWeight(1)
        .align(Alignment.TopStart)

        // 底部操作栏
        Row() {
          Button() {
            Text(this.isFavorited ? '\u2764\uFE0F 已收藏' : '\u2661 收藏')
              .fontSize(TYPO_B1.fontSize)
          }
          .width('45%')
          .height(48)
          .borderRadius(RADIUS_COMPONENT)
          .backgroundColor(this.isFavorited ? '#FFE5E5' : COLOR_BG)
          .fontColor(this.isFavorited ? '#FF4D4F' : COLOR_TEXT_PRIMARY)
          .onClick(() => { this.toggleFavorite() })

          Button() {
            Text('\uD83D\uDCE4 分享')
              .fontSize(TYPO_B1.fontSize)
          }
          .width('45%')
          .height(48)
          .borderRadius(RADIUS_COMPONENT)
          .backgroundColor(COLOR_PRIMARY)
          .fontColor(COLOR_WHITE)
          .onClick(() => { this.shareAnnouncement() })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({ top: SPACING_SM, bottom: SPACING_SM + 20 })
        .backgroundColor(COLOR_CARD_BG)
      } else {
        Text('加载中...')
          .fontSize(TYPO_B2.fontSize)
          .fontColor(COLOR_TEXT_SECONDARY)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_BG)
  }
}
