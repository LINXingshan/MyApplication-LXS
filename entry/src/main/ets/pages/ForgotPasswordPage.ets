/**
 * ForgotPasswordPage - 找回密码页
 * 学号 + 验证码 + 新密码
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import {
  ROUTE, COLOR_PRIMARY, COLOR_PRIMARY_LIGHT, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY,
  COLOR_TEXT_SECONDARY, COLOR_BORDER, COLOR_WHITE, TYPO_PAGE_TITLE, TYPO_B1, TYPO_B2,
  SIZE_BTN_PRIMARY_H, SIZE_INPUT_H, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG
} from '../utils/constants'

/**
 * ForgotPasswordPage page
 */
@Entry
@Component
struct ForgotPasswordPage {
  @State studentId: string = ''
  @State verifyCode: string = ''
  @State newPassword: string = ''

  get isActive(): boolean {
    return this.studentId.trim() !== '' && this.verifyCode.trim() !== '' && this.newPassword.trim().length >= 6
  }

  handleSubmit(): void {
    if (!/^\d+$/.test(this.studentId.trim())) {
      promptAction.showToast({ message: '学号必须为纯数字', duration: 2000 })
      return
    }
    if (this.newPassword.trim().length < 6) {
      promptAction.showToast({ message: '密码长度不能少于6位', duration: 2000 })
      return
    }
    promptAction.showToast({ message: '密码重置成功（模拟）', duration: 1500 })
    setTimeout(() => {
      router.back()
    }, 500)
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

        Text('找回密码')
          .fontSize(TYPO_PAGE_TITLE.fontSize)
          .fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(44)
      }
      .width('100%')
      .height(56)
      .backgroundColor(COLOR_CARD_BG)
      .padding({ left: SPACING_SM, right: SPACING_SM })

      Blank().height(SPACING_LG)

      Column() {
        // 学号
        Row() {
          Text('\uD83C\uDF93')
            .fontSize(20)
            .fontColor(COLOR_PRIMARY)
            .width(36)
          TextInput({ placeholder: '请输入学号', text: this.studentId })
            .layoutWeight(1)
            .height(SIZE_INPUT_H)
            .fontSize(TYPO_B1.fontSize)
            .onChange((v: string) => { this.studentId = v })
        }
        .width('100%')
        .height(SIZE_INPUT_H)
        .borderRadius(RADIUS_COMPONENT)
        .backgroundColor(COLOR_CARD_BG)
        .border({ width: 1, color: COLOR_BORDER })
        .padding({ left: SPACING_SM, right: SPACING_SM })

        Blank().height(SPACING_SM)

        // 验证码
        Row() {
          Text('\uD83D\uDCDD')
            .fontSize(20)
            .fontColor(COLOR_PRIMARY)
            .width(36)
          TextInput({ placeholder: '请输入验证码', text: this.verifyCode })
            .layoutWeight(1)
            .height(SIZE_INPUT_H)
            .fontSize(TYPO_B1.fontSize)
            .onChange((v: string) => { this.verifyCode = v })
        }
        .width('100%')
        .height(SIZE_INPUT_H)
        .borderRadius(RADIUS_COMPONENT)
        .backgroundColor(COLOR_CARD_BG)
        .border({ width: 1, color: COLOR_BORDER })
        .padding({ left: SPACING_SM, right: SPACING_SM })

        Blank().height(SPACING_SM)

        // 新密码
        Row() {
          Text('\uD83D\uDD12')
            .fontSize(20)
            .fontColor(COLOR_PRIMARY)
            .width(36)
          TextInput({ placeholder: '请输入新密码（至少6位）', text: this.newPassword })
            .layoutWeight(1)
            .height(SIZE_INPUT_H)
            .fontSize(TYPO_B1.fontSize)
            .type(InputType.Password)
            .onChange((v: string) => { this.newPassword = v })
        }
        .width('100%')
        .height(SIZE_INPUT_H)
        .borderRadius(RADIUS_COMPONENT)
        .backgroundColor(COLOR_CARD_BG)
        .border({ width: 1, color: COLOR_BORDER })
        .padding({ left: SPACING_SM, right: SPACING_SM })

        Blank().height(SPACING_LG)

        // 确认按钮
        Button('确认重置')
          .width('100%')
          .height(SIZE_BTN_PRIMARY_H)
          .borderRadius(RADIUS_COMPONENT)
          .fontSize(TYPO_B1.fontSize)
          .backgroundColor(this.isActive ? COLOR_PRIMARY : COLOR_PRIMARY_LIGHT)
          .fontColor(this.isActive ? COLOR_WHITE : COLOR_TEXT_SECONDARY)
          .onClick(() => {
            if (this.isActive) {
              this.handleSubmit()
            }
          })
      }
      .width('100%')
      .padding({ left: SPACING_MD, right: SPACING_MD })

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_BG)
  }
}
