
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
 *  @copyright    Copyright © 2016 - 2019年 lee. All rights reserved.
 *  @version    V1.3.3
 */

#ifndef LEEAlertHelper_h
#define LEEAlertHelper_h

FOUNDATION_EXPORT double LEEAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char LEEAlertVersionString[];

@class LEEAlert
, LEEBaseConfig
, LEEAlertConfig
, LEEActionSheetConfig
, LEEBaseConfigModel
, LEEAlertWindow
, LEEAction
, LEEItem
, LEECustomView;

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

typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} CornerRadii;

NS_ASSUME_NONNULL_BEGIN
typedef LEEBaseConfigModel * _Nonnull (^LEEConfig)(void);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToBool)(BOOL is);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToInteger)(NSInteger number);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToFloat)(CGFloat number);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToString)(NSString *str);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToView)(UIView *view);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToColor)(UIColor *color);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToSize)(CGSize size);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToPoint)(CGPoint point);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToEdgeInsets)(UIEdgeInsets insets);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToAnimationStyle)(LEEAnimationStyle style);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToFloatBlock)(CGFloat(^)(LEEScreenOrientationType type));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToAction)(void(^)(LEEAction *action));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToCustomView)(void(^)(LEECustomView *custom));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToCornerRadii)(CornerRadii);
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToStringAndBlock)(NSString *str, void (^ _Nullable)(void));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToConfigLabel)(void(^ _Nullable)(UILabel *label));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToConfigTextField)(void(^ _Nullable)(UITextField *textField));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToItem)(void(^)(LEEItem *item));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToBlock)(void(^block)(void));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToBlockReturnBool)(BOOL(^block)(void));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToBlockIntegerReturnBool)(BOOL(^block)(NSInteger index));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToBlockAndBlock)(void(^)(void (^animatingBlock)(void) , void (^animatedBlock)(void)));
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToStatusBarStyle)(UIStatusBarStyle style);
API_AVAILABLE(ios(13.0))
typedef LEEBaseConfigModel * _Nonnull (^LEEConfigToUserInterfaceStyle)(UIUserInterfaceStyle style);
NS_ASSUME_NONNULL_END

#endif /* LEEAlertHelper_h */
