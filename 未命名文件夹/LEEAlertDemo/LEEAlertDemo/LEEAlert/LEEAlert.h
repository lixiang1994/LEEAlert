//
//  LEEAlert.h
//  LEEAlertDemo
//
//  Created by 李响 on 2017/3/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class LEEAlert , LEEAlertConfig , LEEAlertConfigModel , LEEAction;

typedef LEEAlertConfigModel *(^LEEConfig)();
typedef LEEAlertConfigModel *(^LEEConfigToFloat)(CGFloat number);
typedef LEEAlertConfigModel *(^LEEConfigToString)(NSString *str);
typedef LEEAlertConfigModel *(^LEEConfigToView)(UIView *view);
typedef LEEAlertConfigModel *(^LEEConfigToColor)(UIColor *color);
typedef LEEAlertConfigModel *(^LEEConfigToAction)(void(^)(LEEAction *action));
typedef LEEAlertConfigModel *(^LEEConfigToConfigLabel)(void(^configLabel)(UILabel *label));
typedef LEEAlertConfigModel *(^LEEConfigToConfigTextField)(void(^configTextField)(UITextField *textField));

@interface LEEAlert : NSObject

/** 初始化 */

+ (LEEAlertConfig *)alert;

+ (LEEAlertConfig *)actionsheet;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow *)window;

/** 关闭 */

+ (void)closeWithCompletionBlock:(void (^)())completionBlock;

@end

@interface LEEAlertConfigModel : NSObject

/** 设置 标题 -> 格式: .LeeTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigToString LeeTitle;

/** 设置 内容 -> 格式: .LeeContent(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigToString LeeContent;

/** 设置 内容 -> 格式: .LeeAction(^(LEEAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToAction LeeAction;

/** 设置 添加输入框 -> 格式: .LeeAddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigTextField LeeAddTextField;

/** 设置 添加标题 -> 格式: .LeeCustomTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigLabel LeeAddTitle;

/** 设置 添加内容 -> 格式: .LeeCustomContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigLabel LeeAddContent;

/** 设置 自定义视图 -> 格式: .LeeCustomView(UIView) */
@property (nonatomic , copy , readonly ) LEEConfigToView LeeCustomView;

/** 设置 圆角半径 -> 格式: .LeeCornerRadius(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeCornerRadius;

/** 设置 子控件间距 -> 格式: .LeeSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeSubViewMargin;

/** 设置 顶部距离控件的间距 -> 格式: .LeeTopSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeTopSubViewMargin;

/** 设置 底部距离控件的间距 -> 格式: .LeeBottomSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeBottomSubViewMargin;

/** 设置 左侧距离控件的间距 -> 格式: .LeeLeftSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeLeftSubViewMargin;

/** 设置 右侧距离控件的间距 -> 格式: .LeeRightSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeRightSubViewMargin;

/** 设置 最大宽度 -> 格式: .LeeMaxWidth(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeMaxWidth;

/** 设置 最大高度 -> 格式: .LeeMaxHeight(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeMaxHeight;

/** 设置 开启动画时长 -> 格式: .LeeOpenAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeOpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .LeeCloseAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeCloseAnimationDuration;


/** 设置 颜色 -> 格式: .LeeColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeColor;

/** 设置 背景颜色 -> 格式: .LeeBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeBackGroundColor;


/** 设置 半透明背景样式及透明度 [默认] -> 格式: .LeeBackgroundStyleTranslucent(0.6f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeBackgroundStyleTranslucent;

/** 设置 模糊背景样式及透明度 -> 格式: .LeeViewBackgroundStyleBlur(0.6f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeViewBackgroundStyleBlur;

/** 设置 点击背景关闭 -> 格式: .LeeClickBackgroundClose() */
@property (nonatomic , copy , readonly ) LEEConfig LeeClickBackgroundClose;

/** 设置 点击按钮关闭 -> 格式: .LeeClickActionClose() */
@property (nonatomic , copy , readonly ) LEEConfig LeeClickActionClose;

/** 设置 是否加入到队列 -> 格式: .LeeAddQueue() */
@property (nonatomic , copy , readonly ) LEEConfig LeeAddQueue;


/** 显示  -> 格式: .LeeShow() */
@property (nonatomic , copy , readonly ) LEEConfig LeeShow;

@end


typedef NS_ENUM(NSInteger, LEEActionType) {
    
    LEEActionTypeDefault,
    
    LEEActionTypeCancel,
    
    LEEActionTypeDestructive
};

@interface LEEAction : NSObject

@property (nonatomic , strong ) NSString *title;

@property (nonatomic , strong ) NSString *highlight;

@property (nonatomic , strong ) UIFont *font;

@property (nonatomic , strong ) UIColor *titleColor;

@property (nonatomic , strong ) UIColor *highlightColor;

@property (nonatomic , strong ) UIColor *backgroundColor;

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) LEEActionType type;

@property (nonatomic , copy ) void (^clickBlock)();

@end

typedef NS_ENUM(NSInteger, LEEItemType) {
    
    LEEItemTypeTitle,
    
    LEEItemTypeContent,
    
    LEEItemTypeCustomView
};

@interface LEEAction : NSObject

@property (nonatomic , strong ) NSString *title;

@property (nonatomic , strong ) NSString *highlight;

@property (nonatomic , strong ) UIFont *font;

@property (nonatomic , strong ) UIColor *titleColor;

@property (nonatomic , strong ) UIColor *highlightColor;

@property (nonatomic , strong ) UIColor *backgroundColor;

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) LEEActionType type;

@property (nonatomic , copy ) void (^clickBlock)();

@end



typedef NS_ENUM(NSInteger, LEEAlertType) {
    
    LEEAlertTypeAlert,
    
    LEEAlertTypeActionSheet
};

@interface LEEAlertConfig : NSObject

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@property (nonatomic , assign ) LEEAlertType type;

@end

@interface LEEBaseViewController : UIViewController @end

@interface LEEAlertViewController : LEEBaseViewController @end

@interface LEEActionSheetViewController : LEEBaseViewController @end


@interface UIImage (LEEImageEffects)

- (UIImage*)Lee_ApplyLightEffect;

- (UIImage*)Lee_ApplyExtraLightEffect;

- (UIImage*)Lee_ApplyDarkEffect;

- (UIImage*)Lee_ApplyTintEffectWithColor:(UIColor*)tintColor;

- (UIImage*)Lee_ApplyBlurWithRadius:(CGFloat)blurRadius TintColor:(UIColor*)tintColor SaturationDeltaFactor:(CGFloat)saturationDeltaFactor MaskImage:(UIImage*)maskImage;

@end
