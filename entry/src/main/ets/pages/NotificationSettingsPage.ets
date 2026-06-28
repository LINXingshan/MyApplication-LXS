/**
 * NotificationSettingsPage - 通知设置页
 */

import { router } from '@kit.ArkUI'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER,
  TYPO_PAGE_TITLE, TYPO_B1, SPACING_SM, SPACING_MD }
  from '../utils/constants'

/**
 * NotificationSettingsPage page
 */
@Entry
@Component
struct NotificationSettingsPage {
  @State courseReminder: boolean = true
  @State announcementReminder: boolean = true
  @State todoReminder: boolean = true

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('通知设置').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      Column() {
        Row() {
          Text('课程提醒').fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.courseReminder }).selectedColor(COLOR_PRIMARY)
            .onChange((v: boolean) => { this.courseReminder = v })
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })

        Divider().color(COLOR_BORDER)

        Row() {
          Text('公告提醒').fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.announcementReminder }).selectedColor(COLOR_PRIMARY)
            .onChange((v: boolean) => { this.announcementReminder = v })
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })

        Divider().color(COLOR_BORDER)

        Row() {
          Text('待办提醒').fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.todoReminder }).selectedColor(COLOR_PRIMARY)
            .onChange((v: boolean) => { this.todoReminder = v })
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })
      }
      .width('95%').borderRadius(8).backgroundColor(COLOR_CARD_BG).alignSelf(ItemAlign.Center)
      .margin({ top: SPACING_MD })
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
