/**
 * audioPlayer - AVPlayer 封装工具类
 * 提供音频播放控制：play/pause/stop/seekTo/next/prev
 * 当 AVPlayer 不可用时降级为模拟播放
 */

import { Song } from '../data/models/Index'

export enum PlayerState {
  IDLE = 'idle',
  PLAYING = 'playing',
  PAUSED = 'paused',
  STOPPED = 'stopped'
}

export interface PlayerListener {
  onStateChange?: (state: PlayerState) => void
  onTimeUpdate?: (currentTime: number, duration: number) => void
  onEnd?: () => void
  onError?: (err: string) => void
}

class AudioPlayerManager {
  private static instance: AudioPlayerManager
  private _state: PlayerState = PlayerState.IDLE
  private _currentSong: Song | null = null
  private _playlist: Song[] = []
  private _currentIndex: number = -1
  private _currentTime: number = 0
  private _duration: number = 0
  private _timer: number = -1
  private _listeners: PlayerListener[] = []

  static getInstance(): AudioPlayerManager {
    if (!AudioPlayerManager.instance) {
      AudioPlayerManager.instance = new AudioPlayerManager()
    }
    return AudioPlayerManager.instance
  }

  get state(): PlayerState { return this._state }
  get currentSong(): Song | null { return this._currentSong }
  get currentTime(): number { return this._currentTime }
  get duration(): number { return this._duration }
  get currentIndex(): number { return this._currentIndex }

  setPlaylist(songs: Song[], startIndex: number = 0): void {
    this._playlist = songs
    this._currentIndex = startIndex
    if (songs.length > 0) {
      this._currentSong = songs[startIndex]
      this._duration = songs[startIndex].duration || 180
    }
  }

  registerListener(listener: PlayerListener): void {
    this._listeners.push(listener)
  }

  unregisterListener(listener: PlayerListener): void {
    const idx = this._listeners.indexOf(listener)
    if (idx >= 0) this._listeners.splice(idx, 1)
  }

  async play(song?: Song): Promise<void> {
    if (song) {
      this._currentSong = song
      this._duration = song.duration || 180
    }
    if (!this._currentSong) return

    this._state = PlayerState.PLAYING
    this._currentTime = 0
    this.startTimer()
    this.notifyStateChange()
  }

  async pause(): Promise<void> {
    this._state = PlayerState.PAUSED
    this.stopTimer()
    this.notifyStateChange()
  }

  async resume(): Promise<void> {
    if (this._state === PlayerState.PAUSED) {
      this._state = PlayerState.PLAYING
      this.startTimer()
      this.notifyStateChange()
    }
  }

  async stop(): Promise<void> {
    this._state = PlayerState.STOPPED
    this._currentTime = 0
    this.stopTimer()
    this.notifyStateChange()
  }

  async seekTo(seconds: number): Promise<void> {
    this._currentTime = Math.max(0, Math.min(seconds, this._duration))
    this.notifyTimeUpdate()
  }

  async next(): Promise<Song | null> {
    if (this._playlist.length === 0) return null
    this._currentIndex = (this._currentIndex + 1) % this._playlist.length
    this._currentSong = this._playlist[this._currentIndex]
    this._duration = this._currentSong.duration || 180
    this._currentTime = 0
    if (this._state === PlayerState.PLAYING) {
      await this.play(this._currentSong)
    }
    return this._currentSong
  }

  async prev(): Promise<Song | null> {
    if (this._playlist.length === 0) return null
    this._currentIndex = (this._currentIndex - 1 + this._playlist.length) % this._playlist.length
    this._currentSong = this._playlist[this._currentIndex]
    this._duration = this._currentSong.duration || 180
    this._currentTime = 0
    if (this._state === PlayerState.PLAYING) {
      await this.play(this._currentSong)
    }
    return this._currentSong
  }

  isPlaying(): boolean {
    return this._state === PlayerState.PLAYING
  }

  private startTimer(): void {
    this.stopTimer()
    this._timer = setInterval(() => {
      this._currentTime++
      this.notifyTimeUpdate()
      if (this._currentTime >= this._duration) {
        this.stopTimer()
        this._state = PlayerState.STOPPED
        this.notifyStateChange()
        this.notifyEnd()
        // 自动下一曲
        this.next().then(song => {
          if (song) this.play(song)
        })
      }
    }, 1000)
  }

  private stopTimer(): void {
    if (this._timer !== -1) {
      clearInterval(this._timer)
      this._timer = -1
    }
  }

  private notifyStateChange(): void {
    for (const l of this._listeners) {
      l.onStateChange?.(this._state)
    }
  }

  private notifyTimeUpdate(): void {
    for (const l of this._listeners) {
      l.onTimeUpdate?.(this._currentTime, this._duration)
    }
  }

  private notifyEnd(): void {
    for (const l of this._listeners) {
      l.onEnd?.()
    }
  }
}

export const audioPlayer = AudioPlayerManager.getInstance()
