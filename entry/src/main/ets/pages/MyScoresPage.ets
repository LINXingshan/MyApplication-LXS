/**
 * MyScoresPage - 我的成绩页
 */

import { router } from '@kit.ArkUI'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_WHITE,
  COLOR_WARNING, COLOR_SUCCESS, TYPO_PAGE_TITLE, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'

interface MyScore { courseName: string; score: number; gpa: number; examDate: string }

const SCORE_DATA: MyScore[] = [
  { courseName: '高等数学（二）', score: 92, gpa: 4.0, examDate: '2026-06-28' },
  { courseName: '大学英语（四）', score: 85, gpa: 3.5, examDate: '2026-06-26' },
  { courseName: '数据结构',       score: 88, gpa: 3.7, examDate: '2026-07-02' },
  { courseName: '线性代数',       score: 78, gpa: 3.0, examDate: '2026-06-25' },
  { courseName: '大学物理（上）', score: 90, gpa: 3.9, examDate: '2026-06-30' },
  { courseName: 'C语言程序设计',  score: 82, gpa: 3.3, examDate: '2026-07-04' },
  { courseName: '离散数学',       score: 75, gpa: 2.8, examDate: '2026-06-27' },
  { courseName: 'Java程序设计',   score: 86, gpa: 3.6, examDate: '2026-07-01' },
]

@Entry
@Component
struct MyScoresPage {
  @State scores: MyScore[] = SCORE_DATA

  getColor(s: number): string {
    if (s >= 90) return COLOR_SUCCESS
    if (s >= 80) return COLOR_PRIMARY
    return COLOR_WARNING
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('我的成绩').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      Scroll() {
        Column() {
          ForEach(this.scores, (s: MyScore) => {
            Row() {
              Column() {
                Text(s.courseName).fontSize(18).fontColor(COLOR_TEXT_PRIMARY)
                Text(s.examDate).fontSize(14).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 4 })
              }.alignItems(HorizontalAlign.Start).layoutWeight(1)
              Column() {
                Text(`${s.score}`).fontSize(28).fontWeight(FontWeight.Bold)
                  .fontColor(s.score >= 90 ? COLOR_SUCCESS : (s.score >= 80 ? COLOR_PRIMARY : COLOR_WARNING))
                Text(`绩点 ${s.gpa.toFixed(1)}`).fontSize(14).fontColor(COLOR_WARNING).margin({ top: 2 })
              }.alignItems(HorizontalAlign.End)
            }.width('92%').padding(16).backgroundColor(COLOR_CARD_BG).borderRadius(8).margin({ bottom: 8 })
          })
        }.width('100%').alignItems(HorizontalAlign.Center).padding({ top: SPACING_SM })
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
