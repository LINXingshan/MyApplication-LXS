/**
 * CourseDetailPage - 课程详情页
 */

import { router } from '@kit.ArkUI'
import { Course } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER, COLOR_WHITE,
  TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

const WEEK_NAMES = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日']

/**
 * CourseDetailPage page
 */
@Entry
@Component
struct CourseDetailPage {
  @State course: Course | null = null
  @State weekStr: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>
    if (params && params['course']) {
      this.course = params['course'] as Course
      if (this.course) {
        this.weekStr = this.course.weeks.map(w => `第${w}周`).join(', ')
      }
    }
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => { router.back() })
        Text('课程详情').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }
      .width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      if (this.course) {
        Column() {
          Column() {
            Text(this.course.name)
              .fontSize(TYPO_H3.fontSize + 4).fontWeight(FontWeight.Bold).fontColor(COLOR_WHITE)
            Text(WEEK_NAMES[this.course.dayOfWeek])
              .fontSize(TYPO_B2.fontSize).fontColor(COLOR_WHITE).opacity(0.8).margin({ top: 8 })
          }
          .width('90%').borderRadius(12)
          .backgroundColor(this.course.colorTag || COLOR_PRIMARY)
          .padding({ top: 24, bottom: 24 }).margin({ top: SPACING_MD })

          Column() {
            this.detailRow('授课教师', this.course.teacher)
            Divider().color(COLOR_BORDER)
            this.detailRow('上课时间', `${this.course.startTime} - ${this.course.endTime}`)
            Divider().color(COLOR_BORDER)
            this.detailRow('上课地点', this.course.location)
            Divider().color(COLOR_BORDER)
            this.detailRow('学分', `${this.course.credits} 学分`)
            Divider().color(COLOR_BORDER)
            this.detailRow('学期', this.course.term)
            Divider().color(COLOR_BORDER)
            this.detailRow('上课周次', this.weekStr)
          }
          .width('90%').borderRadius(8).backgroundColor(COLOR_CARD_BG)
          .padding(SPACING_MD).margin({ top: SPACING_MD })
        }
        .width('100%').layoutWeight(1)
      }
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
  }

  @Builder
  detailRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
      Text(value).fontSize(TYPO_B1.fontSize).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1)
    }
    .width('100%').padding({ top: SPACING_SM, bottom: SPACING_SM })
  }
}
