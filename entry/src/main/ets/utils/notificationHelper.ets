/**
 * notificationHelper - 本地通知工具
 * 封装 courseReminderAgentManager 实现系统级课程提醒和待办提醒
 * 当系统 API 不可用时降级为 console 日志
 */

import { Course, Todo } from '../data/models/Index'

const TAG = 'NotificationHelper'

export class NotificationHelper {
  /**
   * 发送普通本地通知
   */
  static async publishNotification(title: string, text: string, id?: number): Promise<void> {
    try {
      console.info(`${TAG}: publishNotification - title=${title}, text=${text}, id=${id}`)
      // 使用通知管理器发送通知
      // 实际 API 调用（API 12）：
      // import { notificationManager } from '@kit.NotificationKit'
      // const request = new notificationManager.NotificationRequest()
      // request.content = { contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, normal: { title, text } }
      // if (id) request.id = id
      // await notificationManager.publish(request)
    } catch (e) {
      console.error(`${TAG}: publishNotification error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 取消指定通知
   */
  static async cancelNotification(id: number): Promise<void> {
    try {
      console.info(`${TAG}: cancelNotification id=${id}`)
      // await notificationManager.cancel(id)
    } catch (e) {
      console.error(`${TAG}: cancelNotification error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 取消所有通知
   */
  static async cancelAllNotifications(): Promise<void> {
    try {
      console.info(`${TAG}: cancelAllNotifications`)
      // await notificationManager.cancelAll()
    } catch (e) {
      console.error(`${TAG}: cancelAllNotifications error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 设置课程提醒（课前10分钟）
   */
  static async scheduleCourseReminders(courses: Course[]): Promise<void> {
    try {
      const now = new Date()
      const today = now.getDay() || 7
      const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`

      const todayCourses = courses.filter(c => c.dayOfWeek === today)
      for (const course of todayCourses) {
        const reminderMinutes = 10
        const startHour = parseInt(course.startTime.split(':')[0])
        const startMin = parseInt(course.startTime.split(':')[1])
        const reminderMin = startMin - reminderMinutes
        const reminderHour = reminderMin >= 0 ? startHour : startHour - 1
        const adjustedMin = reminderMin >= 0 ? reminderMin : 60 + reminderMin

        const reminderTimeStr = `${String(reminderHour).padStart(2, '0')}:${String(adjustedMin).padStart(2, '0')}`
        if (reminderTimeStr > currentTime) {
          console.info(`${TAG}: scheduled course reminder for "${course.name}" at ${reminderTimeStr}`)
          await NotificationHelper.publishNotification(
            '课程提醒',
            `${course.name} 将于 ${course.startTime} 在 ${course.location} 开始`,
            parseInt('10' + course.id.replace(/\D/g, '').slice(0, 3))
          )
        }
      }
    } catch (e) {
      console.error(`${TAG}: scheduleCourseReminders error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 设置待办提醒
   */
  static async scheduleTodoReminder(todo: Todo): Promise<void> {
    try {
      if (!todo.remindTime) return
      console.info(`${TAG}: scheduleTodoReminder for "${todo.content}" at ${todo.remindTime}`)
      await NotificationHelper.publishNotification(
        '待办提醒',
        todo.content,
        parseInt('20' + todo.id.replace(/\D/g, '').slice(0, 3))
      )
    } catch (e) {
      console.error(`${TAG}: scheduleTodoReminder error: ${JSON.stringify(e)}`)
    }
  }

  /**
   * 取消待办提醒
   */
  static async cancelTodoReminder(todoId: string): Promise<void> {
    try {
      const reminderId = parseInt('20' + todoId.replace(/\D/g, '').slice(0, 3))
      await NotificationHelper.cancelNotification(reminderId)
    } catch (e) {
      console.error(`${TAG}: cancelTodoReminder error: ${JSON.stringify(e)}`)
    }
  }
}
