/**
 * Index - 应用根入口
 * 首次启动: splash → guide → login → main
 * 非首次:   splash → login(已登录则main)
 */

import { SplashPage } from './SplashPage'
import { GuidePage } from './GuidePage'
import { LoginPage } from './LoginPage'
import { RegisterPage } from './RegisterPage'
import { MainPage } from './MainPage'

@Entry
@Component
struct Index {
  @StorageLink('isDarkMode') isDarkMode: boolean = false
  @State currentPage: string = 'splash'
  @State isFirst: boolean = true

  aboutToAppear(): void {
    AppStorage.setOrCreate('isDarkMode', false)
    AppStorage.setOrCreate('fontSize', '中')
    AppStorage.setOrCreate('currentTabIndex', 0)
  }

  onSplashEnd(): void {
    const logged = AppStorage.get<boolean>('isLoggedIn') ?? false
    if (logged) {
      // 已登录 → 直接进主页
      this.currentPage = 'main'
    } else {
      this.currentPage = 'guide'
    }
  }

  build() {
    if (this.currentPage === 'splash') {
      SplashPage({ onNext: () => { this.onSplashEnd() } })
    } else if (this.currentPage === 'guide') {
      GuidePage({ onFinish: () => { this.currentPage = 'login' } })
    } else if (this.currentPage === 'login') {
      LoginPage({
        onLoginSuccess: () => { this.currentPage = 'main' },
        onRegisterClick: () => { this.currentPage = 'register' }
      })
    } else if (this.currentPage === 'register') {
      RegisterPage({
        onRegisterSuccess: () => { this.currentPage = 'login' },
        onBackToLogin: () => { this.currentPage = 'login' }
      })
    } else if (this.currentPage === 'main') {
      MainPage({
        onLogout: () => { this.currentPage = 'login' }
      })
    }
  }
}
