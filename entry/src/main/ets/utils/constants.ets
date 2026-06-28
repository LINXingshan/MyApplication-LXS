/**
 * 全局常量定义 - 颜色、字体、间距、尺寸令牌
 * 所有 UI 组件必须引用此文件中的常量，禁止硬编码
 */

// ===== 主色调 =====
export const COLOR_PRIMARY = '#1677FF'        // 鸿蒙蓝：导航栏、Tab栏、按钮、选中态、标题
export const COLOR_PRIMARY_LIGHT = '#C6E2FF'  // 浅蓝：按钮未激活背景
export const COLOR_PRIMARY_DARK = '#4096FF'   // 深蓝：渐变终点

// ===== 辅助色 =====
export const COLOR_WARNING = '#FF7D00'        // 暖橙：提醒标识、重点按钮、进度条
export const COLOR_SUCCESS = '#00B42A'        // 清新绿：完成态、成功提示

// ===== 中性色 =====
export const COLOR_BG = '#F5F7FA'             // 浅灰：页面背景
export const COLOR_CARD_BG = '#FFFFFF'        // 白色：卡片/列表项背景
export const COLOR_TEXT_PRIMARY = '#1D2129'   // 深黑：正文、标题
export const COLOR_TEXT_SECONDARY = '#86909C' // 浅灰：辅助说明、占位符、时间
export const COLOR_BORDER = '#E5E6EB'         // 淡灰：边框、分割线
export const COLOR_WHITE = '#FFFFFF'          // 白色：深色背景文字

// ===== 深色模式颜色映射 =====
export const DARK_COLORS: Record<string, string> = {
  'COLOR_BG': '#1A1A1A',
  'COLOR_CARD_BG': '#2D2D2D',
  'COLOR_TEXT_PRIMARY': '#E5E5E5',
  'COLOR_TEXT_SECONDARY': '#8B8B8B',
  'COLOR_BORDER': '#3D3D3D',
}

// ===== 字体令牌 =====
export interface TypoToken {
  fontSize: number
  lineHeight: number
  fontWeight: number
}

export const TYPO_APP_NAME: TypoToken = { fontSize: 36, lineHeight: 43.2, fontWeight: FontWeight.Bold }
export const TYPO_H1: TypoToken = { fontSize: 32, lineHeight: 38.4, fontWeight: FontWeight.Bold }
export const TYPO_PAGE_TITLE: TypoToken = { fontSize: 30, lineHeight: 36.0, fontWeight: FontWeight.Bold }
export const TYPO_H2: TypoToken = { fontSize: 28, lineHeight: 36.4, fontWeight: FontWeight.Bold }
export const TYPO_H3: TypoToken = { fontSize: 26, lineHeight: 33.8, fontWeight: FontWeight.Medium }
export const TYPO_B1: TypoToken = { fontSize: 26, lineHeight: 39.0, fontWeight: FontWeight.Normal }
export const TYPO_B2: TypoToken = { fontSize: 24, lineHeight: 33.6, fontWeight: FontWeight.Normal }
export const TYPO_B3: TypoToken = { fontSize: 22, lineHeight: 30.8, fontWeight: FontWeight.Normal }

// ===== 间距与圆角 =====
export const RADIUS_COMPONENT = 8
export const RADIUS_SEARCH = 24
export const SPACING_XS = 12
export const SPACING_SM = 16
export const SPACING_MD = 20
export const SPACING_LG = 24
export const SPACING_XL = 32

// ===== 组件尺寸 =====
export const SIZE_BTN_PRIMARY_H = 48
export const SIZE_BTN_SMALL_H = 36
export const SIZE_INPUT_H = 48
export const SIZE_TABBAR_H = 56
export const SIZE_ICON_TAB = 28
export const SIZE_ICON_FUNC = 32
export const SIZE_AVATAR = 80
export const SIZE_ENTRY_ICON = 64
export const SIZE_THUMB_SM = 64
export const SIZE_THUMB_MD = 80
export const SIZE_ALBUM_COVER = 180
export const SIZE_MUSIC_CTRL = 40

// ===== 卡片与阴影 =====
export interface ShadowToken {
  radius: number
  color: string
  offsetY: number
  opacity: number
}

export interface CardToken {
  width: string
  borderRadius: number
  backgroundColor: string
  alignSelf: ItemAlign
  padding: number
  shadow: ShadowToken
}

export const CARD_STYLE: CardToken = {
  width: '95%',
  borderRadius: RADIUS_COMPONENT,
  backgroundColor: COLOR_CARD_BG,
  alignSelf: ItemAlign.Center,
  padding: SPACING_SM,
  shadow: {
    radius: 8,
    color: '#000000',
    offsetY: 2,
    opacity: 0.05
  }
}

// ===== 按钮样式 =====
export interface ButtonToken {
  width?: string
  height: number
  borderRadius: number
  backgroundColor: string
  fontSize: number
  fontColor: string
}

export const BTN_PRIMARY_STYLE: ButtonToken = {
  width: '100%',
  height: SIZE_BTN_PRIMARY_H,
  borderRadius: RADIUS_COMPONENT,
  backgroundColor: COLOR_PRIMARY,
  fontSize: 26,
  fontColor: COLOR_WHITE
}

export const BTN_DISABLED_STYLE: ButtonToken = {
  width: '100%',
  height: SIZE_BTN_PRIMARY_H,
  borderRadius: RADIUS_COMPONENT,
  backgroundColor: COLOR_PRIMARY_LIGHT,
  fontSize: 26,
  fontColor: COLOR_TEXT_SECONDARY
}

export const BTN_SMALL_PRIMARY_STYLE: ButtonToken = {
  height: SIZE_BTN_SMALL_H,
  borderRadius: RADIUS_COMPONENT,
  backgroundColor: COLOR_PRIMARY,
  fontSize: 24,
  fontColor: COLOR_WHITE
}

export const BTN_SMALL_WARNING_STYLE: ButtonToken = {
  height: SIZE_BTN_SMALL_H,
  borderRadius: RADIUS_COMPONENT,
  backgroundColor: COLOR_WARNING,
  fontSize: 24,
  fontColor: COLOR_WHITE
}

// ===== 输入框样式 =====
export interface InputToken {
  height: number
  borderRadius: number
  paddingHorizontal: number
  backgroundColor: string
  borderColor: string
  placeholderColor: string
}

export const INPUT_STYLE: InputToken = {
  height: SIZE_INPUT_H,
  borderRadius: RADIUS_COMPONENT,
  paddingHorizontal: SPACING_SM,
  backgroundColor: COLOR_CARD_BG,
  borderColor: COLOR_BORDER,
  placeholderColor: COLOR_TEXT_SECONDARY
}

// ===== 路由常量 =====
export class RouteMap {
  SPLASH: string = 'pages/SplashPage'
  GUIDE: string = 'pages/GuidePage'
  LOGIN: string = 'pages/LoginPage'
  MAIN: string = 'pages/MainPage'
  SEARCH_RESULT: string = 'pages/SearchResultPage'
  MESSAGE_CENTER: string = 'pages/MessageCenterPage'
  ANNOUNCEMENT_DETAIL: string = 'pages/AnnouncementDetailPage'
  NEWS_DETAIL: string = 'pages/NewsDetailPage'
  CAMPUS_MAP: string = 'pages/CampusMapPage'
  BUILDING_DETAIL: string = 'pages/BuildingDetailPage'
  COURSE_EDIT: string = 'pages/CourseEditPage'
  COURSE_DETAIL: string = 'pages/CourseDetailPage'
  BOOK_DETAIL: string = 'pages/BookDetailPage'
  LOSTFOUND_PUBLISH: string = 'pages/LostFoundPublishPage'
  LOSTFOUND_DETAIL: string = 'pages/LostFoundDetailPage'
  FOOD_DETAIL: string = 'pages/FoodDetailPage'
  MUSIC_LIST: string = 'pages/MusicListPage'
  PROFILE_EDIT: string = 'pages/ProfileEditPage'
  SETTINGS: string = 'pages/SettingsPage'
  NOTIFICATION_SETTINGS: string = 'pages/NotificationSettingsPage'
  FAVORITES: string = 'pages/FavoritesPage'
  MY_COURSES: string = 'pages/MyCoursesPage'
  MY_SCORES: string = 'pages/MyScoresPage'
  MY_LOSTFOUND: string = 'pages/MyLostFoundPage'
  ABOUT: string = 'pages/AboutPage'
  FORGOT_PWD: string = 'pages/ForgotPasswordPage'
  FEEDBACK: string = 'pages/FeedbackPage'
}

export const ROUTE: RouteMap = new RouteMap()

// ===== Tab列表 =====
export interface TabItemData {
  name: string
  icon: string
  activeIcon: string
  page: string
}

export const TAB_LIST: TabItemData[] = [
  { name: '首页', icon: '🏠', activeIcon: '🏠', page: 'HomeTab' },
  { name: '校园信息', icon: '🏫', activeIcon: '🏫', page: 'CampusInfoTab' },
  { name: '学习助手', icon: '📚', activeIcon: '📚', page: 'StudyTab' },
  { name: '生活服务', icon: '🍔', activeIcon: '🍔', page: 'LifeTab' },
  { name: '我的', icon: '👤', activeIcon: '👤', page: 'MineTab' },
]
