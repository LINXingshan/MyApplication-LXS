/**
 * AvatarUpload - 头像上传组件
 * 圆形头像显示 + 点击弹出ActionSheet选择方式
 * 使用 photoAccessHelper 访问相册（降级为模拟选择）
 */

import { promptAction } from '@kit.ArkUI'
import { COLOR_BG, COLOR_BORDER, COLOR_TEXT_SECONDARY, COLOR_PRIMARY, SIZE_AVATAR,
  TYPO_B2, TYPO_B3, SPACING_SM, RADIUS_COMPONENT } from '../utils/constants'

/**
 * @Component - AvatarUpload
 */
@Component
export struct AvatarUpload {
  @Link imagePath: string
  @Prop size: number = SIZE_AVATAR

  build() {
    Column() {
      Stack() {
        // 头像圆圈
        Circle()
          .width(this.size)
          .height(this.size)
          .fill(COLOR_BG)
          .stroke(COLOR_BORDER)
          .strokeWidth(1)

        // 显示头像或默认图标
        if (this.imagePath && this.imagePath !== '') {
          Image(this.imagePath)
            .width(this.size)
            .height(this.size)
            .borderRadius(this.size / 2)
            .onError(() => {
              // 图片加载失败显示默认图标
              this.imagePath = ''
            })
        } else {
          Column() {
            Text('👤')
              .fontSize(this.size * 0.5)
              .fontColor(COLOR_TEXT_SECONDARY)
          }
          .width(this.size)
          .height(this.size)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }

        // 底部小相机图标
        Column()
          .width(this.size * 0.32)
          .height(this.size * 0.32)
          .borderRadius(this.size * 0.16)
          .backgroundColor(COLOR_PRIMARY)
          .position({ x: this.size * 0.7, y: this.size * 0.7 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center) {
          Text('📷')
            .fontSize(this.size * 0.16)
            .fontColor(COLOR_WHITE)
        }
      }
      .width(this.size)
      .height(this.size)
      .onClick(() => {
        this.showAvatarActions()
      })

      Text('点击更换头像')
        .fontSize(TYPO_B3.fontSize)
        .fontColor(COLOR_TEXT_SECONDARY)
        .margin({ top: SPACING_SM })
    }
    .alignItems(HorizontalAlign.Center)
  }

  showAvatarActions(): void {
    promptAction.showToast({ message: '头像选择功能（模拟）', duration: 2000 })
  }
}
