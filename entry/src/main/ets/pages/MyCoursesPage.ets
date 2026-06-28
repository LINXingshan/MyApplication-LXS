/**
 * MyCoursesPage - 我的课程页
 */

import { router } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Course } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY,
  TYPO_PAGE_TITLE, TYPO_H3, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'

/**
 * MyCoursesPage page
 */
@Entry
@Component
struct MyCoursesPage {
  @State courses: Course[] = []
  aboutToAppear(): void { this.load() }
  async load(): Promise<void> { this.courses = await StorageManager.loadJsonFile<Course>('courses') }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('我的课程').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      List() {
        ForEach(this.courses, (c: Course, idx: number) => {
          ListItem() {
            Row() {
              Column().width(4).height(40).borderRadius(2).backgroundColor(c.colorTag || COLOR_PRIMARY)
              Column() {
                Text(c.name).fontSize(TYPO_H3.fontSize).fontColor(COLOR_TEXT_PRIMARY)
                Text(`${['','周一','周二','周三','周四','周五','周六','周日'][c.dayOfWeek]} ${c.startTime}-${c.endTime} ${c.location}`)
                  .fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 4 })
              }.alignItems(HorizontalAlign.Start).margin({ left: SPACING_SM }).layoutWeight(1)
            }.width('100%').padding(SPACING_SM)
          }.backgroundColor(COLOR_CARD_BG).margin({ left: SPACING_MD, right: SPACING_MD, bottom: 1 }).borderRadius(8)
        })
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
