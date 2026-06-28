/**
 * FoodRepository - 校园美食数据访问层
 */

import { StorageManager } from '../utils/storage'
import { FoodItem } from '../models/Index'

const FILE_NAME = 'food_items'

export class FoodRepository {
  static async getFoods(): Promise<FoodItem[]> {
    return await StorageManager.loadJsonFile<FoodItem>(FILE_NAME)
  }

  static async saveFoods(foods: FoodItem[]): Promise<void> {
    await StorageManager.saveJsonFile(FILE_NAME, foods)
  }
}
