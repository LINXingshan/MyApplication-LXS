/**
 * FoodDetailPage - 美食详情页
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { FoodItem, FavoriteItem } from '../data/models/Index'
import { StarRating } from '../components/StarRating'
import {
  COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_WHITE, COLOR_BORDER,
  TYPO_PAGE_TITLE, TYPO_H2, TYPO_H3, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG, SPACING_XL
} from '../utils/constants'

/**
 * FoodDetailPage page
 */
@Entry
@Component
struct FoodDetailPage {
  @State food: FoodItem | null = null
  @State isFavorited: boolean = false
  private itemId: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params && params['id']) { this.itemId = params['id']; this.load() }
  }

  async load(): Promise<void> {
    const foods = await StorageManager.loadJsonFile<FoodItem>('food_items')
    this.food = foods.find(f => f.id === this.itemId) || null
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    this.isFavorited = favs.some(f => f.sourceId === this.itemId && f.type === 'food')
  }

  async toggleFavorite(): Promise<void> {
    if (!this.food) return
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    if (this.isFavorited) {
      await StorageManager.saveJsonFile('favorites', favs.filter(f => f.sourceId !== this.itemId || f.type !== 'food'))
      this.isFavorited = false
    } else {
      favs.push({ id: `fav_${Date.now()}`, type: 'food', title: this.food.name, summary: this.food.canteen, imagePath: '', sourceId: this.itemId, createdAt: new Date().toISOString().split('T')[0] })
      await StorageManager.saveJsonFile('favorites', favs)
      this.isFavorited = true
    }
  }

  async updateRating(rating: number): Promise<void> {
    if (!this.food) return
    this.food.rating = rating
    const foods = await StorageManager.loadJsonFile<FoodItem>('food_items')
    const idx = foods.findIndex(f => f.id === this.itemId)
    if (idx >= 0) foods[idx] = this.food
    await StorageManager.saveJsonFile('food_items', foods)
    promptAction.showToast({ message: `评分 ${rating} 分`, duration: 1000 })
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44).textAlign(TextAlign.Center).onClick(() => router.back())
        Text('美食详情').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.food) {
        Scroll() {
          Column() {
            Column() {
              Text('\uD83C\uDF54').fontSize(80)
              Text(this.food.name).fontSize(TYPO_H2.fontSize).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).margin({ top: SPACING_MD })
              Text(this.food.canteen).fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_SM })
            }
            .width('100%').padding({ top: SPACING_XL, bottom: SPACING_XL }).backgroundColor('#FFF7E6').alignItems(HorizontalAlign.Center)

            Column() {
              this.infoRow('位置', this.food.location)
              Divider().color(COLOR_BORDER)

              // 评分（可编辑）
              Row() {
                Text('评分').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(60)
                StarRating({ rating: this.food.rating, starSize: 28, editable: true, onChange: (rating: number) => { this.updateRating(rating) } })
              }.width('100%').padding({ top: 8, bottom: 8 })

              Divider().color(COLOR_BORDER)

              // 特色菜品
              Row() {
                Text('特色菜').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(60)
                Text(this.food.specialDishes.join('、')).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1)
              }.width('100%').padding({ top: 8, bottom: 8 })
            }
            .width('90%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG).padding(SPACING_MD).margin({ top: SPACING_MD })

            Row({ space: 16 }) {
              Button(this.isFavorited ? '\u2764\uFE0F 已收藏' : '\u2661 收藏')
                .width('45%').height(48).borderRadius(RADIUS_COMPONENT)
                .backgroundColor(this.isFavorited ? '#FFE5E5' : COLOR_BG).fontColor(this.isFavorited ? '#FF4D4F' : COLOR_TEXT_PRIMARY)
                .fontSize(TYPO_B1.fontSize).onClick(() => { this.toggleFavorite() })

              Button('\uD83D\uDCF7 上传图片')
                .width('45%').height(48).borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_PRIMARY).fontColor(COLOR_WHITE)
                .fontSize(TYPO_B1.fontSize)
                .onClick(() => { promptAction.showToast({ message: '图片上传功能（模拟）', duration: 1500 }) })
            }
            .width('90%').justifyContent(FlexAlign.SpaceEvenly).margin({ top: SPACING_MD, bottom: SPACING_LG })
          }
          .width('100%')
        }
        .width('100%').layoutWeight(1)
      }
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder infoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(60)
      Text(value).fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1)
    }.width('100%').padding({ top: 8, bottom: 8 })
  }
}
