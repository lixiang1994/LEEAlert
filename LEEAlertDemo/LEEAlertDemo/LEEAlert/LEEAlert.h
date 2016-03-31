
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

/* Alert 基本信息 */

/** 设置 Alert 标题 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString title;
/** 设置 Alert 内容 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString content;
/** 设置 Alert 取消按钮标题 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString cancelButtonTitle;
/** 设置 Alert 取消按钮响应事件Block */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonBlock cancelButtonAction;
/** 设置 Alert 添加按钮 (按钮标题 , 点击响应事件Block) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonAndBlock addButton;
/** 设置 Alert 添加输入框 (返回输入框对象的block) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomTextField addTextField;

/* Alert 自定义信息 */

/** 设置 Alert 自定义标题 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomLabel customTitle;
/** 设置 Alert 自定义内容 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomLabel customContent;
/** 设置 Alert 自定义取消按钮 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomButton customCancelButton;
/** 设置 Alert 自定义视图 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToView customView;
/** 设置 Alert 添加自定义按钮 (按钮对象Block) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToCustomButton addCustomButton;

/** 设置 Alert 自定义圆角半径 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customCornerRadius;
/** 设置 Alert 自定义控件间距 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customSubViewMargin;
/** 设置 Alert 自定义顶部控件间距 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customTopSubViewMargin;
/** 设置 Alert 自定义底部控件间距 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customBottomSubViewMargin;
/** 设置 Alert 自定义警示框最大宽度 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertMaxWidth;
/** 设置 Alert 自定义警示框最大高度 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertMaxHeight;
/** 设置 Alert 自定义警示框开启动画时长 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertOpenAnimationDuration;
/** 设置 Alert 自定义警示框关闭动画时长 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToFloat customAlertCloseAnimationDuration;

/** 设置 Alert 自定义警示框颜色 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToColor customAlertViewColor;
/** 设置 Alert 自定义警示框半透明或模糊背景颜色 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToColor customAlertViewBackGroundColor;

/** 设置 Alert 自定义警示框半透明背景样式 [默认] */
@property (nonatomic , copy , readonly ) LEEConfigAlert customAlertViewBackGroundStypeTranslucent;
/** 设置 Alert 自定义警示框模糊背景样式 */
@property (nonatomic , copy , readonly ) LEEConfigAlert customAlertViewBackGroundStypeBlur;

/** 显示 Alert 默认通过KeyWindow弹出 (二选一) */
@property (nonatomic , copy , readonly ) LEEConfigAlert show;
/** 显示 Alert 通过指定视图控制器弹出 (二选一) */
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








































/* 以下是内部使用的工具类 ╮(╯▽╰)╭ 无视就好 */

@interface UIImage (LEEImageEffects)

-(UIImage*)applyLightEffect;

-(UIImage*)applyExtraLightEffect;

-(UIImage*)applyDarkEffect;

-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;

-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end