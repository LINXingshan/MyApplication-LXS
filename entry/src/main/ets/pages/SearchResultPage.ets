/**
 * SearchResultPage - 搜索结果页
 * 顶部搜索框 + 跨模块搜索结果列表
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { SearchBar } from '../components/SearchBar'
import { Announcement, Book, FoodItem } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  ROUTE, TYPO_PAGE_TITLE, TYPO_H3, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'

interface SearchResult {
  type: string
  title: string
  subtitle: string
  id: string
}

/**
 * SearchResultPage page
 */
@Entry
@Component
struct SearchResultPage {
  @State results: SearchResult[] = []
  @State isLoading: boolean = false

  async doSearch(keyword: string): Promise<void> {
    if (keyword.trim() === '') {
      this.results = []
      return
    }
    this.isLoading = true
    const kw = keyword.trim().toLowerCase()
    const res: SearchResult[] = []

    // 搜索公告
    const anns = await StorageManager.loadJsonFile<Announcement>('announcements')
    for (const a of anns) {
      if (a.title.toLowerCase().includes(kw) || a.content.toLowerCase().includes(kw)) {
        res.push({ type: '公告', title: a.title, subtitle: a.source, id: a.id })
      }
    }

    // 搜索图书
    const books = await StorageManager.loadJsonFile<Book>('books')
    for (const b of books) {
      if (b.title.toLowerCase().includes(kw) || b.author.toLowerCase().includes(kw) || b.isbn.includes(kw)) {
        res.push({ type: '图书', title: b.title, subtitle: b.author, id: b.id })
      }
    }

    // 搜索美食
    const foods = await StorageManager.loadJsonFile<FoodItem>('food_items')
    for (const f of foods) {
      if (f.name.toLowerCase().includes(kw) || f.canteen.toLowerCase().includes(kw)) {
        res.push({ type: '美食', title: f.name, subtitle: f.canteen, id: f.id })
      }
    }

    this.results = res
    this.isLoading = false
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

        SearchBar({
          placeholder: '搜索校园信息/课程/美食',
          onSearch: (keyword: string) => {
            this.doSearch(keyword)
          }
        })
        .layoutWeight(1)

        Text('搜索')
          .fontSize(TYPO_B2.fontSize)
          .fontColor(COLOR_PRIMARY)
          .width(50)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            // search trigger handled by SearchBar
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor(COLOR_CARD_BG)
      .padding({ left: SPACING_SM, right: SPACING_SM })

      // 搜索结果
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(36)
            .height(36)
            .color(COLOR_PRIMARY)
          Text('搜索中...')
            .fontSize(TYPO_B2.fontSize)
            .fontColor(COLOR_TEXT_SECONDARY)
            .margin({ top: SPACING_MD })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.results.length === 0) {
        Column() {
          Text('\uD83D\uDD0D')
            .fontSize(48)
          Text('输入关键词搜索')
            .fontSize(TYPO_H3.fontSize)
            .fontColor(COLOR_TEXT_SECONDARY)
            .margin({ top: SPACING_SM })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.results, (item: SearchResult) => {
            ListItem() {
              Row() {
                // 类型标签
                Text(item.type)
                  .fontSize(20)
                  .fontColor(COLOR_PRIMARY)
                  .border({ width: 1, color: COLOR_PRIMARY, radius: 4 })
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })

                Column() {
                  Text(item.title)
                    .fontSize(TYPO_H3.fontSize)
                    .fontColor(COLOR_TEXT_PRIMARY)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(item.subtitle)
                    .fontSize(TYPO_B2.fontSize)
                    .fontColor(COLOR_TEXT_SECONDARY)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: SPACING_SM })
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ left: SPACING_MD, right: SPACING_MD, top: SPACING_SM, bottom: SPACING_SM })
              .onClick(() => {
                // 根据类型跳转不同详情页
                if (item.type === '公告') {
                  router.pushUrl({ url: ROUTE.ANNOUNCEMENT_DETAIL, params: { id: item.id } })
                } else if (item.type === '图书') {
                  router.pushUrl({ url: ROUTE.BOOK_DETAIL, params: { id: item.id } })
                } else if (item.type === '美食') {
                  router.pushUrl({ url: ROUTE.FOOD_DETAIL, params: { id: item.id } })
                }
              })
            }
            .backgroundColor(COLOR_CARD_BG)
            .margin({ bottom: 1 })
          })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor(COLOR_BG)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_BG)
  }
}
