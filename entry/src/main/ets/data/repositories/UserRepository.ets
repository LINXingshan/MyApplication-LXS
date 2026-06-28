/**
 * UserRepository - 用户数据访问层
 * 基于 Preferences 存取用户信息
 */

import { UserInfo } from '../models/Index'
import { StorageManager } from '../../utils/storage'

const USER_KEY = 'user_info'

export class UserRepository {
  /**
   * 获取用户信息
   */
  static async getUserInfo(): Promise<UserInfo | null> {
    return await StorageManager.loadPref<UserInfo>(USER_KEY)
  }

  /**
   * 保存用户信息
   */
  static async saveUserInfo(info: UserInfo): Promise<void> {
    await StorageManager.savePref(USER_KEY, info)
  }
}
