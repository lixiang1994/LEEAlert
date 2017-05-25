
# LEEAlert - 最好用的轻量级Alert ActionSheet

[![](https://img.shields.io/aur/license/yaourt.svg?maxAge=2592000)](https://github.com/lixiang1994/LEEAlert/blob/master/LICENSE)&nbsp;
[![](http://img.shields.io/cocoapods/v/LEETheme.svg?style=flat)](http://cocoapods.org/?q=LEETheme)&nbsp;
[![](http://img.shields.io/cocoapods/p/LEETheme.svg?style=flat)](http://cocoapods.org/?q=LEETheme)&nbsp;
[![](https://img.shields.io/badge/support-iOS8%2B-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
![Build Status](https://travis-ci.org/lixiang1994/LEETheme.svg?branch=master)&nbsp;



演示
==============
![新日间Demo演示](https://github.com/lixiang1994/LEETheme/blob/master/Resources/社区日间.gif)
![新夜间Demo演示](https://github.com/lixiang1994/LEETheme/blob/master/Resources/社区夜间.gif)

![新日间Demo演示](https://github.com/lixiang1994/LEETheme/blob/master/Resources/微博日间.gif)
![新夜间Demo演示](https://github.com/lixiang1994/LEETheme/blob/master/Resources/微博夜间.gif)


特性
==============
- 两种设置模式,可根据对象单独添加某一主题中某一属性或方法的设置,可使用JSON模式为某一属性或方法设置标识符,二者可混合使用,满足不同需求的开发者。
- 轻量级设计, 简化文件架构, 全部集合为两个文件中。
- 支持对所有NSObject子类对象进行设置, 并提供了常用视图对象的颜色和图片等属性的快捷设置方法。
- 支持自定义类型对象的自定义属性或方法设置。
- 支持动态添加主题,可实现类似网络主题下载并切换的功能。
- 语法优雅, 高效简洁, OC链式, 一行代码完成对象设置。
- 当前主题记忆功能, 下一次启动自动布置。
- 完善的文档注释和使用教程, 并有众多Demo可供参考。


用法
==============

### 默认模式

主要适用于固定主题样式的情况下使用
 
 优点:直观 清晰, 编码时可随初始化控件编写完成, 不影响编码思路.
 
 缺点:每个主题的设置固定, 不支持新主题的设置.


	// 添加背景颜色
	imageView.lee_theme
    .LeeAddBackgroundColor(@"red" , [UIColor redColor])
    .LeeAddBackgroundColor(@"blue" , [UIColor blueColor]);
	
	// 添加图片
	imageView.lee_theme
    .LeeAddImage(@"red" , [UIImage imageNamed:@"red.png"])
    .LeeAddImage(@"blue" , [UIImage imageNamed:@"blue.png"]);
	
	// 添加自定义设置 (每个主题标签对应一个block , 当触发其中添加的主题后会执行相应的block)
	imageView.lee_theme
    .LeeAddCustomConfig(@"red" , ^(UIImageView *item){
        
        item.hidden = YES; //简单举例 红色主题启动时 将这个imageview对象隐藏
    })
    .LeeAddCustomConfig(@"blue" , ^(UIImageView *item){
        
        item.hidden = NO; //或者随便做一些其他羞羞的事
    });


LEETheme支持对任何NSObject子类的对象进行其持有属性或方法的设置 , 例如UIImageView类的对象持有image属性 , 那么使用LEETheme就可以为它设置不同主题对应的image属性值, 以此类推 , 当然所有类型的对象都可以添加自定义Block设置.

### JSON模式
	
 适用于固定和动态主题样式的情况下使用
 
 优点:对于对象的设置只需要给定标识符即可, 代码较默认模式更加简洁, 可动态增加新主题JSON配置.

##### JSON标准格式

	{
		"color": {
		   	"identifier1(唯一标识符)": "十六进制颜色值",
		    	"identifier2": "#000000"
		},
		"image": {
			"identifier3(唯一标识符)": "图片名称",
			 "identifier4": "lee.png"
		},
		"other": {
			"identifier5(唯一标识符)": "其他值",
			 "identifier6": "12345"
		}
	}

这里一般分为3种类型

1. 颜色类型 (color) - 适用于颜色属性
2. 图片类型 (image) - 适用于图片属性
3. 其他类型 (other) - 适用于自定义Block

![JSON配置关系图](https://github.com/lixiang1994/LEETheme/blob/master/Resources/JSON配置关系图.png)

##### 添加新主题的JSON配置

	// 添加json , 设置所属主题标签 , 设置资源路径  所添加过的Json配置会自动存储 无需每次都添加
	[LEETheme addThemeConfigWithJson:json Tag:@"red" ResourcesPath:nil];

##### 移除某一主题的JSON配置

	// 所要移除的主题标签
	[LEETheme removeThemeConfigWithTag:@"red"];

##### 对象设置

	// 设置背景颜色
	imageView.lee_theme.LeeConfigBackgroundColor(@"identifier2");
	
	// 设置图片
	imageView.lee_theme.LeeConfigImage(@"identifier4");

	// 自定义设置 (如果没有对应的标识符 则不会触发该block执行 , 如果有 则执行)
	imageView.lee_theme.LeeCustomConfig(@"identifier6" , ^(id item , id value){
			
		//item 为当前对象
		//value 为当前主题的JSON配置中 other 类型下 "identifier6"对应的值
		item.alpha = [value floatValue]; //举个例子 设置一下透明度
	});


### 启用主题

启用主题后 , LEETheme会自动保存当前所启用的主题 , APP下一次开启会自动启用上一次的主题.

	// 启用主题
	[LEETheme startTheme:@"主题标签"];
	
建议在`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`中添加默认主题的设置 , 指定第一次启动APP时默认启用的主题.	
	
	// 设置默认主题
	[LEETheme defaultTheme:@"主题标签"];
	
### 关于添加过渡动画效果

这里提供一个小技巧 可以让过渡更加自然 可根据自身情况调整使用.
切换主题前 获取当前window的快照视图 并覆盖到window上 > 执行主题切换 > 将覆盖的快照视图通过动画隐藏 显示出切换完成的真实window.


	// 覆盖截图
	UIView *tempView = [weakSelf.window snapshotViewAfterScreenUpdates:NO];
	[weakSelf.window addSubview:tempView];
	
	// 切换主题
	[LEETheme startTheme:@"tag"];
	
	// 增加动画 移除覆盖
	[UIView animateWithDuration:1.0f animations:^{
                
		tempView.alpha = 0.0f;
                
	} completion:^(BOOL finished) {
                
		[tempView removeFromSuperview];
	}];


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
2. 在 Podfile 中添加 `pod 'LEETheme'`。
3. 执行 `pod install` 或 `pod update`。
4. 导入 `<LEETheme/LEETheme.h>`。

### 手动安装

1. 下载 LEETheme 文件夹内的所有内容。
2. 将 LEETheme 内的源文件添加(拖放)到你的工程。
3. 导入 `LEETheme.h`。

系统要求
==============
该库最低支持 `iOS 7.0` 和 `Xcode 7.0`。


版本更新
==============
详情请查看[更新日志](https://github.com/lixiang1994/LEETheme/blob/master/UPDATELOG.md)


许可证
==============
LEETheme 使用 GPL V3 许可证，详情见 LICENSE 文件。


友情链接
==============
[高效的自动布局库 - SDAutoLayout](https://github.com/gsdios/SDAutoLayout)


个人主页
==============
[我的简书](http://www.jianshu.com/users/a6da0db100c8)
[我的博客](http://www.lee1994.com)
