/**
 * BookDetailPage - 图书详情页
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Book, FavoriteItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_WHITE, COLOR_BORDER, COLOR_SUCCESS,
  TYPO_PAGE_TITLE, TYPO_H2, TYPO_H3, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * BookDetailPage page
 */
@Entry
@Component
struct BookDetailPage {
  @State book: Book | null = null
  @State isFavorited: boolean = false
  private itemId: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params && params['id']) { this.itemId = params['id']; this.load() }
  }

  async load(): Promise<void> {
    const books = await StorageManager.loadJsonFile<Book>('books')
    this.book = books.find(b => b.id === this.itemId) || null
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    this.isFavorited = favs.some(f => f.sourceId === this.itemId && f.type === 'book')
  }

  async toggleFavorite(): Promise<void> {
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    if (this.isFavorited) {
      await StorageManager.saveJsonFile('favorites', favs.filter(f => !(f.sourceId === this.itemId && f.type === 'book')))
      this.isFavorited = false
    } else {
      favs.push({ id: `fav_${Date.now()}`, type: 'book', title: this.book!.title, summary: this.book!.author, imagePath: '', sourceId: this.itemId, createdAt: new Date().toISOString().split('T')[0] })
      await StorageManager.saveJsonFile('favorites', favs)
      this.isFavorited = true
    }
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44).textAlign(TextAlign.Center).onClick(() => router.back())
        Text('图书详情').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.book) {
        Scroll() {
          Column() {
            // 封面区
            Column() {
              Text('\uD83D\uDCDA').fontSize(80)
              Text(this.book.title).fontSize(TYPO_H2.fontSize).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).margin({ top: SPACING_MD })
            }.width('100%').padding({ top: SPACING_LG, bottom: SPACING_LG }).backgroundColor('#E8F4FD')

            // 信息区
            Column() {
              this.infoRow('作者', this.book.author)
              Divider().color(COLOR_BORDER)
              this.infoRow('ISBN', this.book.isbn)
              Divider().color(COLOR_BORDER)
              this.infoRow('出版社', this.book.publisher)
              Divider().color(COLOR_BORDER)
              this.infoRow('馆藏位置', this.book.location)
              Divider().color(COLOR_BORDER)
              this.infoRow('剩余可借', `${this.book.availableCount} 册`)
            }.width('90%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG).padding(SPACING_MD).margin({ top: SPACING_MD })

            // 按钮
            Row({ space: 16 }) {
              Button(this.isFavorited ? '\u2764\uFE0F 已收藏' : '\u2661 收藏')
                .width('45%').height(48).borderRadius(RADIUS_COMPONENT)
                .backgroundColor(this.isFavorited ? '#FFE5E5' : COLOR_BG)
                .fontColor(this.isFavorited ? '#FF4D4F' : COLOR_TEXT_PRIMARY).fontSize(TYPO_B1.fontSize)
                .onClick(() => { this.toggleFavorite() })

              Button(this.book.status === 'want' ? '\u2705 已标记想看' : '\uD83D\uDC41 想看')
                .width('45%').height(48).borderRadius(RADIUS_COMPONENT)
                .backgroundColor(this.book.status === 'want' ? '#E6F7ED' : COLOR_PRIMARY)
                .fontColor(this.book.status === 'want' ? COLOR_SUCCESS : COLOR_WHITE).fontSize(TYPO_B1.fontSize)
                .onClick(() => {
                  if (this.book) { this.book.status = this.book.status === 'want' ? 'none' : 'want' }
                })
            }.width('90%').justifyContent(FlexAlign.SpaceEvenly).margin({ top: SPACING_MD, bottom: SPACING_LG })
          }
        }.width('100%').layoutWeight(1)
      }
    }.width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder infoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
      Text(value).fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1)
    }.width('100%').padding({ top: 8, bottom: 8 })
  }
}
