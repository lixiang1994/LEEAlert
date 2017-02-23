/*!
 *  @header LEEAlert.m
 *
 *
 *  @brief  警告框
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.1
 */


#import "LEEAlert.h"

#import <objc/runtime.h>

#import <Accelerate/Accelerate.h>

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

@interface LEEAlert ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) UIWindow *alertWindow;

@property (nonatomic , strong ) NSMutableArray <LEEAlertCustom *>*customAlertArray;

@end

@protocol LEEAlertProtocol <NSObject>

- (void)closeAlertWithCompletionBlock:(void (^)())completionBlock;

@end

@implementation LEEAlert

- (void)dealloc{
    
    _system = nil;
    
    _custom = nil;
    
    _mainWindow = nil;
    
    _alertWindow = nil;
}

+ (LEEAlert *)shareAlertManager{
    
    static LEEAlert *alertManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alertManager = [LEEAlert alert];
    });
    
    return alertManager;
}

+ (LEEAlert *)alert{
    
    LEEAlert *alert = [[LEEAlert alloc] init];
    
    return alert;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [LEEAlert shareAlertManager].mainWindow = window;
}

+ (void)closeCustomAlert{
    
    [self closeCustomAlertWithCompletionBlock:nil];
}

+ (void)closeCustomAlertWithCompletionBlock:(void (^)())completionBlock{
    
    if ([LEEAlert shareAlertManager].customAlertArray.count) {
        
        LEEAlertCustom *custom = [LEEAlert shareAlertManager].customAlertArray.lastObject;
        
        if ([custom respondsToSelector:@selector(closeAlertWithCompletionBlock:)]) [custom performSelector:@selector(closeAlertWithCompletionBlock:) withObject:completionBlock];
        
    }
    
}

#pragma mark LazyLoading

- (LEEAlertSystem *)system{
    
    if (!_system) _system = [[LEEAlertSystem alloc]init];
    
    return _system;
}

- (LEEAlertCustom *)custom{
    
    if (!_custom) _custom = [[LEEAlertCustom alloc]init];
    
    return _custom;
}

- (NSMutableArray *)customAlertArray{
    
    if (!_customAlertArray) _customAlertArray = [NSMutableArray array];
    
    return _customAlertArray;
}

- (UIWindow *)alertWindow{
    
    if (!_alertWindow) {
        
        _alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _alertWindow.backgroundColor = [UIColor clearColor];
        
        _alertWindow.windowLevel = UIWindowLevelAlert;
        
        _alertWindow.hidden = YES;
    }
    
    return _alertWindow;
}

@end

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, LEEAlertCustomBackGroundStype) {
    /** 自定义背景样式 模糊 */
    LEEAlertCustomBackGroundStypeBlur,
    /** 自定义背景样式 半透明 */
    LEEAlertCustomBackGroundStypeTranslucent,
};

typedef NS_ENUM(NSInteger, LEEAlertCustomSubViewType) {
    /** 自定义子视图类型 标题 */
    LEEAlertCustomSubViewTypeTitle,
    /** 自定义子视图类型 内容 */
    LEEAlertCustomSubViewTypeContent,
    /** 自定义子视图类型 输入框 */
    LEEAlertCustomSubViewTypeTextField,
    /** 自定义子视图类型 自定义视图 */
    LEEAlertCustomSubViewTypeCustomView,
};

@interface LEEAlertConfigModel ()

/* 以下为配置模型属性 ╮(╯▽╰)╭ 无视就好 */

@property (nonatomic , copy ) NSString *modelTitleStr;
@property (nonatomic , copy ) NSString *modelContentStr;
@property (nonatomic , copy ) NSString *modelCancelButtonTitleStr;

@property (nonatomic , strong ) NSMutableArray *modelButtonArray;
@property (nonatomic , strong ) NSMutableArray *modelTextFieldArray;
@property (nonatomic , strong ) NSMutableArray *modelCustomSubViewsQueue;

@property (nonatomic , strong ) UIView *modelCustomContentView;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelSubViewMargin;
@property (nonatomic , assign ) CGFloat modelTopSubViewMargin;
@property (nonatomic , assign ) CGFloat modelBottomSubViewMargin;
@property (nonatomic , assign ) CGFloat modelLeftSubViewMargin;
@property (nonatomic , assign ) CGFloat modelRightSubViewMargin;
@property (nonatomic , assign ) CGFloat modelAlertMaxWidth;
@property (nonatomic , assign ) CGFloat modelAlertMaxHeight;
@property (nonatomic , assign ) CGFloat modelAlertOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelAlertCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelAlertCustomBackGroundStypeColorAlpha;

@property (nonatomic , strong ) UIColor *modelAlertViewColor;
@property (nonatomic , strong ) UIColor *modelAlertWindowBackGroundColor;

@property (nonatomic , assign ) BOOL modelIsAlertWindowTouchClose;
@property (nonatomic , assign ) BOOL modelIsCustomButtonClickClose;
@property (nonatomic , assign ) BOOL modelIsAddQueue;

@property (nonatomic , copy ) void(^modelCancelButtonAction)();
@property (nonatomic , copy ) void(^modelCancelButtonBlock)(UIButton *button);
@property (nonatomic , copy ) void(^modelFinishConfig)(UIViewController *vc);

@property (nonatomic , assign ) LEEAlertCustomBackGroundStype modelAlertCustomBackGroundStype;

@end

@implementation LEEAlertConfigModel

- (void)dealloc{
    
    _modelTitleStr = nil;
    _modelContentStr = nil;
    _modelCancelButtonTitleStr = nil;
    _modelButtonArray = nil;
    _modelTextFieldArray = nil;
    _modelCustomSubViewsQueue = nil;
    _modelCustomContentView = nil;
    _modelAlertViewColor = nil;
    _modelAlertWindowBackGroundColor = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化默认值
        
        _modelCornerRadius = 10.0f; //默认警示框圆角半径
        _modelSubViewMargin = 10.0f; //默认警示框内部控件之间间距
        _modelTopSubViewMargin = 20.0f; //默认警示框顶部距离控件的间距
        _modelBottomSubViewMargin = 20.0f; //默认警示框底部距离控件的间距
        _modelLeftSubViewMargin = 20.0f; //默认警示框左侧距离控件的间距
        _modelRightSubViewMargin = 20.0f; //默认警示框右侧距离控件的间距
        _modelAlertMaxWidth = 280; //默认最大宽度 设备最小屏幕宽度 320 去除20左右边距
        _modelAlertMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.8f; //默认最大高度屏幕80%
        _modelAlertOpenAnimationDuration = 0.3f; //默认警示框打开动画时长
        _modelAlertCloseAnimationDuration = 0.2f; //默认警示框关闭动画时长
        _modelAlertCustomBackGroundStypeColorAlpha = 0.6f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.6f
        
        _modelAlertViewColor = [UIColor whiteColor]; //默认警示框颜色
        _modelAlertWindowBackGroundColor = [UIColor blackColor]; //默认警示框背景半透明或者模糊颜色
        
        _modelIsAlertWindowTouchClose = NO; //默认点击window不关闭
        _modelIsCustomButtonClickClose = YES; //默认点击自定义按钮关闭
        _modelIsAddQueue = YES; //默认加入队列
        
        _modelAlertCustomBackGroundStype = LEEAlertCustomBackGroundStypeTranslucent; //默认为半透明背景样式
    }
    return self;
}

- (LEEConfigAlertToString)LeeTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelTitleStr = str;
            
            //是否加入队列
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEEAlertCustomSubViewTypeTitle];
            
            if ([weakSelf.modelCustomSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeTitle)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToString)LeeContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelContentStr = str;
            
            //是否加入队列
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEEAlertCustomSubViewTypeContent];
            
            if ([weakSelf.modelCustomSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeContent)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToString)LeeCancelButtonTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelCancelButtonTitleStr = str;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToButtonBlock)LeeCancelButtonAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^buttonAction)()){
        
        if (weakSelf) {
            
            if (buttonAction) weakSelf.modelCancelButtonAction = buttonAction;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToButtonAndBlock)LeeAddButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^buttonAction)()){
        
        if (weakSelf) {
            
            [weakSelf.modelButtonArray addObject:@{@"title" : title , @"actionblock" : buttonAction}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToCustomTextField)LeeAddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addTextField)(UITextField *textField)){
        
        if (weakSelf) {
            
            [weakSelf.modelTextFieldArray addObject:addTextField];
            
            [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeTextField) , @"block" : addTextField}];
        }
        
        return weakSelf;
    };
    
}


- (LEEConfigAlertToCustomLabel)LeeCustomTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addLabel)(UILabel *label)){
        
        if (weakSelf) {
            
            NSDictionary *customSubViewInfo = @{@"type" : @(LEEAlertCustomSubViewTypeTitle) , @"block" : addLabel};
            
            if (weakSelf.modelTitleStr) {
                
                for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
                    
                    if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeTitle) {
                        
                        [weakSelf.modelCustomSubViewsQueue replaceObjectAtIndex:[weakSelf.modelCustomSubViewsQueue indexOfObject:item] withObject:customSubViewInfo];
                        
                        break;
                    }
                    
                }
                
            } else {
                
                [weakSelf.modelCustomSubViewsQueue addObject:customSubViewInfo];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToCustomLabel)LeeCustomContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addLabel)(UILabel *label)){
        
        if (weakSelf) {
            
            NSDictionary *customSubViewInfo = @{@"type" : @(LEEAlertCustomSubViewTypeContent) , @"block" : addLabel};
            
            if (weakSelf.modelContentStr) {
                
                for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
                    
                    if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeContent) {
                        
                        [weakSelf.modelCustomSubViewsQueue replaceObjectAtIndex:[weakSelf.modelCustomSubViewsQueue indexOfObject:item] withObject:customSubViewInfo];
                        
                        break;
                    }
                    
                }
                
            } else {
                
                [weakSelf.modelCustomSubViewsQueue addObject:customSubViewInfo];
            }

        }

        return weakSelf;
    };
    
}

- (LEEConfigAlertToCustomButton)LeeCustomCancelButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        if (weakSelf) {
            
            if (addButton) weakSelf.modelCancelButtonBlock = addButton;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToView)LeeCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            weakSelf.modelCustomContentView = view;
            
            //是否加入队列
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEEAlertCustomSubViewTypeCustomView];
            
            if ([weakSelf.modelCustomSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeCustomView)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToCustomButton)LeeAddCustomButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        if (weakSelf) {
            
            [weakSelf.modelButtonArray addObject:@{@"title" : @"按钮" , @"block" : addButton}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomCornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelCornerRadius = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomTopSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelTopSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomBottomSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBottomSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomLeftSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelLeftSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomRightSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelRightSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomAlertMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelAlertMaxWidth = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomAlertMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelAlertMaxHeight = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomAlertOpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelAlertOpenAnimationDuration = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomAlertCloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelAlertCloseAnimationDuration = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToColor)LeeCustomAlertViewColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) {
            
            weakSelf.modelAlertViewColor = color;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToColor)LeeCustomAlertViewBackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) {
            
            weakSelf.modelAlertWindowBackGroundColor = color;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomAlertViewBackGroundStypeTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelAlertCustomBackGroundStype = LEEAlertCustomBackGroundStypeTranslucent;
            
            weakSelf.modelAlertCustomBackGroundStypeColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToFloat)LeeCustomAlertViewBackGroundStypeBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelAlertCustomBackGroundStype = LEEAlertCustomBackGroundStypeBlur;
            
            weakSelf.modelAlertCustomBackGroundStypeColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlert)LeeCustomAlertTouchClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) {
            
            weakSelf.modelIsAlertWindowTouchClose = YES;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlert)LeeCustomButtonClickNotClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) {
            
            weakSelf.modelIsCustomButtonClickClose = NO;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToBool)LeeAddQueue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL result){
        
        if (weakSelf) {
            
            weakSelf.modelIsAddQueue = result;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlert)LeeShow{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig(nil);
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigAlertToViewController)LeeShowFromViewController{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIViewController *viewController){
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig(viewController);
        }
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelButtonArray{
    
    if (!_modelButtonArray) _modelButtonArray = [NSMutableArray array];
    
    return _modelButtonArray;
}

-(NSMutableArray *)modelTextFieldArray{
    
    if (!_modelTextFieldArray) _modelTextFieldArray = [NSMutableArray array];
    
    return _modelTextFieldArray;
}

-(NSMutableArray *)modelCustomSubViewsQueue{
    
    if (!_modelCustomSubViewsQueue) _modelCustomSubViewsQueue = [NSMutableArray array];
    
    return _modelCustomSubViewsQueue;
}

@end

#pragma mark - =====================系统=====================

@interface LEEAlertSystem ()<UIAlertViewDelegate>

@property (nonatomic , strong ) NSMutableDictionary *alertViewButtonIndexDic;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@end

@implementation LEEAlertSystem

- (void)dealloc{
    
    _config = nil;
    
    _alertViewButtonIndexDic = nil;
    
    _currentKeyWindow = nil;
}

- (void)configAlertWithShow:(UIViewController *)vc{
    
    NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : nil;
    
    NSString *message = self.config.modelContentStr ? self.config.modelContentStr : nil;
    
    NSString *cancelButtonTitle = self.config.modelCancelButtonTitleStr ? self.config.modelCancelButtonTitleStr : @"取消";
    
    if (iOS8) {
        
        __weak typeof(self) weakSelf = self;
        
        //使用 UIAlertController
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        void (^cancelButtonAction)() = weakSelf.config.modelCancelButtonAction;
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (cancelButtonAction) cancelButtonAction();
            
            if (weakSelf) weakSelf.config = nil;
        }];
        
        [alertController addAction:alertAction];
        
        for (NSDictionary *buttonDic in self.config.modelButtonArray) {
            
            NSString *buttonTitle = buttonDic[@"title"];
            
            void (^buttonAction)() = buttonDic[@"actionblock"];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (buttonAction) buttonAction();
                
                if (weakSelf) weakSelf.config = nil;
            }];
            
            [alertController addAction:alertAction];
        }
        
        for (void(^addTextField)(UITextField *textField) in self.config.modelTextFieldArray) {
            
            [alertController addTextFieldWithConfigurationHandler:addTextField];   
        }
        
        //弹出 Alert
        
        if (vc) {
            
            [vc presentViewController:alertController animated:YES completion:^{}];
            
        } else {
            
            if (self.currentKeyWindow) {
                
                [[self getPresentedViewController:self.currentKeyWindow.rootViewController] presentViewController:alertController animated:YES completion:^{}];
                
            } else {
                
                /*
                 * keywindow的rootViewController 获取不到 建议传入视图控制器对象
                 *
                 * 建议: XXX.system.config.XXX().XXX().showFromViewController(视图控制器对象);
                 * 或者: 在appDelegate内设置主窗口 [LEEAlert configMainWindow:self.window];
                 */
                NSAssert(self, @"LEEAlert : keywindow的rootViewController 获取不到 建议传入视图控制器对象");
            }
            
        }
        
    } else {
        
        //使用UIAlertView
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
        
        for (NSDictionary *buttonDic in self.config.modelButtonArray) {
            
            NSString *buttonTitle = buttonDic[@"title"];
            
            void (^buttonAction)() = buttonDic[@"actionblock"];
            
            NSInteger buttonIndex = [alertView addButtonWithTitle:buttonTitle];
            
            [self.alertViewButtonIndexDic setValue:buttonAction forKey:[NSString stringWithFormat:@"%ld" , buttonIndex]];
            
        }
        
        NSInteger textFieldCount = self.config.modelTextFieldArray.count;
        
        if (textFieldCount == 0) {
            
            alertView.alertViewStyle = UIAlertViewStyleDefault;
            
        } else if (textFieldCount == 1) {
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
        } else if (textFieldCount == 2) {
            
            alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
            [alertView textFieldAtIndex:1].secureTextEntry = NO;
            
        } else {
            
            alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
            [alertView textFieldAtIndex:1].secureTextEntry = NO;
            
            textFieldCount = 2;
        }
        
        for (NSInteger i = 0; i < textFieldCount; i++) {
            
            void(^addTextField)(UITextField *textField) = [self.config.modelTextFieldArray objectAtIndex:i];
            
            if (addTextField) addTextField([alertView textFieldAtIndex:i]);
        }
        
        [alertView show];
    }
    
    //清空按钮数组
    
    [self.config.modelButtonArray removeAllObjects];
    
    //清空输入框数组
    
    [self.config.modelTextFieldArray removeAllObjects];
}

#pragma mark Tool

- (UIViewController *)getPresentedViewController:(UIViewController *)vc{
    
    if (vc.presentedViewController) {
        
        return [self getPresentedViewController:vc.presentedViewController];
        
    } else {
        
        return vc;
    }
    
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        
    } else if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
        
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        [[alertView textFieldAtIndex:1] resignFirstResponder];
    }
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        void (^buttonAction)() = self.alertViewButtonIndexDic[[NSString stringWithFormat:@"%ld" , buttonIndex]];
        
        if (buttonAction) buttonAction();
        
    } else {
        
        if (self.config.modelCancelButtonAction) self.config.modelCancelButtonAction();
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //清空UIAlertView按钮下标字典
    
    [self.alertViewButtonIndexDic removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    
    //延迟释放模型 防止循环引用
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf) weakSelf.config = nil;
    });
    
}

#pragma mark LazyLoading

- (LEEAlertConfigModel *)config{
    
    if (!_config) {
        
        _config = [[LEEAlertConfigModel alloc]init];
        
        __weak typeof(self) weakSelf = self;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        _config.modelFinishConfig = ^(UIViewController *vc){
            
            [strongSelf configAlertWithShow:vc];
        };
        
    }
    
    return _config;
}

- (NSMutableDictionary *)alertViewButtonIndexDic{
    
    if (!_alertViewButtonIndexDic) _alertViewButtonIndexDic = [NSMutableDictionary dictionary];
    
    return _alertViewButtonIndexDic;
}

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LEEAlert shareAlertManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LEEAlert shareAlertManager].mainWindow) [LEEAlert shareAlertManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

@end

#pragma mark - ====================自定义====================

@interface LEEAlertViewController ()

@property (nonatomic , weak ) LEEAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIImageView *alertBackgroundImageView;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray *alertSubViewArray;

@property (nonatomic , strong ) NSMutableArray *alertButtonArray;

@property (nonatomic , copy ) void (^closeAction)();

@end

@implementation LEEAlertViewController
{
    CGFloat alertViewMaxHeight;
    CGFloat alertViewHeight;
    CGFloat alertViewWidth;
    CGFloat customViewHeight;
    CGRect keyboardFrame;
    UIDeviceOrientation currentOrientation;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _alertBackgroundImageView = nil;
    
    _alertView = nil;
    
    _alertSubViewArray = nil;
    
    _alertButtonArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars=NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.alertBackgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.alertBackgroundImageView];
    
    [self addNotification];
    
    currentOrientation = (UIDeviceOrientation)self.interfaceOrientation; //默认当前方向
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification *) notify{
    
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    isShowingKeyboard = YES;
}

- (void)keyboardWillHidden:(NSNotification *) notify{
    
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    isShowingKeyboard = NO;
}

- (void)keyboardWillChangeFrame:(NSNotification *) notify{
    
}

- (void)keyboardDidChangeFrame:(NSNotification *) notify{
 
    double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (isShowingKeyboard) {
        
        [UIView beginAnimations:@"keyboardDidChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        if (iOS8) {
            
            if (keyboardFrame.size.height) {
                
                CGFloat keyboardY = keyboardFrame.origin.y;
                
                CGRect alertViewFrame = self.alertView.frame;
                
                CGFloat tempAlertViewHeight = keyboardY - alertViewHeight < 20 ? keyboardY - 20 : alertViewHeight;
                
                alertViewFrame.size.height = tempAlertViewHeight;
                
                alertViewFrame.origin.y = keyboardY - alertViewFrame.size.height - 10;
                
                self.alertView.frame = alertViewFrame;
            }
            
            [self.alertView setContentOffset:CGPointZero animated:NO];
            
            [self.alertView scrollRectToVisible:[self findFirstResponder:self.alertView].frame animated:YES];
            
            self.alertView.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2 , self.alertView.center.y);
            
        } else {
            
            [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //iOS 8 以下处理
        }
        
        [UIView commitAnimations];
        
    } else {
        
        [UIView beginAnimations:@"keyboardDidChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        if (iOS8) {
            
            CGRect alertViewFrame = self.alertView.frame;
            
            alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;;
            
            alertViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - alertViewFrame.size.height) / 2;
            
            self.alertView.frame = alertViewFrame;
            
            self.alertView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.alertView.center.y);
            
        } else {
            
            [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //iOS 8 以下处理
        }
        
        [UIView commitAnimations];
    }
    
}

- (void)changeOrientationNotification:(NSNotification *)notify{
    
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortraitUpsideDown &&
        [UIDevice currentDevice].orientation != UIDeviceOrientationFaceUp &&
        [UIDevice currentDevice].orientation != UIDeviceOrientationFaceDown) currentOrientation = [UIDevice currentDevice].orientation; //设置当前方向
    
    if (self.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
        
        self.alertBackgroundImageView.image = [[self getCurrentKeyWindowImage] LeeAlert_ApplyTintEffectWithColor:[self.config.modelAlertWindowBackGroundColor colorWithAlphaComponent:self.config.modelAlertCustomBackGroundStypeColorAlpha]];
    }
    
    if (iOS8) [self updateOrientationLayout];
}

- (void)updateOrientationLayout{
    
    alertViewMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) >  CGRectGetWidth([[UIScreen mainScreen] bounds]) ? self.config.modelAlertMaxHeight : CGRectGetHeight([[UIScreen mainScreen] bounds]) - 20.0f; //(iOS 8 以上处理)
    
    if (!isShowingKeyboard) {
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        alertViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - alertViewFrame.size.height) / 2;
        
        self.alertView.frame = alertViewFrame;
        
        self.alertView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.alertView.center.y);
    }
    
    self.alertBackgroundImageView.frame = self.view.frame;
}

- (void)updateOrientationLayoutWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    alertViewMaxHeight = UIDeviceOrientationIsLandscape(currentOrientation) ? CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20.0f : self.config.modelAlertMaxHeight; //(iOS 8 以下处理)
    
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortrait:
        {
            if (isShowingKeyboard) {
                
                CGRect alertViewFrame = self.alertView.frame;
                
                alertViewFrame.size.height = keyboardFrame.origin.y - alertViewHeight < 20 ? keyboardFrame.origin.y - 20 : alertViewHeight;
                
                alertViewFrame.origin.y = keyboardFrame.origin.y - alertViewFrame.size.height - 10;
                
                self.alertView.frame = alertViewFrame;
                
            } else {
                
                CGRect alertViewFrame = self.alertView.frame;
                
                alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;;
                
                alertViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - alertViewFrame.size.height) / 2;
                
                self.alertView.frame = alertViewFrame;
            }
            
            self.alertView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, self.alertView.center.y);
            
            self.alertBackgroundImageView.transform = CGAffineTransformIdentity;
            
            self.alertBackgroundImageView.frame = self.view.frame;
        }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        {
            if (isShowingKeyboard) {
                
                CGRect alertViewFrame = self.alertView.frame;
                
                alertViewFrame.size.height = keyboardFrame.origin.x - alertViewHeight < 20 ? keyboardFrame.origin.x - 20 : alertViewHeight;
                
                alertViewFrame.origin.y = (keyboardFrame.origin.x - alertViewFrame.size.height) / 2;
                
                self.alertView.frame = alertViewFrame;
                
            } else {
                
                CGRect alertViewFrame = self.alertView.frame;
                
                alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;;
                
                alertViewFrame.origin.y = (CGRectGetWidth(self.view.frame) - alertViewFrame.size.height) / 2;
                
                self.alertView.frame = alertViewFrame;
            }
            
            self.alertView.center = CGPointMake(CGRectGetHeight(self.view.frame) / 2, self.alertView.center.y);
            
            self.alertBackgroundImageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            
            self.alertBackgroundImageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        }
            break;
            
        case UIInterfaceOrientationLandscapeRight:
        {
            if (isShowingKeyboard) {
                
                CGRect alertViewFrame = self.alertView.frame;
                
                CGFloat availableHeight = (CGRectGetWidth(self.view.frame) - keyboardFrame.size.width);
                
                alertViewFrame.size.height = availableHeight - alertViewHeight < 20 ? availableHeight - 20 : alertViewHeight;
                
                alertViewFrame.origin.y = (availableHeight - alertViewFrame.size.height) / 2;
                
                self.alertView.frame = alertViewFrame;
                
            } else {
                
                CGRect alertViewFrame = self.alertView.frame;
                
                alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;;
                
                alertViewFrame.origin.y = (CGRectGetWidth(self.view.frame) - alertViewFrame.size.height) / 2;
                
                self.alertView.frame = alertViewFrame;
            }
            
            self.alertView.center = CGPointMake(CGRectGetHeight(self.view.frame) / 2 , self.alertView.center.y);
            
            self.alertBackgroundImageView.transform = CGAffineTransformMakeRotation(-(M_PI / 2));
            
            self.alertBackgroundImageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        }
            break;
            
        default:
            break;
    }
    
}

- (void)updateAlertViewSubViewsLayout{
    
    alertViewHeight = 0.0f;
    
    alertViewWidth = self.config.modelAlertMaxWidth;
    
    if (self.alertSubViewArray.count > 0) alertViewHeight += self.config.modelTopSubViewMargin;
    
    for (UIView *subView in self.alertSubViewArray) {
        
        CGRect subViewFrame = subView.frame;
        
        subViewFrame.origin.y = alertViewHeight;
        
        if (subView == self.config.modelCustomContentView) customViewHeight = subViewFrame.size.height;
        
        subView.frame = subViewFrame;
        
        alertViewHeight += subViewFrame.size.height;
        
        alertViewHeight += self.config.modelSubViewMargin;
    }
    
    if (self.alertSubViewArray.count > 0) {
        
        alertViewHeight -= self.config.modelSubViewMargin;
        
        alertViewHeight += self.config.modelBottomSubViewMargin;
    }
    
    for (UIButton *button in self.alertButtonArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.y = alertViewHeight;
        
        button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height;
    }
    
    if (self.alertButtonArray.count == 2) {
        
        UIButton *buttonA = self.alertButtonArray.count == self.config.modelButtonArray.count ? [self.alertButtonArray firstObject] : [self.alertButtonArray lastObject];
        
        UIButton *buttonB = self.alertButtonArray.count == self.config.modelButtonArray.count ? [self.alertButtonArray lastObject] : [self.alertButtonArray firstObject];
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame);
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame);
        
        CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = buttonA.frame.origin.y > buttonB.frame.origin.y ? buttonB.frame.origin.y : buttonA.frame.origin.y;
        
        buttonA.frame = CGRectMake(0, minY, alertViewWidth / 2, maxHeight);
        
        buttonB.frame = CGRectMake(alertViewWidth / 2, minY, alertViewWidth / 2, maxHeight);
        
        alertViewHeight -= minHeight;
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewWidth, alertViewHeight);
    
    if (iOS8) [self updateOrientationLayout]; //更新方向布局 iOS 8 以上处理
    
    if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //更新方向布局 iOS 8 以下处理
}

- (void)configAlert{
    
    alertViewHeight = 0.0f;
    
    alertViewWidth = self.config.modelAlertMaxWidth;
    
    [self.view addSubview: self.alertView];
    
    for (NSDictionary *item in self.config.modelCustomSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEEAlertCustomSubViewTypeTitle:
            {
                
                NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : @" ";
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, alertViewHeight, alertViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin, 0)];
                
                [self.alertView addSubview:titleLabel];
                
                [self.alertSubViewArray addObject:titleLabel];
                
                titleLabel.textAlignment = NSTextAlignmentCenter;
                
                titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
                
                titleLabel.textColor = [UIColor blackColor];
                
                titleLabel.text = title;
                
                titleLabel.numberOfLines = 0;
                
                void(^addLabel)(UILabel *label) = item[@"block"];
                
                if (addLabel) addLabel(titleLabel);
                
                CGRect titleLabelRect = [self getLabelTextHeight:titleLabel];
                
                CGRect titleLabelFrame = titleLabel.frame;
                
                titleLabelFrame.size.height = titleLabelRect.size.height;
                
                titleLabel.frame = titleLabelFrame;
            }
                break;
            case LEEAlertCustomSubViewTypeContent:
            {
                
                NSString *content = self.config.modelContentStr ? self.config.modelContentStr : @" ";
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, alertViewHeight, alertViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin, 0)];
                
                [self.alertView addSubview:contentLabel];
                
                [self.alertSubViewArray addObject:contentLabel];
                
                contentLabel.textAlignment = NSTextAlignmentCenter;
                
                contentLabel.font = [UIFont systemFontOfSize:14.0f];
                
                contentLabel.textColor = [UIColor blackColor];
                
                contentLabel.text = content;
                
                contentLabel.numberOfLines = 0;
                
                void(^addLabel)(UILabel *label) = item[@"block"];
                
                if (addLabel) addLabel(contentLabel);
                
                CGRect contentLabelRect = [self getLabelTextHeight:contentLabel];
                
                CGRect contentLabelFrame = contentLabel.frame;
                
                contentLabelFrame.size.height = contentLabelRect.size.height;
                
                contentLabel.frame = contentLabelFrame;
            }
                break;
            case LEEAlertCustomSubViewTypeCustomView:
            {
                
                if (self.config.modelCustomContentView) {
                    
                    CGRect customContentViewFrame = self.config.modelCustomContentView.frame;
                    
                    customContentViewFrame.origin.y = alertViewHeight;
                    
                    customViewHeight = customContentViewFrame.size.height;
                    
                    self.config.modelCustomContentView.frame = customContentViewFrame;
                    
                    [self.alertView addSubview:self.config.modelCustomContentView];
                    
                    [self.alertSubViewArray addObject:self.config.modelCustomContentView];
                    
                    [self.config.modelCustomContentView addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
                    
                    [self.config.modelCustomContentView layoutSubviews];
                }
                
            }
                break;
            case LEEAlertCustomSubViewTypeTextField:
            {
                
                UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, alertViewHeight, alertViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin , 40.0f)];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                [self.alertView addSubview:textField];
                
                [self.alertSubViewArray addObject:textField];
                
                void(^addTextField)(UITextField *textField) = item[@"block"];
                
                if (addTextField) addTextField(textField);
            }
                break;
                
            default:
                break;
        }
        
    }
    
    for (NSDictionary *buttonDic in self.config.modelButtonArray) {
        
        NSString *buttonTitle = buttonDic[@"title"];
        
        void(^addButton)(UIButton *button) = buttonDic[@"block"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, alertViewHeight, alertViewWidth, 45.0f);
        
        [button.layer setBorderWidth:0.5f];
        
        [button.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[self getImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[self getImageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2f]] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        [self.alertButtonArray addObject:button];
        
        if (addButton) addButton(button);
    }
    
    if (self.config.modelCancelButtonTitleStr || self.config.modelCancelButtonAction || self.config.modelCancelButtonBlock) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        cancelButton.frame = CGRectMake(0, alertViewHeight, alertViewWidth, 45.0f);
        
        [cancelButton.layer setBorderWidth:0.5f];
        
        [cancelButton.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [cancelButton setTitle:self.config.modelCancelButtonTitleStr ? self.config.modelCancelButtonTitleStr : @"取消" forState:UIControlStateNormal];
        
        [cancelButton setTitleColor:[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [cancelButton setBackgroundImage:[self getImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        
        [cancelButton setBackgroundImage:[self getImageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2f]] forState:UIControlStateHighlighted];
        
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:cancelButton];
        
        [self.alertButtonArray addObject:cancelButton];
        
        if (self.config.modelCancelButtonBlock) {
            
            self.config.modelCancelButtonBlock(cancelButton);
        }
    }
    
    [self updateAlertViewSubViewsLayout]; //更新子视图布局
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    //开启显示警示框动画
    
    [self showAlertAnimations];
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    if (self.config.modelCancelButtonAction) self.config.modelCancelButtonAction();
    
    [self closeAnimations];
}

- (void)buttonAction:(UIButton *)sender{
    
    void (^buttonAction)() = self.config.modelButtonArray[[self.alertButtonArray indexOfObject:sender]][@"actionblock"];
    
    if (buttonAction) buttonAction();
    
    if (self.config.modelIsCustomButtonClickClose) [self closeAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.config.modelIsAlertWindowTouchClose) [self closeAnimations]; //拦截AlertView点击响应
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *customView = (UIView *)object;
    
    if (customViewHeight != CGRectGetHeight(customView.frame)) [self updateAlertViewSubViewsLayout];
}

#pragma mark start animations

- (void)showAlertAnimations{
    
    if (self.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
        
        self.alertBackgroundImageView.alpha = 0.0f;
        
        self.alertBackgroundImageView.image = [[self getCurrentKeyWindowImage] LeeAlert_ApplyBlurWithRadius:10.0f tintColor:[self.config.modelAlertWindowBackGroundColor colorWithAlphaComponent:self.config.modelAlertCustomBackGroundStypeColorAlpha] saturationDeltaFactor:1.0f maskImage:nil];
    }
    
    [self.currentKeyWindow endEditing:YES]; //结束输入 收起键盘
    
    [LEEAlert shareAlertManager].alertWindow.hidden = NO;
    
    [[LEEAlert shareAlertManager].alertWindow makeKeyAndVisible];
    
    self.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    self.alertView.alpha = 0.0f;
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeTranslucent) {
        
        [UIView animateWithDuration:self.config.modelAlertOpenAnimationDuration animations:^{
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelAlertCustomBackGroundStypeColorAlpha];
            
            weakSelf.alertView.transform = CGAffineTransformIdentity;
            
            weakSelf.alertView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {}];
        
    } else if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
        
        [UIView animateWithDuration:self.config.modelAlertOpenAnimationDuration animations:^{
            
            weakSelf.alertBackgroundImageView.alpha = 1.0f;
            
            weakSelf.alertView.transform = CGAffineTransformIdentity;
            
            weakSelf.alertView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {}];
        
    }
    
}

#pragma mark close animations

- (void)closeAnimations{
    
    [self closeAnimationsWithCompletionBlock:nil];
}

- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    if (self.config.modelCustomContentView) [self.config.modelCustomContentView removeObserver:self forKeyPath:@"frame"];
    
    [[LEEAlert shareAlertManager].alertWindow endEditing:YES]; //结束输入 收起键盘
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelAlertCloseAnimationDuration animations:^{
        
        if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
            
            weakSelf.alertBackgroundImageView.alpha = 0.0f;
        }
        
        weakSelf.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
        weakSelf.alertView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (weakSelf) {
            
            weakSelf.alertView.transform = CGAffineTransformIdentity;
            
            weakSelf.alertView.alpha = 1.0f;
            
            [LEEAlert shareAlertManager].alertWindow.hidden = YES;
            
            [[LEEAlert shareAlertManager].alertWindow resignKeyWindow];
            
            if (weakSelf.closeAction) weakSelf.closeAction();
            
            if (completionBlock) completionBlock();
        }
        
    }];
    
}

#pragma mark Tool

- (UIImage *)getCurrentKeyWindowImage{
    
    UIGraphicsBeginImageContext(self.currentKeyWindow.frame.size);
    
    [self.currentKeyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGRect)getLabelTextHeight:(UILabel *)label{
    
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
    
    return rect;
}

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LEEAlert shareAlertManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LEEAlert shareAlertManager].mainWindow) [LEEAlert shareAlertManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

- (UIImageView *)alertBackgroundImageView{
    
    if (!_alertBackgroundImageView) _alertBackgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    return _alertBackgroundImageView;
}

- (UIScrollView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.config.modelAlertMaxWidth, 0)];
        
        _alertView.backgroundColor = self.config.modelAlertViewColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.bounces = NO;
    }
    
    return _alertView;
}

- (NSMutableArray *)alertSubViewArray{
    
    if (!_alertSubViewArray) _alertSubViewArray = [NSMutableArray array];
    
    return _alertSubViewArray;
}

- (NSMutableArray *)alertButtonArray{
    
    if (!_alertButtonArray) _alertButtonArray = [NSMutableArray array];
    
    return _alertButtonArray;
}

#pragma mark  Rotation

- (BOOL)shouldAutorotate{
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:toInterfaceOrientation]; //iOS 8 以下处理
}

@end

@interface LEEAlertCustom ()<LEEAlertProtocol>

@property (nonatomic , strong ) LEEAlertViewController *alertViewController;

@end

@implementation LEEAlertCustom

- (void)dealloc{
    
    _config = nil;
    
    _alertViewController = nil;
}

- (void)showAlert{
    
    if (self.config) {
        
        [LEEAlert shareAlertManager].alertWindow.backgroundColor = [self.config.modelAlertWindowBackGroundColor colorWithAlphaComponent:0.0f];
        
        [LEEAlert shareAlertManager].alertWindow.rootViewController = self.alertViewController;
        
        self.alertViewController.config = self.config;
        
        [self.alertViewController configAlert];
    }
    
}

#pragma mark LEEAlertProtocol

- (void)closeAlertWithCompletionBlock:(void (^)())completionBlock{
    
    [self.alertViewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark LazyLoading

- (LEEAlertConfigModel *)config{
    
    if (!_config) {
        
        _config = [[LEEAlertConfigModel alloc]init];
        
        __weak typeof(self) weakSelf = self;
        
        _config.modelFinishConfig = ^(UIViewController *vc){
            
            if (weakSelf) {
                
                if ([LEEAlert shareAlertManager].customAlertArray.count) {
                    
                    if ([[LEEAlert shareAlertManager].customAlertArray containsObject:weakSelf]) {
                        
                        [weakSelf showAlert];
                        
                    } else {
                        
                        LEEAlertCustom *lastCustom = [LEEAlert shareAlertManager].customAlertArray.lastObject;
                        
                        [lastCustom closeAlertWithCompletionBlock:^{
                            
                            if (weakSelf) [weakSelf showAlert];
                        }];
                        
                        [[LEEAlert shareAlertManager].customAlertArray addObject:weakSelf];
                    }
                    
                } else {
                    
                    [weakSelf showAlert];
                    
                    [[LEEAlert shareAlertManager].customAlertArray addObject:weakSelf];
                }
                
            }
            
        };
        
    }
    
    return _config;
}

- (LEEAlertViewController *)alertViewController{
    
    if (!_alertViewController) {
        
        _alertViewController = [[LEEAlertViewController alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        _alertViewController.closeAction = ^(){
            
            if (weakSelf) {
                
                [LEEAlert shareAlertManager].alertWindow.rootViewController = nil;
                
                weakSelf.alertViewController = nil;
                
                if ([LEEAlert shareAlertManager].customAlertArray.lastObject == weakSelf) {
                    
                    [[LEEAlert shareAlertManager].customAlertArray removeLastObject];
                    
                    if ([LEEAlert shareAlertManager].customAlertArray.count) {
                        
                        [LEEAlert shareAlertManager].customAlertArray.lastObject.config.modelFinishConfig(nil);
                    }
                    
                } else {
                    
                    if (!weakSelf.config.modelIsAddQueue) [[LEEAlert shareAlertManager].customAlertArray removeObject:weakSelf];
                }
                
            }
            
        };
   
    }
    
    return _alertViewController;       
}

@end

#pragma mark - ====================工具类====================


@implementation UIImage (LEEAlertImageEffects)

-(UIImage*)LeeAlert_ApplyLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    
    return[self LeeAlert_ApplyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)LeeAlert_ApplyExtraLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    
    return[self LeeAlert_ApplyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)LeeAlert_ApplyDarkEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    
    return[self LeeAlert_ApplyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)LeeAlert_ApplyTintEffectWithColor:(UIColor*)tintColor {
    
    const CGFloat EffectColorAlpha = 0.6;
    UIColor*effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if(componentCount == 2) {
        CGFloat b;
        if([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else{
        CGFloat r, g, b;
        if([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return[self LeeAlert_ApplyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:1.0f maskImage:nil];
}
-(UIImage*)LeeAlert_ApplyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage {
    /**
     *  半径,颜色,色彩饱和度
     */
    //  Check pre-conditions. 检查前提条件
    if(self.size.width <1||self.size.height <1){
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@",self.size.width,self.size.height,self);
        return nil;
    }
    if(!self.CGImage){
        NSLog(@"*** error: image must be backed by a CGImage: %@",self);
        return nil;
    }
    if(maskImage &&!maskImage.CGImage){
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = {CGPointZero , self.size};
    UIImage*effectImage = self;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor -1.)> __FLT_EPSILON__;
    if(hasBlur || hasSaturationChange) {
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext,1.0,-1.0);
        CGContextTranslateCTM(effectInContext,0,-self.size.height);
        CGContextDrawImage(effectInContext,imageRect,self.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        if(hasBlur){
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius *[[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius *3.* sqrt(2* M_PI)/4+0.5);
            if(radius %2 != 1) {
                radius += 1;// force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer,&effectInBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if(hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722+0.9278* s,0.0722-0.0722* s,0.0722-0.0722* s,0,
                0.7152-0.7152* s,0.7152+0.2848* s,0.7152-0.7152* s,0,
                0.2126-0.2126* s,0.2126-0.2126* s,0.2126+0.7873* s,0,
                0,0,0,1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for(NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i]* divisor);
            }
            if(hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer,&effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if(!effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if(effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context. 设置输出上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    // Draw base image. 绘制基准图像
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    // Draw effect image. 绘制效果图像
    if(hasBlur) {
        CGContextSaveGState(outputContext);
        if(maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint. 添加颜色渲染
    if(tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready. 输出图像
    UIImage*outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
