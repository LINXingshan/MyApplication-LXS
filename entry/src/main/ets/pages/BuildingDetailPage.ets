/**
 * BuildingDetailPage - 建筑详情页
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { CampusBuilding } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER,
  TYPO_PAGE_TITLE, TYPO_H2, TYPO_H3, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * BuildingDetailPage page
 */
@Entry
@Component
struct BuildingDetailPage {
  @State building: CampusBuilding | null = null
  private itemId: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params && params['id']) {
      this.itemId = params['id']
      this.loadBuilding()
    }
  }

  async loadBuilding(): Promise<void> {
    const blds = await StorageManager.loadJsonFile<CampusBuilding>('buildings')
    this.building = blds.find(b => b.id === this.itemId) || null
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => { router.back() })
        Text('建筑详情').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }
      .width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.building) {
        Column() {
          // 建筑图标
          Column() {
            Text('\uD83C\uDFE2').fontSize(64)
            Text(this.building.name)
              .fontSize(TYPO_H2.fontSize).fontWeight(FontWeight.Bold)
              .fontColor(COLOR_TEXT_PRIMARY).margin({ top: SPACING_SM })
          }
          .width('100%').padding({ top: SPACING_LG, bottom: SPACING_LG })
          .backgroundColor('#E8F4FD')

          // 信息卡片
          Column() {
            // 介绍
            Text('建筑介绍')
              .fontSize(TYPO_H3.fontSize).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT_PRIMARY)
            Text(this.building.description)
              .fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_SECONDARY)
              .margin({ top: SPACING_SM }).lineHeight(TYPO_B1.lineHeight * 1.5)

            Divider().color(COLOR_BORDER).margin({ top: SPACING_MD, bottom: SPACING_MD })

            // 功能
            Text('功能设施')
              .fontSize(TYPO_H3.fontSize).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT_PRIMARY)

            Row({ space: 8 }) {
              ForEach(this.building.functions, (func: string) => {
                Text(func)
                  .fontSize(TYPO_B2.fontSize).fontColor(COLOR_PRIMARY)
                  .backgroundColor('#141677FF').borderRadius(8)
                  .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              })
            }
            .width('100%').margin({ top: SPACING_SM })

            Divider().color(COLOR_BORDER).margin({ top: SPACING_MD, bottom: SPACING_MD })

            // 地图坐标
            Text('位置坐标')
              .fontSize(TYPO_H3.fontSize).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT_PRIMARY)
            Text(`X: ${this.building.x}%  Y: ${this.building.y}%`)
              .fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_SM })
          }
          .width('90%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG)
          .padding(SPACING_MD).margin({ top: SPACING_MD })
        }
        .width('100%').layoutWeight(1)
      }
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
