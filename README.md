# 高校校园助手 🎓

> 基于 HarmonyOS NEXT（API 24）开发的智慧校园综合服务平台

**高校校园助手** 是一款面向大学生的全功能校园服务应用，整合校园资讯、学习工具、生活服务三大核心场景，提供一站式的智慧校园体验。

---


## 📱 应用截图

| 引导页 | 登录页 | 首页 | 学习助手 |
|--------|--------|------|----------|
| (3屏滑动引导) | (学号/密码登录) | (校园动态) | (课表/成绩) |

---

## ✨ 功能特性

### 🏠 首页模块
- **校园公告** — 最新通知与公告列表
- **快捷入口** — 常用功能一键直达
- **资讯推荐** — 校园新闻与活动推荐
- **搜索功能** — 全局搜索（课程、公告、美食、失物等）

### 🏫 校园信息
- **校园地图** — 教学楼/宿舍/食堂等建筑标注与导航
- **资讯中心** — 校园新闻详情查看
- **失物招领** — 失物发布与认领

### 📚 学习助手
- **课表管理** — 周课表展示与课程编辑（增删改）
- **成绩查询** — 学期成绩查看
- **图书馆** — 图书检索与详情

### 🍔 生活服务
- **校园美食** — 食堂/商家列表与菜品详情
- **音乐电台** — 内置音乐播放器（播放/暂停/上一首/下一首）
- **待办事项** — Todo 清单管理

### 👤 个人中心
- **个人资料** — 头像上传、昵称/学院/专业编辑
- **收藏夹** — 收藏的课程/图书/美食
- **我的课程** — 已选课程列表
- **我的成绩** — 个人成绩总览
- **我的失物** — 发布的失物记录
- **消息中心** — 系统消息
- **设置** — 深色模式切换、通知管理、关于、意见反馈

---

## 🛠️ 技术栈

| 层面 | 技术 |
|------|------|
| 语言 | ArkTS（HarmonyOS 原生声明式 UI） |
| 框架 | Stage 模型 + @Entry 组件化架构 |
| 构建工具 | hvigor（DevEco Studio） |
| SDK 版本 | HarmonyOS NEXT API 24（6.1.1） |
| 状态管理 | AppStorage 全局状态 + @State 本地状态 |
| 路由 | 自定义 routerConfig（slide 动画路由） |
| 数据持久化 | @ohos.data.preferences（键值存储） |
| 测试框架 | @ohos/hypium + @ohos/hamock |
| 打包格式 | HAP（HarmonyOS Ability Package） |

---

## 📁 项目结构

```
MyApplication/
├── AppScope/                          # 应用级配置
│   └── resources/base/               # 应用图标、名称、版本信息
│
├── entry/                             # 主入口模块
│   └── src/main/ets/
│       ├── entryability/              # 应用生命周期（EntryAbility）
│       ├── entrybackupability/        # 备份能力
│       ├── pages/                     # 页面层（29个页面）
│       │   ├── Index.ets              # 导航状态机（入口）
│       │   ├── SplashPage.ets         # 启动页（3秒倒计时）
│       │   ├── GuidePage.ets          # 引导页（3屏滑动）
│       │   ├── LoginPage.ets          # 登录页
│       │   ├── RegisterPage.ets       # 注册页
│       │   ├── MainPage.ets           # 主页容器（5 Tab）
│       │   ├── HomeTab.ets            # 首页
│       │   ├── CampusInfoTab.ets      # 校园信息
│       │   ├── StudyTab.ets           # 学习助手
│       │   ├── LifeTab.ets            # 生活服务
│       │   ├── MineTab.ets            # 个人中心
│       │   └── ...                    # 其他详情/子页面
│       │
│       ├── components/                # 可复用组件（9个）
│       │   ├── CustomTabBar.ets       # 自定义 TabBar
│       │   ├── CourseTable.ets        # 课表组件
│       │   ├── SearchBar.ets          # 搜索栏
│       │   ├── InfoCard.ets           # 信息卡片
│       │   ├── StarRating.ets         # 星级评分
│       │   ├── AvatarUpload.ets       # 头像上传
│       │   ├── TagBar.ets             # 标签栏
│       │   ├── FluidParticleBg.ets    # 粒子动效背景
│       │   └── CommonComponents.ets   # 通用小组件
│       │
│       ├── data/                      # 数据层
│       │   ├── mockData.ets           # 模拟数据
│       │   ├── models/Index.ets       # 数据模型定义
│       │   └── repositories/          # 仓储层（数据访问）
│       │       ├── UserRepository.ets
│       │       ├── CourseRepository.ets
│       │       ├── ScoreRepository.ets
│       │       ├── FoodRepository.ets
│       │       ├── SongRepository.ets
│       │       ├── LostFoundRepository.ets
│       │       ├── FavoriteRepository.ets
│       │       ├── TodoRepository.ets
│       │
│       └── utils/                     # 工具层
│           ├── constants.ets          # 全局常量（颜色/字体/间距）
│           ├── routerConfig.ets       # 路由工具
│           ├── storage.ets            # 存储工具类
│           ├── theme.ets              # 主题切换
│           ├── notificationHelper.ets # 通知辅助
│           ├── floatingWindow.ets     # 悬浮窗
│           └── audioPlayer.ets        # 音频播放器
│
├── hvigor/                            # 构建配置
├── build-profile.json5                # 项目级构建配置
├── oh-package.json5                   # OHPM 包依赖
└── code-linter.json5                  # 代码规范配置
```

---

## 🚀 快速开始

### 环境要求

- **DevEco Studio** 5.0+（推荐最新版）
- **HarmonyOS SDK** API 24（6.1.1+）
- **Node.js** 18+
- **ohpm**（OpenHarmony 包管理器，随 DevEco Studio 内置）

### 运行步骤

```bash
# 1. 克隆项目
git clone <repository-url>

# 2. 使用 DevEco Studio 打开项目根目录
#    注意：项目实际代码位于 MyApplication/MyApplication/

# 3. 安装依赖（在 DevEco Studio Terminal 中执行）
cd MyApplication
ohpm install

# 4. 构建与运行
#    连接 HarmonyOS 设备或启动模拟器
#    点击 DevEco Studio 工具栏的 ▶ Run 按钮
```

### 命令行构建

```bash
# 调试构建
hvigorw assembleHap --mode debug

# 发布构建
hvigorw assembleHap --mode release
```

---

## 🧭 导航流程

```
启动 App
   │
   ├─ 首次启动 ──→ SplashPage ──→ GuidePage ──→ LoginPage ──→ MainPage
   │                                          ↕           │
   │                                      RegisterPage     │
   │                                                        │
   └─ 非首次启动 ──→ SplashPage ──→ LoginPage ──→ MainPage
                                   (已登录则跳过)
                                              │
                                              └─ 退出登录 ──→ LoginPage
```

---

## 🏗️ 架构设计

### 页面驱动模式

使用 `Index.ets` 作为中央导航状态机，通过 `currentPage` 字符串状态驱动页面切换：

```
' splash ' → ' guide ' → ' login ' ↔ ' register '
                                        ↓
                                   ' main ' (含 5 Tab)
```

### 数据流

```
UI 组件（@State）
    ↕  双向绑定
页面逻辑（事件处理）
    ↓  调用
Repository 层（数据访问）
    ↓  读写
StorageManager（@ohos.data.preferences 持久化）
```

### 主题系统

支持浅色/深色模式切换，通过 `AppStorage` 全局状态 `isDarkMode` 驱动，主题色值定义在 `constants.ets` 中。

---

## 🧪 测试

```bash
# 运行单元测试（在 DevEco Studio 中）
# 测试文件位于：
# - entry/src/main/ohosTest/  (Instrumentation Test)
# - entry/src/main/test/      (Local Unit Test)
```

---

## 📄 许可证

本项目仅供学习交流使用。

## 👥 贡献

欢迎提交 Issue 和 Pull Request 来完善功能。

---

> **注：** 本项目为 HarmonyOS NEXT 教学/演示项目，部分数据使用本地模拟数据，未接入真实后端服务。
