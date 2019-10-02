
# LEEAlert - 更新日志

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
