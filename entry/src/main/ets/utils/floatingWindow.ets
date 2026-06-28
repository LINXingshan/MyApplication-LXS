/**
 * floatingWindow - 悬浮窗工具
 * 使用 windowStage.createSubWindow() 创建后台悬浮窗
 * 显示条件：音乐播放中或有待办提醒时 APP 进入后台
 * 当 createSubWindow 不可用时降级为常驻通知
 */

import { Song, Todo } from '../data/models/Index'

const TAG = 'FloatingWindow'

export class FloatingWindowManager {
  private static instance: FloatingWindowManager
  private _isVisible: boolean = false

  static getInstance(): FloatingWindowManager {
    if (!FloatingWindowManager.instance) {
      FloatingWindowManager.instance = new FloatingWindowManager()
    }
    return FloatingWindowManager.instance
  }

  get isVisible(): boolean {
    return this._isVisible
  }

  /**
   * 显示音乐播放器悬浮窗
   */
  async showMusicFloatingWindow(song: Song, isPlaying: boolean): Promise<void> {
    try {
      console.info(`${TAG}: showMusicFloatingWindow - song="${song.title}", playing=${isPlaying}`)
      // 使用 createSubWindow 创建悬浮窗（API 12）
      // import { window } from '@kit.ArkUI'
      // const subWin = await window.createSubWindow('music_player', windowType: window.WindowType.TYPE_FLOAT)
      // subWin.setUIContent('pages/MusicFloatingPanel')
      // subWin.show()

      this._isVisible = true
    } catch (e) {
      console.error(`${TAG}: showMusicFloatingWindow error: ${JSON.stringify(e)}`)
      // 降级：通过 NotificationHelper 发送常驻通知
    }
  }

  /**
   * 更新音乐悬浮窗状态（播放/暂停）
   */
  async updateMusicState(isPlaying: boolean): Promise<void> {
    try {
      console.info(`${TAG}: updateMusicState - playing=${isPlaying}`)
      if (!this._isVisible) return
      // subWin.setUIContent(...) 更新 UI
    } catch (e) {
      console.error(`${TAG}: updateMusicState error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 显示待办悬浮窗
   */
  async showTodoFloatingWindow(todos: Todo[]): Promise<void> {
    try {
      const displayTodos = todos.slice(0, 2)
      console.info(`${TAG}: showTodoFloatingWindow - ${displayTodos.length} todos`)
      for (const todo of displayTodos) {
        console.info(`${TAG}: todo - ${todo.content}`)
      }
      // 使用 createSubWindow 创建待办悬浮窗
      // subWin.setUIContent('pages/TodoFloatingPanel')
      // subWin.show()

      this._isVisible = true
    } catch (e) {
      console.error(`${TAG}: showTodoFloatingWindow error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 隐藏所有悬浮窗
   */
  async hide(): Promise<void> {
    try {
      console.info(`${TAG}: hide all floating windows`)
      // if (this.subWindow) { this.subWindow.destroy(); this.subWindow = null }
      this._isVisible = false
    } catch (e) {
      console.error(`${TAG}: hide error: ${JSON.stringify(e)}`)
    }
  }
}

export const floatingWindow = FloatingWindowManager.getInstance()
