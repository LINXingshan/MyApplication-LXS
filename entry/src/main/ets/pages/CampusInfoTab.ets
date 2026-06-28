/**
 * CampusInfoTab - 校园信息 Tab
 * 分类标签栏 + 内容列表 + 校园地图视图
 */

import { router } from '@kit.ArkUI'
import { TagBar } from '../components/TagBar'
import { StorageManager } from '../utils/storage'
import { Announcement, CampusBuilding } from '../data/models/Index'
import {
  ROUTE, TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2, SIZE_THUMB_SM, RADIUS_COMPONENT,
  RADIUS_SEARCH, SPACING_SM, SPACING_MD, SPACING_LG
} from '../utils/constants'
import { ThemeColors, ThemePalette } from '../utils/theme'

@Component
export struct CampusInfoTab {
  @StorageLink('isDarkMode') isDarkMode: boolean = false
  @State selectedTag: number = 0

  theme(): ThemePalette { return ThemeColors.get(this.isDarkMode) }
  @State announcements: Announcement[] = []
  @State buildings: CampusBuilding[] = []
  @State newsList: Announcement[] = []
  @State isLoading: boolean = false
  @State mapScale: number = 1
  @State mapOffsetX: number = 0
  @State mapOffsetY: number = 0
  @State searchKeyword: string = ''

  private tags: string[] = ['校园公告', '校园资讯', '社团活动', '学术讲座', '校园地图']

  aboutToAppear(): void {
    this.loadData()
  }

  async loadData(): Promise<void> {
    this.isLoading = true
    const anns = await StorageManager.loadJsonFile<Announcement>('announcements')
    this.announcements = anns
    // 资讯列表复用公告数据，按category筛选
    this.newsList = anns.filter(a => a.category === 'school' || a.category === 'college')

    const blds = await StorageManager.loadJsonFile<CampusBuilding>('buildings')
    this.buildings = blds
    this.isLoading = false
  }

  getCategoryAnnouncements(category: string): Announcement[] {
    if (category === '校园公告') return this.announcements.filter(a => a.category === 'school')
    if (category === '校园资讯') return this.newsList
    if (category === '社团活动') return this.announcements.filter(a => a.category === 'club')
    if (category === '学术讲座') return this.announcements.filter(a => a.category === 'college')
    return []
  }

  @Builder
  AnnouncementListItem(item: Announcement) {
    Row() {
      // 缩略图
      Column() {
        Text('\uD83D\uDCC4')
          .fontSize(32)
          .fontColor(this.theme().textSecondary)
      }
      .width(SIZE_THUMB_SM)
      .height(SIZE_THUMB_SM)
      .borderRadius(RADIUS_COMPONENT)
      .backgroundColor(this.theme().bg)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text(item.title)
          .fontSize(TYPO_H3.fontSize)
          .fontColor(this.theme().textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(`${item.publishDate}  ${item.source}`)
          .fontSize(TYPO_B2.fontSize)
          .fontColor(this.theme().textSecondary)
          .margin({ top: 4 })

        Text(item.summary)
          .fontSize(TYPO_B2.fontSize)
          .fontColor(this.theme().textSecondary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: SPACING_SM })
    }
    .width('100%')
    .padding(SPACING_SM)
    .backgroundColor(this.theme().cardBg)
    .borderRadius(RADIUS_COMPONENT)
    .onClick(() => {
      router.pushUrl({ url: ROUTE.ANNOUNCEMENT_DETAIL, params: { id: item.id } })
    })
  }

  @Builder
  CampusMapView() {
    Column() {
      // 地图区域
      Stack() {
        // 背景（占位，实际应使用地图图片）
        Column()
          .width('100%')
          .height(200)
          .backgroundColor('#E8F4FD')
          .borderRadius(RADIUS_COMPONENT)

        Text('\uD83D\uDDFA\uFE0F')
          .fontSize(80)
          .opacity(0.3)

        // 建筑标注点
        ForEach(this.buildings, (building: CampusBuilding) => {
          Column() {
            Circle({ width: 8, height: 8 })
              .fill(this.theme().primary)

            Text(building.name)
              .fontSize(20)
              .fontColor(this.theme().textPrimary)
              .backgroundColor('#C8FFFFFF')
              .borderRadius(4)
              .padding({ left: 4, right: 4, top: 2, bottom: 2 })
          }
          .position({ x: `${building.x}%`, y: `${building.y}%` })
          .onClick(() => {
            AlertDialog.show({
              title: building.name,
              message: `${building.description}\n\n功能：${building.functions.join('、')}`,
              confirm: {
                value: '查看详情',
                fontColor: this.theme().primary,
                action: () => {
                  router.pushUrl({ url: ROUTE.BUILDING_DETAIL, params: { id: building.id } })
                }
              },
              cancel: () => {}
            })
          })
        })
      }
      .width('95%')
      .height(200)
      .alignSelf(ItemAlign.Center)
      .clip(true)

      // 搜索框
      Row() {
        Text('\uD83D\uDD0D')
          .fontSize(24)
          .fontColor(this.theme().primary)
          .margin({ left: 16 })

        TextInput({ placeholder: '搜索建筑', text: this.searchKeyword })
          .layoutWeight(1)
          .height(40)
          .fontSize(TYPO_B2.fontSize)
          .onChange((v: string) => { this.searchKeyword = v })
      }
      .width('95%')
      .height(40)
      .borderRadius(RADIUS_SEARCH)
      .backgroundColor(this.theme().cardBg)
      .alignSelf(ItemAlign.Center)
      .margin({ top: SPACING_SM, bottom: SPACING_SM })

      // 建筑快捷入口
      Scroll() {
        Row({ space: 8 }) {
          ForEach(this.buildings.filter(b =>
            this.searchKeyword === '' || b.name.includes(this.searchKeyword)
          ), (building: CampusBuilding) => {
            Column() {
              Text(building.name.substring(0, 2))
                .fontSize(TYPO_B2.fontSize)
                .fontColor(this.theme().primary)
                .backgroundColor(this.theme().bg)
                .borderRadius(RADIUS_COMPONENT)
                .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            }
            .onClick(() => {
              router.pushUrl({ url: ROUTE.BUILDING_DETAIL, params: { id: building.id } })
            })
          })
        }
        .padding({ left: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
    }
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Text('校园信息')
          .fontSize(TYPO_PAGE_TITLE.fontSize)
          .fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(this.theme().textPrimary)
      }
      .width('100%')
      .height(56)
      .backgroundColor(this.theme().cardBg)
      .padding({ left: SPACING_MD })

      // 标签栏
      TagBar({ tags: this.tags, selectedIndex: $selectedTag })

      // 内容区
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(36).height(36).color(this.theme().primary)
          Text('加载中...').fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary).margin({ top: SPACING_SM })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.selectedTag === 4) {
        // 校园地图视图
        Column() {
          this.CampusMapView()
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ top: SPACING_SM })
      } else {
        // 列表视图
        List() {
          ForEach(this.getCategoryAnnouncements(this.tags[this.selectedTag]),
            (item: Announcement) => {
              ListItem() {
                this.AnnouncementListItem(item)
              }
              .padding({ left: SPACING_MD, right: SPACING_MD, bottom: SPACING_SM })
            })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
  }
}
