/**
 * ScoreRepository - 成绩数据访问层
 */

import { StorageManager } from '../utils/storage'
import { Score } from '../models/Index'

const FILE_NAME = 'scores'

export class ScoreRepository {
  static async getScores(): Promise<Score[]> {
    return await StorageManager.loadJsonFile<Score>(FILE_NAME)
  }

  static async saveScores(scores: Score[]): Promise<void> {
    await StorageManager.saveJsonFile(FILE_NAME, scores)
  }
}
