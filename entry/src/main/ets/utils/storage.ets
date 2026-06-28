/**
 * StorageManager - 统一存储工具类
 * 封装 Preferences 读写、JSON 文件读写、本地文件操作、缓存管理
 */

import preferences from '@ohos.data.preferences'
import util from '@ohos.util'
import fileIo from '@ohos.file.fs'
import common from '@ohos.app.ability.common'

const STORE_NAME = 'campus_assistant_store'
const JSON_DIR = 'json_data'

/**
 * 获取应用上下文
 */
function getAppContext(): common.Context | undefined {
  return AppStorage.get<common.Context>('appContext')
}

// ===== Preferences =====

export class StorageManager {
  /**
   * 保存数据到 Preferences
   */
  static async savePref<T>(key: string, value: T): Promise<void> {
    try {
      const context = getAppContext()
      if (!context) {
        console.error('StorageManager: appContext not found')
        return
      }
      const prefs = await preferences.getPreferences(context, STORE_NAME)
      await prefs.put(key, JSON.stringify(value))
      await prefs.flush()
      console.info(`StorageManager: savePref success, key=${key}`)
    } catch (e) {
      console.error(`StorageManager: savePref error, key=${key}, err=${JSON.stringify(e)}`)
    }
  }

  /**
   * 从 Preferences 读取数据
   */
  static async loadPref<T>(key: string): Promise<T | null> {
    try {
      const context = getAppContext()
      if (!context) {
        console.error('StorageManager: appContext not found')
        return null
      }
      const prefs = await preferences.getPreferences(context, STORE_NAME)
      const val = await prefs.get(key, '') as string
      if (val === '') {
        return null
      }
      return JSON.parse(val) as T
    } catch (e) {
      console.error(`StorageManager: loadPref error, key=${key}, err=${JSON.stringify(e)}`)
      return null
    }
  }

  /**
   * 删除 Preferences 中的键
   */
  static async deletePref(key: string): Promise<void> {
    try {
      const context = getAppContext()
      if (!context) {
        return
      }
      const prefs = await preferences.getPreferences(context, STORE_NAME)
      await prefs.delete(key)
      await prefs.flush()
    } catch (e) {
      console.error(`StorageManager: deletePref error, key=${key}, err=${JSON.stringify(e)}`)
    }
  }

  // ===== JSON 文件 =====

  /**
   * 保存 JSON 数组文件
   */
  static async saveJsonFile<T>(filename: string, data: T[]): Promise<void> {
    try {
      const context = getAppContext()
      if (!context) {
        console.error('StorageManager: appContext not found')
        return
      }
      const dirPath = `${context.filesDir}/${JSON_DIR}`
      if (!fileIo.accessSync(dirPath)) {
        fileIo.mkdirSync(dirPath, true)
      }
      const filePath = `${dirPath}/${filename}.json`
      const content = JSON.stringify(data, null, 2)
      const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC | fileIo.OpenMode.WRITE_ONLY)
      fileIo.writeSync(file.fd, content)
      fileIo.closeSync(file)
      console.info(`StorageManager: saveJsonFile success, file=${filename}`)
    } catch (e) {
      console.error(`StorageManager: saveJsonFile error, file=${filename}, err=${JSON.stringify(e)}`)
    }
  }

  /**
   * 读取 JSON 数组文件
   */
  static async loadJsonFile<T>(filename: string): Promise<T[]> {
    try {
      const context = getAppContext()
      if (!context) {
        console.error('StorageManager: appContext not found')
        return []
      }
      const filePath = `${context.filesDir}/${JSON_DIR}/${filename}.json`
      if (!fileIo.accessSync(filePath)) {
        return []
      }
      const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
      const stat = fileIo.statSync(filePath)
      const buf = new ArrayBuffer(stat.size)
      fileIo.readSync(file.fd, buf)
      fileIo.closeSync(file)
      const decoder = new util.TextDecoder('utf-8')
      const content = decoder.decodeWithStream(new Uint8Array(buf))
      return JSON.parse(content) as T[]
    } catch (e) {
      console.error(`StorageManager: loadJsonFile error, file=${filename}, err=${JSON.stringify(e)}`)
      return []
    }
  }

  /**
   * 删除 JSON 文件
   */
  static async deleteJsonFile(filename: string): Promise<void> {
    try {
      const context = getAppContext()
      if (!context) {
        return
      }
      const filePath = `${context.filesDir}/${JSON_DIR}/${filename}.json`
      if (fileIo.accessSync(filePath)) {
        fileIo.unlinkSync(filePath)
      }
    } catch (e) {
      console.error(`StorageManager: deleteJsonFile error, file=${filename}, err=${JSON.stringify(e)}`)
    }
  }

  // ===== 本地文件操作 =====

  /**
   * 将外部文件复制到应用沙箱
   */
  static async saveLocalFile(srcUri: string, destDir: string, destName: string): Promise<string> {
    try {
      const context = getAppContext()
      if (!context) {
        return ''
      }
      const destDirPath = `${context.filesDir}/${destDir}`
      if (!fileIo.accessSync(destDirPath)) {
        fileIo.mkdirSync(destDirPath, true)
      }
      const destPath = `${destDirPath}/${destName}`
      const srcFile = fileIo.openSync(srcUri, fileIo.OpenMode.READ_ONLY)
      const stat = fileIo.statSync(srcUri)
      const buf = new ArrayBuffer(stat.size)
      fileIo.readSync(srcFile.fd, buf)
      fileIo.closeSync(srcFile)

      const destFile = fileIo.openSync(destPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC | fileIo.OpenMode.WRITE_ONLY)
      fileIo.writeSync(destFile.fd, buf)
      fileIo.closeSync(destFile)

      return destPath
    } catch (e) {
      console.error(`StorageManager: saveLocalFile error, src=${srcUri}, err=${JSON.stringify(e)}`)
      return ''
    }
  }

  /**
   * 读取本地文件为 ArrayBuffer
   */
  static async readLocalFile(path: string): Promise<ArrayBuffer> {
    try {
      if (!fileIo.accessSync(path)) {
        return new ArrayBuffer(0)
      }
      const file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY)
      const stat = fileIo.statSync(path)
      const buf = new ArrayBuffer(stat.size)
      fileIo.readSync(file.fd, buf)
      fileIo.closeSync(file)
      return buf
    } catch (e) {
      console.error(`StorageManager: readLocalFile error, path=${path}, err=${JSON.stringify(e)}`)
      return new ArrayBuffer(0)
    }
  }

  /**
   * 删除本地文件
   */
  static async deleteLocalFile(path: string): Promise<void> {
    try {
      if (fileIo.accessSync(path)) {
        fileIo.unlinkSync(path)
      }
    } catch (e) {
      console.error(`StorageManager: deleteLocalFile error, path=${path}, err=${JSON.stringify(e)}`)
    }
  }

  /**
   * 获取文件大小（字节）
   */
  static async getFileSize(path: string): Promise<number> {
    try {
      if (!fileIo.accessSync(path)) {
        return 0
      }
      return fileIo.statSync(path).size
    } catch (_e) {
      return 0
    }
  }

  // ===== 缓存管理 =====

  /**
   * 获取缓存目录总大小
   */
  static async getCacheSize(): Promise<number> {
    try {
      const context = getAppContext()
      if (!context) {
        return 0
      }
      let totalSize = 0
      const jsonDir = `${context.filesDir}/${JSON_DIR}`
      if (fileIo.accessSync(jsonDir)) {
        const files = fileIo.listFileSync(jsonDir)
        for (const file of files) {
          const path = `${jsonDir}/${file}`
          totalSize += fileIo.statSync(path).size
        }
      }
      return totalSize
    } catch (e) {
      console.error(`StorageManager: getCacheSize error, err=${JSON.stringify(e)}`)
      return 0
    }
  }

  /**
   * 清除所有缓存文件
   */
  static async clearCache(): Promise<void> {
    try {
      const context = getAppContext()
      if (!context) {
        return
      }
      const jsonDir = `${context.filesDir}/${JSON_DIR}`
      if (fileIo.accessSync(jsonDir)) {
        const files = fileIo.listFileSync(jsonDir)
        for (const file of files) {
          fileIo.unlinkSync(`${jsonDir}/${file}`)
        }
      }
      if (fileIo.accessSync(context.cacheDir)) {
        const cacheFiles = fileIo.listFileSync(context.cacheDir)
        for (const file of cacheFiles) {
          const path = `${context.cacheDir}/${file}`
          try {
            if (fileIo.statSync(path).isDirectory()) {
              // 跳过目录
            } else {
              fileIo.unlinkSync(path)
            }
          } catch (_e) {
            // ignore
          }
        }
      }
      console.info('StorageManager: clearCache success')
    } catch (e) {
      console.error(`StorageManager: clearCache error, err=${JSON.stringify(e)}`)
    }
  }
}
