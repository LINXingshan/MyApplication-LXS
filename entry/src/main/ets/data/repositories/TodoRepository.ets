/**
 * TodoRepository - 待办数据访问层
 * 完整 CRUD + 批量操作，底层使用 Preferences 存储
 */

import { StorageManager } from '../utils/storage'
import { Todo } from '../models/Index'

const STORAGE_KEY = 'todos'

export class TodoRepository {
  static async getTodos(): Promise<Todo[]> {
    return (await StorageManager.loadPref<Todo[]>(STORAGE_KEY)) || []
  }

  static async saveTodos(todos: Todo[]): Promise<void> {
    await StorageManager.savePref(STORAGE_KEY, todos)
  }

  static async addTodo(todo: Todo): Promise<void> {
    const todos = await this.getTodos()
    todos.push(todo)
    await this.saveTodos(todos)
  }

  static async updateTodo(todoId: string, updated: Partial<Todo>): Promise<void> {
    const todos = await this.getTodos()
    const index = todos.findIndex(t => t.id === todoId)
    if (index >= 0) {
      todos[index] = { ...todos[index], ...updated }
      await this.saveTodos(todos)
    }
  }

  static async deleteTodo(todoId: string): Promise<void> {
    const todos = await this.getTodos()
    await this.saveTodos(todos.filter(t => t.id !== todoId))
  }

  static async batchComplete(todoIds: string[]): Promise<void> {
    const todos = await this.getTodos()
    for (const id of todoIds) {
      const t = todos.find(t => t.id === id)
      if (t) t.isCompleted = true
    }
    await this.saveTodos(todos)
  }

  static async batchDelete(todoIds: string[]): Promise<void> {
    const todos = await this.getTodos()
    await this.saveTodos(todos.filter(t => !todoIds.includes(t.id)))
  }
}
