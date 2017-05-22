
/*!
 *  @header LEEAlert.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEEAlert
 *
 *  @author LEE
 *  @copyright    Copyright © 2016 - 2017年 lee. All rights reserved.
 *  @version    V1.0.0
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "LEEAlertHelper.h"

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

/** ✨通用设置 */

/** 设置 标题 -> 格式: .LeeTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigToString LeeTitle;

/** 设置 内容 -> 格式: .LeeContent(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigToString LeeContent;

/** 设置 自定义视图 -> 格式: .LeeCustomView(UIView) */
@property (nonatomic , copy , readonly ) LEEConfigToView LeeCustomView;

/** 设置 动作 -> 格式: .LeeAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToStringAndBlock LeeAction;

/** 设置 取消动作 -> 格式: .LeeCancelAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToStringAndBlock LeeCancelAction;

/** 设置 取消动作 -> 格式: .LeeDestructiveAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToStringAndBlock LeeDestructiveAction;

/** 设置 添加标题 -> 格式: .LeeConfigTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigLabel LeeAddTitle;

/** 设置 添加内容 -> 格式: .LeeConfigContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigLabel LeeAddContent;

/** 设置 添加一项 -> 格式: .LeeAddItem(^(LEEItem *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToItem LeeAddItem;

/** 设置 添加动作 -> 格式: .LeeAddAction(^(LEEAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToAction LeeAddAction;

/** 设置 添加自定义视图 -> 格式: .LeeAddCustomView(^(LEECustomView *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToCustomView LeeAddCustomView;

/** 设置 头部内的间距 -> 格式: .LeeHeaderInsets(UIEdgeInsetsMake(20, 20, 20, 20)) */
@property (nonatomic , copy , readonly ) LEEConfigToEdgeInsets LeeHeaderInsets;

/** 设置 上一项的间距 (在它之前添加的项的间距) -> 格式: .LeeItemInsets(UIEdgeInsetsMake(5, 0, 5, 0)) */
@property (nonatomic , copy , readonly ) LEEConfigToEdgeInsets LeeItemInsets;

/** 设置 最大宽度 -> 格式: .LeeMaxWidth(280.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeMaxWidth;

/** 设置 最大高度 -> 格式: .LeeMaxHeight(400.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeMaxHeight;

/** 设置 设置最大宽度 -> 格式: .LeeConfigMaxWidth(CGFloat(^)(^CGFloat(LEEScreenOrientationType type) { return 280.0f; }) */
@property (nonatomic , copy , readonly ) LEEConfigToFloatBlock LeeConfigMaxWidth;

/** 设置 设置最大高度 -> 格式: .LeeConfigMaxHeight(CGFloat(^)(^CGFloat(LEEScreenOrientationType type) { return 600.0f; }) */
@property (nonatomic , copy , readonly ) LEEConfigToFloatBlock LeeConfigMaxHeight;

/** 设置 圆角半径 -> 格式: .LeeCornerRadius(13.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeCornerRadius;

/** 设置 开启动画时长 -> 格式: .LeeOpenAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeOpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .LeeCloseAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeCloseAnimationDuration;

/** 设置 颜色 -> 格式: .LeeColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeColor;

/** 设置 背景颜色 -> 格式: .LeeBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeBackGroundColor;

/** 设置 半透明背景样式及透明度 [默认] -> 格式: .LeeBackgroundStyleTranslucent(0.45f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeBackgroundStyleTranslucent;

/** 设置 模糊背景样式及类型 -> 格式: .LeeBackgroundStyleBlur(UIBlurEffectStyleDark) */
@property (nonatomic , copy , readonly ) LEEConfigToBlurEffectStyle LeeBackgroundStyleBlur;

/** 设置 点击背景关闭 -> 格式: .LeeClickBackgroundClose() */
@property (nonatomic , copy , readonly ) LEEConfig LeeClickBackgroundClose;

/** 设置 是否加入到队列 -> 格式: .LeeAddQueue() */
@property (nonatomic , copy , readonly ) LEEConfig LeeAddQueue;


/** 显示  -> 格式: .LeeShow() */
@property (nonatomic , copy , readonly ) LEEConfig LeeShow;

/** ✨alert 专用设置 */

/** 设置 添加输入框 -> 格式: .LeeAddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigTextField LeeAddTextField;

/** ✨actionSheet 专用设置 */

/** 设置 取消动作的间隔宽度 -> 格式: .LeeActionSheetCancelActionSpaceWidth(10.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeActionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 -> 格式: .LeeActionSheetCancelActionSpaceColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeActionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 -> 格式: .LeeActionSheetBottomMargin(10.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeActionSheetBottomMargin;

@end


@interface LEEItem : NSObject

@property (nonatomic , assign ) LEEItemType type;

@property (nonatomic , assign ) UIEdgeInsets insets;

@property (nonatomic , copy ) void (^block)(id view);

- (void)update;

@end

@interface LEEAction : NSObject

@property (nonatomic , assign ) LEEActionType type;

@property (nonatomic , strong ) NSString *title;

@property (nonatomic , strong ) NSString *highlight;

@property (nonatomic , strong ) UIFont *font;

@property (nonatomic , strong ) UIColor *titleColor;

@property (nonatomic , strong ) UIColor *highlightColor;

@property (nonatomic , strong ) UIColor *backgroundColor;

@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , strong ) UIImage *image;

@property (nonatomic , strong ) UIImage *highlightImage;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , assign ) CGFloat height;

@property (nonatomic , assign ) BOOL isClickNotClose;

@property (nonatomic , copy ) void (^clickBlock)();

- (void)update;

@end

@interface LEECustomView : NSObject

@property (nonatomic , strong ) UIView *view;

@property (nonatomic , assign ) LEECustomViewPositionType positionType;

@end


@interface LEEAlertConfig : NSObject

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@property (nonatomic , assign ) LEEAlertType type;

@end


@interface LEEBaseViewController : UIViewController @end

@interface LEEAlertViewController : LEEBaseViewController @end

@interface LEEActionSheetViewController : LEEBaseViewController @end
