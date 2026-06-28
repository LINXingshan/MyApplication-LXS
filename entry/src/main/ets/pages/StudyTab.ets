/**
 * StudyTab - 学习助手 Tab
 * 课程表 / 成绩查询 / 图书馆检索 / 学习资料 四标签
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { CourseTable } from '../components/CourseTable'
import { Course, Score, Book } from '../data/models/Index'
import { FavoriteItem } from '../data/models/Index'
import { StorageManager } from '../utils/storage'
import { ROUTE, SIZE_BTN_SMALL_H, SIZE_ICON_FUNC, TYPO_PAGE_TITLE, TYPO_H3, TYPO_B1, TYPO_B2,
  RADIUS_COMPONENT, RADIUS_SEARCH, SPACING_SM, SPACING_MD, SPACING_LG }
  from '../utils/constants'
import { ThemeColors, ThemePalette } from '../utils/theme'

interface MaterialItem {
  name: string
  icon: string
  files: string[]
}

interface NavCourseParams {
  course: Course
}

@Component
export struct StudyTab {
  @StorageLink('isDarkMode') isDarkMode: boolean = false
  @State selectedTag: number = 0
  @State weekNumber: number = this.getCurrentWeek()
  @State courses: Course[] = []
  @State scores: Score[] = []
  @State books: Book[] = []
  @State favorites: FavoriteItem[] = []
  // 成绩查询
  @State queryId: string = ''
  @State queryPwd: string = ''
  @State showScores: boolean = false
  @State sortAsc: boolean = false
  // 图书搜索
  @State bookKeyword: string = ''
  @State bookResults: Book[] = []
  @State displayBooks: Book[] = []

  private tags: string[] = ['课程表', '成绩查询', '图书馆检索', '学习资料']

  theme(): ThemePalette { return ThemeColors.get(this.isDarkMode) }

  aboutToAppear(): void { this.loadAllData(); this.checkLibraryNav() }

  getCurrentWeek(): number {
    // 简易周次计算（2026年春季学期第1周始于3月2日）
    const start = new Date('2026-03-02')
    const now = new Date()
    const diffDays = Math.floor((now.getTime() - start.getTime()) / (1000 * 3600 * 24))
    return Math.max(1, Math.min(20, Math.ceil((diffDays + 1) / 7)))
  }

  get weekCourses(): Course[] {
    return this.courses.filter(c => c.weeks.includes(this.weekNumber))
  }
  async loadAllData(): Promise<void> {
    this.courses = await StorageManager.loadJsonFile<Course>('courses')
    this.scores = [
      { id: 's1', courseName: '高等数学（二）', score: 92, gpa: 4.0, examDate: '2026-06-28', term: '2025-2026-2' } as Score,
      { id: 's2', courseName: '大学英语（四）', score: 85, gpa: 3.5, examDate: '2026-06-26', term: '2025-2026-2' } as Score,
      { id: 's3', courseName: '数据结构', score: 88, gpa: 3.7, examDate: '2026-07-02', term: '2025-2026-2' } as Score,
      { id: 's4', courseName: '线性代数', score: 78, gpa: 3.0, examDate: '2026-06-25', term: '2025-2026-2' } as Score,
      { id: 's5', courseName: '大学物理（上）', score: 90, gpa: 3.9, examDate: '2026-06-30', term: '2025-2026-2' } as Score,
      { id: 's6', courseName: 'C语言程序设计', score: 82, gpa: 3.3, examDate: '2026-07-04', term: '2025-2026-2' } as Score,
      { id: 's7', courseName: '离散数学', score: 75, gpa: 2.8, examDate: '2026-06-27', term: '2025-2026-2' } as Score,
      { id: 's8', courseName: 'Java程序设计', score: 86, gpa: 3.6, examDate: '2026-07-01', term: '2025-2026-2' } as Score,
    ]
    this.books = await StorageManager.loadJsonFile<Book>('books')
    const db: Book[] = []; for (let i = 0; i < this.books.length; i++) db.push(this.books[i]); this.displayBooks = db
    this.favorites = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    this.showScores = false
  }

  checkLibraryNav(): void { if (AppStorage.get<boolean>('gotoLibrary')) { this.selectedTag = 2; AppStorage.setOrCreate('gotoLibrary', false) } }

  sortedScores(): Score[] {
    const copy: Score[] = []; for (let i = 0; i < this.scores.length; i++) copy.push(this.scores[i]); return copy.sort((a, b) => this.sortAsc ? a.gpa - b.gpa : b.gpa - a.gpa)
  }

  searchBooks(): void {
    const kw = this.bookKeyword.trim().toLowerCase()
    this.bookResults = this.books.filter(b =>
      b.title.toLowerCase().includes(kw) ||
      b.author.toLowerCase().includes(kw) ||
      b.isbn.includes(kw)
    )
    const db: Book[] = []; for (let i = 0; i < this.bookResults.length; i++) db.push(this.bookResults[i]); this.displayBooks = db
  }



  isBookFavorited(bookId: string): boolean {
    return this.favorites.some(f => f.sourceId === bookId && f.type === 'book')
  }

  async toggleBookFavorite(book: Book): Promise<void> {
    const favs = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    if (this.isBookFavorited(book.id)) {
      await StorageManager.saveJsonFile('favorites', favs.filter(f => f.sourceId !== book.id || f.type !== 'book'))
      this.favorites = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    } else {
      favs.push({
        id: `fav_book_${book.id}`, type: 'book', title: book.title,
        summary: book.author, imagePath: book.coverPath, sourceId: book.id,
        createdAt: new Date().toISOString().split('T')[0]
      })
      await StorageManager.saveJsonFile('favorites', favs)
      this.favorites = await StorageManager.loadJsonFile<FavoriteItem>('favorites')
    }
  }

  @Builder
  CourseTableView() {
    Column() {
      // 周次选择
      Row() {
        Text('\u2190 上一周')
          .fontSize(TYPO_B2.fontSize).fontColor(this.theme().primary)
          .onClick(() => { if (this.weekNumber > 1) this.weekNumber-- })
        Text(`2026年第${this.weekNumber}周`)
          .fontSize(TYPO_B2.fontSize).fontColor(this.theme().textPrimary).fontWeight(FontWeight.Medium)
          .layoutWeight(1).textAlign(TextAlign.Center)
        Text('下一周 \u2192')
          .fontSize(TYPO_B2.fontSize).fontColor(this.theme().primary)
          .onClick(() => { if (this.weekNumber < 20) this.weekNumber++ })
      }
      .width('95%').padding({ top: SPACING_SM, bottom: SPACING_SM }).alignSelf(ItemAlign.Center)

      // 课程表
      Scroll() {
        CourseTable({
          weekNumber: this.weekNumber,
          courses: $courses,
          onCourseClick: (course: Course) => {
            const navParams: NavCourseParams = { course: course }
            router.pushUrl({ url: ROUTE.COURSE_DETAIL, params: navParams })
          }
        })
      }
      .width('100%').layoutWeight(1)

      // 编辑按钮
      Button('编辑课程表')
        .width('60%').height(SIZE_BTN_SMALL_H).borderRadius(RADIUS_COMPONENT)
        .backgroundColor(this.theme().primary).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textOnPrimary)
        .alignSelf(ItemAlign.Center).margin({ bottom: SPACING_MD })
        .onClick(() => { router.pushUrl({ url: ROUTE.COURSE_EDIT }) })
    }
    .width('100%').layoutWeight(1)
  }

  @Builder
  ScoreQueryView() {
    Column() {
      Row() {
        TextInput({ placeholder: '请输入学号', text: this.queryId })
          .layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize)
          .borderRadius(8).backgroundColor(this.theme().cardBg).margin({ right: SPACING_SM })
          .onChange((v: string) => { this.queryId = v })
        TextInput({ placeholder: '请输入密码', text: this.queryPwd })
          .layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize)
          .borderRadius(8).backgroundColor(this.theme().cardBg)
          .type(InputType.Password).onChange((v: string) => { this.queryPwd = v })
      }
      .width('95%').padding({ top: SPACING_SM })

      Row() {
        Button('查询')
          .height(32).borderRadius(8).backgroundColor(this.theme().primary).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textOnPrimary)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            if (this.queryId.trim() && this.queryPwd.trim()) {
              this.showScores = true
            } else {
              promptAction.showToast({ message: '请输入学号和密码', duration: 1500 })
            }
          })

        if (this.showScores) {
          Button('刷新成绩').height(32).borderRadius(8).backgroundColor(this.theme().bg).fontSize(TYPO_B2.fontSize).fontColor(this.theme().primary)
            .padding({ left: 12, right: 12 }).margin({ left: SPACING_SM })
            .onClick(() => { this.loadAllData() })
        }
      }
      .width('95%').padding({ top: SPACING_SM, bottom: SPACING_SM }).justifyContent(FlexAlign.SpaceBetween)

      if (!this.showScores) {
        Column() {
          Text('\uD83D\uDCCA').fontSize(48)
          Text('请输入学号密码查询').fontSize(TYPO_B1.fontSize).fontColor(this.theme().textSecondary).margin({ top: SPACING_SM })
        }
        .width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        // 排序按钮
        Row() {
          Button(`按绩点排序 ${this.sortAsc ? '↑' : '↓'}`)
            .height(28).borderRadius(8).backgroundColor(this.theme().primary).fontSize(22).fontColor(this.theme().textOnPrimary)
            .padding({ left: 10, right: 10 }).onClick(() => { this.sortAsc = !this.sortAsc })
        }.width('95%').padding({ bottom: 8 })

        // 成绩列表
        List() {
          ForEach(this.sortedScores(), (s: Score) => {
            ListItem() {
              Row() {
                Column() {
                  Text(s.courseName).fontSize(TYPO_H3.fontSize).fontColor(this.theme().textPrimary)
                  Text(s.examDate).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary).margin({ top: 2 })
                }.alignItems(HorizontalAlign.Start).layoutWeight(1)

                Column() {
                  Text(`${s.score}`).fontSize(26).fontWeight(FontWeight.Bold).fontColor(this.theme().primary)
                  Text(`绩点 ${s.gpa.toFixed(1)}`).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary).margin({ top: 2 })
                }.alignItems(HorizontalAlign.End)
              }.width('100%').padding(SPACING_SM)
            }.backgroundColor(this.theme().cardBg).margin({ left: SPACING_MD, right: SPACING_MD, bottom: 1 }).borderRadius(8)
          })
        }.width('100%').layoutWeight(1)
      }
    }
    .width('100%').layoutWeight(1)
  }

  @Builder
  BookSearchView() {
    Column() {
      Row() {
        TextInput({ placeholder: '请输入图书名称/作者/ISBN', text: this.bookKeyword })
          .layoutWeight(1).height(40).fontSize(TYPO_B2.fontSize)
          .borderRadius(RADIUS_SEARCH).backgroundColor(this.theme().cardBg)
          .padding({ left: SPACING_SM }).onChange((v: string) => { this.bookKeyword = v })
        Button('搜索').height(32).borderRadius(8).backgroundColor(this.theme().primary).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textOnPrimary)
          .padding({ left: 12, right: 12 }).margin({ left: SPACING_SM })
          .onClick(() => { this.searchBooks() })
      }
      .width('95%').padding({ top: SPACING_SM, bottom: SPACING_SM }).alignSelf(ItemAlign.Center)

      List() {
        ForEach(this.displayBooks, (book: Book) => {
          ListItem() {
            Row() {
              Column() {
                Text('\uD83D\uDCDA').fontSize(36).fontColor(this.theme().textSecondary)
              }.width(64).height(64).borderRadius(4).backgroundColor(this.theme().bg).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)

              Column() {
                Text(book.title).fontSize(TYPO_H3.fontSize).fontColor(this.theme().textPrimary).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(`${book.author} / ${book.publisher}`).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary).margin({ top: 4 })
                Text(`${book.location}`).fontSize(TYPO_B2.fontSize - 2).fontColor(this.theme().textSecondary).margin({ top: 2 })
                Text(`剩余 ${book.availableCount} 册`).fontSize(TYPO_B2.fontSize - 2).fontColor(this.theme().primary).margin({ top: 2 })
              }.alignItems(HorizontalAlign.Start).layoutWeight(1).margin({ left: SPACING_SM })

              Text(this.isBookFavorited(book.id) ? '\u2764\uFE0F' : '\u2661')
                .fontSize(24).fontColor(this.isBookFavorited(book.id) ? this.theme().primary : this.theme().textSecondary)
                .onClick(() => { this.toggleBookFavorite(book) })
            }.width('100%').padding(SPACING_SM)
            .onClick(() => { router.pushUrl({ url: ROUTE.BOOK_DETAIL, params: { id: book.id } }) })
          }.backgroundColor(this.theme().cardBg).margin({ left: SPACING_MD, right: SPACING_MD, bottom: 1 }).borderRadius(8)
        })
      }.width('100%').layoutWeight(1)
    }
    .width('100%').layoutWeight(1)
  }

  @Builder
  LearningMaterialsView() {
    Column() {
      Scroll() {
        Column() {
          ForEach([
            { name: '高等数学课件', icon: '\uD83D\uDCD0', files: ['第一章 函数与极限.pdf', '第二章 导数与微分.pdf'] } as MaterialItem,
            { name: '程序设计作业', icon: '\uD83D\uDCBB', files: ['实验一 C语言基础.doc', '实验二 数组与指针.doc'] } as MaterialItem,
            { name: '英语四级真题', icon: '\uD83D\uDCDC', files: ['2024年6月真题.pdf', '2024年12月真题.pdf'] } as MaterialItem,
            { name: '思政课资料', icon: '\uD83D\uDCD6', files: ['毛概复习提纲.docx', '时政热点汇总.pdf'] } as MaterialItem
          ], (item: MaterialItem, index: number) => {
            Column() {
              Row() {
                Text(item.icon).fontSize(SIZE_ICON_FUNC)
                Column() {
                  Text(item.name).fontSize(TYPO_H3.fontSize).fontColor(this.theme().textPrimary)
                  Text(`${item.files.length} 个文件`).fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary).margin({ top: 2 })
                }.alignItems(HorizontalAlign.Start).layoutWeight(1).margin({ left: SPACING_SM })
                Text('>').fontSize(TYPO_B2.fontSize).fontColor(this.theme().textSecondary)
              }.width('100%').padding(SPACING_SM)
              .onClick(() => {
                AlertDialog.show({
                  title: item.name,
                  message: item.files.join('\n'),
                  confirm: { value: '知道了', fontColor: this.theme().primary, action: () => {} }
                })
              })
            }
            .width('90%').borderRadius(RADIUS_COMPONENT).backgroundColor(this.theme().cardBg)
            .alignSelf(ItemAlign.Center).margin({ bottom: SPACING_SM })
          })
        }.width('100%').padding({ top: SPACING_MD })
      }
      .width('100%').layoutWeight(1)
    }
    .width('100%').layoutWeight(1)
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Text('学习助手')
          .fontSize(TYPO_PAGE_TITLE.fontSize).fontWeight(TYPO_PAGE_TITLE.fontWeight).fontColor(this.theme().textPrimary)
      }
      .width('100%').height(56).backgroundColor(this.theme().cardBg).padding({ left: SPACING_MD })

      // 4标签平分宽度
      Row() {
        ForEach(this.tags, (tag: string, index: number) => {
          Column() {
            Text(tag)
              .fontSize(TYPO_B2.fontSize)
              .fontColor(this.selectedTag === index ? this.theme().primary : this.theme().textSecondary)
              .fontWeight(this.selectedTag === index ? FontWeight.Medium : FontWeight.Normal)
              .padding({ bottom: 8 })

            if (this.selectedTag === index) {
              Divider().width(30).height(2).color(this.theme().primary)
            }
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Center)
          .onClick(() => { this.selectedTag = index })
        })
      }
      .width('100%').backgroundColor(this.theme().cardBg).padding({ top: 4 })

      // 内容区
      if (this.selectedTag === 0) { this.CourseTableView() }
      else if (this.selectedTag === 1) { this.ScoreQueryView() }
      else if (this.selectedTag === 2) { this.BookSearchView() }
      else { this.LearningMaterialsView() }
    }
  }
}
