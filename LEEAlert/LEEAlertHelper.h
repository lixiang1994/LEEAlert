
/*!
 *  @header LEEAlertHelper.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEEAlertHelper
 *
 *  @author LEE
 *  @copyright    Copyright © 2016 - 2017年 lee. All rights reserved.
 *  @version    V1.1.5
 */

#ifndef LEEAlertHelper_h
#define LEEAlertHelper_h

FOUNDATION_EXPORT double LEEAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char LEEAlertVersionString[];

@class LEEAlert , LEEAlertConfig , LEEAlertConfigModel , LEEAlertWindow , LEEAction , LEEItem , LEECustomView;

typedef NS_ENUM(NSInteger, LEEScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    LEEScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    LEEScreenOrientationTypeVertical
};


typedef NS_ENUM(NSInteger, LEEAlertType) {
    
    LEEAlertTypeAlert,
    
    LEEAlertTypeActionSheet
};


typedef NS_ENUM(NSInteger, LEEActionType) {
    /** 默认 */
    LEEActionTypeDefault,
    /** 取消 */
    LEEActionTypeCancel,
    /** 销毁 */
    LEEActionTypeDestructive
};


typedef NS_OPTIONS(NSInteger, LEEActionBorderPosition) {
    /** Action边框位置 上 */
    LEEActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    LEEActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    LEEActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    LEEActionBorderPositionRight    = 1 << 3
};


typedef NS_ENUM(NSInteger, LEEItemType) {
    /** 标题 */
    LEEItemTypeTitle,
    /** 内容 */
    LEEItemTypeContent,
    /** 输入框 */
    LEEItemTypeTextField,
    /** 自定义视图 */
    LEEItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, LEECustomViewPositionType) {
    /** 居中 */
    LEECustomViewPositionTypeCenter,
    /** 靠左 */
    LEECustomViewPositionTypeLeft,
    /** 靠右 */
    LEECustomViewPositionTypeRight
};

typedef NS_OPTIONS(NSInteger, LEEAnimationStyle) {
    /** 动画样式方向 默认 */
    LEEAnimationStyleOrientationNone    = 1 << 0,
    /** 动画样式方向 上 */
    LEEAnimationStyleOrientationTop     = 1 << 1,
    /** 动画样式方向 下 */
    LEEAnimationStyleOrientationBottom  = 1 << 2,
    /** 动画样式方向 左 */
    LEEAnimationStyleOrientationLeft    = 1 << 3,
    /** 动画样式方向 右 */
    LEEAnimationStyleOrientationRight   = 1 << 4,
    
    /** 动画样式 淡入淡出 */
    LEEAnimationStyleFade               = 1 << 12,
    
    /** 动画样式 缩放 放大 */
    LEEAnimationStyleZoomEnlarge        = 1 << 24,
    /** 动画样式 缩放 缩小 */
    LEEAnimationStyleZoomShrink         = 2 << 24,
};

typedef LEEAlertConfigModel *(^LEEConfig)(void);
typedef LEEAlertConfigModel *(^LEEConfigToBool)(BOOL is);
typedef LEEAlertConfigModel *(^LEEConfigToInteger)(NSInteger number);
typedef LEEAlertConfigModel *(^LEEConfigToFloat)(CGFloat number);
typedef LEEAlertConfigModel *(^LEEConfigToString)(NSString *str);
typedef LEEAlertConfigModel *(^LEEConfigToView)(UIView *view);
typedef LEEAlertConfigModel *(^LEEConfigToColor)(UIColor *color);
typedef LEEAlertConfigModel *(^LEEConfigToSize)(CGSize size);
typedef LEEAlertConfigModel *(^LEEConfigToEdgeInsets)(UIEdgeInsets insets);
typedef LEEAlertConfigModel *(^LEEConfigToAnimationStyle)(LEEAnimationStyle style);
typedef LEEAlertConfigModel *(^LEEConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef LEEAlertConfigModel *(^LEEConfigToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef LEEAlertConfigModel *(^LEEConfigToFloatBlock)(CGFloat(^)(LEEScreenOrientationType type));
typedef LEEAlertConfigModel *(^LEEConfigToAction)(void(^)(LEEAction *action));
typedef LEEAlertConfigModel *(^LEEConfigToCustomView)(void(^)(LEECustomView *custom));
typedef LEEAlertConfigModel *(^LEEConfigToStringAndBlock)(NSString *str , void (^)(void));
typedef LEEAlertConfigModel *(^LEEConfigToConfigLabel)(void(^)(UILabel *label));
typedef LEEAlertConfigModel *(^LEEConfigToConfigTextField)(void(^)(UITextField *textField));
typedef LEEAlertConfigModel *(^LEEConfigToItem)(void(^)(LEEItem *item));
typedef LEEAlertConfigModel *(^LEEConfigToBlock)(void(^block)(void));
typedef LEEAlertConfigModel *(^LEEConfigToBlockAndBlock)(void(^)(void (^animatingBlock)(void) , void (^animatedBlock)(void)));

#endif /* LEEAlertHelper_h */
