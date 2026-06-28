/**
 * GuidePage - 3页滑动引导页
 */

@Entry
@Component
export struct GuidePage {
  onFinish?: () => void
  @State index: number = 0
  private cards: GuideCard[] = [
    { emoji: '🏫', title: '校园信息，实时掌握', desc: '校园公告、资讯、活动地图\n全校动态尽在掌握' },
    { emoji: '📚', title: '学习助手，高效备考', desc: '课表管理、成绩查询、图书馆\n助你学业更出色' },
    { emoji: '🍔', title: '生活服务，贴心相伴', desc: '失物招领、校园美食、音乐\n校园生活更便捷' },
  ]

  build() {
    Stack() {
      // 白色背景
      Column().width('100%').height('100%').backgroundColor('#FFFFFF')

      // 前景内容
      Column() {
        Swiper() {
          ForEach(this.cards, (item: GuideCard) => {
            Column() {
              Row() { Text(item.emoji).fontSize(56) }
              .width(120).height(120).borderRadius(60)
              .backgroundColor('rgba(0,0,0,0.06)')
              .justifyContent(FlexAlign.Center).margin({ top: 80, bottom: 36 })

              Text(item.title).fontSize(30).fontWeight(FontWeight.Bold).fontColor('#1D2129')
              Text(item.desc).fontSize(15).fontColor('rgba(0,0,0,0.6)')
                .textAlign(TextAlign.Center).lineHeight(24).margin({ top: 16 })
              Blank()
            }.width('100%').height('100%')
          })
        }
        .index(this.index).indicator(new DotIndicator().color('rgba(0,0,0,0.15)').selectedColor('#1677FF'))
        .onChange((i: number) => { this.index = i })
        .width('100%').layoutWeight(1).loop(false).duration(300)

        Column() {
          Button(this.index === 2 ? '立即进入' : '下一步')
            .fontSize(17).fontColor('#FFFFFF').backgroundColor('#1677FF')
            .borderRadius(25).width('88%').height(48)
            .onClick(() => { if (this.onFinish) this.onFinish() }).margin({ bottom: 14 })
          Text('跳过引导').fontSize(14).fontColor('rgba(0,0,0,0.4)')
            .onClick(() => { if (this.onFinish) this.onFinish() }).margin({ bottom: 30 })
        }.width('100%').alignItems(HorizontalAlign.Center)
      }.width('100%').height('100%')
    }.width('100%').height('100%')
  }
}

interface GuideCard { emoji: string; title: string; desc: string }
