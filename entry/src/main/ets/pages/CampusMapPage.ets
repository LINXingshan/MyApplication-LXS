/**
 * CampusMapPage - 校园地图页
 * 支持双指缩放(PinchGesture) + 拖动(PanGesture)
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { CampusBuilding } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  ROUTE, TYPO_PAGE_TITLE, TYPO_B2, SPACING_SM, SPACING_MD } from '../utils/constants'

/**
 * CampusMapPage page
 */
@Entry
@Component
struct CampusMapPage {
  @State buildings: CampusBuilding[] = []
  @State searchKeyword: string = ''
  @State mapScale: number = 1
  @State mapOffsetX: number = 0
  @State mapOffsetY: number = 0
  @State prevScale: number = 1

  aboutToAppear(): void {
    this.loadBuildings()
  }

  async loadBuildings(): Promise<void> {
    this.buildings = await StorageManager.loadJsonFile<CampusBuilding>('buildings')
  }

  build() {
    Column() {
      Row() {
        Text('←')
          .fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => { router.back() })

        Text('校园地图')
          .fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)

        Blank().width(44)
      }
      .width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      // 地图区域（支持双指缩放 + 拖动）
      Stack() {
        Column()
          .width('100%').height(250).backgroundColor('#E8F4FD')
          .borderRadius(8).margin({ left: SPACING_MD, right: SPACING_MD, top: SPACING_MD })

        Text('🗺️ 校园平面图（占位）')
          .fontSize(24).fontColor(COLOR_TEXT_SECONDARY).opacity(0.5)

        ForEach(this.buildings, (b: CampusBuilding) => {
          Column() {
            Circle({ width: 8, height: 8 }).fill(COLOR_PRIMARY)
            Text(b.name).fontSize(18).fontColor(COLOR_TEXT_PRIMARY)
              .backgroundColor('#C8FFFFFF').borderRadius(4)
              .padding({ left: 4, right: 4, top: 2, bottom: 2 })
          }
          .position({ x: `${b.x}%`, y: `${b.y}%` })
          .onClick(() => {
            router.pushUrl({ url: ROUTE.BUILDING_DETAIL, params: { id: b.id } })
          })
        })
      }
      .width('100%')
      .height(300)
      .scale({ x: this.mapScale, y: this.mapScale })
      .translate({ x: this.mapOffsetX, y: this.mapOffsetY })
      .clip(true)
      .gesture(
        PinchGesture()
          .onActionStart(() => {
            this.prevScale = this.mapScale
          })
          .onActionUpdate((event: GestureEvent) => {
            this.mapScale = Math.max(0.5, Math.min(3, this.prevScale * event.scale))
          })
      )
      .gesture(
        PanGesture({ direction: PanDirection.All, distance: 10 })
          .onActionUpdate((event: GestureEvent) => {
            this.mapOffsetX += event.offsetX * 0.5
            this.mapOffsetY += event.offsetY * 0.5
          })
      )
      .animation({ duration: 200, curve: Curve.EaseOut })

      // 建筑列表
      List() {
        ForEach(this.buildings, (b: CampusBuilding) => {
          ListItem() {
            Row() {
              Text('🏢').fontSize(28)
              Column() {
                Text(b.name).fontSize(TYPO_B2.fontSize + 2).fontColor(COLOR_TEXT_PRIMARY)
                Text(b.functions.join(' | ')).fontSize(TYPO_B2.fontSize - 2).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start).layoutWeight(1).margin({ left: SPACING_SM })
            }
            .width('100%').padding(SPACING_SM)
            .onClick(() => { router.pushUrl({ url: ROUTE.BUILDING_DETAIL, params: { id: b.id } }) })
          }
          .backgroundColor(COLOR_CARD_BG).margin({ left: SPACING_MD, right: SPACING_MD, bottom: SPACING_SM }).borderRadius(8)
        })
      }
      .width('100%').layoutWeight(1).margin({ top: SPACING_MD })
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
