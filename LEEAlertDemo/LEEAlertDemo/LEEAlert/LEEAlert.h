
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
typedef LEEAlertConfigModel *(^LEEConfigAlertToString)(NSString *str);
typedef LEEAlertConfigModel *(^LEEConfigAlertToView)(UIView *view);
typedef LEEAlertConfigModel *(^LEEConfigAlertToButtonAndBlock)(NSString *title , void(^buttonAction)());
typedef LEEAlertConfigModel *(^LEEConfigAlertToButtonBlock)(void(^buttonAction)());
typedef LEEAlertConfigModel *(^LEEConfigAlertToTextField)(void(^addTextField)(UITextField *textField));
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

@end

@interface LEEAlertConfigModel : NSObject

/* Alert 基本信息 */

/* 设置 Alert 标题 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString title;
/* 设置 Alert 内容 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString content;
/* 设置 Alert 取消按钮标题 */
@property (nonatomic , copy , readonly ) LEEConfigAlertToString cancelButtonTitle;
/* 设置 Alert 取消按钮响应事件Block */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonBlock cancelButtonAction;
/* 设置 Alert 添加按钮 (按钮标题 , 响应事件Block) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToButtonAndBlock addButton;
/* 设置 Alert 添加输入框 (输入框对象返回Block) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToTextField addTextField;


/* 显示 Alert 默认通过KeyWindow弹出 (二选一) */
@property (nonatomic , copy , readonly ) LEEConfigAlert show;
/* 显示 Alert 通过指定视图控制器弹出 (二选一) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToViewController showFromViewController;


/* 以下为配置模型属性 ╮(╯▽╰)╭ 无视就好 */

@property (nonatomic , copy , readonly ) NSString *modelTitleStr;
@property (nonatomic , copy , readonly ) NSString *modelContentStr;
@property (nonatomic , copy , readonly ) NSString *modelCancelButtonTitleStr;
@property (nonatomic , strong ) NSMutableArray *modelButtonArray;
@property (nonatomic , strong ) NSMutableArray *modelTextFieldArray;
@property (nonatomic , copy ) void(^modelCancelButtonAction)();
@property (nonatomic , copy ) void(^modelFinishConfig)(UIViewController *vc);

@end

@interface LEEAlertConfigCustomModel : LEEAlertConfigModel

/* Alert 自定义信息 */

/* 设置 Alert 自定义视图 (仅适用于自定义类型) */
@property (nonatomic , copy , readonly ) LEEConfigAlertToView customView;



/* 以下为配置模型属性 ╮(╯▽╰)╭ 无视就好 */

@property (nonatomic , strong ) NSMutableArray *modelCustomSubViewsQueue;
@property (nonatomic , strong , readonly ) UIView *modelCustomContentView;

@end


@interface LEEAlertSystem : NSObject

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@end

@interface LEEAlertCustom : NSObject

@property (nonatomic , strong ) LEEAlertConfigCustomModel *config;

@end