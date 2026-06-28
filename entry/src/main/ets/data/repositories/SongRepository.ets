/**
 * SongRepository - 歌曲数据访问层
 */

import { StorageManager } from '../utils/storage'
import { Song } from '../models/Index'

const FILE_NAME = 'songs'

export class SongRepository {
  static async getSongs(): Promise<Song[]> {
    return await StorageManager.loadJsonFile<Song>(FILE_NAME)
  }

  static async saveSongs(songs: Song[]): Promise<void> {
    await StorageManager.saveJsonFile(FILE_NAME, songs)
  }
}
