/**
 * FavoriteRepository - 收藏数据访问层
 */

import { StorageManager } from '../utils/storage'
import { FavoriteItem } from '../models/Index'

const FILE_NAME = 'favorites'

export class FavoriteRepository {
  static async getFavorites(): Promise<FavoriteItem[]> {
    return await StorageManager.loadJsonFile<FavoriteItem>(FILE_NAME)
  }

  static async saveFavorites(items: FavoriteItem[]): Promise<void> {
    await StorageManager.saveJsonFile(FILE_NAME, items)
  }

  static async addFavorite(item: FavoriteItem): Promise<void> {
    const items = await this.getFavorites()
    items.push(item)
    await this.saveFavorites(items)
  }

  static async removeFavorite(itemId: string): Promise<void> {
    const items = await this.getFavorites()
    await this.saveFavorites(items.filter(i => i.id !== itemId))
  }
}
