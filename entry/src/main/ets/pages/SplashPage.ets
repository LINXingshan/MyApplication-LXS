/**
 * SplashPage - 启动页
 * 沉浸式渐变蓝背景 + 3秒倒计时 + 点击跳过
 */

@Entry
@Component
export struct SplashPage {
  onNext?: () => void
  @State countdown: number = 3
  @State progress: number = 0
  private timer: number = -1

  aboutToAppear(): void { this.startTimer() }
  aboutToDisappear(): void { clearInterval(this.timer) }

  startTimer(): void {
    let elapsed = 0
    this.timer = setInterval(() => {
      elapsed += 50
      this.progress = Math.min(elapsed / 3000 * 100, 100)
      if (elapsed >= 3000) { clearInterval(this.timer); this.goNext() }
    }, 50)
  }

  goNext(): void { if (this.onNext) this.onNext() }

  build() {
    Column() {
      Column() {
        Text('🏫').fontSize(64)
        Blank().height(20)
        Text('高校校园助手').fontSize(36).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
        Blank().height(12)
        Text('HarmonyOS NEXT 版').fontSize(24).fontColor('#FFFFFF').opacity(0.7)
      }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)

      Column() {
        Progress({ value: this.progress, total: 100, type: ProgressType.Ring })
          .width(28).height(28).color('#FFFFFF').style({ strokeWidth: 3 })
        Blank().height(16)
        Text('校园助手开发团队').fontSize(22).fontColor('#FFFFFF').opacity(0.6)
      }.width('100%').padding({ bottom: 30 }).alignItems(HorizontalAlign.Center)
    }
    .width('100%').height('100%')
    .linearGradient({ direction: GradientDirection.Top, colors: [['#1677FF', 0.0], ['#4096FF', 1.0]] })
    .onClick(() => { clearInterval(this.timer); this.goNext() })
  }
}
