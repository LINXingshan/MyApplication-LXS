/**
 * LifeTab - 生活服务
 * 2×2网格入口 + 失物招领/美食/音乐/工具
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { LostFoundItem, FoodItem, Song, FavoriteItem } from '../data/models/Index'
import { ROUTE, TYPO_PAGE_TITLE, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'
import { ThemeColors, ThemePalette } from '../utils/theme'

const W = '92%'
const LF_TAGS: string[] = ['全部','失物','拾物','校园卡','电子']

@Component
export struct LifeTab {
  @StorageLink('currentTabIndex') @Watch('onTabChanged') currentTab: number = 0
  @StorageLink('isDarkMode') isDarkMode: boolean = false
  @State activeView: number = 0

  theme(): ThemePalette { return ThemeColors.get(this.isDarkMode) }
  @State lfItems: LostFoundItem[] = []
  @State foods: FoodItem[] = []
  @State songs: Song[] = []
  @State favs: FavoriteItem[] = []
  @State lfTag: number = 0
  @State isPlay: boolean = false
  @State songIdx: number = 0
  @State curTime: number = 0
  private td: number = 180
  private timer: number = -1

  aboutToAppear(): void { this.loadAll() }
  aboutToDisappear(): void { clearInterval(this.timer) }

  onTabChanged(): void {
    if (this.currentTab === 3) {
      const v = AppStorage.get<number>('gotoLifeView')
      if (v !== undefined && v >= 0 && v <= 2) {
        this.activeView = v
        AppStorage.setOrCreate('gotoLifeView', -1)
      }
    }
  }

  async loadAll(): Promise<void> {
    this.lfItems = (await StorageManager.loadJsonFile<LostFoundItem>('lost_found_items')) || []
    this.foods = (await StorageManager.loadJsonFile<FoodItem>('food_items')) || []
    this.songs = (await StorageManager.loadJsonFile<Song>('songs')) || []
    this.favs = (await StorageManager.loadJsonFile<FavoriteItem>('favorites')) || []
  }

  getFiltered(): LostFoundItem[] {
    const f = LF_TAGS[this.lfTag]
    if (f === '全部') return this.lfItems
    if (f === '失物') return this.lfItems.filter(i => i.type === 'lost')
    if (f === '拾物') return this.lfItems.filter(i => i.type === 'found')
    return this.lfItems.filter(i => i.category === 'campus_card' || i.category === 'electronic')
  }

  togglePlay(): void {
    if (this.isPlay) { clearInterval(this.timer); this.isPlay = false; return }
    this.isPlay = true
    const s: Song = this.songs[this.songIdx]; this.td = s ? s.duration : 180
    this.timer = setInterval(() => {
      if (this.curTime < this.td) { this.curTime++ } else { this.nextSong() }
    }, 1000)
  }

  nextSong(): void {
    if (!this.songs.length) return; clearInterval(this.timer)
    this.songIdx = (this.songIdx + 1) % this.songs.length; this.curTime = 0
    this.timer = setInterval(() => {
      if (this.curTime < this.td) { this.curTime++ } else { this.nextSong() }
    }, 1000)
  }

  prevSong(): void {
    if (!this.songs.length) return; clearInterval(this.timer)
    this.songIdx = (this.songIdx - 1 + this.songs.length) % this.songs.length; this.curTime = 0
    this.timer = setInterval(() => {
      if (this.curTime < this.td) { this.curTime++ } else { this.nextSong() }
    }, 1000)
  }

  formatTime(s: number): string {
    return `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`
  }

  build() {
    Column() {
      Row() {
        Text('生活服务').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(this.theme().textPrimary)
      }.width('100%').height(56).backgroundColor(this.theme().cardBg).padding({ left: SPACING_MD })

      Scroll() {
        Column() {
          Grid() {
            ForEach([0, 1, 2, 3], (idx: number) => {
              GridItem() {
                Column() {
                  Text(['🎒','🍔','🎵','🔧'][idx]).fontSize(40)
                  Text(['失物招领','校园美食','音乐播放','校园工具'][idx]).fontSize(14).fontColor(this.theme().textPrimary).margin({ top: 8 })
                }.width('100%').height(120).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).borderRadius(8).backgroundColor(this.theme().cardBg)
              }.onClick(() => { this.activeView = idx })
            })
          }.columnsTemplate('1fr 1fr').rowsGap(12).columnsGap(12).width('95%').alignSelf(ItemAlign.Center).margin({ top: SPACING_MD })

          if (this.activeView === 0) {
            Button('发布信息').width('95%').height(44).borderRadius(8).backgroundColor(this.theme().warning).fontSize(14).fontColor('#FFFFFF')
              .alignSelf(ItemAlign.Center).margin({ top: SPACING_SM }).onClick(() => { router.pushUrl({ url: ROUTE.LOSTFOUND_PUBLISH }) })
            Row({ space: 6 }) { ForEach(LF_TAGS, (t: string, i: number) => {
              Text(t).fontSize(13).fontColor(this.lfTag === i ? '#FFFFFF' : '#1D2129').backgroundColor(this.lfTag === i ? '#1677FF' : '#F5F7FA').borderRadius(6).padding({ left: 14, right: 14, top: 6, bottom: 6 }).onClick(() => { this.lfTag = i }) }) }.width('95%').alignSelf(ItemAlign.Center).margin({ top: SPACING_SM, bottom: SPACING_SM })
            ForEach(this.getFiltered(), (item: LostFoundItem) => {
              Row() {
                Text(item.type === 'lost' ? '🔍' : '✅').fontSize(28).margin({ right: 12 })
                Column() { Text(item.itemName).fontSize(15).fontWeight(FontWeight.Medium).fontColor(this.theme().textPrimary); Text(item.date + ' · ' + item.location).fontSize(12).fontColor(this.theme().textSecondary).margin({ top: 2 }) }.alignItems(HorizontalAlign.Start).layoutWeight(1)
              }.width(W).padding(14).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ bottom: 6 })
              .onClick(() => { const p: Record<string, string> = { 'id': item.id }; router.pushUrl({ url: ROUTE.LOSTFOUND_DETAIL, params: p }) })
            })
          }

          if (this.activeView === 1) {
            ForEach(this.foods, (food: FoodItem) => {
              Column() {
                Row() { Text('🍔').fontSize(40) }.width('100%').height(130).backgroundColor('#FFF7E6').borderRadius(8).justifyContent(FlexAlign.Center)
                Row() {
                  Column() {
                    Text(food.name).fontSize(16).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary)
                    Text(food.canteen).fontSize(12).fontColor(this.theme().textSecondary).margin({ top: 2 })
                    Row() { ForEach([1, 2, 3, 4, 5], (s: number) => { Text(s <= food.rating ? '★' : '☆').fontSize(16).fontColor('#FF7D00') }) }
                  }.alignItems(HorizontalAlign.Start).layoutWeight(1)
                }.width('100%').padding(SPACING_SM)
              }.width(W).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ bottom: 8 })
              .onClick(() => { const p: Record<string, string> = { 'id': food.id }; router.pushUrl({ url: ROUTE.FOOD_DETAIL, params: p }) })
            })
          }

          if (this.activeView === 2) {
            Column() {
              Stack() {
                Circle().width(160).height(160).fill('#E8F4FD'); Text('🎵').fontSize(72)
              }.width(160).height(160).margin({ top: SPACING_MD })
              Text(this.songs.length > 0 ? this.songs[this.songIdx].title : '暂无歌曲').fontSize(18).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary).margin({ top: SPACING_MD })
              Text(this.songs.length > 0 ? this.songs[this.songIdx].artist : '').fontSize(14).fontColor(this.theme().textSecondary).margin({ top: SPACING_SM })
              Row() {
                Text(this.formatTime(this.curTime)).fontSize(12).fontColor(this.theme().textSecondary).width(40).textAlign(TextAlign.Center)
                Slider({ value: this.curTime, min: 0, max: this.td }).layoutWeight(1).blockColor('#1677FF').trackColor('#E5E6EB').onChange((v: number) => { this.curTime = v })
                Text(this.formatTime(this.td)).fontSize(12).fontColor(this.theme().textSecondary).width(40).textAlign(TextAlign.Center)
              }.width('90%').margin({ top: SPACING_MD })
              Row({ space: 40 }) {
                Text('⏮️').fontSize(36).onClick(() => { this.prevSong() })
                Text(this.isPlay ? '⏸️' : '▶️').fontSize(48).fontColor('#1677FF').onClick(() => { this.togglePlay() })
                Text('⏭️').fontSize(36).onClick(() => { this.nextSong() })
              }.margin({ top: SPACING_LG })
            }.width('100%').alignItems(HorizontalAlign.Center).margin({ top: SPACING_MD })
          }

          if (this.activeView === 3) {
            ForEach(['计算器','倒计时','快递查询'], (name: string, idx: number) => {
              Row() {
                Text(['🧮','⏰','📦'][idx]).fontSize(28); Text(name).fontSize(15).fontColor(this.theme().textPrimary).margin({ left: 12 })
                Blank(); Text('>').fontSize(16).fontColor(this.theme().textSecondary)
              }.width(W).padding(16).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ bottom: 8 })
              .onClick(() => { promptAction.showToast({ message: '功能开发中', duration: 1500 }) })
            })
          }
          Blank().height(80)
        }.width('100%').alignItems(HorizontalAlign.Center)
      }.width('100%').scrollBar(BarState.Off)
  }
}
}
