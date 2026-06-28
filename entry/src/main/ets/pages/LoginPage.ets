/**
 * LoginPage - 登录页
 * 记住学号快捷登录
 */

import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { UserRepository } from '../data/repositories/UserRepository'
import { UserInfo } from '../data/models/Index'

@Entry
@Component
export struct LoginPage {
  onLoginSuccess?: () => void
  onRegisterClick?: () => void
  @State account: string = ''
  @State password: string = ''

  async aboutToAppear(): Promise<void> {
    const saved = await StorageManager.loadPref<string>('saved_student_id')
    if (saved) this.account = saved
  }

  build() {
    Stack() {
      // 白色背景
      Column().width('100%').height('100%').backgroundColor('#FFFFFF')

      // 前景内容
      Column() {
        Text('欢迎回来 👋').fontSize(28).fontWeight(FontWeight.Bold).fontColor('#1D2129')
          .width('88%').margin({ top: 80, bottom: 40 })

        Column() {
          TextInput({ placeholder: '请输入账号/学号', text: this.account })
            .width('100%').height(48).backgroundColor('#F5F7FA').borderRadius(8).fontSize(16)
            .fontColor('#1D2129').placeholderColor('rgba(0,0,0,0.35)')
            .margin({ bottom: 16 }).onChange((v: string) => { this.account = v })

          TextInput({ placeholder: '请输入密码', text: this.password }).type(InputType.Password)
            .width('100%').height(48).backgroundColor('#F5F7FA').borderRadius(8).fontSize(16)
            .fontColor('#1D2129').placeholderColor('rgba(0,0,0,0.35)')
            .margin({ bottom: 24 }).onChange((v: string) => { this.password = v })

          Button('登 录').fontSize(17).fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF').backgroundColor('#1677FF').borderRadius(8).width('100%').height(48)
            .onClick(async () => {
              if (!this.account) { promptAction.showToast({ message: '请输入账号或学号', duration: 1500 }); return }
              if (!this.password) { promptAction.showToast({ message: '请输入密码', duration: 1500 }); return }
              const info: UserInfo = { avatarPath:'', nickname:'同学', studentId:this.account.trim(), college:'计算机学院', major:'软件工程', password:this.password }
              await UserRepository.saveUserInfo(info)
              await StorageManager.savePref('saved_student_id', this.account.trim())
              AppStorage.setOrCreate('isLoggedIn', true)
              AppStorage.setOrCreate('isFirstLaunch', false)
              promptAction.showToast({ message: '登录成功', duration: 1500 })
              setTimeout(() => { if (this.onLoginSuccess) this.onLoginSuccess() }, 500)
            }).margin({ bottom: 30 })
        }.width('88%')

        Text('—— 其他登录方式 ——').fontSize(12).fontColor('rgba(0,0,0,0.3)').margin({ bottom: 20 })
        Row() {
          Column() { Circle().width(48).height(48).fill('rgba(0,0,0,0.06)'); Text('ⓦ').fontSize(22).fontColor('#1D2129') }.margin({ left: 30, right: 30 })
          Column() { Circle().width(48).height(48).fill('rgba(0,0,0,0.06)'); Text('ⓠ').fontSize(22).fontColor('#1D2129') }
        }.margin({ bottom: 20 })

        Blank()
        Row() {
          Text('还没有账号？').fontSize(14).fontColor('rgba(0,0,0,0.45)')
          Text('立即注册').fontSize(14).fontColor('#1677FF').fontWeight(FontWeight.Medium)
            .onClick(() => { if (this.onRegisterClick) this.onRegisterClick() })
        }.margin({ bottom: 40 })
      }.width('100%').height('100%')
    }.width('100%').height('100%')
  }
}
