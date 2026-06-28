/**
 * CourseTable - 课程表组件
 * 周一至周日7列纵向排列，支持周次切换
 */

import { Course } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_CARD_BG, COLOR_WARNING, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER,
  TYPO_B2, RADIUS_COMPONENT, SPACING_SM } from '../utils/constants'

const WEEK_NAMES = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

/**
 * @Component - CourseTable
 */
@Component
export struct CourseTable {
  @Prop weekNumber: number = 7
  @Link courses: Course[]
  onCourseClick?: (course: Course) => void

  /** 获取指定日期的课程列表 */
  getDayCourses(day: number): Course[] {
    return this.courses
      .filter(c => c.dayOfWeek === day && c.weeks.includes(this.weekNumber))
      .sort((a, b) => a.startTime.localeCompare(b.startTime))
  }

  /** 判断课程是否正在进行 */
  isCurrentCourse(course: Course): boolean {
    const now = new Date()
    const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
    const today = now.getDay() || 7
    return course.dayOfWeek === today && currentTime >= course.startTime && currentTime <= course.endTime
  }

  build() {
    Column() {
      ForEach(WEEK_NAMES, (dayName: string, dayIndex: number) => {
        this.DayColumn(dayName, dayIndex)
      })
    }
    .width('100%')
  }

  @Builder DayColumn(dayName: string, dayIndex: number) {
    Column() {
      // 日期标题
      Text(dayName)
        .fontSize(TYPO_B2.fontSize)
        .fontColor(COLOR_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ top: SPACING_SM, bottom: 8, left: SPACING_SM })

      // 课程列表
      Column() {
        if (this.getDayCourses(dayIndex + 1).length === 0) {
          Text('无课程')
            .fontSize(TYPO_B2.fontSize)
            .fontColor(COLOR_TEXT_SECONDARY)
            .padding({ left: SPACING_SM, top: 16, bottom: 16 })
            .width('100%')
            .textAlign(TextAlign.Center)
        } else {
          ForEach(this.getDayCourses(dayIndex + 1), (course: Course) => {
            Row() {
              // 左侧色条
              Column()
                .width(4)
                .height(48)
                .borderRadius(2)
                .backgroundColor(course.colorTag || COLOR_PRIMARY)

              Column() {
                Text(course.name)
                  .fontSize(TYPO_B2.fontSize)
                  .fontColor(COLOR_TEXT_PRIMARY)
                  .fontWeight(FontWeight.Medium)

                Text(`${course.startTime}-${course.endTime}`)
                  .fontSize(TYPO_B2.fontSize - 2)
                  .fontColor(COLOR_TEXT_SECONDARY)
                  .margin({ top: 2 })

                Text(course.location)
                  .fontSize(TYPO_B2.fontSize - 2)
                  .fontColor(COLOR_TEXT_SECONDARY)
                  .margin({ top: 1 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: SPACING_SM })
              .layoutWeight(1)

              if (this.isCurrentCourse(course)) {
                Text('进行中')
                  .fontSize(20)
                  .fontColor(COLOR_WARNING)
                  .border({ width: 1, color: COLOR_WARNING, radius: 8 })
                  .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              }
            }
            .width('95%')
            .alignSelf(ItemAlign.Center)
            .borderRadius(RADIUS_COMPONENT)
            .backgroundColor(COLOR_CARD_BG)
            .padding(SPACING_SM)
            .margin({ bottom: 8 })
            .border({
              width: this.isCurrentCourse(course) ? 2 : 0,
              color: this.isCurrentCourse(course) ? COLOR_WARNING : Color.Transparent
            })
            .onClick(() => {
              if (this.onCourseClick) {
                this.onCourseClick(course)
              }
            })
          })
        }
      }
      .width('100%')

      // 分隔线
      Divider().color(COLOR_BORDER).margin({ top: 4 })
    }
    .width('100%')
  }
}
