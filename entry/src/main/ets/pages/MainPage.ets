/**
 * MainPage - 5Tab 主页面
 * 使用 @Builder TabBuilder + Tabs 组件
 */

import { HomeTab } from './HomeTab'
import { CampusInfoTab } from './CampusInfoTab'
import { StudyTab } from './StudyTab'
import { LifeTab } from './LifeTab'
import { MineTab } from './MineTab'

@Entry
@Component
export struct MainPage {
  onLogout?: () => void
  @StorageLink('currentTabIndex') @Watch('onTabChange') currentIndex: number = 0

  onTabChange(): void {}

  @Builder TabBuilder(title: string, index: number, icon: string) {
    Column() {
      Text(icon).fontSize(22).margin({ bottom: 2 })
      Text(title).fontSize(10).fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? '#1677FF' : '#86909C')
    }.justifyContent(FlexAlign.Center).height(56).width('100%')
    .onClick(() => { this.currentIndex = index; AppStorage.setOrCreate('currentTabIndex', index) })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() { HomeTab() }.tabBar(this.TabBuilder('首页', 0, '🏠'))
      TabContent() { CampusInfoTab() }.tabBar(this.TabBuilder('校园信息', 1, '🏫'))
      TabContent() { StudyTab() }.tabBar(this.TabBuilder('学习助手', 2, '📚'))
      TabContent() { LifeTab() }.tabBar(this.TabBuilder('生活服务', 3, '🍔'))
      TabContent() { MineTab({ onLogout: this.onLogout }) }.tabBar(this.TabBuilder('我的', 4, '👤'))
    }
    .width('100%').height('100%').scrollable(false)
    .onChange((i: number) => { this.currentIndex = i; AppStorage.setOrCreate('currentTabIndex', i) })
  }
}
