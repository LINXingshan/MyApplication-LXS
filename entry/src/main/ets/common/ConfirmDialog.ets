/**
 * ConfirmDialog - 统一确认弹窗组件
 * 用于删除确认、清理缓存确认等场景
 * 使用 AlertDialog 实现统一样式
 */

import { COLOR_PRIMARY, COLOR_WARNING, COLOR_TEXT_SECONDARY, TYPO_H3, TYPO_B1 } from '../utils/constants'

export interface ConfirmDialogOptions {
  title: string
  message: string
  confirmText?: string
  cancelText?: string
  confirmColor?: string
  onConfirm?: () => void
  onCancel?: () => void
}

export class ConfirmDialog {
  static show(options: ConfirmDialogOptions): void {
    AlertDialog.show({
      title: options.title,
      message: options.message,
      autoCancel: true,
      alignment: DialogAlignment.Center,
      primaryButton: {
        value: options.cancelText || '取消',
        fontColor: COLOR_TEXT_SECONDARY,
        action: () => {
          options.onCancel?.()
        }
      },
      confirm: {
        value: options.confirmText || '确定',
        fontColor: options.confirmColor || COLOR_PRIMARY,
        action: () => {
          options.onConfirm?.()
        }
      }
    })
  }
}
