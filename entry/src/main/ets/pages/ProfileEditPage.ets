/**
 * ProfileEditPage - 个人信息编辑页
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { UserRepository } from '../data/repositories/UserRepository'
import { UserInfo } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_WHITE, COLOR_BORDER,
  SIZE_AVATAR, TYPO_PAGE_TITLE, TYPO_B1, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * ProfileEditPage page
 */
@Entry
@Component
struct ProfileEditPage {
  @State userInfo: UserInfo = {
    avatarPath: '', nickname: '', studentId: '', college: '', major: '', password: ''
  }

  aboutToAppear(): void {
    this.loadUserInfo()
  }

  async loadUserInfo(): Promise<void> {
    const info = await UserRepository.getUserInfo()
    if (info) {
      this.userInfo = info
    }
  }

  async saveProfile(): Promise<void> {
    await UserRepository.saveUserInfo(this.userInfo)
    promptAction.showToast({ message: '保存成功', duration: 1500 })
    setTimeout(() => { router.back() }, 500)
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => { router.back() })
        Text('编辑资料').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('保存')
          .fontSize(TYPO_B1.fontSize).fontColor(COLOR_PRIMARY).width(50)
          .onClick(() => { this.saveProfile() })
      }
      .width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      Scroll() {
        Column() {
          // 头像
          Column() {
            Stack() {
              Circle()
                .width(SIZE_AVATAR).height(SIZE_AVATAR).fill(COLOR_BG).stroke(COLOR_BORDER).strokeWidth(1)
              Text('\uD83D\uDCF7').fontSize(36).fontColor(COLOR_TEXT_SECONDARY)
            }
            .onClick(() => {
              promptAction.showToast({ message: '图片选择功能（模拟）', duration: 1500 })
            })

            Text('点击更换头像')
              .fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: SPACING_SM })
          }
          .width('100%').padding({ top: SPACING_LG, bottom: SPACING_MD })
          .alignItems(HorizontalAlign.Center)

          // 表单
          Column() {
            this.editRow('昵称', this.userInfo.nickname, (v: string) => { this.userInfo.nickname = v })
            Divider().color(COLOR_BORDER)
            this.editRow('学院', this.userInfo.college, (v: string) => { this.userInfo.college = v })
            Divider().color(COLOR_BORDER)
            this.editRow('专业', this.userInfo.major, (v: string) => { this.userInfo.major = v })
          }
          .width('95%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG)
          .padding(SPACING_MD).margin({ top: SPACING_MD })

          // 密码修改入口
          Button('修改密码')
            .width('95%').height(48).borderRadius(RADIUS_COMPONENT)
            .backgroundColor(COLOR_PRIMARY).fontSize(TYPO_B1.fontSize).fontColor(COLOR_WHITE)
            .margin({ top: SPACING_LG })
            .onClick(() => {
              promptAction.showToast({ message: '密码修改功能（示例）', duration: 1500 })
            })
        }
        .width('100%')
      }
      .width('100%').layoutWeight(1)
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder
  editRow(label: string, value: string, onChange: (v: string) => void) {
    Row() {
      Text(label).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(60)
      TextInput({ text: value, placeholder: `请输入${label}` })
        .layoutWeight(1).height(44).backgroundColor(Color.Transparent)
        .fontSize(TYPO_B2.fontSize).onChange(onChange)
    }
    .width('100%').padding({ top: 8, bottom: 8 })
  }
}
