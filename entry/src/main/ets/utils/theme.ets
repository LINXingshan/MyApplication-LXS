/**
 * theme - 集中式主题颜色系统
 *
 * 参考 Omni-UI / 社区最佳实践：
 * - 所有颜色集中定义，一处修改全局生效
 * - 亮色/深色双主题，通过 ThemeColors.get(isDark) 访问
 * - 避免在各页面分散写三目运算
 *
 * 使用方式：
 *   import { ThemeColors } from '../utils/theme'
 *
 *   // 在组件中声明（已有则跳过）:
 *   @StorageLink('isDarkMode') isDarkMode: boolean = false
 *
 *   // 获取颜色:
 *   ThemeColors.get(this.isDarkMode).bg
 *
 *   // 替代:
 *   this.isDarkMode ? '#1A1A1A' : '#F5F7FA'
 */

import { COLOR_BG, COLOR_CARD_BG, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_BORDER, DARK_COLORS } from './constants'

/**
 * 主题调色板接口
 * 覆盖所有 UI 场景的颜色需求
 */
export interface ThemePalette {
  bg: string           // 页面背景
  cardBg: string       // 卡片/列表项背景
  cardBgAlt: string    // 卡片交替色
  navBg: string        // 导航栏背景

  textPrimary: string  // 主标题/正文
  textSecondary: string // 辅助文字/时间
  textDisabled: string // 禁用态
  textOnPrimary: string // 主色调按钮文字
  textOnDark: string   // 深色背景上的文字

  border: string       // 边框色
  divider: string      // 分割线色

  primary: string      // 主色调
  primaryLight: string // 主色调浅色背景
  warning: string      // 警告色
  success: string      // 成功色
  error: string        // 错误色

  overlay: string      // 遮罩层
  highlight: string    // 高亮背景
  placeholder: string  // 占位符文字
}

const LIGHT: ThemePalette = {
  bg: '#F5F7FA',
  cardBg: '#FFFFFF',
  cardBgAlt: '#FAFBFC',
  navBg: '#FFFFFF',

  textPrimary: '#1D2129',
  textSecondary: '#86909C',
  textDisabled: '#C9CDD4',
  textOnPrimary: '#FFFFFF',
  textOnDark: '#FFFFFF',

  border: '#E5E6EB',
  divider: '#F0F0F0',

  primary: '#1677FF',
  primaryLight: '#E8F4FD',
  warning: '#FF7D00',
  success: '#00B42A',
  error: '#F53F3F',

  overlay: 'rgba(0,0,0,0.45)',
  highlight: '#FFF3E0',
  placeholder: '#C9CDD4',
}

const DARK: ThemePalette = {
  bg: '#1A1A1A',
  cardBg: '#2D2D2D',
  cardBgAlt: '#363636',
  navBg: '#1A1A1A',

  textPrimary: '#E5E5E5',
  textSecondary: '#8B8B8B',
  textDisabled: '#5A5A5A',
  textOnPrimary: '#FFFFFF',
  textOnDark: '#E5E5E5',

  border: '#3D3D3D',
  divider: '#383838',

  primary: '#4096FF',
  primaryLight: '#1A3A6A',
  warning: '#FF7D00',
  success: '#00B42A',
  error: '#F53F3F',

  overlay: 'rgba(0,0,0,0.6)',
  highlight: '#3A3520',
  placeholder: '#5A5A5A',
}

/**
 * ThemeColors 集中式主题颜色访问
 *
 * 使用: ThemeColors.get(isDark).textPrimary
 * 替代: isDark ? '#E5E5E5' : '#1D2129'
 */
export class ThemeColors {
  static get(isDark: boolean): ThemePalette {
    return isDark ? DARK : LIGHT
  }
}

/**
 * (旧版兼容) 根据当前主题模式获取对应的颜色值
 * @param colorKey 颜色常量名称 (如 'COLOR_BG')
 * @returns 当前主题下的颜色值
 */
export function getColor(colorKey: string): string {
  const isDarkMode = AppStorage.get<boolean>('isDarkMode') ?? false
  if (isDarkMode && DARK_COLORS[colorKey]) {
    return DARK_COLORS[colorKey]
  }
  switch (colorKey) {
    case 'COLOR_BG': return COLOR_BG
    case 'COLOR_CARD_BG': return COLOR_CARD_BG
    case 'COLOR_TEXT_PRIMARY': return COLOR_TEXT_PRIMARY
    case 'COLOR_TEXT_SECONDARY': return COLOR_TEXT_SECONDARY
    case 'COLOR_BORDER': return COLOR_BORDER
    default: return colorKey
  }
}

/**
 * 获取字体缩放系数
 * @returns 小=0.85 / 中=1.0 / 大=1.15
 */
export function getFontScale(): number {
  const fontSize = AppStorage.get<string>('fontSize') ?? '中'
  switch (fontSize) {
    case '小': return 0.85
    case '大': return 1.15
    default: return 1.0
  }
}
