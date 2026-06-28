/**
 * CourseEditPage - 课程编辑页
 * 表单：课程名/老师/时间/地点/学分/周次 + 保存/删除按钮
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { Course } from '../data/models/Index'
import { COLOR_PRIMARY, COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER,
  COLOR_PRIMARY_LIGHT, COLOR_WHITE, COLOR_WARNING, ROUTE, TYPO_PAGE_TITLE, TYPO_B2, TYPO_B1,
  RADIUS_COMPONENT, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'

/**
 * CourseEditPage page
 */
@Entry
@Component
struct CourseEditPage {
  @State course: Course = {
    id: `c_${Date.now()}`, name: '', teacher: '', dayOfWeek: 1,
    startTime: '08:00', endTime: '09:40', location: '', credits: 3,
    weeks: [], colorTag: '#1677FF', term: '2025-2026-2'
  }
  @State selectedWeeks: boolean[] = new Array(17).fill(false) // index 1..16
  @State isEdit: boolean = false
  private dayNames: string[] = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日']
  private colorOptions: string[] = ['#1677FF', '#FF7D00', '#00B42A']

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>
    if (params && params['course']) {
      this.course = params['course'] as Course
      this.isEdit = true
      for (const w of this.course.weeks) {
        if (w >= 1 && w <= 16) this.selectedWeeks[w] = true
      }
    }
  }

  async saveCourse(): Promise<void> {
    if (!this.course.name.trim()) { promptAction.showToast({ message: '请输入课程名称', duration: 1500 }); return }
    if (!this.course.teacher.trim()) { promptAction.showToast({ message: '请输入授课教师', duration: 1500 }); return }
    if (!this.course.location.trim()) { promptAction.showToast({ message: '请输入上课地点', duration: 1500 }); return }

    this.course.weeks = []
    for (let i = 1; i <= 16; i++) { if (this.selectedWeeks[i]) this.course.weeks.push(i) }
    if (this.course.weeks.length === 0) { promptAction.showToast({ message: '请选择上课周次', duration: 1500 }); return }

    const courses = await StorageManager.loadJsonFile<Course>('courses')
    if (this.isEdit) {
      const idx = courses.findIndex(c => c.id === this.course.id)
      if (idx >= 0) courses[idx] = this.course
    } else {
      courses.push(this.course)
    }
    await StorageManager.saveJsonFile('courses', courses)
    promptAction.showToast({ message: this.isEdit ? '修改成功' : '添加成功', duration: 1500 })
    setTimeout(() => { router.back() }, 500)
  }

  async deleteCourse(): Promise<void> {
    AlertDialog.show({
      title: '确认删除', message: '确定要删除这门课程吗？',
      confirm: { value: '删除', fontColor: COLOR_WARNING,
        action: async () => {
          const courses = await StorageManager.loadJsonFile<Course>('courses')
          await StorageManager.saveJsonFile('courses', courses.filter(c => c.id !== this.course.id))
          promptAction.showToast({ message: '已删除', duration: 1500 })
          setTimeout(() => { router.back() }, 500)
        }
      },
      cancel: () => {}
    })
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(COLOR_PRIMARY).width(44).height(44).textAlign(TextAlign.Center).onClick(() => router.back())
        Text(this.isEdit ? '编辑课程' : '添加课程').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(COLOR_CARD_BG).padding({ left: SPACING_SM })

      Scroll() {
        Column() {
          // 表单区
          Column() {
            // 课程名称
            Column() {
              Row() {
                Text('课程名称').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                TextInput({ text: this.course.name, placeholder: '请输入课程名称' })
                  .layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize)
                  .onChange((v: string) => { this.course.name = v })
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 授课教师
              Row() {
                Text('授课教师').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                TextInput({ text: this.course.teacher, placeholder: '请输入授课教师' })
                  .layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize)
                  .onChange((v: string) => { this.course.teacher = v })
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 上课日期
              Row() {
                Text('上课日期').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                Row({ space: 8 }) {
                  ForEach(this.dayNames.slice(1), (name: string, index: number) => {
                    Text(name).fontSize(TYPO_B2.fontSize - 2)
                      .fontColor(this.course.dayOfWeek === index + 1 ? COLOR_WHITE : COLOR_TEXT_PRIMARY)
                      .backgroundColor(this.course.dayOfWeek === index + 1 ? COLOR_PRIMARY : COLOR_BG)
                      .borderRadius(12).padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .onClick(() => { this.course.dayOfWeek = index + 1 })
                  })
                }.layoutWeight(1)
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 上课时间
              Row() {
                Text('上课时间').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                Row({ space: 8 }) {
                  TextInput({ text: this.course.startTime })
                    .width(80).height(36).fontSize(TYPO_B2.fontSize)
                    .borderRadius(4).backgroundColor(COLOR_BG).textAlign(TextAlign.Center)
                    .onChange((v: string) => { this.course.startTime = v })
                  Text('~').fontSize(TYPO_B2.fontSize)
                  TextInput({ text: this.course.endTime })
                    .width(80).height(36).fontSize(TYPO_B2.fontSize)
                    .borderRadius(4).backgroundColor(COLOR_BG).textAlign(TextAlign.Center)
                    .onChange((v: string) => { this.course.endTime = v })
                }.layoutWeight(1)
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 上课地点
              Row() {
                Text('上课地点').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                TextInput({ text: this.course.location, placeholder: '如 教A201' })
                  .layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize)
                  .onChange((v: string) => { this.course.location = v })
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 学分
              Row() {
                Text('学分').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                TextInput({ text: `${this.course.credits}`, placeholder: '学分' })
                  .width(60).height(36).fontSize(TYPO_B2.fontSize).textAlign(TextAlign.Center)
                  .borderRadius(4).backgroundColor(COLOR_BG)
                  .onChange((v: string) => { this.course.credits = parseInt(v) || 0 })
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 卡片颜色
              Row() {
                Text('卡片颜色').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
                Row({ space: 8 }) {
                  ForEach(this.colorOptions, (color: string) => {
                    Circle({ width: 28, height: 28 }).fill(color)
                      .border({ width: this.course.colorTag === color ? 2 : 0, color: '#333' })
                      .onClick(() => { this.course.colorTag = color })
                  })
                }.layoutWeight(1)
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)

              // 上课周次
              Row() {
                Text('上课周次').fontSize(TYPO_B2.fontSize).fontColor(COLOR_TEXT_SECONDARY).width(80)
              }.width('100%').padding({ top: 8, bottom: 8 })
              Divider().color(COLOR_BORDER)
            }

            // 周次选择网格
            Column() {
              Grid() {
                ForEach([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], (week: number) => {
                  GridItem() {
                    Text(`${week}`)
                      .fontSize(TYPO_B2.fontSize - 2)
                      .fontColor(this.selectedWeeks[week] ? COLOR_WHITE : COLOR_TEXT_PRIMARY)
                      .backgroundColor(this.selectedWeeks[week] ? COLOR_PRIMARY : COLOR_BG)
                      .borderRadius(12).width(36).height(36).textAlign(TextAlign.Center)
                      .onClick(() => { this.selectedWeeks[week] = !this.selectedWeeks[week] })
                  }
                })
              }
              .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr').rowsGap(8).columnsGap(4)
            }.width('100%').margin({ top: 8 })

          }.width('90%').borderRadius(RADIUS_COMPONENT).backgroundColor(COLOR_CARD_BG).padding(SPACING_MD).margin({ top: SPACING_MD })

          // 保存按钮
          Button('保存课程')
            .width('90%').height(48).borderRadius(RADIUS_COMPONENT)
            .backgroundColor(COLOR_PRIMARY).fontSize(TYPO_B1.fontSize).fontColor(COLOR_WHITE)
            .margin({ top: SPACING_LG })

          // 删除按钮（仅编辑模式）
          if (this.isEdit) {
            Button('删除课程')
              .width('90%').height(48).borderRadius(RADIUS_COMPONENT)
              .backgroundColor(COLOR_WARNING).fontSize(TYPO_B1.fontSize).fontColor(COLOR_WHITE)
              .margin({ top: SPACING_SM })
          }

          Column() { Blank().height(30) }
        }.width('100%')
      }
      .width('100%').layoutWeight(1)
    }.width('100%').height('100%').backgroundColor(COLOR_BG)
  }
}
