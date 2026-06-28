/**
 * HomeTab - 首页（优化版）
 * 主题色使用 ThemeColors 集中管理，替换散落三目运算
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Announcement, Course, Todo, WeatherData, WeatherWrapper } from '../data/models/Index'
import { ROUTE } from '../utils/constants'
import { ThemeColors, ThemePalette } from '../utils/theme'

interface MenuEntry { name: string; emoji: string; color: string; bg: string }
const MENU: MenuEntry[] = [
  { name: '校园公告', emoji: '📢', color: '#1677FF', bg: '#E8F4FD' },
  { name: '课程表',   emoji: '📅', color: '#00B42A', bg: '#E8FFE8' },
  { name: '成绩查询', emoji: '📊', color: '#FF7D00', bg: '#FFF3E0' },
  { name: '失物招领', emoji: '🔍', color: '#722ED1', bg: '#F0E6FF' },
  { name: '校园地图', emoji: '🗺️', color: '#13C2C2', bg: '#E6FFFB' },
  { name: '图书馆',   emoji: '📚', color: '#EB2F96', bg: '#FFE6F0' },
  { name: '校园美食', emoji: '🍔', color: '#FA8C16', bg: '#FFF7E6' },
  { name: '音乐播放', emoji: '🎵', color: '#1677FF', bg: '#E8F4FD' },
  { name: '待办提醒', emoji: '✅', color: '#00B42A', bg: '#E8FFE8' },
  { name: '更多功能', emoji: '📌', color: '#86909C', bg: '#F5F7FA' },
  { name: '活动中心', emoji: '🎪', color: '#13C2C2', bg: '#FFF8E1' },
  { name: '后勤服务', emoji: '🔧', color: '#FA8C16', bg: '#FCE4EC' },
]

const W = '92%'

@Component
export struct HomeTab {
  @StorageLink('isDarkMode') isDarkMode: boolean = false
  @StorageLink('fontSize') fontSize: string = '中'
  @State todayCourses: Course[] = []
  @State announcements: Announcement[] = []
  @State weather: WeatherData | null = null
  @State todayTodos: Todo[] = []
  @State gridOrder: number[] = [0,1,2,3,4,5,6,7,8,9,10,11]
  @State isRefreshing: boolean = false

  aboutToAppear(): void { this.loadData() }

  /** 获取当前主题色板 */
  theme(): ThemePalette { return ThemeColors.get(this.isDarkMode) }

  async loadData(): Promise<void> {
    this.todayCourses = (await StorageManager.loadJsonFile<Course>('courses')).filter(c => {
      const d = new Date().getDay(); return c.dayOfWeek === (d === 0 ? 7 : d)
    })
    this.announcements = (await StorageManager.loadJsonFile<Announcement>('announcements')).slice(0, 3)
    const todos = await StorageManager.loadPref<Todo[]>('todos') || []
    const ts = new Date().toISOString().split('T')[0]
    this.todayTodos = todos.filter(t => !t.isCompleted && t.remindTime.startsWith(ts)).slice(0, 3)
    const wd = await StorageManager.loadJsonFile<WeatherWrapper>('weather')
    if (wd.length > 0) this.weather = wd[0].data
  }

  switchTab(index: number): void { AppStorage.setOrCreate('currentTabIndex', index) }

  getMenuItem(idx: number): MenuEntry { return MENU[idx] }

  handleMenuClick(idx: number): void {
    const real = this.gridOrder[idx]
    switch (real) {
      case 0: this.switchTab(1); break
      case 1: this.switchTab(2); break
      case 2: router.pushUrl({ url: ROUTE.MY_SCORES }); break
      case 3: AppStorage.setOrCreate('gotoLifeView', 0); this.switchTab(3); break
      case 4: router.pushUrl({ url: ROUTE.CAMPUS_MAP }); break
      case 5: AppStorage.setOrCreate('gotoLibrary', true); this.switchTab(2); break
      case 6: AppStorage.setOrCreate('gotoLifeView', 1); this.switchTab(3); break
      case 7: AppStorage.setOrCreate('gotoLifeView', 2); this.switchTab(3); break
      case 8: this.switchTab(4); break
      default: promptAction.showToast({ message: '功能开发中', duration: 1500 }); break
    }
  }

  isCurrent(c: Course): boolean {
    const n = new Date(); const t = `${String(n.getHours()).padStart(2,'0')}:${String(n.getMinutes()).padStart(2,'0')}`
    return t >= c.startTime && t <= c.endTime
  }

  async completeTodo(id: string): Promise<void> {
    const all = await StorageManager.loadPref<Todo[]>('todos') || []
    for (const t of all) { if (t.id === id) t.isCompleted = true }
    await StorageManager.savePref('todos', all)
    this.todayTodos = this.todayTodos.filter(t => t.id !== id)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column().width('100%').height('100%').backgroundColor(this.theme().bg)

      Refresh({ refreshing: $$this.isRefreshing }) {
        Scroll() {
          Column() {
            // 导航栏：随内容自然滚动消失
            Row() {
              Text('校园助手').fontSize(28).fontWeight(FontWeight.Bold)
                .fontColor(this.theme().textPrimary)
              Blank()
              Stack() {
                Text('🔔').fontSize(24)
                if (true) Circle({ width: 8, height: 8 }).fill(this.theme().warning).position({ x: -2, y: -2 })
              }.width(36).height(36)
              .onClick(() => { router.pushUrl({ url: ROUTE.MESSAGE_CENTER }) })
            }
            .width('100%').height(56)
            .padding({ left: 20, right: 20 })
            .backgroundColor(this.theme().bg)

            // 搜索框
            Row() {
              Text('🔍').fontSize(20).fontColor(this.theme().textSecondary).margin({ left: 16 })
              Text('搜索校园信息 / 课程 / 美食').fontSize(14).fontColor(this.theme().textSecondary)
            }
            .width('95%').height(44).backgroundColor(this.theme().cardBg).borderRadius(24)
            .alignSelf(ItemAlign.Center)
            .onClick(() => { router.pushUrl({ url: ROUTE.SEARCH_RESULT }) })
            .margin({ bottom: 16 })

            // Banner
            Swiper() {
              Column() {
                Text('🎓 期末备考指南').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
                Text('考试安排 · 复习资料 · 自习室').fontSize(12).fontColor('rgba(255,255,255,0.85)').margin({ top: 6 })
              }.width(W).height(130).justifyContent(FlexAlign.Center).borderRadius(16).backgroundColor(this.theme().primary)
              Column() {
                Text('📝 暑期留校申请开启').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
                Text('申请截止7月5日 · 详情见通知').fontSize(12).fontColor('rgba(255,255,255,0.85)').margin({ top: 6 })
              }.width(W).height(130).justifyContent(FlexAlign.Center).borderRadius(16).backgroundColor('#269FB4')
            }
            .autoPlay(true).interval(3000).width('100%').height(150)
            .indicator(new DotIndicator().color('#E5E6EB').selectedColor(this.theme().primary))
            .margin({ bottom: 20 })

            // 功能入口 3列×4行
            Grid() {
              ForEach(this.gridOrder, (realIdx: number, dispIdx: number) => {
                GridItem() {
                  Column() {
                    Circle({ width: 64, height: 64 }).fill(this.getMenuItem(realIdx).bg)
                      .stroke(this.getMenuItem(realIdx).color).strokeWidth(1.5)
                    Stack() {
                      Circle({ width: 64, height: 64 }).fill(Color.Transparent)
                      Text(this.getMenuItem(realIdx).emoji).fontSize(30)
                    }.width(64).height(64).position({ x: 0, y: 0 })
                    Text(this.getMenuItem(realIdx).name)
                      .fontSize(20).fontColor(this.theme().textPrimary).margin({ top: 6 }).maxLines(1)
                  }.width('100%').justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
                  .height(116).onClick(() => { this.handleMenuClick(dispIdx) })
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr').columnsGap(8).rowsGap(8).width('95%').alignSelf(ItemAlign.Center)

            // 公告
            if (this.announcements.length > 0) {
              Row() {
                Text('📢 校园公告').fontSize(18).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary)
                Blank(); Text('更多 >').fontSize(14).fontColor(this.theme().primary).onClick(() => { this.switchTab(1) })
              }.width(W).margin({ top: 20, bottom: 12 })
              ForEach(this.announcements, (item: Announcement) => {
                Column() {
                  Text(item.title).fontSize(16).fontWeight(FontWeight.Medium).fontColor(this.theme().textPrimary)
                    .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
                  Text(`${item.publishDate} · ${item.source}`).fontSize(12).fontColor(this.theme().textSecondary).margin({ top: 4 })
                }.width('100%').padding(16).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ bottom: 8 })
                .onClick(() => { const p: Record<string, string> = { 'id': item.id }; router.pushUrl({ url: ROUTE.ANNOUNCEMENT_DETAIL, params: p }) })
              })
            }

            // 今日课程
            Row() {
              Text('📋 今日课程').fontSize(18).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary)
              Blank(); Text('查看全部 >').fontSize(14).fontColor(this.theme().primary).onClick(() => { this.switchTab(2) })
            }.width(W).margin({ top: 20, bottom: 12 })
            if (this.todayCourses.length === 0) {
              Text('今日无课程，好好休息吧～').fontSize(14).fontColor(this.theme().textSecondary).width(W).padding(16)
            } else {
              ForEach(this.todayCourses, (c: Course) => {
                Row() {
                  Column() { Text(c.startTime).fontSize(16).fontWeight(FontWeight.Bold).fontColor(this.theme().primary) }
                    .width(56).height(56).borderRadius(12).backgroundColor(this.theme().primaryLight).justifyContent(FlexAlign.Center)
                  Column() {
                    Text(c.name).fontSize(15).fontWeight(FontWeight.Medium).fontColor(this.theme().textPrimary)
                    Text(`${c.teacher || '未知'} · ${c.location}`).fontSize(12).fontColor(this.theme().textSecondary).margin({ top: 4 })
                  }.alignItems(HorizontalAlign.Start).margin({ left: 12 }).layoutWeight(1)
                }.width(W).padding(14).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ bottom: 8 })
              })
            }

            // 待办
            if (this.todayTodos.length > 0) {
              Row() {
                Text('✅ 待办提醒').fontSize(18).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary)
                Blank(); Text('更多 >').fontSize(14).fontColor(this.theme().primary).onClick(() => { this.switchTab(4) })
              }.width(W).margin({ top: 20, bottom: 12 })
              ForEach(this.todayTodos, (todo: Todo) => {
                Row() {
                  Checkbox({ name: todo.id }).selectedColor(this.theme().primary)
                    .onChange((c: boolean) => { if (c) this.completeTodo(todo.id) })
                  Text(todo.content).fontSize(14).fontColor(this.theme().textPrimary).margin({ left: 8 }).maxLines(1)
                  Blank(); Text(todo.remindTime.split(' ')[1] || '').fontSize(12).fontColor(this.theme().textSecondary)
                }.width(W).padding(14).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ bottom: 8 })
              })
            }

            // 天气
            if (this.weather) {
              Row() {
                Text('☀️').fontSize(40)
                Column() {
                  Text(`${this.weather.current.temperature}℃`).fontSize(24).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary)
                  Text(this.weather.current.condition).fontSize(13).fontColor(this.theme().textSecondary)
                }.margin({ left: 12 })
                Blank()
                Column() {
                  Text(this.weather.current.city).fontSize(14).fontColor(this.theme().textPrimary)
                  Text(this.weather.current.wind).fontSize(12).fontColor(this.theme().textSecondary).margin({ top: 2 })
                }.alignItems(HorizontalAlign.End)
              }.width(W).padding(16).backgroundColor(this.theme().cardBg).borderRadius(8).margin({ top: 20, bottom: 16 })
              .onClick(() => {
                const w = this.weather!
                let s = ''; for (const f of w.forecast) s += `${f.date}: ${f.condition} ${f.temperature}℃\n`
                AlertDialog.show({ title: '未来三天天气', message: s, confirm: { value: '知道了', fontColor: this.theme().primary, action: () => {} } })
              })
            }

            Blank().height(80)
          }.width('100%').alignItems(HorizontalAlign.Center).backgroundColor(this.theme().bg)
        }.width('100%').scrollBar(BarState.Off)
      }
      .onRefreshing(() => { this.isRefreshing = true; setTimeout(() => { this.loadData(); this.isRefreshing = false }, 1000) })
      .width('100%').height('100%').backgroundColor(this.theme().bg)
    }
  }
}
