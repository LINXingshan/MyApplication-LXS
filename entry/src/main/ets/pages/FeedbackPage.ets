/**
 * FeedbackPage - 意见反馈页
 * 常见问题一键反馈 + 补充说明输入
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'

const QUICK_FEEDBACK: string[] = ['功能建议','界面优化','数据错误','网络问题','性能卡顿','其他问题']

@Entry
@Component
struct FeedbackPage {
  @State text: string = ''
  @State selected: string = ''

  async submit(): Promise<void> {
    if (!this.selected && !this.text.trim()) {
      promptAction.showToast({ message: '请选择问题类型或输入反馈内容', duration: 1500 })
      return
    }
    const record: Record<string, string> = {
      'type': this.selected || '其他',
      'content': this.text.trim() || '(无补充说明)',
      'time': new Date().toISOString()
    }
    const list = await StorageManager.loadPref<string[]>('feedback_list') || []
    list.push(JSON.stringify(record))
    await StorageManager.savePref('feedback_list', list)

    promptAction.showToast({ message: '感谢你的反馈！', duration: 1500 })
    setTimeout(() => router.back(), 500)
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor('#1677FF').width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('意见反馈').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#1D2129')
          .layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor('#FFFFFF').padding({ left: 8, right: 8 })

      Scroll() {
        Column() {
          Text('请选择问题类型（必选）').fontSize(15).fontWeight(FontWeight.Medium).fontColor('#1D2129')
            .width('92%').margin({ top: 24, bottom: 12 })

          Grid() {
            ForEach(QUICK_FEEDBACK, (item: string, idx: number) => {
              GridItem() {
                Text(item).fontSize(14)
                  .fontColor(this.selected === item ? '#FFFFFF' : '#1677FF')
                  .backgroundColor(this.selected === item ? '#1677FF' : '#F5F7FA')
                  .border({ width: 1, color: this.selected === item ? '#1677FF' : '#E5E6EB' })
                  .borderRadius(8).padding({ left: 12, right: 12, top: 8, bottom: 8 })
                  .textAlign(TextAlign.Center)
                  .onClick(() => { this.selected = item })
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr').columnsGap(10).rowsGap(10)
          .width('92%')

          Text('补充说明（可选）').fontSize(15).fontWeight(FontWeight.Medium).fontColor('#1D2129')
            .width('92%').margin({ top: 24, bottom: 12 })

          TextArea({ text: this.text, placeholder: '请详细描述你的问题或建议，以便我们更快处理...' })
            .width('92%').height(160)
            .backgroundColor('#F5F7FA').borderRadius(8).fontSize(15)
            .padding(12)
            .onChange((v: string) => { this.text = v })

          Button('提交反馈').fontSize(17).fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF').backgroundColor('#1677FF')
            .borderRadius(8).width('92%').height(48)
            .margin({ top: 24 })
            .onClick(() => { this.submit() })

          Blank().height(40)
        }.width('100%').alignItems(HorizontalAlign.Center)
      }.width('100%').scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor('#F5F7FA')
  }
}
