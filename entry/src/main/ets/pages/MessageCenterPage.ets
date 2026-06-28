/**
 * MessageCenterPage - 消息中心
 * 简易消息列表页，展示模拟系统通知
 */

import { router } from '@kit.ArkUI'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  COLOR_BORDER, TYPO_PAGE_TITLE, TYPO_H3, TYPO_B2, RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

interface MessageItem {
  id: string
  title: string
  content: string
  time: string
  isRead: boolean
}

/**
 * MessageCenterPage page
 */
@Entry
@Component
struct MessageCenterPage {
  @State messages: MessageItem[] = [
    { id: '1', title: '系统通知', content: '期末考试安排已发布，请查看校园公告', time: '2026-06-20', isRead: false },
    { id: '2', title: '课程提醒', content: '明天上午8:00高等数学在教A201上课', time: '2026-06-19', isRead: false },
    { id: '3', title: '系统通知', content: '图书馆暑期开放时间已调整', time: '2026-06-18', isRead: true },
    { id: '4', title: '活动通知', content: '校园音乐节将于6月28日举行', time: '2026-06-15', isRead: true },
    { id: '5', title: '待办提醒', content: '记得完成高等数学第七章作业', time: '2026-06-14', isRead: true }
  ]

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

        Text('消息中心')
          .fontSize(TYPO_PAGE_TITLE.fontSize)
          .fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('全部已读')
          .fontSize(TYPO_B2.fontSize)
          .fontColor(COLOR_PRIMARY)
          .width(70)
          .onClick(() => {
            for (const m of this.messages) {
              m.isRead = true
            }
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor(COLOR_CARD_BG)
      .padding({ left: SPACING_SM, right: SPACING_SM })

      // 消息列表
      List() {
        ForEach(this.messages, (item: MessageItem) => {
          ListItem() {
            Row() {
              // 未读标记
              Column() {
                if (!item.isRead) {
                  Circle({ width: 8, height: 8 })
                    .fill(COLOR_PRIMARY)
                } else {
                  Blank().width(8)
                }
              }
              .width(16)
              .alignItems(HorizontalAlign.Center)

              Column() {
                Text(item.title)
                  .fontSize(TYPO_H3.fontSize)
                  .fontColor(item.isRead ? COLOR_TEXT_PRIMARY : COLOR_TEXT_PRIMARY)
                  .fontWeight(item.isRead ? FontWeight.Normal : FontWeight.Medium)

                Text(item.content)
                  .fontSize(TYPO_B2.fontSize)
                  .fontColor(COLOR_TEXT_SECONDARY)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 4 })

                Text(item.time)
                  .fontSize(20)
                  .fontColor(COLOR_TEXT_SECONDARY)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')
            .padding({ left: SPACING_MD, right: SPACING_MD, top: SPACING_SM, bottom: SPACING_SM })
          }
          .backgroundColor(COLOR_CARD_BG)
          .margin({ bottom: 1 })
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(COLOR_BG)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_BG)
  }
}
