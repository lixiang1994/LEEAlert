
# LEEAlert - 优雅的Alert ActionSheet

[![](https://img.shields.io/aur/license/yaourt.svg?maxAge=2592000)](https://github.com/lixiang1994/LEEAlert/blob/master/LICENSE)&nbsp;
[![](http://img.shields.io/cocoapods/v/LEEAlert.svg?style=flat)](http://cocoapods.org/?q=LEEAlert)&nbsp;
[![](http://img.shields.io/cocoapods/p/LEEAlert.svg?style=flat)](http://cocoapods.org/?q=LEEAlert)&nbsp;
[![](https://img.shields.io/badge/support-iOS8%2B-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![](https://img.shields.io/badge/Xcode-9.0-blue.svg)](https://developer.apple.com/xcode/)&nbsp;
[![](https://img.shields.io/badge/language-Objective--C-f48041.svg?style=flat)](https://www.apple.com/)&nbsp;
![Build Status](https://travis-ci.org/lixiang1994/LEEAlert.svg?branch=master)&nbsp;
![](https://img.shields.io/cocoapods/dt/LEEAlert.svg)



演示
==============
![AlertDemo演示](https://github.com/lixiang1994/Resources/blob/master/LEEAlert/alertDemo.gif)
![ActionSheetDemo演示](https://github.com/lixiang1994/Resources/blob/master/LEEAlert/actionSheetDemo.gif)


特性
==============
 - 链式语法 结构优雅
 - 支持alert类型与actionsheet类型
 - 默认样式为Apple风格 可自定义其样式
 - 支持自定义标题与内容 可动态调整其样式
 - 支持自定义视图添加 同时可设置位置类型等 自定义视图size改变时会自动适应.
 - 支持输入框添加 自动处理键盘相关的细节
 - 支持屏幕旋转适应 同时可自定义横竖屏最大宽度和高度
 - 支持自定义action添加 可动态调整其样式
 - 支持内部添加的功能项的间距范围设置等
 - 支持圆角设置 支持阴影效果设置
 - 支持队列和优先级 多个同时显示时根据优先级顺序排队弹出 添加到队列的如被高优先级覆盖 以后还会继续显示等.
 - 支持两种背景样式 1.半透明 (支持自定义透明度比例和颜色) 2.毛玻璃 (支持效果类型)
 - 支持自定义UIView动画方法
 - 支持自定义打开关闭动画样式(动画方向 渐变过渡 缩放过渡等)
 - 更多特性未来版本中将不断更新.


用法
==============

### 概念

无论是Alert还是ActionSheet 这里我把它们内部的控件分为两类 一: 功能项类型 (Item) 二: 动作类型 (Action).

按照apple的风格设计 弹框分为上下两个部分 其中功能项的位置为 Header 既 头部, 而Action则在下部分.

功能项一般分为4种类型  1. 标题 2. 内容(也叫Message) 3.输入框 4.自定义的视图 

Action一般分为3种类型 1. 默认类型 2. 销毁类型(Destructive) 3.取消类型(Cancel)

所以说 能添加的东西归根结底为两种 1. Item 2.Action  其余的都是一些设置等.


根据上面的概念 我来简单介绍一下API的结构:

所有添加的方法都是以 `LeeAddItem` 和 `LeeAddAction` 两个方法为基础进行的扩展.

查看源码 可以发现 无论是 `LeeAddTitle` 还是 `LeeAddTextField` 最终都是通过 `LeeAddItem` 来实现的.

也就是说整个添加的结构是以他们两个展开的 , 这个仅作为了解即可.

### Alert
```
    // 完整结构
    [LEEAlert alert].cofing.XXXXX.XXXXX.LeeShow();
```

### ActionSheet
```
    // 完整结构
    [LEEAlert actionSheet].cofing.XXXXX.XXXXX.LeeShow();
```

### 默认基础功能添加

```
    [LEEAlert alert].config
    .LeeTitle(@"标题") 		// 添加一个标题 (默认样式)
    .LeeContent(@"内容")		// 添加一个标题 (默认样式)
    .LeeAddTextField(^(UITextField *textField) {	// 添加一个输入框 (自定义设置)
    	// textfield设置Block
    })
    .LeeCustomView(view)	// 添加自定义的视图
    .LeeAction(@"默认Action", ^{		//添加一个默认类型的Action (默认样式 字体颜色为蓝色)
    	// 点击事件Block
    })
    .LeeDestructiveAction(@"销毁Action", ^{	// 添加一个销毁类型的Action (默认样式 字体颜色为红色)
    	// 点击事件Block
    })
    .LeeCancelAction(@"取消Action", ^{	// 添加一个取消类型的Action (默认样式 alert中为粗体 actionsheet中为最下方独立)
    	// 点击事件Block
    })
    .LeeShow(); // 最后调用Show开始显示
```	
	
### 自定义基础功能添加

```
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        // 自定义设置Block
        
        // 关于UILabel的设置这里不多说了
        
        label.text = @"标题";
        
        label.textColor = [UIColor redColor];
    })
    .LeeAddContent(^(UILabel *label) {
        
        // 自定义设置Block
        
        // 同标题一样
    })
    .LeeAddTextField(^(UITextField *textField) {
        
        // 自定义设置Block
        
        // 关于UITextField的设置你们都懂的 这里textField默认高度为40.0f 如果需要调整可直接设置frame 当然frame只有高度是有效的 其他的均无效
        
        textField.textColor = [UIColor redColor];
    })
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        // 自定义设置Block
        
        // 设置视图对象
        custom.view = view;
        
        // 设置自定义视图的位置类型 (包括靠左 靠右 居中 , 默认为居中)
        custom.positionType = LEECustomViewPositionTypeLeft;
        
        // 设置是否自动适应宽度 (自适应宽度后 位置类型为居中)
        custom.isAutoWidth = YES;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        // 自定义设置Block
        
        // 关于更多属性的设置 请查看'LEEAction'类 这里不过多演示了
        
        action.title = @"确认";
        
        action.titleColor = [UIColor blueColor];
    })
    .LeeShow();
```

### 自定义相关样式

```
    [LEEAlert alert].config
    .LeeCornerRadius(10.0f) 	//弹框圆角曲率
    .LeeShadowOpacity(0.35f) 	//弹框阴影的不透明度 0.0 -- 1.0
    .LeeHeaderColor([UIColor whiteColor]) 	//弹框背景颜色
    .LeeBackGroundColor([UIColor whiteColor])	 //屏幕背景颜色
    .LeeBackgroundStyleTranslucent(0.5f) 	//屏幕背景半透明样式 参数为透明度
    .LeeBackgroundStyleBlur(UIBlurEffectStyleDark)	 //屏幕背景毛玻璃样式 参数为模糊处理样式类型 `UIBlurEffectStyle`
    .LeeShow();
```

### 自定义最大宽高范围及相关间距

```
    [LEEAlert alert].config
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 10, 10, 10)) 		// 头部内间距设置 等于内部项的范围
    .LeeMaxWidth(280.0f) // 设置最大宽度 (固定数值 横竖屏相同)
    .LeeMaxHeight(400.0f) // 设置最大高度 (固定数值 横竖屏相同)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) { 	// 设置最大宽度 (根据横竖屏类型进行设置 最大高度同理)
        
        if (type == LEEScreenOrientationTypeVertical) {
            
            // 竖屏类型
            
            return 280.0f;
        }
        
        if (type == LEEScreenOrientationTypeHorizontal) {
            
            // 横屏类型
            
            return 400.0f;
        }
        
        return 0.0f;
    })
    .LeeShow();
    

    [LEEAlert alert].config
    .LeeTitle(@"标题")
    .LeeItemInsets(UIEdgeInsetsMake(10, 0, 0, 0)) 	// 设置某一项的外边距范围 在哪一项后面 就是对哪一项进行设置
    .LeeContent(@"内容")
    .LeeItemInsets(UIEdgeInsetsMake(10, 0, 10, 0)) 	// 例如在设置标题后 紧接着添加一个LeeItemInsets() 就等于为这个标题设置了外边距范围  以此类推
    .LeeShow();
    
    /**
   	 LeeHeaderInsets 与 LeeItemInsets 决定了所添加的功能项的布局 可根据需求添加调整.
    */
```

### 自定义动画时长

```
    [LEEAlert alert].config
    .LeeOpenAnimationDuration(0.3f) // 设置打开动画时长 默认为0.3秒
    .LeeCloseAnimationDuration(0.2f) // 设置关闭动画时长 默认为0.2秒
    .LeeShow();
```

### 自定义动画样式

```
    [LEEAlert alert].config
    .LeeOpenAnimationStyle(LEEAnimationStyleOrientationTop | LEEAnimationStyleFade | LEEAnimationStyleZoom) //设置打开动画样式的方向为上 以及淡入效果和缩放效果.
    .LeeCloseAnimationStyle(LEEAnimationStyleOrientationBottom | LEEAnimationStyleFade | LEEAnimationStyleZoom) //设置关闭动画样式的方向为下 以及淡出效果和缩放效果.
    .LeeShow();
```

### 自定义动画方法设置

```
    [LEEAlert alert].config
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
	// 可自定义UIView动画方法以及参数设置
	
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
            animatingBlock(); //调用动画中Block
                    
        } completion:^(BOOL finished) {
                    
            animatedBlock(); //调用动画结束Block
        }];
                
    })
    .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
                
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
            animatingBlock();
                    
        } completion:^(BOOL finished) {
                    
            animatedBlock();
        }];
                
     })
    .LeeShow();
```

### 队列与优先级设置

```
    [LEEAlert alert].config
    .LeeQueue(YES)	// 设置添加到队列 默认不添加 (添加后 处于显示状态时 如果有新的弹框显示 会将它暂时隐藏 等新的弹框显示结束 再将其显示出来)
    .LeePriority(1) 	// 设置优先级 默认为0 按照优先级从高到低的顺序显示, 优先级相同时 优先显示最新的
    .LeeShow();
    /**
    	优先级和队列结合使用会将其特性融合 具体效果请运行demo自行调试体验
    */
```

### 其他设置

```
    [LEEAlert alert].config
    .LeeWindowLevel(UIWindowLevelAlert) // 弹框window层级 默认UIWindowLevelAlert
    .LeeShouldAutorotate(YES) // 是否支持自动旋转 默认为NO
    .LeeSupportedInterfaceOrientations(UIInterfaceOrientationMaskAll) // 支持的旋转方向 默认为UIInterfaceOrientationMaskAll
    .LeeClickHeaderClose(YES) // 点击弹框进行关闭 默认为NO
    .LeeClickBackgroundClose(YES) 	// 设置点击背景进行关闭 Alert默认 NO , ActionSheet默认 YES
    .LeeCloseComplete(^{ 
    	// 关闭回调事件
    })
    .LeeShow();
```

### 关闭当前显示

```
    // 关闭当前显示的Alert或ActionSheet
    [LEEAlert closeWithCompletionBlock:^{
    	
    	//如果在关闭后需要做一些其他操作 建议在该Block中进行
    }];
```


### 注意事项

- 添加的功能项顺序会决定显示的排列顺序.
- 当需要很复杂的样式时 如果默认提供的这些功能项无法满足, 建议将其封装成一个UIView对象 添加自定义视图来显示.
- ActionSheet中 取消类型的Action 显示的位置与原生位置相同 处于底部独立的位置.
- 设置最大宽度高度时如果使用`CGRectGetWidth([[UIScreen mainScreen] bounds])`这类方法 请考虑iOS8以后屏幕旋转 width和height会变化的特性.


安装
==============

### CocoaPods

1. 将 cocoapods 更新至最新版本.
2. 在 Podfile 中添加 `pod 'LEEAlert'`。
3. 执行 `pod install` 或 `pod update`。
4. 导入 `<LEEAlert/LEEAlert.h>`。

### 手动安装

1. 下载 LEEAlert 文件夹内的所有内容。
2. 将 LEEAlert 内的源文件添加(拖放)到你的工程。
3. 导入 `LEEAlert.h`。

系统要求
==============
该库最低支持 `iOS 8.0` 和 `Xcode 9.0`。


版本更新
==============
详情请查看[更新日志](https://github.com/lixiang1994/LEEAlert/blob/master/UPDATELOG.md)


许可证
==============
LEEAlert 使用 GPL V3 许可证，详情见 LICENSE 文件。


友情链接
==============
[高效的自动布局库 - SDAutoLayout](https://github.com/gsdios/SDAutoLayout)


个人主页
==============
[我的简书](http://www.jianshu.com/users/a6da0db100c8)
[我的博客](http://www.lee1994.com)
