/**
 * MusicListPage - 本地音乐列表页
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Song } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  TYPO_PAGE_TITLE, TYPO_H3, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'

/**
 * MusicListPage page
 */
@Entry
@Component
struct MusicListPage {
  @State songs: Song[] = []

  aboutToAppear(): void { this.load() }
  async load(): Promise<void> { this.songs = await StorageManager.loadJsonFile<Song>('songs') }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44).textAlign(TextAlign.Center).onClick(() => router.back())
        Text('本地音乐').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.songs.length === 0) {
        Column() {
          Text('\uD83C\uDFB5').fontSize(48)
          Text('暂无本地音乐').fontSize(TYPO_H3.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_SM })
        }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.songs, (song: Song, index: number) => {
            ListItem() {
              Row() {
                Column() {
                  Text('\uD83C\uDFB5').fontSize(36)
                }.width(56).height(56).borderRadius(4).backgroundColor(COLOR_BG).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)

                Column() {
                  Text(song.title).fontSize(TYPO_H3.fontSize).fontColor(COLOR_TEXT_PRIMARY)
                  Text(song.artist).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start).layoutWeight(1).margin({ left: SPACING_SM })

                Text(`${Math.floor(song.duration / 60)}:${String(song.duration % 60).padStart(2, '0')}`)
                  .fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY)
              }
              .width('100%').padding(SPACING_SM)
              .onClick(() => { router.back() })
            }
            .backgroundColor(COLOR_CARD_BG).margin({ left: SPACING_MD, right: SPACING_MD, bottom: 1 }).borderRadius(8)
          })
        }
        .width('100%').layoutWeight(1)
      }
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
