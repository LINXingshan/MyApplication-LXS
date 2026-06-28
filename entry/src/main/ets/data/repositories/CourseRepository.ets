/**
 * CourseRepository - 课程数据访问层
 * 封装课程数据的增删改查，底层使用 StorageManager JSON 文件存储
 */

import { StorageManager } from '../utils/storage'
import { Course } from '../models/Index'

const FILE_NAME = 'courses'

export class CourseRepository {
  static async getCourses(): Promise<Course[]> {
    return await StorageManager.loadJsonFile<Course>(FILE_NAME)
  }

  static async saveCourses(courses: Course[]): Promise<void> {
    await StorageManager.saveJsonFile(FILE_NAME, courses)
  }

  static async addCourse(course: Course): Promise<void> {
    const courses = await this.getCourses()
    courses.push(course)
    await this.saveCourses(courses)
  }

  static async deleteCourse(courseId: string): Promise<void> {
    const courses = await this.getCourses()
    await this.saveCourses(courses.filter(c => c.id !== courseId))
  }

  static async updateCourse(courseId: string, updated: Course): Promise<void> {
    const courses = await this.getCourses()
    const index = courses.findIndex(c => c.id === courseId)
    if (index >= 0) {
      courses[index] = updated
      await this.saveCourses(courses)
    }
  }
}
