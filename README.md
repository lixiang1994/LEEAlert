
# LEEAlert - 最好用的轻量级Alert ActionSheet

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

	// 结构
	
	[LEEAlert alert].cofing.XXXXX.XXXXX.LeeShow();


### ActionSheet
	
	// 结构
	
	[LEEAlert actionSheet].cofing.XXXXX.XXXXX.LeeShow();


##### 添加新主题的JSON配置

	// 添加json , 设置所属主题标签 , 设置资源路径  所添加过的Json配置会自动存储 无需每次都添加
	[LEETheme addThemeConfigWithJson:json Tag:@"red" ResourcesPath:nil];


### 注意事项

- 默认模式与JSON模式可以同时使用.
- 当一个对象同时使用了2种设置模式 那么同主题情况下会优先使用后设置的.
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
