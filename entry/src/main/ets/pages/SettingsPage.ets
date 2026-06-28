/**
 * SettingsPage - 设置页
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { ROUTE, TYPO_PAGE_TITLE, TYPO_B1, TYPO_B2, SPACING_SM, SPACING_MD }
  from '../utils/constants'
import { ThemeColors, ThemePalette } from '../utils/theme'

/**
 * SettingsPage page
 */
@Entry
@Component
struct SettingsPage {
  @StorageLink('isDarkMode') isDarkMode: boolean = false
  @State fontSize: string = AppStorage.get<string>('fontSize') ?? '中'
  @State cacheSize: string = '0 MB'

  theme(): ThemePalette { return ThemeColors.get(this.isDarkMode) }

  aboutToAppear(): void { this.loadCache() }
  async loadCache(): Promise<void> {
    const s = await StorageManager.getCacheSize()
    this.cacheSize = s > 1048576 ? `${(s / 1048576).toFixed(1)} MB` : `${(s / 1024).toFixed(1)} KB`
  }

  build() {
    Column() {
      Row() {
        Text('\u2190').fontSize(28).fontColor(this.theme().primary).width(44).height(44)
          .textAlign(TextAlign.Center).onClick(() => router.back())
        Text('设置').fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight)
          .fontColor(this.theme().textPrimary).layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(44)
      }.width('100%').height(56).backgroundColor(this.theme().cardBg).padding({ left: SPACING_SM })

      Column() {
        Row() {
          Text('\uD83C\uDF19').fontSize(24)
          Text('深色模式').fontSize(TYPO_B1.fontSize).fontColor(this.theme().textPrimary).margin({ left: SPACING_SM })
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode }).selectedColor(this.theme().primary)
            .onChange((v: boolean) => { this.isDarkMode = v; AppStorage.setOrCreate('isDarkMode', v) })
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })

        Divider().color(this.theme().border)

        Row() {
          Text('Aa').fontSize(24)
          Text('字体大小').fontSize(TYPO_B1.fontSize).fontColor(this.theme().textPrimary).margin({ left: SPACING_SM })
          Blank()
          Row() {
            ForEach(['小','中','大'], (s: string) => {
              Text(s).fontSize(TYPO_B2.fontSize)
                .fontColor(this.fontSize === s ? '#FFFFFF' : this.theme().textPrimary)
                .backgroundColor(this.fontSize === s ? this.theme().primary : this.theme().bg).borderRadius(12)
                .padding({ left: 10, right: 10, top: 4, bottom: 4 }).margin({ left: 4 })
                .onClick(() => { this.fontSize = s; AppStorage.setOrCreate('fontSize', s) })
            })
          }
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })

        Divider().color(this.theme().border)

        Row() {
          Text('\uD83D\uDD14').fontSize(24)
          Text('通知设置').fontSize(TYPO_B1.fontSize).fontColor(this.theme().textPrimary).margin({ left: SPACING_SM })
          Blank()
          Text('>').fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary)
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })
        .onClick(() => router.pushUrl({ url: ROUTE.NOTIFICATION_SETTINGS }))

        Divider().color(this.theme().border)

        Row() {
          Text('\uD83D\uDDD1\uFE0F').fontSize(24)
          Text('清理缓存').fontSize(TYPO_B1.fontSize).fontColor(this.theme().textPrimary).margin({ left: SPACING_SM })
          Blank()
          Text(this.cacheSize).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary)
          Button('清理').height(28).borderRadius(12).backgroundColor(this.theme().warning).fontSize(22).fontColor(this.theme().textOnPrimary)
            .padding({ left: 10, right: 10 }).margin({ left: 8 })
            .onClick(() => {
              AlertDialog.show({
                title: '确认清理', message: '确定要清理缓存吗？',
                confirm: { value: '确定', fontColor: this.theme().primary,
                  action: async () => { await StorageManager.clearCache(); await this.loadCache() }
                },
                cancel: () => {}
              })
            })
        }.width('100%').height(48).padding({ left: SPACING_MD, right: SPACING_MD })
      }
      .width('95%').borderRadius(8).backgroundColor(this.theme().cardBg).alignSelf(ItemAlign.Center)
      .margin({ top: SPACING_MD })
    }
    .width('100%').height('100%').backgroundColor(this.theme().bg)
  }
}
