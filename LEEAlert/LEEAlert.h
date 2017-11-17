
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
 *  @version    V1.1.5
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "LEEAlertHelper.h"


/*
 *************************简要说明************************
 
 Alert 使用方法
 
 [LEEAlert alert].cofing.XXXXX.XXXXX.LeeShow();
 
 ActionSheet 使用方法
 
 [LEEAlert actionSheet].cofing.XXXXX.XXXXX.LeeShow();
 
 特性:
 - 支持alert类型与actionsheet类型
 - 默认样式为Apple风格 可自定义其样式
 - 支持自定义标题与内容 可动态调整其样式
 - 支持自定义视图添加 同时可设置位置类型等 自定义视图size改变时会自动适应.
 - 支持输入框添加 自动处理键盘相关的细节
 - 支持屏幕旋转适应 同时可自定义横竖屏最大宽度和高度
 - 支持自定义action添加 可动态调整其样式
 - 支持内部添加的功能项的间距范围设置等
 - 支持圆角设置 支持阴影效果设置
 - 支持队列和优先级 多个同时显示时根据优先级顺序排队弹出 添加到队列的如被高优先级覆盖 以后还会继续显示.
 - 支持两种背景样式 1.半透明 (支持自定义透明度比例和颜色) 2.毛玻璃 (支持效果类型)
 - 支持自定义UIView动画方法
 - 支持自定义打开关闭动画样式(动画方向 渐变过渡 缩放过渡等)
 - 更多特性未来版本中将不断更新.
 
 设置方法结束后在最后请不要忘记使用.LeeShow()方法来显示.
 
 最低支持iOS8及以上
 
 *****************************************************
 */


@interface LEEAlert : NSObject

/** 初始化 */

+ (LEEAlertConfig *)alert;

+ (LEEAlertConfig *)actionsheet;

/** 获取Alert窗口 */

+ (LEEAlertWindow *)getAlertWindow;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow *)window;

/** 继续队列显示 */

+ (void)continueQueueDisplay;

/** 清空队列 */

+ (void)clearQueue;

/** 关闭 */

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

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

/** 设置 添加自定义视图 -> 格式: .LeeAddCustomView(^(LEECustomView *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToCustomView LeeAddCustomView;

/** 设置 添加一项 -> 格式: .LeeAddItem(^(LEEItem *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToItem LeeAddItem;

/** 设置 添加动作 -> 格式: .LeeAddAction(^(LEEAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToAction LeeAddAction;

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

/** 设置 开启动画时长 -> 格式: .LeeOpenAnimationDuration(0.3f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeOpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .LeeCloseAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeCloseAnimationDuration;

/** 设置 颜色 -> 格式: .LeeHeaderColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeHeaderColor;

/** 设置 背景颜色 -> 格式: .LeeBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeBackGroundColor;

/** 设置 半透明背景样式及透明度 [默认] -> 格式: .LeeBackgroundStyleTranslucent(0.45f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeBackgroundStyleTranslucent;

/** 设置 模糊背景样式及类型 -> 格式: .LeeBackgroundStyleBlur(UIBlurEffectStyleDark) */
@property (nonatomic , copy , readonly ) LEEConfigToBlurEffectStyle LeeBackgroundStyleBlur;

/** 设置 点击头部关闭 -> 格式: .LeeClickHeaderClose(YES) */
@property (nonatomic , copy , readonly ) LEEConfigToBool LeeClickHeaderClose;

/** 设置 点击背景关闭 -> 格式: .LeeClickBackgroundClose(YES) */
@property (nonatomic , copy , readonly ) LEEConfigToBool LeeClickBackgroundClose;

/** 设置 阴影偏移 -> 格式: .LeeShadowOffset(CGSizeMake(0.0f, 2.0f)) */
@property (nonatomic , copy , readonly ) LEEConfigToSize LeeShadowOffset;

/** 设置 阴影不透明度 -> 格式: .LeeShadowOpacity(0.3f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeShadowOpacity;

/** 设置 阴影半径 -> 格式: .LeeShadowRadius(5.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeShadowRadius;

/** 设置 阴影颜色 -> 格式: .LeeShadowOpacity(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeShadowColor;

/** 设置 标识 -> 格式: .LeeIdentifier(@@"ident") */
//@property (nonatomic , copy , readonly ) LEEConfigToString LeeIdentifier;

/** 设置 是否加入到队列 -> 格式: .LeeQueue(YES) */
@property (nonatomic , copy , readonly ) LEEConfigToBool LeeQueue;

/** 设置 优先级 -> 格式: .LeePriority(1000) */
@property (nonatomic , copy , readonly ) LEEConfigToInteger LeePriority;

/** 设置 是否继续队列显示 -> 格式: .LeeContinueQueue(YES) */
@property (nonatomic , copy , readonly ) LEEConfigToBool LeeContinueQueueDisplay;

/** 设置 window等级 -> 格式: .LeeWindowLevel(UIWindowLevel) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeWindowLevel;

/** 设置 是否支持自动旋转 -> 格式: .LeeShouldAutorotate(YES) */
@property (nonatomic , copy , readonly ) LEEConfigToBool LeeShouldAutorotate;

/** 设置 是否支持显示方向 -> 格式: .LeeShouldAutorotate(UIInterfaceOrientationMaskAll) */
@property (nonatomic , copy , readonly ) LEEConfigToInterfaceOrientationMask LeeSupportedInterfaceOrientations;

/** 设置 打开动画配置 -> 格式: .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToBlockAndBlock LeeOpenAnimationConfig;

/** 设置 关闭动画配置 -> 格式: .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToBlockAndBlock LeeCloseAnimationConfig;

/** 设置 打开动画样式 -> 格式: .LeeOpenAnimationStyle() */
@property (nonatomic , copy , readonly ) LEEConfigToAnimationStyle LeeOpenAnimationStyle;

/** 设置 关闭动画样式 -> 格式: .LeeCloseAnimationStyle() */
@property (nonatomic , copy , readonly ) LEEConfigToAnimationStyle LeeCloseAnimationStyle;


/** 显示  -> 格式: .LeeShow() */
@property (nonatomic , copy , readonly ) LEEConfig LeeShow;

/** ✨alert 专用设置 */

/** 设置 添加输入框 -> 格式: .LeeAddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToConfigTextField LeeAddTextField;

/** 设置 是否闪避键盘 -> 格式: .LeeAvoidKeyboard(YES) */
@property (nonatomic , copy , readonly ) LEEConfigToBool LeeAvoidKeyboard;

/** ✨actionSheet 专用设置 */

/** 设置 取消动作的间隔宽度 -> 格式: .LeeActionSheetCancelActionSpaceWidth(10.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeActionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 -> 格式: .LeeActionSheetCancelActionSpaceColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigToColor LeeActionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 -> 格式: .LeeActionSheetBottomMargin(10.0f) */
@property (nonatomic , copy , readonly ) LEEConfigToFloat LeeActionSheetBottomMargin;



/** 设置 当前关闭回调 -> 格式: .LeeCloseComplete(^{ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigToBlock LeeCloseComplete;

@end


@interface LEEItem : NSObject

/** item类型 */
@property (nonatomic , assign ) LEEItemType type;

/** item间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** item设置视图Block */
@property (nonatomic , copy ) void (^block)(id view);

- (void)update;

@end

@interface LEEAction : NSObject

/** action类型 */
@property (nonatomic , assign ) LEEActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) LEEActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^clickBlock)(void);

- (void)update;

@end

@interface LEECustomView : NSObject

/** 自定义视图对象 */
@property (nonatomic , strong ) UIView *view;

/** 自定义视图位置类型 (默认为居中) */
@property (nonatomic , assign ) LEECustomViewPositionType positionType;

/** 是否自动适应宽度 */
@property (nonatomic , assign ) BOOL isAutoWidth;

@end

@interface LEEAlertConfig : NSObject

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@property (nonatomic , assign ) LEEAlertType type;

@end


@interface LEEAlertWindow : UIWindow @end

@interface LEEBaseViewController : UIViewController @end

@interface LEEAlertViewController : LEEBaseViewController @end

@interface LEEActionSheetViewController : LEEBaseViewController @end
