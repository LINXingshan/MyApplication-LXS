/**
 * CommonComponents - 通用可复用 UI 组件集合
 *
 * 参考 JhHarmonyDemo 的模块化思想和 Omni-UI 的组件化方案：
 * - 所有组件自动适配深色模式
 * - 统一间距/圆角/字体令牌
 * - 一处修改全局生效
 */

import { ThemeColors, ThemePalette } from '../utils/theme'
import { SPACING_SM, SPACING_MD, RADIUS_COMPONENT } from '../utils/constants'

/**
 * ThemeCard - 深色模式自适应卡片容器
 *
 * 使用方式：
 *   ThemeCard() {
 *     Text('内容').fontSize(16)
 *   }
 */
@Component
export struct ThemeCard {
  @Prop isDark: boolean = false
  @BuilderParam content?: () => void
  @Prop widthVal: string = '92%'
  @Prop borderRadius: number = RADIUS_COMPONENT
  @Prop paddingVal: number = SPACING_SM
  @Prop marginBottom: number = 8
  @Prop onClickAction: () => void = () => {}

  build() {
    Column() {
      if (this.content) {
        this.content()
      }
    }
    .width(this.widthVal)
    .padding(this.paddingVal)
    .backgroundColor(ThemeColors.get(this.isDark).cardBg)
    .borderRadius(this.borderRadius)
    .margin({ bottom: this.marginBottom })
    .onClick(() => { this.onClickAction() })
  }
}

/**
 * SectionHeader - 区块标题 + 可选"更多"链接
 *
 * 使用方式：
 *   SectionHeader({
 *     title: '校园公告', isDark: isDark,
 *     onMore: () => switchTab(1)
 *   })
 */
@Component
export struct SectionHeader {
  @Prop isDark: boolean = false
  @Prop title: string = ''
  @Prop showMore: boolean = true
  @Prop moreText: string = '更多 >'
  @Prop onMore: () => void = () => {}

  build() {
    Row() {
      Text(this.title)
        .fontSize(18).fontWeight(FontWeight.Bold)
        .fontColor(ThemeColors.get(this.isDark).textPrimary)
      Blank()
      if (this.showMore) {
        Text(this.moreText)
          .fontSize(14)
          .fontColor(ThemeColors.get(this.isDark).primary)
          .onClick(() => { this.onMore() })
      }
    }
    .width('92%')
    .margin({ top: 20, bottom: 12 })
  }
}

/**
 * MenuItemRow - 菜单行（图标 + 标题 + 箭头）
 *
 * 使用方式：
 *   MenuItemRow({
 *     icon: '❤️', title: '我的收藏',
 *     isDark: isDark, onClick: () => router.pushUrl(...)
 *   })
 */
@Component
export struct MenuItemRow {
  @Prop isDark: boolean = false
  @Prop icon: string = ''
  @Prop title: string = ''
  @Prop showArrow: boolean = true
  @Prop onClick: () => void = () => {}

  build() {
    Row() {
      Text(this.icon).fontSize(20)
      Text(this.title)
        .fontSize(15)
        .fontColor(ThemeColors.get(this.isDark).textPrimary)
        .margin({ left: 12 })
        .layoutWeight(1)
      if (this.showArrow) {
        Text('>')
          .fontSize(16)
          .fontColor(ThemeColors.get(this.isDark).textSecondary)
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .onClick(() => { this.onClick() })
  }
}

/**
 * ToolCard - 工具/功能卡片（圆形图标 + 名称）
 *
 * 使用方式：
 *   ToolCard({
 *     emoji: '📢', name: '校园公告',
 *     bgColor: '#E8F4FD', iconColor: '#1677FF',
 *     onClick: () => handleClick()
 *   })
 */
@Component
export struct ToolCard {
  @Prop emoji: string = ''
  @Prop name: string = ''
  @Prop bgColor: string = '#E8F4FD'
  @Prop iconColor: string = '#1677FF'
  @Prop onClick: () => void = () => {}

  build() {
    Column() {
      Circle({ width: 64, height: 64 })
        .fill(this.bgColor)
        .stroke(this.iconColor).strokeWidth(1.5)
      Stack() {
        Circle({ width: 64, height: 64 }).fill(Color.Transparent)
        Text(this.emoji).fontSize(30)
      }.width(64).height(64).position({ x: 0, y: 0 })
      Text(this.name)
        .fontSize(14).margin({ top: 6 }).maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height(116)
    .onClick(() => { this.onClick() })
  }
}

/**
 * EmptyState - 空状态占位
 *
 * 使用方式：
 *   EmptyState({ isDark: isDark, text: '暂无数据' })
 */
@Component
export struct EmptyState {
  @Prop isDark: boolean = false
  @Prop icon: string = '📭'
  @Prop text: string = '暂无内容'

  build() {
    Column() {
      Blank().height(80)
      Text(this.icon).fontSize(48)
      Text(this.text)
        .fontSize(15)
        .fontColor(ThemeColors.get(this.isDark).textSecondary)
        .margin({ top: 12 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}
