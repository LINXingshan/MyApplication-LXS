/**
 * routerConfig - 路由配置与统一跳转函数
 * 封装 router.pushUrl/back，统一添加转场动画（从右滑入 300ms）
 */

import { router } from '@kit.ArkUI'

export interface RouterParams {
  url: string
  params?: Record<string, Object>
}

/**
 * 统一页面跳转：从右滑入 300ms
 */
export function navigateTo(options: RouterParams): void {
  try {
    router.pushUrl({
      url: options.url,
      params: options.params,
      animation: {
        duration: 300,
        curve: Curve.EaseOut
      }
    })
  } catch (e) {
    console.error(`routerConfig: navigateTo error, url=${options.url}, err=${JSON.stringify(e)}`)
  }
}

/**
 * 统一返回：向右滑出 300ms
 */
export function navigateBack(): void {
  try {
    router.back({
      animation: {
        duration: 300,
        curve: Curve.EaseOut
      }
    })
  } catch (e) {
    console.error(`routerConfig: navigateBack error, err=${JSON.stringify(e)}`)
  }
}

/**
 * 替换跳转（用于启动链：无动画）
 */
export function replaceTo(url: string): void {
  try {
    router.replaceUrl({ url })
  } catch (e) {
    console.error(`routerConfig: replaceTo error, url=${url}, err=${JSON.stringify(e)}`)
  }
}
