/**
 * FavoritesPage - 收藏列表页
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { FavoriteItem } from '../data/models/Index'
import { TagBar } from '../components/TagBar'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  COLOR_WHITE, COLOR_WARNING, COLOR_BORDER, ROUTE, TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'

/**
 * FavoritesPage page
 */
@Entry
@Component
struct FavoritesPage {
  @State favorites: FavoriteItem[] = []
  @State selectedTag: number = 0
  private tags: string[] = ['全部', '公告', '图书', '美食']

  aboutToAppear(): void { this.load() }
  async load(): Promise<void> {
    this.favorites = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
  }
  getFiltered(): FavoriteItem[] {
    const typeMap: Record<number, string> = { 0: '', 1: 'announcement', 2: 'book', 3: 'food' }
    const t = typeMap[this.selectedTag] || ''
    const favs = this.favorites || []
    return t === '' ? favs : favs.filter(f => f.type === t)
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('我的收藏').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      TagBar({ tags: this.tags, selectedIndex: $selectedTag })

      List() {
        if (this.getFiltered().length === 0) {
          ListItem() {
            Column() {
              Blank().height(150)
              Text('\uD83D\uDC94')
                .fontSize(48)
                .opacity(0.4)
              Text('\u6682\u65E0\u6536\u85CF')
                .fontSize(TYPO_B1.fontSize)
                .fontColor(COLOR_TEXT_SECONDARY)
                .margin({ top: SPACING_SM })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
        } else {
          ForEach(this.getFiltered(), (item: FavoriteItem) => {
            ListItem() {
              Row() {
                Text(item.type === 'announcement' ? '\uD83D\uDCC4' : item.type === 'book' ? '\uD83D\uDCDA' : '\uD83C\uDF54')
                  .fontSize(28)
                Column() {
                  Text(item.title).fontSize(TYPO_H3.fontSize).fontColor(COLOR_TEXT_PRIMARY).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(item.summary).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).margin({ top: 4 })
                }.alignItems(HorizontalAlign.Start).layoutWeight(1).margin({ left: SPACING_SM })
              }.width('100%').padding(SPACING_SM)
            }
            .backgroundColor(COLOR_CARD_BG).margin({ left: SPACING_MD, right: SPACING_MD, bottom: SPACING_SM }).borderRadius(8)
            .swipeAction({ end: { builder: () => { this.deleteBtn(item.id) } } })
          })
        }
      }.width('100%').layoutWeight(1)
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder deleteBtn(id: string) {
    Button('删除').height('100%').backgroundColor(COLOR_WARNING).fontColor(COLOR_WHITE).fontSize(TYPO_B2.fontSize)
      .onClick(async () => {
        this.favorites = this.favorites.filter(f => f.id !== id)
        await StorageManager.saveJsonFile('favorites', this.favorites)
      })
  }
}
