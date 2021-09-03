
# LEEAlert - 更新日志

V1.5.1
==============
修复`[LEEAlert clearQueue]`问题


V1.5.0
==============
移除`.LeeWindowLevel(UIWindowLevel)`设置

增加`.LeePresentation(LEEPresentation)`设置弹窗显示层级

```
// 在指定窗口层级显示
[LEEPresentation windowLevel:UIWindowLevelAlert]
// 在指定控制器上显示
[LEEPresentation viewController:xxxx]
```

旧版本:

```
.LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {

    // 最大宽度为屏幕宽度 (横屏和竖屏)
    return CGRectGetWidth([[UIScreen mainScreen] bounds]);
}
```

新版本:

```
.LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
    
    // 最大宽度为屏幕宽度 (横屏和竖屏)
    // size 为当前弹窗容器最大尺寸
    return size.width;
})
```

V1.4.3
==============
补充block非空判断

V1.4.2
==============
优化关闭方法回调 现在队列中无论是否存在正在显示的 回调Block都会被调用.

V1.4.1
==============
优化ActionSheet内部视图结构.

V1.4.0
==============
`LEEAction`增加 `numberOfLines`  `textAlignment`  `adjustsFontSizeToFitWidth`  `lineBreakMode`属性. 

V1.3.10
==============
修复内存泄露

V1.3.9
==============
优化自定义视图内部处理 解决iOS10及以下添加AutoLayout布局的自定义视图显示异常的问题.
```
// 使用AutoLayout布局的自定义视图 必须设置translatesAutoresizingMaskIntoConstraints=NO
// 内部会为该视图设置centerXY的约束, 所以请不要为该视图设置关于top left right bottom center等位置相关的约束.
// 不需要关心该视图位置 只需要保证大小正确即可.
view.translatesAutoresizingMaskIntoConstraints = NO;
```

V1.3.8
==============
修复崩溃问题

V1.3.7
==============
修复Button圆角失效问题 

V1.3.6
==============
修复iOS10以下崩溃问题

V1.3.5
==============
LEEAction增加 numberOfLines 属性 用于设置title行数
```
action.numberOfLines = 2;
```

V1.3.4
==============
优化圆角内部处理

V1.3.3
==============
增加iOS13 windowScene支持,  在 AppDelegate 或 SceneDelegate 中设置主要Window

```
[LEEAlert configMainWindow:self.window];
```

V1.3.2
==============
```
/** 队列是否为空 */
+ (BOOL)isQueueEmpty;
```

V1.3.1
==============
```
/// 查询队列中是否包含某一标识
+ (BOOL)containsQueueWithIdentifier:(NSString *)identifier;
```

V1.3.0
==============

### iOS13

由于iOS13API变化, 目前最低支持Xcode11.
增加iOS13 Dark样式适配, 默认样式兼容Dark样式. 增加`.LeeUserInterfaceStyle(UIUserInterfaceStyleUnspecified)`方法强制样式类型.

### ActionSheet圆角
在ActionSheet中 由于特殊的UI结构, 其圆角设置方法分为3个, 分别控制整体, 头部, 取消按钮.

原有的`.LeeCornerRadius(20)`相当于`.LeeCornerRadii(CornerRadiiMake(20, 20, 20, 20))`

增加`.LeeActionSheetHeaderCornerRadii(CornerRadiiMake(13.0f, 13.0f, 13.0f, 13.0f))`方法设置ActionSheet头部圆角
增加`.LeeActionSheetCancelActionCornerRadii(CornerRadiiMake(13.0f, 13.0f, 13.0f, 13.0f))`方法设置ActionSheet取消按钮圆角

V1.2.8
==============
增加是否可滑动开关 `.LeeIsScrollEnabled(YES)`

V1.2.7
==============
增加`.LeeCornerRadii(CornerRadiiMake(13.0f, 13.0f, 13.0f, 13.0f))` 圆角半径设置方法 支持4个圆角不同半径的设置

V1.2.6
==============
自定义视图增加AutoLayout布局类型支持, 优化内部布局计算

V1.2.5
==============
修改开源协议为MIT
优化中心偏移后超出屏幕的边界问题

V1.2.4
==============
增加Alert中心位置偏移设置
`.LeeAlertCenterOffset(CGPointMake(0, 0))`

V1.2.3
==============
增加关闭拦截特性
增加是否可以关闭回调设置 返回YES则执行关闭处理 返回NO 则放弃关闭
`.leeShouldClose(^{ return YES; })`

增加Action点击是否可以关闭回调设置 返回YES则执行关闭处理 返回NO 则放弃关闭
`.leeShouldActionClickClose(^(NSInteger index){ return YES; })`

增加关闭指定标识的方法 可设置是否强制关闭, 如果强制`.leeShouldClose`设置变为无效.
`+ (void)closeWithIdentifier:(NSString *)identifier force:(BOOL)force completionBlock:(void (^ _Nullable)(void))completionBlock;`

V1.2.2
==============
增加标识特性
增加 `.LeeIdentifier(@"xxx")` 标识设置方法
增加 `[LEEAlert closeWithIdentifier: completionBlock:]` 关闭指定标识的alert或actionsheet

V1.2.1
==============
优化Swift调用语法 增加nonnull修饰

V1.2.0
==============
增加状态栏样式设置
`.LeeStatusBarStyle(UIStatusBarStyleLightContent)`

V1.1.9
==============
修复自定义视图自动适应宽度的计算异常问题

V1.1.8
==============
修复CocoaPods问题

V1.1.7
==============
- LEEAction增加`backgroundImage`和`backgroundHighlightImage`属性, 用于设置action的背景样式, 与 `backgroundColor`..属性相同.

V1.1.6
==============
- 增加ActionSheet背景视图颜色设置方法, 可通过设置颜色解决填充底部间隙的效果.

V1.1.5
==============
- 优化阴影处理, 增加阴影偏移 颜色 透明度等设置方法
- 修复可能造成某种偶现崩溃的BUG

V1.1.4
==============
- 调整持续集成配置 (其他无改动)

V1.1.3
==============
- 内部项增加安全区域(Safe Area)适配.

V1.1.2
==============
- 增加安全区域(Safe Area)适配, 最低Xcode版本更改为9.0.
- 

V1.1.1
==============
- 增加获取AlertWindow获取的方法
- 增加某个alert的关闭回调

V1.1.0
==============
- 细分缩放动画样式 分为放大 缩小
- 完善内部Hook处理
- 优化旋转处理
- 调整内部阴影视图处理机制

V1.0.9
==============
- 增加优先级设置 按照优先级从高到低的顺序显示, 优先级相同时 优先显示最新的
- 调整添加队列方法 由`.LeeAddQueue()` 改为 `.LeeQueue(YES)`
- 优先级和队列结合使用会将其特性融合 具体效果请运行demo自行调试体验

V1.0.8
==============
- 去除iPad actionsheet样式转换
- 增加动画配置设置 可自行根据需求设置打开关闭动画的UIView的animation方法的使用
- 增加动画样式设置 可自定义打开关闭动画的动画方向 (上左下右), 淡入淡出, 缩放等样式

V1.0.7
==============
- 增加windowLevel设置 调整action的borderwidth最小宽度
- 增加自动旋转和显示方向设置

V1.0.6
==============
- 调整内部方法名 解决与Masonry冲突问题
- 增加头部点击关闭设置
- 修复在与键盘同时弹出时 被键盘遮挡的BUG
- 调整键盘显示时的适配处理 (原来会在键盘弹出后才进行调整 , 现在与键盘同时进行)

V1.0.5
==============
- 修复actionsheet的action默认无分隔线的BUG

V1.0.4
==============
- action增加attributed标题设置

V1.0.3
==============
- action增加圆角曲率 间距范围 边框位置等设置 

V1.0.2
==============
- 调整内部Hook

V1.0.1
==============
- 调整Pods

V1.0.0
==============
正式发布
