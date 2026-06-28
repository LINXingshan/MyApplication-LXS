/**
 * mockData - 预置模拟数据
 * 首次启动时将所有模拟数据写入本地存储
 */

import { Announcement, Book, Song, FoodItem, CampusBuilding, CurrentWeather, WeatherData, WeatherForecast, WeatherWrapper, Course, Score, Todo, LostFoundItem } from './models/Index'
import { StorageManager } from '../utils/storage'

// ===== 默认公告 =====
const DEFAULT_ANNOUNCEMENTS: Announcement[] = [
  {
    id: '1',
    title: '关于2026年春季学期期末考试安排的通知',
    content: '各学院、各教学单位：\n\n根据学校教学工作安排，2026年春季学期期末考试将于7月10日至7月20日进行。现将有关事项通知如下：\n\n一、考试时间\n上午场：8:00-10:00\n下午场：14:00-16:00\n晚上场：18:30-20:30\n\n二、考试地点\n请各学院根据教务处统一安排，具体考场安排将于7月5日前在教务系统公布。\n\n三、注意事项\n1. 考生须携带学生证和身份证入场；\n2. 开考15分钟后不得入场；\n3. 严禁携带电子设备进入考场。\n\n请各学院做好考试组织工作，祝同学们取得好成绩！\n\n教务处\n2026年6月15日',
    category: 'school',
    publishDate: '2026-06-15',
    source: '教务处',
    imagePaths: [],
    summary: '2026年春季学期期末考试将于7月10日至7月20日进行，请各学院做好考试组织工作...'
  },
  {
    id: '2',
    title: '关于图书馆暑期开放时间调整的通知',
    content: '各位读者：\n\n为满足暑期留校师生的学习需求，图书馆暑期开放时间作如下调整：\n\n一、开放时间\n7月1日-8月31日 每天 8:00-22:00\n\n二、开放区域\n二楼自习区、三楼期刊阅览室全天开放\n科技阅览室、社科阅览室实行预约开放制\n\n三、借还书服务\n每周一、三、五上午9:00-11:30提供借还书服务\n\n请各位读者相互转告。\n\n图书馆\n2026年6月14日',
    category: 'school',
    publishDate: '2026-06-14',
    source: '图书馆',
    imagePaths: [],
    summary: '图书馆暑期（7月1日-8月31日）每天8:00-22:00开放，借还书服务调整为每周一三五上午...'
  },
  {
    id: '3',
    title: '计算机学院第三届程序设计竞赛报名通知',
    content: '为提升同学们的算法设计与编程能力，激发创新思维，计算机学院将举办第三届程序设计竞赛。\n\n比赛时间：2026年7月5日 14:00-17:00\n比赛地点：计算机楼403、404实验室\n参赛对象：全校在校本科生\n比赛形式：个人赛，使用C/C++/Java/Python语言\n奖项设置：一等奖1名、二等奖3名、三等奖5名\n\n报名方式：登录教务系统在线报名\n报名截止：2026年7月1日\n\n欢迎各位同学踊跃报名！\n\n计算机学院学生会\n2026年6月13日',
    category: 'college',
    publishDate: '2026-06-13',
    source: '计算机学院',
    imagePaths: [],
    summary: '计算机学院第三届程序设计竞赛将于7月5日举行，欢迎全校同学报名参加...'
  },
  {
    id: '4',
    title: '校园音乐节——夏日之声 即将来袭',
    content: '校园音乐节 - 夏日之声\n\n这个夏天，让我们一起感受音乐的魅力！\n\n时间：2026年6月28日 19:00-22:00\n地点：学校田径场\n演出阵容：校园十大歌手、吉他社、街舞社、民乐团\n\n特别环节：\n- 观众互动环节\n- 最佳人气投票\n- 现场抽奖\n\n门票：免费！\n承办：校学生会文艺部、音乐协会\n\n让我们用音乐点燃这个夏天！\n\n校学生会文艺部\n2026年6月12日',
    category: 'club',
    publishDate: '2026-06-12',
    source: '校学生会',
    imagePaths: [],
    summary: '校园音乐节"夏日之声"将于6月28日晚在田径场举行，免费入场，欢迎参加...'
  },
  {
    id: '5',
    title: '关于学生宿舍空调检修的通知',
    content: '各位同学：\n\n为确保夏季宿舍空调正常运行，后勤集团将于近期对各宿舍楼空调进行集中检修。\n\n检修时间：2026年6月20日-6月25日\n检修范围：全校所有学生宿舍\n\n检修期间请同学们配合工作人员进入宿舍进行检查，如有不便敬请谅解。\n\n如有空调故障请及时报修：\n报修电话：0451-8888XXXX\n\n后勤集团\n2026年6月11日',
    category: 'school',
    publishDate: '2026-06-11',
    source: '后勤集团',
    imagePaths: [],
    summary: '后勤集团将于6月20日-25日对全校宿舍空调进行集中检修，请同学们配合...'
  }
]

// ===== 默认图书 =====
const DEFAULT_BOOKS: Book[] = [
  {
    id: '1',
    title: '数据结构与算法分析',
    author: 'Mark Allen Weiss',
    isbn: '978-7-111-52890-4',
    publisher: '机械工业出版社',
    coverPath: '',
    location: '图书馆3层-科技阅览室A区3排',
    availableCount: 5,
    status: 'none'
  },
  {
    id: '2',
    title: '深入理解计算机系统',
    author: 'Randal E. Bryant',
    isbn: '978-7-111-54493-7',
    publisher: '机械工业出版社',
    coverPath: '',
    location: '图书馆3层-科技阅览室A区5排',
    availableCount: 3,
    status: 'none'
  },
  {
    id: '3',
    title: '人工智能：一种现代方法',
    author: 'Stuart Russell',
    isbn: '978-7-302-33107-0',
    publisher: '清华大学出版社',
    coverPath: '',
    location: '图书馆4层-科技阅览室B区2排',
    availableCount: 4,
    status: 'none'
  },
  {
    id: '4',
    title: '高等数学（第七版）',
    author: '同济大学数学系',
    isbn: '978-7-04-039663-8',
    publisher: '高等教育出版社',
    coverPath: '',
    location: '图书馆2层-基础阅览室A区1排',
    availableCount: 10,
    status: 'none'
  },
  {
    id: '5',
    title: 'Python编程：从入门到实践',
    author: 'Eric Matthes',
    isbn: '978-7-115-54602-1',
    publisher: '人民邮电出版社',
    coverPath: '',
    location: '图书馆3层-科技阅览室A区8排',
    availableCount: 6,
    status: 'none'
  }
]

// ===== 默认歌曲 =====
const DEFAULT_SONGS: Song[] = [
  { id: '1', title: '示例音乐1 - 晨光', artist: '校内创作人', filePath: '', duration: 210, coverPath: '' },
  { id: '2', title: '示例音乐2 - 午后', artist: '音乐协会', filePath: '', duration: 180, coverPath: '' },
  { id: '3', title: '示例音乐3 - 晚风', artist: '吉他社', filePath: '', duration: 240, coverPath: '' }
]

// ===== 默认美食 =====
const DEFAULT_FOODS: FoodItem[] = [
  {
    id: '1',
    name: '麻辣香锅',
    canteen: '学生一食堂二层',
    location: '一食堂二层东侧窗口',
    rating: 4,
    specialDishes: ['辣子鸡', '麻辣牛肉', '干锅菜花'],
    imagePath: '',
    createdAt: '2026-06-01'
  },
  {
    id: '2',
    name: '兰州拉面',
    canteen: '学生二食堂一层',
    location: '二食堂一层西侧',
    rating: 5,
    specialDishes: ['牛肉面', '炒拉条', '大盘鸡'],
    imagePath: '',
    createdAt: '2026-06-02'
  },
  {
    id: '3',
    name: '铁板饭',
    canteen: '学生一食堂一层',
    location: '一食堂一层南侧',
    rating: 4,
    specialDishes: ['黑椒牛柳饭', '咖喱鸡肉饭', '照烧鸡腿饭'],
    imagePath: '',
    createdAt: '2026-06-03'
  },
  {
    id: '4',
    name: '麻辣烫',
    canteen: '学生二食堂二层',
    location: '二食堂二层北侧',
    rating: 3,
    specialDishes: ['自选麻辣烫', '骨汤麻辣烫', '番茄麻辣烫'],
    imagePath: '',
    createdAt: '2026-06-04'
  }
]

// ===== 默认建筑标注 =====
const DEFAULT_BUILDINGS: CampusBuilding[] = [
  { id: '1', name: '教学楼A', x: 30, y: 25, description: '主教学楼，含阶梯教室、多媒体教室', functions: ['上课', '自习'] },
  { id: '2', name: '图书馆', x: 55, y: 40, description: '校图书馆，藏书50万册，设有阅览室、自习区', functions: ['阅览', '自习', '借还书'] },
  { id: '3', name: '学生一食堂', x: 70, y: 60, description: '一食堂共三层，提供各地特色美食', functions: ['餐饮', '超市'] },
  { id: '4', name: '学生宿舍1号楼', x: 20, y: 70, description: '本科生宿舍，4人间，独立卫浴', functions: ['住宿'] },
  { id: '5', name: '操场', x: 50, y: 80, description: '标准田径场，含足球场、篮球场', functions: ['运动', '体育课', '比赛'] }
]

// ===== 默认课程（2025-2026学年第二学期 完整课程表）=====
const DEFAULT_COURSES: Course[] = [
  // ---- 周一 ----
  { id: 'c1',  name: '高等数学（二）', teacher: '张志远 教授', dayOfWeek: 1, startTime: '08:00', endTime: '09:40', location: '教学楼A201', credits: 5, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#1677FF', term: '2025-2026-2' },
  { id: 'c2',  name: '大学物理（上）', teacher: '杨明 教授',   dayOfWeek: 1, startTime: '10:00', endTime: '11:40', location: '教学楼B201', credits: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#FF7D00', term: '2025-2026-2' },
  { id: 'c3',  name: 'C语言程序设计', teacher: '赵敏 教授',   dayOfWeek: 1, startTime: '14:00', endTime: '15:40', location: '实验楼C201', credits: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#00B42A', term: '2025-2026-2' },

  // ---- 周二 ----
  { id: 'c4',  name: '大学英语（四）', teacher: '李芳华 副教授', dayOfWeek: 2, startTime: '08:00', endTime: '09:40', location: '教学楼B103', credits: 3, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#1677FF', term: '2025-2026-2' },
  { id: 'c5',  name: '数据结构',       teacher: '赵敏 教授',     dayOfWeek: 2, startTime: '10:00', endTime: '11:40', location: '实验楼C201', credits: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#FF7D00', term: '2025-2026-2' },
  { id: 'c6',  name: '马克思主义原理', teacher: '周伟 教授',     dayOfWeek: 2, startTime: '14:00', endTime: '15:40', location: '教学楼A102', credits: 3, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#00B42A', term: '2025-2026-2' },
  { id: 'c7',  name: '数据库原理',     teacher: '孙磊 副教授',   dayOfWeek: 2, startTime: '16:00', endTime: '17:40', location: '实验楼C102', credits: 4, weeks: [1,3,5,7,9,11,13,15],      colorTag: '#1677FF', term: '2025-2026-2' },

  // ---- 周三 ----
  { id: 'c8',  name: '离散数学',       teacher: '黄伟 副教授', dayOfWeek: 3, startTime: '08:00', endTime: '09:40', location: '教学楼A303', credits: 3, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#FF7D00', term: '2025-2026-2' },
  { id: 'c9',  name: '高等数学（二）', teacher: '张志远 教授', dayOfWeek: 3, startTime: '10:00', endTime: '11:40', location: '教学楼A201', credits: 5, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#1677FF', term: '2025-2026-2' },
  { id: 'c10', name: '大学体育（四）', teacher: '刘强 副教授', dayOfWeek: 3, startTime: '14:00', endTime: '15:40', location: '体育馆',     credits: 1, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#00B42A', term: '2025-2026-2' },
  { id: 'c11', name: '计算机组成原理', teacher: '王建国 教授', dayOfWeek: 3, startTime: '16:00', endTime: '17:40', location: '实验楼C301', credits: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#FF7D00', term: '2025-2026-2' },

  // ---- 周四 ----
  { id: 'c12', name: '线性代数',       teacher: '陈明 讲师',   dayOfWeek: 4, startTime: '08:00', endTime: '09:40', location: '教学楼A305', credits: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#1677FF', term: '2025-2026-2' },
  { id: 'c13', name: '数据结构实验',   teacher: '陈明 讲师',   dayOfWeek: 4, startTime: '10:00', endTime: '11:40', location: '实验楼C202', credits: 2, weeks: [2,4,6,8,10,12,14,16],        colorTag: '#00B42A', term: '2025-2026-2' },
  { id: 'c14', name: 'Java程序设计',   teacher: '孙磊 副教授', dayOfWeek: 4, startTime: '14:00', endTime: '15:40', location: '实验楼C102', credits: 3, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#FF7D00', term: '2025-2026-2' },

  // ---- 周五 ----
  { id: 'c15', name: '大学英语（四）', teacher: '李芳华 副教授', dayOfWeek: 5, startTime: '08:00', endTime: '09:40', location: '教学楼B103', credits: 3, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#1677FF', term: '2025-2026-2' },
  { id: 'c16', name: '计算机组成原理', teacher: '王建国 教授',   dayOfWeek: 5, startTime: '10:00', endTime: '11:40', location: '实验楼C301', credits: 4, weeks: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], colorTag: '#FF7D00', term: '2025-2026-2' },
  { id: 'c17', name: '大学物理实验',   teacher: '杨明 教授',     dayOfWeek: 5, startTime: '14:00', endTime: '15:40', location: '物理实验楼101', credits: 1, weeks: [3,5,7,9,11,13,15],        colorTag: '#00B42A', term: '2025-2026-2' },
  { id: 'c18', name: '大学生心理健康', teacher: '马丽 教授',     dayOfWeek: 5, startTime: '16:00', endTime: '17:40', location: '教学楼A102', credits: 2, weeks: [1,2,3,4,5,6,7,8],           colorTag: '#1677FF', term: '2025-2026-2' },
]

// ===== 默认成绩 =====
export const DEFAULT_SCORES: Score[] = [
  { id: 's1', courseName: '高等数学（二）', score: 92, gpa: 4.0, examDate: '2026-06-28', term: '2025-2026-2' },
  { id: 's2', courseName: '大学英语（四）', score: 85, gpa: 3.5, examDate: '2026-06-26', term: '2025-2026-2' },
  { id: 's3', courseName: '数据结构',       score: 88, gpa: 3.7, examDate: '2026-07-02', term: '2025-2026-2' },
  { id: 's4', courseName: '线性代数',       score: 78, gpa: 3.0, examDate: '2026-06-25', term: '2025-2026-2' },
  { id: 's5', courseName: '大学物理（上）', score: 90, gpa: 3.9, examDate: '2026-06-30', term: '2025-2026-2' },
  { id: 's6', courseName: 'C语言程序设计',  score: 82, gpa: 3.3, examDate: '2026-07-04', term: '2025-2026-2' },
  { id: 's7', courseName: '离散数学',       score: 75, gpa: 2.8, examDate: '2026-06-27', term: '2025-2026-2' },
  { id: 's8', courseName: 'Java程序设计',   score: 86, gpa: 3.6, examDate: '2026-07-01', term: '2025-2026-2' },
]

// ===== 默认待办 =====
const DEFAULT_TODOS: Todo[] = [
  { id: 't1', content: '完成高等数学第七章作业', category: 'study', remindTime: '2026-06-22 20:00', isCompleted: false, createdAt: '2026-06-21' },
  { id: 't2', content: '准备英语四级考试复习', category: 'study', remindTime: '2026-06-23 18:00', isCompleted: false, createdAt: '2026-06-21' },
  { id: 't3', content: '去图书馆还书', category: 'life', remindTime: '2026-06-22 16:00', isCompleted: false, createdAt: '2026-06-20' },
  { id: 't4', content: '参加社团活动', category: 'other', remindTime: '2026-06-24 19:00', isCompleted: false, createdAt: '2026-06-21' }
]

// ===== 默认失物招领 =====
const DEFAULT_LOSTFOUND: LostFoundItem[] = [
  {
    id: 'lf1', type: 'lost', itemName: '校园卡', category: 'campus_card',
    location: '教学楼A区', date: '2026-06-20', description: '蓝色校园卡，姓名：张XX',
    contactPhone: '138XXXX1234', imagePaths: [], createdAt: '2026-06-20'
  },
  {
    id: 'lf2', type: 'found', itemName: '黑色双肩包', category: 'bag',
    location: '图书馆二楼', date: '2026-06-19', description: '黑色双肩包，内有课本和文具',
    contactPhone: '139XXXX5678', imagePaths: [], createdAt: '2026-06-19'
  },
  {
    id: 'lf3', type: 'lost', itemName: '蓝牙耳机', category: 'electronic',
    location: '操场', date: '2026-06-18', description: '白色蓝牙耳机，品牌AirPods',
    contactPhone: '137XXXX9012', imagePaths: [], createdAt: '2026-06-18'
  },
  {
    id: 'lf4', type: 'found', itemName: '钥匙串', category: 'other',
    location: '一食堂', date: '2026-06-21', description: '一串钥匙，包含3把钥匙和一个小挂件',
    contactPhone: '136XXXX3456', imagePaths: [], createdAt: '2026-06-21'
  }
]

// ===== 默认天气 =====
const DEFAULT_CURRENT_WEATHER: CurrentWeather = { temperature: 25, condition: '晴', wind: '微风', city: '哈尔滨' }

const forecast1: WeatherForecast = { date: '2026-06-22', temperature: '23~28', condition: '晴' }
const forecast2: WeatherForecast = { date: '2026-06-23', temperature: '21~26', condition: '多云' }
const forecast3: WeatherForecast = { date: '2026-06-24', temperature: '20~25', condition: '阵雨' }
const DEFAULT_WEATHER_FORECAST: WeatherForecast[] = [forecast1, forecast2, forecast3]

const DEFAULT_WEATHER: WeatherData = {
  current: DEFAULT_CURRENT_WEATHER,
  forecast: DEFAULT_WEATHER_FORECAST
}

const DEFAULT_WEATHER_WRAPPER: WeatherWrapper = { data: DEFAULT_WEATHER }

/**
 * 初始化模拟数据
 * 检查 isFirstLaunch，首次启动时将所有模拟数据写入对应存储
 */
export async function initMockData(): Promise<void> {
  try {
    console.info('initMockData: writing mock data...')

    // 写入 JSON 文件数据
    await StorageManager.saveJsonFile('announcements', DEFAULT_ANNOUNCEMENTS)
    await StorageManager.saveJsonFile('books', DEFAULT_BOOKS)
    await StorageManager.saveJsonFile('songs', DEFAULT_SONGS)
    await StorageManager.saveJsonFile('food_items', DEFAULT_FOODS)
    await StorageManager.saveJsonFile('buildings', DEFAULT_BUILDINGS)
    await StorageManager.saveJsonFile('courses', DEFAULT_COURSES)
    await StorageManager.saveJsonFile('scores', DEFAULT_SCORES)
    await StorageManager.saveJsonFile('lost_found_items', DEFAULT_LOSTFOUND)
    await StorageManager.saveJsonFile('weather', [DEFAULT_WEATHER_WRAPPER])

    // 写入 Preferences 数据
    await StorageManager.savePref('todos', DEFAULT_TODOS)
    await StorageManager.savePref('favorites', [])

    console.info('initMockData: all mock data written successfully')
  } catch (err) {
    console.error(`initMockData error: ${JSON.stringify(err)}`)
  }
}
