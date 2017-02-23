
/*!
 *  @header LEEAlert.h
 *
 *
 *  @brief  警告框
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.1
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LEEAlertSystem , LEEAlertCustom , LEEAlertConfigModel;

typedef LEEAlertConfigModel *(^LEEConfigAlert)();
typedef LEEAlertConfigModel *(^LEEConfigAlertToBool)(BOOL);
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
 * QQ    : 可以添加SDAutoLayout群 497140713 在这里找到我(LEE)
 * Email : applelixiang@126.com
 * GitHub: https://github.com/lixiang1994/LEEAlert
 * 简书:    http://www.jianshu.com/users/a6da0db100c8
 *
 *********************************************************************************
 
 */


@interface LEEAlert : NSObject

/**
 *  系统类型
 */
@property (nonatomic , strong ) LEEAlertSystem *system;
/**
 *  自定义类型
 */
@property (nonatomic , strong ) LEEAlertCustom *custom;

/** 初始化Alert */

+ (LEEAlert *)alert;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow *)window;

/** 关闭自定义Alert */

+ (void)closeCustomAlert;

@end

@interface LEEAlertConfigModel : NSObject

/*
 *************************说明************************
 
 LEEAlert 目前提供两种方案 1.使用系统Alert  2.使用自定义Alert
 
 1.系统Alert [LEEAlert alert].system.cofing.XXXXX.LeeShow();
 
 2.自定义Alert [LEEAlert alert].custom.cofing.XXXXX.LeeShow();
 
 两种Alert的设置方法如下,其中系统Alert类型支持基本设置,自定义Alert支持全部设置/
 
 设置方法结束后在最后请不要忘记使用.LeeShow()方法显示Alert.
 
 最低支持iOS7及以上 ARC ✌(˵¯̴͒ꇴ¯̴͒˵)✌
 
 *****************************************************
 */

/* Alert 基本设置 */

/** 设置 Alert 标题 -> 格式: .LeeTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString LeeTitle;
/** 设置 Alert 内容 -> 格式: .LeeContent(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString LeeContent;
/** 设置 Alert 取消按钮标题 -> 格式: .LeeCancelButtonTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString LeeCancelButtonTitle;
/** 设置 Alert 取消按钮响应事件Block(取消按钮点击后会自动关闭Alert 请勿再次调用关闭方法) -> 格式: .LeeCancelButtonAction(^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonBlock LeeCancelButtonAction;
/** 设置 Alert 添加按钮 -> 格式: .LeeAddButton(@@"" , ^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonAndBlock LeeAddButton;
/** 设置 Alert 添加输入框 -> 格式: .LeeAddTextField(^(UITextField *textField){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomTextField LeeAddTextField;

/* Alert 自定义设置 */

/** 设置 Alert 自定义标题 -> 格式: .LeeCustomTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomLabel LeeCustomTitle;
/** 设置 Alert 自定义内容 -> 格式: .LeeCustomContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomLabel LeeCustomContent;
/** 设置 Alert 自定义取消按钮 -> 格式: .LeeCustomCancelButton(^(UIButton *button){ //code.. } */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomButton LeeCustomCancelButton;
/** 设置 Alert 自定义视图 -> 格式: .LeeCustomView(UIView) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToView LeeCustomView;
/** 设置 Alert 添加自定义按钮 -> 格式: .LeeAddCustomButton(^(UIButton *button){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomButton LeeAddCustomButton;

/** 设置 Alert 自定义圆角半径 -> 格式: .LeeCustomCornerRadius(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomCornerRadius;
/** 设置 Alert 自定义控件间距 -> 格式: .LeeCustomSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomSubViewMargin;
/** 设置 Alert 自定义顶部距离控件的间距 -> 格式: .LeeCustomTopSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomTopSubViewMargin;
/** 设置 Alert 自定义底部距离控件的间距 -> 格式: .LeeCustomBottomSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomBottomSubViewMargin;
/** 设置 Alert 自定义左侧距离控件的间距 -> 格式: .LeeCustomLeftSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomLeftSubViewMargin;
/** 设置 Alert 自定义右侧距离控件的间距 -> 格式: .LeeCustomRightSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomRightSubViewMargin;
/** 设置 Alert 自定义警示框最大宽度 -> 格式: .LeeCustomAlertMaxWidth(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomAlertMaxWidth;
/** 设置 Alert 自定义警示框最大高度 -> 格式: .LeeCustomAlertMaxHeight(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomAlertMaxHeight;
/** 设置 Alert 自定义警示框开启动画时长 -> 格式: .LeeCustomAlertOpenAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomAlertOpenAnimationDuration;
/** 设置 Alert 自定义警示框关闭动画时长 -> 格式: .LeeCustomAlertCloseAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomAlertCloseAnimationDuration;

/** 设置 Alert 自定义警示框颜色 -> 格式: .LeeCustomAlertViewColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToColor LeeCustomAlertViewColor;
/** 设置 Alert 自定义警示框半透明或模糊背景颜色 -> 格式: .LeeCustomAlertViewBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToColor LeeCustomAlertViewBackGroundColor;

/** 设置 Alert 自定义警示框半透明背景样式及透明度 [默认] -> 格式: .LeeCustomAlertViewBackGroundStypeTranslucent(0.6f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomAlertViewBackGroundStypeTranslucent;
/** 设置 Alert 自定义警示框模糊背景样式及透明度 -> 格式: .LeeCustomAlertViewBackGroundStypeBlur(0.6f) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat LeeCustomAlertViewBackGroundStypeBlur;

/** 设置 Alert 自定义警示框背景触摸关闭 -> 格式: .LeeCustomAlertTouchClose() */
@property (nonatomic , copy , readonly ) LEEConfigAlert LeeCustomAlertTouchClose;
/** 设置 Alert 自定义按钮点击不关闭警示框 -> 格式: .LeeCustomButtonClickNotClose() */
@property (nonatomic , copy , readonly ) LEEConfigAlert LeeCustomButtonClickNotClose;

/** 显示 Alert 是否加入到队列 -> 格式: .LeeAddQueue(NO) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToBool LeeAddQueue;

/** 显示 Alert 默认通过KeyWindow弹出 -> 格式: .LeeShow() */
@property (nonatomic , copy , readonly ) LEEConfigAlert LeeShow;
/** 显示 Alert 通过指定视图控制器弹出 (仅适用系统类型)  -> 格式: .LeeShowFromViewController(UIViewController) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToViewController LeeShowFromViewController;

@end

@interface LEEAlertSystem : NSObject

/** 开始设置 */
@property (nonatomic , strong ) LEEAlertConfigModel *config;

@end

@interface LEEAlertCustom : NSObject

/** 开始设置 */
@property (nonatomic , strong ) LEEAlertConfigModel *config;

@end

@interface LEEAlertViewController : UIViewController @end




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

@interface UIImage (LEEAlertImageEffects)

- (UIImage*)LeeAlert_ApplyLightEffect;

- (UIImage*)LeeAlert_ApplyExtraLightEffect;

- (UIImage*)LeeAlert_ApplyDarkEffect;

- (UIImage*)LeeAlert_ApplyTintEffectWithColor:(UIColor*)tintColor;

- (UIImage*)LeeAlert_ApplyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end
