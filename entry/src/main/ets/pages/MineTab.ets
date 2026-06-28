/**
 * MineTab - 我的（深色模式修复版）
 */

import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'
import { UserRepository } from '../data/repositories/UserRepository'
import { StorageManager } from '../utils/storage'
import { UserInfo, Todo } from '../data/models/Index'
import { ROUTE } from '../utils/constants'
import { ThemeColors, ThemePalette } from '../utils/theme'

const W = '92%'

@Component
export struct MineTab {
  onLogout?: () => void
  @State userInfo: UserInfo | null = null
  @StorageLink('isDarkMode') isDark: boolean = false
  @State fontSize: string = '中'
  @State cacheSize: string = '0 MB'
  @State showTodo: boolean = false
  @State todos: Todo[] = []
  @State todoFilterIdx: number = 0
  @State editMode: boolean = false
  @State selIds: string[] = []
  private tags: string[] = ['全部','学习','生活','其他']

  theme(): ThemePalette { return ThemeColors.get(this.isDark) }

  aboutToAppear(): void { this.loadUser(); this.loadCache() }

  async loadUser(): Promise<void> {
    this.userInfo = await UserRepository.getUserInfo()
    if (!this.userInfo) this.userInfo = { avatarPath:'', nickname:'未登录', studentId:'', college:'', major:'', password:'' }
  }

  async loadCache(): Promise<void> {
    const sz = await StorageManager.getCacheSize()
    this.cacheSize = sz > 1048576 ? `${(sz/1048576).toFixed(1)}MB` : `${(sz/1024).toFixed(1)}KB`
  }

  async openTodo(): Promise<void> {
    this.todos = await StorageManager.loadPref<Todo[]>('todos') || []
    this.todoFilterIdx=0; this.editMode=false; this.selIds=[]; this.showTodo=true
  }

  getFiltered(): Todo[] {
    const m: Record<number,string> = {0:'',1:'study',2:'life',3:'other'}
    const all = this.todos.filter(t => (m[this.todoFilterIdx]||'') === '' || t.category === m[this.todoFilterIdx]);
    return all.sort((a,b) => { if(a.isCompleted!==b.isCompleted) return a.isCompleted?1:-1; return a.remindTime.localeCompare(b.remindTime) })
  }

  async tglTodo(id: string): Promise<void> {
    const ns: Todo[] = []
    for(let i=0;i<this.todos.length;i++) {
      if(this.todos[i].id===id) ns.push({id:this.todos[i].id,content:this.todos[i].content,category:this.todos[i].category,remindTime:this.todos[i].remindTime,isCompleted:!this.todos[i].isCompleted,createdAt:this.todos[i].createdAt})
      else ns.push(this.todos[i])
    }
    this.todos=ns; await StorageManager.savePref('todos',this.todos)
  }

  async delTodo(id: string): Promise<void> { this.todos=this.todos.filter(t=>t.id!==id); await StorageManager.savePref('todos',this.todos) }

  tgSel(id: string): void { const i=this.selIds.indexOf(id); if(i>=0) this.selIds.splice(i,1); else this.selIds.push(id) }

  async batchDone(): Promise<void> {
    const ns: Todo[]=[]
    for(let i=0;i<this.todos.length;i++){
      if(this.selIds.includes(this.todos[i].id)) ns.push({id:this.todos[i].id,content:this.todos[i].content,category:this.todos[i].category,remindTime:this.todos[i].remindTime,isCompleted:true,createdAt:this.todos[i].createdAt})
      else ns.push(this.todos[i])
    }
    this.todos=ns; await StorageManager.savePref('todos',this.todos); this.selIds=[]; this.editMode=false
  }

  async batchDel(): Promise<void> {
    AlertDialog.show({title:'确认删除',message:`确定删除${this.selIds.length}个待办?`,confirm:{value:'删除',fontColor:'#FF7D00',action:async()=>{this.todos=this.todos.filter(t=>!this.selIds.includes(t.id));await StorageManager.savePref('todos',this.todos);this.selIds=[];this.editMode=false}},cancel:()=>{}})
  }

  build() {
    Column() {
      if (this.showTodo) { this.todoView() } else { this.mainView() }
    }.width('100%').height('100%').backgroundColor(this.theme().bg)
  }

  @Builder mainView() {
    Scroll() {
      Column() {
        // 用户信息卡片
        Row() {
          Circle().width(80).height(80).fill(this.theme().primaryLight)
            .stroke(this.theme().primary).strokeWidth(1.5)
          Text('👤').fontSize(36).fontColor(this.theme().textSecondary)
          Column() {
            Text(this.userInfo?.nickname||'未登录').fontSize(20).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary)
            Text(`学号: ${this.userInfo?.studentId||'——'}`).fontSize(13).fontColor(this.theme().textSecondary).margin({top:4})
            if (this.userInfo?.college) Text(`${this.userInfo.college} · ${this.userInfo.major}`).fontSize(13).fontColor(this.theme().textSecondary).margin({top:2})
          }.alignItems(HorizontalAlign.Start).margin({left:16}).layoutWeight(1)
          Text('>').fontSize(20).fontColor(this.theme().textSecondary)
        }.width(W).padding(16).backgroundColor(this.theme().cardBg).borderRadius(8).margin({top:16,bottom:16})
        .onClick(()=>{router.pushUrl({url:ROUTE.PROFILE_EDIT})})

        // 统计
        Row() {
          Column() { Text('0').fontSize(22).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary); Text('发布').fontSize(12).fontColor(this.theme().textSecondary).margin({top:4}) }.layoutWeight(1)
          Divider().vertical(true).height(30).color(this.theme().border)
          Column() { Text('0').fontSize(22).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary); Text('收藏').fontSize(12).fontColor(this.theme().textSecondary).margin({top:4}) }.layoutWeight(1)
          Divider().vertical(true).height(30).color(this.theme().border)
          Column() { Text('0').fontSize(22).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary); Text('积分').fontSize(12).fontColor(this.theme().textSecondary).margin({top:4}) }.layoutWeight(1)
        }.width(W).padding({top:16,bottom:16}).backgroundColor(this.theme().cardBg).borderRadius(8).margin({bottom:16})

        // 功能列表
        Column() {
          this.menuRow('❤️', '我的收藏', ()=>{router.pushUrl({url:ROUTE.FAVORITES})})
          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)
          this.menuRow('✅', '我的待办', ()=>{this.openTodo()})
          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)
          this.menuRow('📚', '我的课程', ()=>{router.pushUrl({url:ROUTE.MY_COURSES})})
          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)
          this.menuRow('📊', '我的成绩', ()=>{router.pushUrl({url:ROUTE.MY_SCORES})})
          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)
          this.menuRow('📦', '失物发布', ()=>{router.pushUrl({url:ROUTE.MY_LOSTFOUND})})
          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)
          this.menuRow('💬', '意见反馈', ()=>{router.pushUrl({url:ROUTE.FEEDBACK})})
        }.width(W).backgroundColor(this.theme().cardBg).borderRadius(8).margin({bottom:16})

        // 设置
        Column() {
          Row() { Text('🌙').fontSize(20); Text('深色模式').fontSize(15).fontColor(this.theme().textPrimary).margin({left:12}); Blank()
            Toggle({type:ToggleType.Switch,isOn:this.isDark}).selectedColor(this.theme().primary)
            .onChange((v:boolean)=>{this.isDark=v;AppStorage.setOrCreate('isDarkMode',v)}) }
          .padding({left:16,right:16,top:14,bottom:14}).width('100%')

          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)

          Row() { Text('Aa').fontSize(20); Text('字体大小').fontSize(15).fontColor(this.theme().textPrimary).margin({left:12}); Blank()
            Row(){ForEach(['小','中','大'],(s:string)=>{Text(s).fontSize(13).fontColor(this.fontSize===s?'#FFFFFF':this.theme().textPrimary).backgroundColor(this.fontSize===s?this.theme().primary:this.theme().bg).borderRadius(4).padding({left:10,right:10,top:4,bottom:4}).margin({left:4}).onClick(()=>{this.fontSize=s;AppStorage.setOrCreate('fontSize',s)})})} }
          .padding({left:16,right:16,top:14,bottom:14}).width('100%')

          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)

          Row() { Text('🔔').fontSize(20); Text('通知设置').fontSize(15).fontColor(this.theme().textPrimary).margin({left:12}).layoutWeight(1); Text('>').fontSize(16).fontColor(this.theme().textSecondary) }
          .width('100%').padding({left:16,right:16,top:14,bottom:14})
          .onClick(()=>{router.pushUrl({url:ROUTE.NOTIFICATION_SETTINGS})})

          Divider().height(0.5).color(this.theme().divider).width('88%').alignSelf(ItemAlign.Center)

          Row() { Text('🗑️').fontSize(20); Text('清理缓存').fontSize(15).fontColor(this.theme().textPrimary).margin({left:12}); Blank(); Text(this.cacheSize).fontSize(12).fontColor(this.theme().textSecondary).margin({right:8})
            Button('清理').height(28).borderRadius(4).backgroundColor(this.theme().warning).fontSize(20).fontColor('#FFFFFF').padding({left:10,right:10})
            .onClick(()=>{AlertDialog.show({title:'确认清理',message:'确定清理缓存?',confirm:{value:'确定',fontColor:this.theme().primary,action:async()=>{await StorageManager.clearCache();await this.loadCache();promptAction.showToast({message:'清理完成',duration:1500})}},cancel:()=>{}})}) }
          .padding({left:16,right:16,top:14,bottom:14}).width('100%')
        }.width(W).backgroundColor(this.theme().cardBg).borderRadius(8).margin({bottom:16})

        Text('版本 V1.0.0 · ©2026 校园助手开发团队').fontSize(12).fontColor(this.theme().textSecondary)
        Button('退出当前账号').fontSize(15).fontColor(this.theme().warning).backgroundColor(this.theme().cardBg)
          .border({width:1.5,color:this.theme().warning}).borderRadius(8).width('88%').height(44)
          .onClick(()=>{AlertDialog.show({title:'确认退出',message:'确定退出登录?',confirm:{value:'退出',fontColor:this.theme().warning,action:()=>{AppStorage.setOrCreate('isLoggedIn',false);AppStorage.setOrCreate('currentTabIndex',0);if(this.onLogout)this.onLogout()}},cancel:()=>{}})})
          .margin({top:16,bottom:30})
      }.width('100%').alignItems(HorizontalAlign.Center)
    }.width('100%').scrollBar(BarState.Off)
  }

  @Builder menuRow(icon: string, title: string, onClick: () => void) {
    Row() {
      Text(icon).fontSize(20)
      Text(title).fontSize(15).fontColor(this.theme().textPrimary).margin({left:12}).layoutWeight(1)
      Text('>').fontSize(16).fontColor(this.theme().textSecondary)
    }.width('100%').padding({left:16,right:16,top:14,bottom:14}).onClick(()=>{onClick()})
  }

  @Builder todoView() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(this.theme().primary).width(44).height(44).textAlign(TextAlign.Center).onClick(()=>{this.showTodo=false})
        Text('我的待办').fontSize(18).fontWeight(FontWeight.Bold).fontColor(this.theme().textPrimary).layoutWeight(1).textAlign(TextAlign.Center)
        Text(this.editMode?'完成':'编辑').fontSize(15).fontColor(this.theme().primary).width(60)
          .onClick(()=>{if(this.editMode)this.selIds=[];this.editMode=!this.editMode})
      }.width('100%').height(56).backgroundColor(this.theme().cardBg).padding({left:8,right:8})

      Row({space:8}) { ForEach(this.tags,(t:string,i:number)=>{
        Text(t).fontSize(13).fontColor(this.todoFilterIdx===i?'#FFFFFF':this.theme().textPrimary)
          .backgroundColor(this.todoFilterIdx===i?this.theme().primary:this.theme().bg).borderRadius(6)
          .padding({left:14,right:14,top:6,bottom:6}).onClick(()=>{this.todoFilterIdx=i})})
      }.width('100%').padding({left:16,top:12,bottom:12})

      List() {
        if(this.getFiltered().length===0) {
          ListItem(){Column(){Blank().height(120);Text('暂无待办').fontSize(15).fontColor(this.theme().textSecondary)}.width('100%').alignItems(HorizontalAlign.Center)}
        } else {
          ForEach(this.getFiltered(),(t:Todo)=>{
            ListItem(){
              Row(){
                Checkbox({name:t.id}).selectedColor(this.theme().primary).margin({right:12}).onChange(()=>{if(this.editMode)this.tgSel(t.id);else this.tglTodo(t.id)})
                Column(){
                  Text(t.content).fontSize(15).fontColor(t.isCompleted?this.theme().textSecondary:this.theme().textPrimary)
                    .decoration({type:t.isCompleted?TextDecorationType.LineThrough:TextDecorationType.None}).maxLines(1).textOverflow({overflow:TextOverflow.Ellipsis})
                  Text(t.remindTime).fontSize(12).fontColor(this.theme().textSecondary).margin({top:2})
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
              }.width('100%').padding(12)
            }.backgroundColor(this.theme().cardBg).margin({left:16,right:16,bottom:6}).borderRadius(8)
            .swipeAction({end:{builder:()=>{Button('删除').height('100%').backgroundColor(this.theme().warning).fontColor('#FFFFFF').fontSize(14).borderRadius(8).onClick(async()=>{await this.delTodo(t.id)})}}})
          })
        }
      }.width('100%').layoutWeight(1).backgroundColor(this.theme().bg)

      Row() {
        if(this.editMode){
          Button('完成').height(36).borderRadius(8).backgroundColor(this.theme().success).fontSize(14).fontColor('#FFFFFF').padding({left:20,right:20}).onClick(()=>{this.batchDone()}).margin({right:12})
          Button('删除').height(36).borderRadius(8).backgroundColor(this.theme().warning).fontSize(14).fontColor('#FFFFFF').padding({left:20,right:20}).onClick(()=>{this.batchDel()})
        } else {
          Button('新增待办').width('60%').height(40).borderRadius(8).backgroundColor(this.theme().primary).fontSize(15).fontColor('#FFFFFF')
            .onClick(()=>{AlertDialog.show({title:'新增',message:'功能完善中',confirm:{value:'确定',fontColor:this.theme().primary,action:()=>{}},cancel:()=>{}})})
        }
      }.width('100%').justifyContent(FlexAlign.Center).padding({top:12,bottom:20}).backgroundColor(this.theme().cardBg)
    }.width('100%').height('100%').backgroundColor(this.theme().bg)
  }
}
