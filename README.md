
# LEEAlert - 优雅的轻量级Alert ActionSheet

[![](https://img.shields.io/aur/license/yaourt.svg?maxAge=2592000)](https://github.com/lixiang1994/LEEAlert/blob/master/LICENSE)&nbsp;
[![](http://img.shields.io/cocoapods/v/LEEAlert.svg?style=flat)](http://cocoapods.org/?q=LEEAlert)&nbsp;
[![](http://img.shields.io/cocoapods/p/LEEAlert.svg?style=flat)](http://cocoapods.org/?q=LEEAlert)&nbsp;
[![](https://img.shields.io/badge/support-iOS8%2B-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
![Build Status](https://travis-ci.org/lixiang1994/LEEAlert.svg?branch=master)&nbsp;



演示
==============
![新日间Demo演示]()
![新夜间Demo演示]()

![新日间Demo演示]()
![新夜间Demo演示]()


特性
==============
 - 支持alert类型与actionsheet类型
 - 默认样式为Apple风格 可自定义其样式
 - 支持自定义标题与内容 可动态调整其样式
 - 支持自定义视图添加 同时可设置位置类型等 自定义视图size改变时会自动适应.
 - 支持输入框添加 自动处理键盘相关的细节
 - 支持屏幕旋转适应 同时可自定义横竖屏最大宽度和高度
 - 支持自定义action添加 可动态调整其样式
 - 支持内部添加的控件的间距设置等
 - 支持圆角设置 支持阴影效果设置
 - 支持队列显示 多个同时显示时根据先后顺序排队弹出.
 - 支持两种背景样式 1.半透明 (支持自定义透明度比例和颜色) 2.毛玻璃 (支持效果类型)
 - 打开和关闭的动画时长均可自定义
 - 更多特性未来版本中将不断更新.


用法
==============

### Alert

	// 组成结构
	[LEEAlert alert].cofing.XXXXX.XXXXX.LeeShow();


### ActionSheet
	
	// 组成结构
	[LEEAlert actionSheet].cofing.XXXXX.XXXXX.LeeShow();


### 默认基础功能添加

	[LEEAlert alert].config
    	.LeeTitle(@"标题") 				// 添加一个标题 (默认样式)
    	.LeeContent(@"")				// 添加一个标题 (默认样式)
    	.LeeAddTextField(^(UITextField *textField) {	// 添加一个输入框 (自定义设置)
        	// textfield设置Block
    	})
    	.LeeCustomView(view)			// 添加自定义的视图
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
	
	
### 自定义基础功能添加

	
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
        custom.view = nil;
        
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



	// 关闭当前显示的Alert或ActionSheet
	[LEEAlert closeWithCompletionBlock:^{
		
	}];




### 注意事项

- 添加的控件设置的顺序会决定显示的排列顺序.
- ActionSheet中 取消类型的Action 显示的位置与原生位置相同.
- JSON中的标识符(identifier)要确保在当前JSON中是唯一的.
- 每个主题对应的JSON中 标识符(identifier)要相同.
- 不要忘记设置默认主题, 应用中应该最少会有一个默认的主题.

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
该库最低支持 `iOS 8.0` 和 `Xcode 7.0`。


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
