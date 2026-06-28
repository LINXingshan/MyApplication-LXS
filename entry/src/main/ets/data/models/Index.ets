/**
 * 数据模型定义 - 统一导出所有接口
 */

// 2.1 用户信息
export interface UserInfo {
  avatarPath: string
  nickname: string
  studentId: string
  college: string
  major: string
  password: string
}

// 2.2 课程
export interface Course {
  id: string
  name: string
  teacher: string
  dayOfWeek: number
  startTime: string
  endTime: string
  location: string
  credits: number
  weeks: number[]
  colorTag: string
  term: string
}

// 2.3 成绩
export interface Score {
  id: string
  courseName: string
  score: number
  gpa: number
  examDate: string
  term: string
}

// 2.4 待办事项
export interface Todo {
  id: string
  content: string
  category: string
  remindTime: string
  isCompleted: boolean
  createdAt: string
}

// 2.5 收藏
export interface FavoriteItem {
  id: string
  type: string
  title: string
  summary: string
  imagePath: string
  sourceId: string
  createdAt: string
}

// 2.6 校园公告/资讯
export interface Announcement {
  id: string
  title: string
  content: string
  category: string
  publishDate: string
  source: string
  imagePaths: string[]
  summary: string
}

// 2.7 图书
export interface Book {
  id: string
  title: string
  author: string
  isbn: string
  publisher: string
  coverPath: string
  location: string
  availableCount: number
  status: 'none' | 'want' | 'borrowed'
}

// 2.8 失物招领
export interface LostFoundItem {
  id: string
  type: string
  itemName: string
  category: string
  location: string
  date: string
  description: string
  contactPhone: string
  imagePaths: string[]
  createdAt: string
}

// 2.9 校园美食
export interface FoodItem {
  id: string
  name: string
  canteen: string
  location: string
  rating: number
  specialDishes: string[]
  imagePath: string
  createdAt: string
}

// 2.10 歌曲
export interface Song {
  id: string
  title: string
  artist: string
  filePath: string
  duration: number
  coverPath: string
}

// 2.11 校园地图建筑
export interface CampusBuilding {
  id: string
  name: string
  x: number
  y: number
  description: string
  functions: string[]
}

// 3.3 底部Tab项
export interface TabItem {
  name: string
  icon: Resource
  activeIcon: Resource
  page: string
}

// 天气数据
export interface CurrentWeather {
  temperature: number
  condition: string
  wind: string
  city: string
}

export interface WeatherForecast {
  date: string
  temperature: string
  condition: string
}

export interface WeatherData {
  current: CurrentWeather
  forecast: WeatherForecast[]
}

// 天气数据包装器（用于JSON存储）
export interface WeatherWrapper {
  data: WeatherData
}
