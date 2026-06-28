/**
 * RegisterPage - 注册页
 * 学号/验证码/密码注册
 */

import { promptAction } from '@kit.ArkUI'
import { StorageManager } from '../utils/storage'
import { UserRepository } from '../data/repositories/UserRepository'
import { UserInfo } from '../data/models/Index'

@Entry
@Component
export struct RegisterPage {
  onRegisterSuccess?: () => void
  onBackToLogin?: () => void
  @State account: string = ''
  @State code: string = ''
  @State password: string = ''

  build() {
    Stack() {
      // 白色背景
      Column().width('100%').height('100%').backgroundColor('#FFFFFF')

      // 前景内容
      Column() {
        Text('注册新账号 ✨').fontSize(28).fontWeight(FontWeight.Bold).fontColor('#1D2129')
          .width('88%').margin({ top: 60, bottom: 8 })
        Text('加入高校校园助手，开启智慧校园之旅').fontSize(14).fontColor('rgba(0,0,0,0.5)')
          .width('88%').margin({ bottom: 36 })

        Column() {
          TextInput({ placeholder: '请输入学号', text: this.account })
            .width('100%').height(48).backgroundColor('#F5F7FA').borderRadius(8).fontSize(16)
            .fontColor('#1D2129').placeholderColor('rgba(0,0,0,0.35)')
            .margin({ bottom: 16 }).onChange((v: string) => { this.account = v })

          Row() {
            TextInput({ placeholder: '输入验证码', text: this.code })
              .height(48).backgroundColor('#F5F7FA').borderRadius(8).fontSize(16)
              .fontColor('#1D2129').placeholderColor('rgba(0,0,0,0.35)').layoutWeight(1)
              .onChange((v: string) => { this.code = v })
            Button('获取验证码').fontSize(13).fontColor('#FFFFFF').backgroundColor('rgba(22,119,255,0.6)')
              .borderRadius(8).height(48).padding({ left: 12, right: 12 }).margin({ left: 10 })
              .onClick(() => { promptAction.showToast({ message: '验证码已发送(模拟)', duration: 1500 }) })
          }.width('100%').margin({ bottom: 16 })

          TextInput({ placeholder: '设置密码(6-20位)', text: this.password }).type(InputType.Password)
            .width('100%').height(48).backgroundColor('#F5F7FA').borderRadius(8).fontSize(16)
            .fontColor('#1D2129').placeholderColor('rgba(0,0,0,0.35)')
            .margin({ bottom: 24 }).onChange((v: string) => { this.password = v })

          Button('注 册').fontSize(17).fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF').backgroundColor('#1677FF').borderRadius(8).width('100%').height(48)
            .onClick(async () => {
              if (!this.account) { promptAction.showToast({ message: '请输入学号', duration: 1500 }); return }
              if (!this.code) { promptAction.showToast({ message: '请输入验证码', duration: 1500 }); return }
              if (this.password.length < 6) { promptAction.showToast({ message: '密码至少6位', duration: 1500 }); return }
              const info: UserInfo = { avatarPath:'', nickname:'同学', studentId:this.account.trim(), college:'计算机学院', major:'软件工程', password:this.password }
              await UserRepository.saveUserInfo(info)
              await StorageManager.savePref('saved_student_id', this.account.trim())
              promptAction.showToast({ message: '注册成功', duration: 1500 })
              setTimeout(() => { if (this.onRegisterSuccess) this.onRegisterSuccess() }, 500)
            }).margin({ bottom: 20 })
        }.width('88%')

        Blank()
        Row() {
          Text('已有账号？').fontSize(14).fontColor('rgba(0,0,0,0.45)')
          Text('直接登录').fontSize(14).fontColor('#1677FF').fontWeight(FontWeight.Medium)
            .onClick(() => { if (this.onBackToLogin) this.onBackToLogin() })
        }.margin({ bottom: 40 })
      }.width('100%').height('100%')
    }.width('100%').height('100%')
  }
}
