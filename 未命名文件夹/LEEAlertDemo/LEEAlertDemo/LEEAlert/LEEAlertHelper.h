//
//  LEEAlertHelper.h
//  LEEAlertDemo
//
//  Created by 李响 on 2017/5/18.
//  Copyright © 2017年 lee. All rights reserved.
//

#ifndef LEEAlertHelper_h
#define LEEAlertHelper_h

@class LEEAlert , LEEAlertConfig , LEEAlertConfigModel , LEEAction;

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
    
    LEEActionTypeDefault,
    
    LEEActionTypeCancel,
    
    LEEActionTypeDestructive
};

typedef LEEAlertConfigModel *(^LEEConfig)();
typedef LEEAlertConfigModel *(^LEEConfigToFloat)(CGFloat number);
typedef LEEAlertConfigModel *(^LEEConfigToString)(NSString *str);
typedef LEEAlertConfigModel *(^LEEConfigToView)(UIView *view);
typedef LEEAlertConfigModel *(^LEEConfigToColor)(UIColor *color);
typedef LEEAlertConfigModel *(^LEEConfigToEdgeInsets)(UIEdgeInsets insets);
typedef LEEAlertConfigModel *(^LEEConfigToFloatBlock)(CGFloat(^)(LEEScreenOrientationType type));
typedef LEEAlertConfigModel *(^LEEConfigToAction)(void(^)(LEEAction *action));
typedef LEEAlertConfigModel *(^LEEConfigToStringAndBlock)(NSString *str , void (^)());
typedef LEEAlertConfigModel *(^LEEConfigToConfigLabel)(void(^configLabel)(UILabel *label));
typedef LEEAlertConfigModel *(^LEEConfigToConfigTextField)(void(^configTextField)(UITextField *textField));

#endif /* LEEAlertHelper_h */
