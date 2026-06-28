/**
 * FluidParticleBg - 黑金粒子背景
 *
 * 基于 HarmonyOS 原生 Particle 组件（API 12+），GPU 加速，60fps
 *
 * 粒子构成：
 *  - 30% 吸引粒子（暖金色）：触摸时发射器移至手指位置，新粒子从点击处涌现
 *  - 70% 自由粒子（金色）：触摸时加速度和发射率提升，运动更剧烈 + 透明度脉冲模拟金色闪光
 *
 * 三种模式：
 *  - guide:  400粒子，螺旋流动
 *  - login:  300粒子，顶部悬浮
 *  - register: 350粒子，底部生长
 *
 * 参考资料：
 * - https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-v5/arkts-particle-animation-V5
 */

@Component
export struct FluidParticleBg {
  @Prop mode: string = 'guide'

  /* ---- 尺寸 ---- */
  @State w: number = 360
  @State h: number = 780

  /* ---- 触摸状态 ---- */
  @State isTouching: boolean = false
  private touchX: number = -1
  private touchY: number = -1

  /* ---- 动态发射器属性（.emitter() 实时控制） ---- */
  @State emitterProps: EmitterProperty[] = this.initEmitterProps()

  /* ---- 自由粒子加速度（触摸时翻倍 → 运动更剧烈 → 更多碰撞） ---- */
  @State freeAccelRange: number[] = [1, 4]

  /** 初始化发射器属性 */
  initEmitterProps(): EmitterProperty[] {
    const cx = this.w / 2
    const cy = this.h / 2
    const p = this.getParams()
    return [
      { index: 0, emitRate: p.attractEmitRate, position: { x: cx, y: cy }, size: { width: this.w, height: this.h } },
      { index: 1, emitRate: p.freeEmitRate, position: { x: cx, y: cy }, size: { width: this.w, height: this.h } },
    ]
  }

  /** 模式参数 */
  getParams(): ParticleModeParams {
    if (this.mode === 'login') {
      return { total: 300, radius: 2.5, lifetime: 3000, freeRate: 25, attractRate: 15 }
    }
    if (this.mode === 'register') {
      return { total: 350, radius: 2.5, lifetime: 3500, freeRate: 30, attractRate: 18 }
    }
    return { total: 400, radius: 3, lifetime: 3000, freeRate: 35, attractRate: 20 }
  }

  build() {
    Stack() {
      // ==================== Particle 组件（GPU 加速） ====================
      Particle({
        particles: [
          // -------- 粒子组 0: 30% 吸引粒子（暖金色） --------
          {
            emitter: {
              particle: {
                type: ParticleType.POINT,
                config: { radius: this.getParams().radius },
                count: Math.floor(this.getParams().total * 0.3),
                lifetime: this.getParams().lifetime,
                lifetimeRange: 1000,
              },
              emitRate: this.getParams().attractRate,
              position: [this.w / 2, this.h / 2],
              size: [this.w, this.h],
              shape: ParticleEmitterShape.RECTANGLE,
            },
            color: {
              range: ['#FFD700', '#DAA520'],
            },
            opacity: {
              range: [0.15, 0.75],
            },
            scale: {
              range: [0.8, 1.3],
            },
            velocity: {
              speed: [30, 90],
              angle: [0, 360],
            },
            acceleration: {
              speed: { range: [2, 6] },
              angle: { range: [0, 360] },
            },
          },
          // -------- 粒子组 1: 70% 自由粒子（金色，碰撞闪光） --------
          {
            emitter: {
              particle: {
                type: ParticleType.POINT,
                config: { radius: this.getParams().radius - 0.5 },
                count: this.getParams().total - Math.floor(this.getParams().total * 0.3),
                lifetime: this.getParams().lifetime + 1000,
                lifetimeRange: 1500,
              },
              emitRate: this.getParams().freeRate,
              position: [this.w / 2, this.h / 2],
              size: [this.w, this.h],
              shape: ParticleEmitterShape.RECTANGLE,
            },
            color: {
              range: ['#FFC125', '#FFB90F'],
            },
            opacity: {
              range: [0.1, 0.7],
              // CURVE 更新器：粒子生命周期内透明度波动 → 模拟闪光脉冲
              updater: {
                type: ParticleUpdater.CURVE,
                config: [0.0, 0.6, 0.1, 0.7, 0.0],
              },
            },
            scale: {
              range: [0.6, 1.2],
              updater: {
                type: ParticleUpdater.CURVE,
                config: [0.5, 1.0, 0.6, 1.0, 0.5],
              },
            },
            velocity: {
              speed: [20, 70],
              angle: [0, 360],
            },
            acceleration: {
              speed: { range: this.freeAccelRange },
              angle: { range: [0, 360] },
            },
          },
        ],
      })
        .width('100%')
        .height('100%')
        .emitter(this.emitterProps) // 动态发射器绑定

      // 半透明遮罩（粒子在下，文字在上，保证可读）
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.15)')
    }
    .width('100%')
    .height('100%')
    .onAreaChange((_oldVal: Area, newVal: Area) => {
      if (Number(newVal.width) > 0 && Number(newVal.height) > 0) {
        this.w = Number(newVal.width)
        this.h = Number(newVal.height)
      }
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down || event.type === TouchType.Move) {
        const tx = event.touches[0].x
        const ty = event.touches[0].y
        this.touchX = tx
        this.touchY = ty
        if (!this.isTouching) {
          this.isTouching = true
        }

        /* ---- 触摸时动态更新 ---- */
        const p = this.getParams()

        // 吸引粒子组: 发射器移到触摸点，集中在小范围(20×20)
        const a0: EmitterProperty = {
          index: 0,
          emitRate: p.attractRate * 2.5,
          position: { x: tx, y: ty },
          size: { width: 20, height: 20 },
        }
        // 自由粒子组: 全屏范围，提高发射率
        const a1: EmitterProperty = {
          index: 1,
          emitRate: p.freeRate * 2,
          position: { x: this.w / 2, y: this.h / 2 },
          size: { width: this.w, height: this.h },
        }
        this.emitterProps = [a0, a1]

        // 自由粒子加速度翻倍：0.02→0.06 等效 (range [1,4] → [3,9])
        this.freeAccelRange = [3, 9]

      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isTouching = false

        /* ---- 恢复默认 ---- */
        const cx = this.w / 2
        const cy = this.h / 2
        const p = this.getParams()
        const r0: EmitterProperty = {
          index: 0,
          emitRate: p.attractRate,
          position: { x: cx, y: cy },
          size: { width: this.w, height: this.h },
        }
        const r1: EmitterProperty = {
          index: 1,
          emitRate: p.freeRate,
          position: { x: cx, y: cy },
          size: { width: this.w, height: this.h },
        }
        this.emitterProps = [r0, r1]
        this.freeAccelRange = [1, 4]
      }
    })
  }
}

/** 模式参数 */
interface ParticleModeParams {
  total: number
  radius: number
  lifetime: number
  freeRate: number
  attractRate: number
}
