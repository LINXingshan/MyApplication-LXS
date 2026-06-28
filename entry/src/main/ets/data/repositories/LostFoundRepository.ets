/**
 * LostFoundRepository - 失物招领数据访问层
 */

import { StorageManager } from '../utils/storage'
import { LostFoundItem } from '../models/Index'

const FILE_NAME = 'lost_found_items'

export class LostFoundRepository {
  static async getItems(): Promise<LostFoundItem[]> {
    return await StorageManager.loadJsonFile<LostFoundItem>(FILE_NAME)
  }

  static async saveItems(items: LostFoundItem[]): Promise<void> {
    await StorageManager.saveJsonFile(FILE_NAME, items)
  }
}
