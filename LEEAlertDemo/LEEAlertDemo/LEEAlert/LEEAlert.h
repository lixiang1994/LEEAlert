
/*!
 *  @header LEEAlert.h
 *
 *
 *  @brief  警告框
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/3/29.
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LEEAlertSystem , LEEAlertCustom , LEEAlertConfigModel;


typedef LEEAlertConfigModel *(^LEEConfigAlert)();
typedef LEEAlertConfigModel *(^LEEConfigAlertToInteger)(NSInteger number);
typedef LEEAlertConfigModel *(^LEEConfigAlertToFloat)(CGFloat number);
typedef LEEAlertConfigModel *(^LEEConfigAlertToString)(NSString *str);
typedef LEEAlertConfigModel *(^LEEConfigAlertToView)(UIView *view);
typedef LEEAlertConfigModel *(^LEEConfigAlertToColor)(UIColor *color);
typedef LEEAlertConfigModel *(^LEEConfigAlertToButtonAndBlock)(NSString *title , void(^buttonAction)());
typedef LEEAlertConfigModel *(^LEEConfigAlertToButtonBlock)(void(^buttonAction)());
typedef LEEAlertConfigModel *(^LEEConfigAlertToCustomTextField)(void(^addTextField)(UITextField *textField));
typedef LEEAlertConfigModel *(^LEEConfigAlertToCustomButton)(void(^addButton)(UIButton *button));
typedef LEEAlertConfigModel *(^LEEConfigAlertToCustomLabel)(void(^addLabel)(UILabel *label));
typedef LEEAlertConfigModel *(^LEEConfigAlertToViewController)(UIViewController *viewController);

/*
 
 *********************************************************************************
 *
 * 在使用LEEAlert的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ    : 可以添加SDAutoLayout群 497140713 在这里找我到(LEE)
 * Email : applelixiang@126.com
 * GitHub: https://github.com/lixiang1994/LEEAlert
 * 简书:    http://www.jianshu.com/users/a6da0db100c8
 *
 *********************************************************************************
 
 */

// 如果需要用“断言”调试程序请打开此宏

//#define LEEDebugWithAssert

@interface LEEAlert : NSObject

/**
 *  系统类型
 */
@property (nonatomic , strong ) LEEAlertSystem *system;
/**
 *  自定义类型
 */
@property (nonatomic , strong ) LEEAlertCustom *custom;

/**
 *  初始化Alert
 *
 *  @return 返回一个Alert对象
 */
+ (LEEAlert *)alert;

/**
 *  关闭自定义Alert
 */
+ (void)closeCustomAlert;

@end

@interface LEEAlertConfigModel : NSObject

/*
 *************************说明************************
 
 LEEAlert 目前提供两种方案 1.使用系统Alert  2.使用自定义Alert
 
 1.系统Alert [LEEAlert alert].system.cofing.XXXXX.show();
 
 2.自定义Alert [LEEAlert alert].custom.cofing.XXXXX.show();

 两种Alert的设置方法如下,其中系统Alert类型支持基本设置,自定义Alert支持全部设置/
 
 设置方法结束后在最后请不要忘记使用.show()方法显示Alert.
 
 最低支持iOS7及以上
 
 *****************************************************
 */

/* Alert 基本设置 */

/** 设置 Alert 标题 -> 格式: .title(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString title;
/** 设置 Alert 内容 -> 格式: .content(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString content;
/** 设置 Alert 取消按钮标题 -> 格式: .cancelButtonTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString cancelButtonTitle;
/** 设置 Alert 取消按钮响应事件Block -> 格式: .cancelButtonAction(^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonBlock cancelButtonAction;
/** 设置 Alert 添加按钮 -> 格式: .addButton(@@"" , ^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonAndBlock addButton;
/** 设置 Alert 添加输入框 -> 格式: .addTextField(^(UITextField *textField){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomTextField addTextField;

/* Alert 自定义设置 */

/** 设置 Alert 自定义标题 -> 格式: .customTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomLabel customTitle;
/** 设置 Alert 自定义内容 -> 格式: .customContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomLabel customContent;
/** 设置 Alert 自定义取消按钮 -> 格式: .customCancelButton(^(UIButton *button){ //code.. } */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomButton customCancelButton;
/** 设置 Alert 自定义视图 -> 格式: .customView(UIView) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToView customView;
/** 设置 Alert 添加自定义按钮 -> 格式: .addCustomButton(^(UIButton *button){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomButton addCustomButton;

/** 设置 Alert 自定义圆角半径 -> 格式: .customCornerRadius(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customCornerRadius;
/** 设置 Alert 自定义控件间距 -> 格式: .customSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customSubViewMargin;
/** 设置 Alert 自定义顶部控件间距 -> 格式: .customTopSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customTopSubViewMargin;
/** 设置 Alert 自定义底部控件间距 -> 格式: .customBottomSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customBottomSubViewMargin;
/** 设置 Alert 自定义警示框最大宽度 -> 格式: .customAlertMaxWidth(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertMaxWidth;
/** 设置 Alert 自定义警示框最大高度 -> 格式: .customAlertMaxHeight(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertMaxHeight;
/** 设置 Alert 自定义警示框开启动画时长 -> 格式: .customAlertOpenAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertOpenAnimationDuration;
/** 设置 Alert 自定义警示框关闭动画时长 -> 格式: .customAlertCloseAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertCloseAnimationDuration;

/** 设置 Alert 自定义警示框颜色 -> 格式: .customAlertViewColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToColor customAlertViewColor;
/** 设置 Alert 自定义警示框半透明或模糊背景颜色 -> 格式: .customAlertViewBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToColor customAlertViewBackGroundColor;

/** 设置 Alert 自定义警示框半透明背景样式 [默认] -> 格式: .customAlertViewBackGroundStypeTranslucent() */
@property (nonatomic , copy , readonly ) LEEConfigAlert customAlertViewBackGroundStypeTranslucent;
/** 设置 Alert 自定义警示框模糊背景样式 -> 格式: .customAlertViewBackGroundStypeBlur() */
@property (nonatomic , copy , readonly ) LEEConfigAlert customAlertViewBackGroundStypeBlur;

/** 设置 Alert 自定义警示框背景触摸关闭 -> 格式: .customAlertTouchClose() */
@property (nonatomic , copy , readonly ) LEEConfigAlert customAlertTouchClose;
/** 设置 Alert 自定义按钮点击不关闭警示框 -> 格式: .customButtonClickNotClose() */
@property (nonatomic , copy , readonly ) LEEConfigAlert customButtonClickNotClose;

/** 显示 Alert 默认通过KeyWindow弹出 -> 格式: .show() */
@property (nonatomic , copy , readonly ) LEEConfigAlert show;
/** 显示 Alert 通过指定视图控制器弹出 (仅适用系统类型)  -> 格式: .showFromViewController(UIViewController) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToViewController showFromViewController;

@end

@interface LEEAlertSystem : NSObject
/** 开始设置 */
@property (nonatomic , strong ) LEEAlertConfigModel *config;

@end

@interface LEEAlertCustom : NSObject
/** 开始设置 */
@property (nonatomic , strong ) LEEAlertConfigModel *config;

@end






/*
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *                 神兽保佑
 *                 代码无BUG!
 */






/* 以下是内部使用的工具类 ╮(╯▽╰)╭ 无视就好 不许乱动 "( *・ω・)✄╰ひ╯ */

@interface UIImage (LEEImageEffects)

- (UIImage*)applyLightEffect;

- (UIImage*)applyExtraLightEffect;

- (UIImage*)applyDarkEffect;

- (UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;

- (UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end