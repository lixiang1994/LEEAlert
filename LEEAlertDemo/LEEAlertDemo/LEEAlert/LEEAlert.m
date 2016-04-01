/*!
 *  @header LEEAlert.m
 *
 *
 *  @brief  警告框
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/3/29.
 */


#import "LEEAlert.h"

#import <objc/runtime.h>

#import <Accelerate/Accelerate.h>

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LEEAlert ()

@property (nonatomic , weak ) id currentCustomAlertDelegate;

@end

@protocol LEEAlertManagerDelegate <NSObject>

- (void)customAlertCloseDelegate;

@end

@implementation LEEAlert

- (void)dealloc{
    
    _system = nil;
    
    _custom = nil;
    
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
    
    LEEAlert *alert = [[LEEAlert alloc]init];
    
    return alert;
}

+ (void)closeCustomAlert{
    
    if ([LEEAlert shareAlertManager].currentCustomAlertDelegate && [[LEEAlert shareAlertManager].currentCustomAlertDelegate respondsToSelector:@selector(customAlertCloseDelegate)]) {
     
        [[LEEAlert shareAlertManager].currentCustomAlertDelegate customAlertCloseDelegate];
    }
    
}

#pragma mark LazyLoading

- (LEEAlertSystem *)system{
    
    if (!_system) {
        
        _system = [[LEEAlertSystem alloc]init];
    }
    
    return _system;
}

- (LEEAlertCustom *)custom{
    
    if (!_custom) {
        
        _custom = [[LEEAlertCustom alloc]init];
    }
    
    return _custom;
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

@property (nonatomic , copy , readonly ) NSString *modelTitleStr;
@property (nonatomic , copy , readonly ) NSString *modelContentStr;
@property (nonatomic , copy , readonly ) NSString *modelCancelButtonTitleStr;

@property (nonatomic , strong ) NSMutableArray *modelButtonArray;
@property (nonatomic , strong ) NSMutableArray *modelTextFieldArray;
@property (nonatomic , strong ) NSMutableArray *modelCustomSubViewsQueue;

@property (nonatomic , strong , readonly ) UIView *modelCustomContentView;

@property (nonatomic , assign , readonly ) CGFloat modelCornerRadius;
@property (nonatomic , assign , readonly ) CGFloat modelSubViewMargin;
@property (nonatomic , assign , readonly ) CGFloat modelTopSubViewMargin;
@property (nonatomic , assign , readonly ) CGFloat modelBottomSubViewMargin;
@property (nonatomic , assign , readonly ) CGFloat modelAlertMaxWidth;
@property (nonatomic , assign , readonly ) CGFloat modelAlertMaxHeight;
@property (nonatomic , assign , readonly ) CGFloat modelAlertOpenAnimationDuration;
@property (nonatomic , assign , readonly ) CGFloat modelAlertCloseAnimationDuration;

@property (nonatomic , strong , readonly ) UIColor *modelAlertViewColor;
@property (nonatomic , strong , readonly ) UIColor *modelAlertWindowBackGroundColor;

@property (nonatomic , assign , readonly ) BOOL modelIsAlertWindowTouchClose;

@property (nonatomic , copy ) void(^modelCancelButtonAction)();
@property (nonatomic , copy ) void(^modelCancelButtonBlock)();
@property (nonatomic , copy ) void(^modelFinishConfig)(UIViewController *vc);

@property (nonatomic , assign , readonly ) LEEAlertCustomBackGroundStype modelAlertCustomBackGroundStype;

@end

@implementation LEEAlertConfigModel

-(void)dealloc{
    
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
        _modelTopSubViewMargin = 20.0f; //默认警示框顶部控件的间距
        _modelBottomSubViewMargin = 20.0f; //默认警示框底部控件的间距
        _modelAlertMaxWidth = 280; //默认最大宽度 设备最小屏幕宽度 320 去除20左右边距
        _modelAlertMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.8f; //默认最大高度屏幕80%
        _modelAlertOpenAnimationDuration = 0.3f; //默认警示框打开动画时长
        _modelAlertCloseAnimationDuration = 0.2f; //默认警示框关闭动画时长
        
        _modelAlertViewColor = [UIColor whiteColor]; //默认警示框颜色
        _modelAlertWindowBackGroundColor = [UIColor blackColor]; //默认警示框背景半透明或者模糊颜色
        
        _modelAlertCustomBackGroundStype = LEEAlertCustomBackGroundStypeTranslucent; //默认为半透明背景样式
        
    }
    return self;
}

-(LEEConfigAlertToString)title{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        _modelTitleStr = str;
        
        BOOL isAddQueue = YES; //是否加入队列
        
        for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
            
            if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeTitle) {
                
                isAddQueue = NO; //已存在 不加入
                
                break;
            }
            
        }
        
        if (isAddQueue) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeTitle)}];
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToString)content{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        _modelContentStr = str;
        
        BOOL isAddQueue = YES; //是否加入队列
        
        for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
            
            if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeContent) {
                
                isAddQueue = NO; //已存在 不加入
                
                break;
            }
            
        }
        
        if (isAddQueue) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeContent)}];
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToString)cancelButtonTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        _modelCancelButtonTitleStr = str;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToButtonBlock)cancelButtonAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^buttonAction)()){
        
        if (buttonAction) {
            
            weakSelf.modelCancelButtonAction = buttonAction;
        }
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToButtonAndBlock)addButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^buttonAction)()){
        
        [weakSelf.modelButtonArray addObject:@{@"title" : title , @"actionblock" : buttonAction}];
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToCustomTextField)addTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addTextField)(UITextField *textField)){
        
        [weakSelf.modelTextFieldArray addObject:addTextField];
        
        [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeTextField) , @"block" : addTextField}];
        
        return weakSelf;
    };
    
}


-(LEEConfigAlertToCustomLabel)customTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addLabel)(UILabel *label)){
        
        NSDictionary *customSubViewInfo = @{@"type" : @(LEEAlertCustomSubViewTypeTitle) , @"block" : addLabel};
        
        if (_modelTitleStr) {
            
            for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
                
                if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeTitle) {
                    
                    [weakSelf.modelCustomSubViewsQueue replaceObjectAtIndex:[weakSelf.modelCustomSubViewsQueue indexOfObject:item] withObject:customSubViewInfo];
                    
                    break;
                }
                
            }
            
        } else {
            
            [weakSelf.modelCustomSubViewsQueue addObject:customSubViewInfo];
        }
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToCustomLabel)customContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addLabel)(UILabel *label)){
        
        NSDictionary *customSubViewInfo = @{@"type" : @(LEEAlertCustomSubViewTypeContent) , @"block" : addLabel};
        
        if (_modelContentStr) {
            
            for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
                
                if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeContent) {
                    
                    [weakSelf.modelCustomSubViewsQueue replaceObjectAtIndex:[weakSelf.modelCustomSubViewsQueue indexOfObject:item] withObject:customSubViewInfo];
                    
                    break;
                }
                
            }
            
        } else {
            
            [weakSelf.modelCustomSubViewsQueue addObject:customSubViewInfo];
        }
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToCustomButton)customCancelButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        if (addButton) {
            
            weakSelf.modelCancelButtonBlock = addButton;
            
        }
    
        return weakSelf;
    };
    
}

-(LEEConfigAlertToView)customView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        _modelCustomContentView = view;
        
        BOOL isAddQueue = YES; //是否加入队列
        
        for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
            
            if ([item[@"type"] integerValue] == LEEAlertCustomSubViewTypeCustomView) {
                
                isAddQueue = NO; //已存在 不加入
                
                break;
            }
            
        }
        
        if (isAddQueue) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEAlertCustomSubViewTypeCustomView)}];
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToCustomButton)addCustomButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        [weakSelf.modelButtonArray addObject:@{@"title" : @"按钮" , @"block" : addButton}];
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customCornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelCornerRadius = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelSubViewMargin = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customTopSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelTopSubViewMargin = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customBottomSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelBottomSubViewMargin = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customAlertMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelAlertMaxWidth = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customAlertMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelAlertMaxHeight = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customAlertOpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelAlertOpenAnimationDuration = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToFloat)customAlertCloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelAlertCloseAnimationDuration = number;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToColor)customAlertViewColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        _modelAlertViewColor = color;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToColor)customAlertViewBackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        _modelAlertWindowBackGroundColor = color;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlert)customAlertViewBackGroundStypeTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        _modelAlertCustomBackGroundStype = LEEAlertCustomBackGroundStypeTranslucent;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlert)customAlertViewBackGroundStypeBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        _modelAlertCustomBackGroundStype = LEEAlertCustomBackGroundStypeBlur;
        
        return weakSelf;
    };
    
}

-(LEEConfigAlert)customAlertTouchClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        _modelIsAlertWindowTouchClose = YES;
        
        return weakSelf;
    };
    
}


-(LEEConfigAlert)show{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf.modelFinishConfig) {
            
            weakSelf.modelFinishConfig(nil);
        }
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToViewController)showFromViewController{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIViewController *viewController){
        
        if (weakSelf.modelFinishConfig) {
            
            weakSelf.modelFinishConfig(viewController);
        }
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelButtonArray{
    
    if (!_modelButtonArray) {
        
        _modelButtonArray = [NSMutableArray array];
    }
    
    return _modelButtonArray;
}

-(NSMutableArray *)modelTextFieldArray{
    
    if (!_modelTextFieldArray) {
        
        _modelTextFieldArray = [NSMutableArray array];
    }
    
    return _modelTextFieldArray;
}

-(NSMutableArray *)modelCustomSubViewsQueue{
    
    if (!_modelCustomSubViewsQueue) {
        
        _modelCustomSubViewsQueue = [NSMutableArray array];
    }
    
    return _modelCustomSubViewsQueue;
}

@end

#pragma mark - =====================系统=====================

@interface LEEAlertSystem ()<UIAlertViewDelegate>

@property (nonatomic , strong ) NSMutableDictionary *alertViewButtonIndexDic;

@end

@implementation LEEAlertSystem

- (void)dealloc{
    
    _config = nil;
    
    _alertViewButtonIndexDic = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)configAlertWithShow:(UIViewController *)vc{
    
    NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : @"";
    
    NSString *message = self.config.modelContentStr ? self.config.modelContentStr : @"";
    
    NSString *cancelButtonTitle = self.config.modelCancelButtonTitleStr ? self.config.modelCancelButtonTitleStr : @"取消";
    
    if (iOS8) {
        
        __weak typeof(self) weakSelf = self;
        
        //使用 UIAlertController
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        void (^cancelButtonAction)() = weakSelf.config.modelCancelButtonAction;
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (cancelButtonAction) {
                
                cancelButtonAction();
            }
            
        }];
        
        [alertController addAction:alertAction];
        
        for (NSDictionary *buttonDic in self.config.modelButtonArray) {
            
            NSString *buttonTitle = buttonDic[@"title"];
            
            void (^buttonAction)() = buttonDic[@"actionblock"];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (buttonAction) {
                    
                    buttonAction();
                }
                
            }];
            
            [alertController addAction:alertAction];
            
        }
        
        for (void(^addTextField)(UITextField *textField) in self.config.modelTextFieldArray) {
            
            [alertController addTextFieldWithConfigurationHandler:addTextField];
            
        }
        
        //弹出 Alert
        
        if (vc) {
            
            [vc presentViewController:alertController animated:YES completion:^{
                
            }];
            
        } else {
            
            if ([UIApplication sharedApplication].keyWindow.rootViewController) {
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
                    
                }];
                
            } else {
                
                
#ifdef LEEDebugWithAssert
                /*
                 * keywindow的rootViewController 获取不到 建议传入视图控制器对象
                 *
                 * 建议: XXX.system.config.XXX().XXX().showFromViewController(视图控制器对象);
                 */
                NSAssert(self, @"LEEAlert : keywindow的rootViewController 获取不到 建议传入视图控制器对象");
#endif
                
            }
            
        }
        
        //释放模型
        
        _config = nil;
        
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
            
            if (addTextField) {
                
                addTextField([alertView textFieldAtIndex:i]);
            }
            
        }
        
        [alertView show];
        
    }
    
    //清空按钮数组
    
    [self.config.modelButtonArray removeAllObjects];
    
    //清空输入框数组
    
    [self.config.modelTextFieldArray removeAllObjects];
    
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        
    } else if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
        
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        [[alertView textFieldAtIndex:1] resignFirstResponder];
    }
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
     
        void (^buttonAction)() = self.alertViewButtonIndexDic[[NSString stringWithFormat:@"%ld" , buttonIndex]];
        
        if (buttonAction) {
            
            buttonAction();
        }
        
    } else {
        
        if (self.config.modelCancelButtonAction) {
            
            self.config.modelCancelButtonAction();
        }
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //清空UIAlertView按钮下标字典
    
    [self.alertViewButtonIndexDic removeAllObjects];
    
    //延迟释放模型 防止循环引用
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       _config = nil;
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

-(NSMutableDictionary *)alertViewButtonIndexDic{
    
    if (!_alertViewButtonIndexDic) {
        
        _alertViewButtonIndexDic = [NSMutableDictionary dictionary];
    }
    
    return _alertViewButtonIndexDic;
}


@end

#pragma mark - ====================自定义====================

@interface LEEAlertCustom ()<LEEAlertManagerDelegate>

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIWindow *alertWindow;

@property (nonatomic , strong ) UIImageView *alertWindowImageView;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray *alertButtonArray;

@end

static NSString * const LEEAlertShowNotification = @"LEEAlertShowNotification";

@implementation LEEAlertCustom
{
    CGFloat alertViewHeight;
    CGFloat alertViewWidth;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _alertWindow = nil;
    
    _alertWindowImageView = nil;
    
    _alertView = nil;
    
    _alertButtonArray = nil;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addNotification];
        
    }
    return self;
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlertShowNotification:) name:LEEAlertShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)AlertShowNotification:(NSNotification *)notify{
    
    NSDictionary *notifyInfo = notify.userInfo;
    
    if (notifyInfo[@"customAlert"] != self) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
             _config = nil;
        }];
        
    }
    
}

- (void)keyboardWillShown:(NSNotification *) notify{
    
    NSDictionary *info = [notify userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardFrame = [value CGRectValue];
    
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯

    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect alertViewFrame = weakSelf.alertView.frame;
        
        if (alertViewFrame.size.height - keyboardFrame.origin.y > -20) {
            
            alertViewFrame.size.height = keyboardFrame.origin.y - 20;
        }
        
        CGFloat resultY = alertViewFrame.size.height + alertViewFrame.origin.y - keyboardFrame.origin.y;
        
        if (resultY > - 10) {
            
            alertViewFrame.origin.y -= resultY + 10;
        }
        
        weakSelf.alertView.frame = alertViewFrame;
        
    } completion:^(BOOL finished) {}];
    
}

- (void) keyboardWillHidden:(NSNotification *) notify{
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
       
        CGRect alertViewFrame = weakSelf.alertView.frame;
        
        alertViewFrame.size.height = alertViewHeight > weakSelf.config.modelAlertMaxHeight ? weakSelf.config.modelAlertMaxHeight : alertViewHeight;;
        
        weakSelf.alertView.frame = alertViewFrame;
        
        weakSelf.alertView.center = CGPointMake(CGRectGetWidth(weakSelf.alertWindow.frame) /2 , CGRectGetHeight(weakSelf.alertWindow.frame) / 2);
        
    } completion:^(BOOL finished) {}];
    
}

- (void)configAlert{
    
    alertViewHeight = 0;
    
    alertViewWidth = self.config.modelAlertMaxWidth;
    
    [self.alertWindow addSubview:self.alertView];
    
    if (self.config.modelCustomSubViewsQueue.count > 0) {
        
        alertViewHeight += self.config.modelTopSubViewMargin;
    }
    
    for (NSDictionary *item in self.config.modelCustomSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
           
            case LEEAlertCustomSubViewTypeTitle:
            {
                
                NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : @" ";
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, alertViewHeight, alertViewWidth - 40, 0)];
             
                [self.alertView addSubview:titleLabel];
                
                titleLabel.textAlignment = NSTextAlignmentCenter;
                
                titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
                
                titleLabel.textColor = [UIColor blackColor];
                
                titleLabel.text = title;
                
                titleLabel.numberOfLines = 0;
                
                void(^addLabel)(UILabel *label) = item[@"block"];
                
                if (addLabel) {
                    
                    addLabel(titleLabel);
                }
                
                CGRect titleLabelRect = [self getLabelTextHeight:titleLabel];
                
                CGRect titleLabelFrame = titleLabel.frame;
                
                titleLabelFrame.size.height = titleLabelRect.size.height;
                
                titleLabel.frame = titleLabelFrame;
                
                alertViewHeight += titleLabelFrame.size.height + self.config.modelSubViewMargin;
                
            }
                break;
            case LEEAlertCustomSubViewTypeContent:
            {
                
                NSString *content = self.config.modelContentStr ? self.config.modelContentStr : @" ";
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, alertViewHeight, alertViewWidth - 40, 0)];
                
                [self.alertView addSubview:contentLabel];
                
                contentLabel.textAlignment = NSTextAlignmentCenter;
                
                contentLabel.font = [UIFont systemFontOfSize:14.0f];
                
                contentLabel.textColor = [UIColor blackColor];
                
                contentLabel.text = content;
                
                contentLabel.numberOfLines = 0;
                
                void(^addLabel)(UILabel *label) = item[@"block"];
                
                if (addLabel) {
                    
                    addLabel(contentLabel);
                }
                
                CGRect contentLabelRect = [self getLabelTextHeight:contentLabel];
                
                CGRect contentLabelFrame = contentLabel.frame;
                
                contentLabelFrame.size.height = contentLabelRect.size.height;
                
                contentLabel.frame = contentLabelFrame;
                
                alertViewHeight += contentLabelFrame.size.height + self.config.modelSubViewMargin;
                
            }
                break;
            case LEEAlertCustomSubViewTypeCustomView:
            {
                
                if (self.config.modelCustomContentView) {
                    
                    CGRect customContentViewFrame = self.config.modelCustomContentView.frame;
                    
                    customContentViewFrame.origin.y = alertViewHeight;
                    
                    self.config.modelCustomContentView.frame = customContentViewFrame;
                    
                    [self.alertView addSubview:self.config.modelCustomContentView];
                    
                    alertViewHeight += CGRectGetHeight(self.config.modelCustomContentView.frame) + self.config.modelSubViewMargin;
                }
                
            }
                break;
            case LEEAlertCustomSubViewTypeTextField:
            {
                
                UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, alertViewHeight, alertViewWidth - 40 , 40)];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                [self.alertView addSubview:textField];
                
                void(^addTextField)(UITextField *textField) = item[@"block"];
                
                if (addTextField) {
                    
                    addTextField(textField);
                }
                
                alertViewHeight += CGRectGetHeight(textField.frame) + self.config.modelSubViewMargin;
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (self.config.modelCustomSubViewsQueue.count > 0) {
        
        alertViewHeight -= self.config.modelSubViewMargin;
        
        alertViewHeight += self.config.modelBottomSubViewMargin;
    }
    
    for (NSDictionary *buttonDic in self.config.modelButtonArray) {
        
        NSString *buttonTitle = buttonDic[@"title"];
        
        void(^addButton)(UIButton *button) = buttonDic[@"block"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, alertViewHeight, alertViewWidth, 45.0f);
        
        [button.layer setBorderWidth:0.5f];
        
        [button.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.alertView addSubview:button];
        
        [self.alertButtonArray addObject:button];
        
        if (addButton) {
            
            addButton(button);
        }
        
        alertViewHeight += CGRectGetHeight(button.frame);
    }
    
    if (self.config.modelCancelButtonTitleStr || self.config.modelCancelButtonAction || self.config.modelCancelButtonBlock) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        cancelButton.frame = CGRectMake(0, alertViewHeight, alertViewWidth, 45.0f);
        
        [cancelButton.layer setBorderWidth:0.5f];
        
        [cancelButton.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [cancelButton setTitle:self.config.modelCancelButtonTitleStr ? self.config.modelCancelButtonTitleStr : @"取消" forState:UIControlStateNormal];
        
        [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:cancelButton];
        
        if (self.config.modelCancelButtonBlock) {
            
            self.config.modelCancelButtonBlock(cancelButton);
        }
        
        alertViewHeight += CGRectGetHeight(cancelButton.frame);
        
        if (self.alertButtonArray.count == 1) {
            
            UIButton *button = [self.alertButtonArray firstObject];
            
            CGFloat buttonHeight = CGRectGetHeight(button.frame);
            
            CGFloat cancelButtonHeight = CGRectGetHeight(cancelButton.frame);
            
            CGFloat maxHeight = buttonHeight > cancelButtonHeight ? buttonHeight : cancelButtonHeight;
            
            CGFloat minHeight = buttonHeight < cancelButtonHeight ? buttonHeight : cancelButtonHeight;
            
            cancelButton.frame = CGRectMake(0, button.frame.origin.y, alertViewWidth / 2, maxHeight);
            
            button.frame = CGRectMake(alertViewWidth / 2, button.frame.origin.y, alertViewWidth / 2, maxHeight);
            
            alertViewHeight -= minHeight;
        }
        
    } else {
        
        if (self.alertButtonArray.count == 2) {
            
            UIButton *buttonA = [self.alertButtonArray firstObject];
            
            UIButton *buttonB = [self.alertButtonArray lastObject];
            
            CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame);
            
            CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame);
            
            CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
            
            CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
            
            buttonA.frame = CGRectMake(0, buttonA.frame.origin.y, alertViewWidth / 2, maxHeight);
            
            buttonB.frame = CGRectMake(alertViewWidth / 2, buttonA.frame.origin.y, alertViewWidth / 2, maxHeight);
            
            alertViewHeight -= minHeight;
        }
        
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewWidth, alertViewHeight);
    
    CGRect alertViewFrame = self.alertView.frame;
    
    alertViewFrame.size.height = alertViewHeight > self.config.modelAlertMaxHeight ? self.config.modelAlertMaxHeight : alertViewHeight;
    
    self.alertView.frame = alertViewFrame;
    
    self.alertView.center = CGPointMake(CGRectGetWidth(self.alertWindow.frame) /2 , CGRectGetHeight(self.alertWindow.frame) / 2);
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    //发送通知
    
    NSDictionary * notifyInfo = @{@"customAlert" : self , @"alertWindow" : self.alertWindow};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEAlertShowNotification object:self userInfo:notifyInfo];
    
    //设置当前自定义Alert代理对象
    
    [LEEAlert shareAlertManager].currentCustomAlertDelegate = self;
    
    //开启显示警示框动画
    
    [self showAlertAnimations];
    
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    if (self.config.modelCancelButtonAction) {
        
        self.config.modelCancelButtonAction();
    }
    
    [self closeAnimationsWithCompletionBlock:^{
        
        _config = nil;
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    void (^buttonAction)() = self.config.modelButtonArray[[self.alertButtonArray indexOfObject:sender]][@"actionblock"];
    
    if (buttonAction) {
        
        buttonAction();
    }
    
    [self closeAnimationsWithCompletionBlock:^{
        
        _config = nil;
    }];
    
}

- (CGRect)getLabelTextHeight:(UILabel *)label{
    
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
    
    return rect;
}

- (void)alertWindowTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsAlertWindowTouchClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            _config = nil;
        }];
    
    }
    
}

- (void)alertViewTapAction:(UITapGestureRecognizer *)tap{
    
    
}

#pragma mark start animations

- (void)showAlertAnimations{
    
    if (self.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
        
        [self.alertWindow addSubview:self.alertWindowImageView];
        
        [self.alertWindow sendSubviewToBack:self.alertWindowImageView];
    }

    self.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    self.alertView.alpha = 0.0f;

    self.alertWindow.hidden = NO;
    
    [self.alertWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeTranslucent) {
    
        [UIView animateWithDuration:self.config.modelAlertOpenAnimationDuration animations:^{
            
            weakSelf.alertWindow.backgroundColor = [weakSelf.alertWindow.backgroundColor colorWithAlphaComponent:0.6f];
            
            weakSelf.alertView.transform = CGAffineTransformIdentity;
            
            weakSelf.alertView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {}];
        
    } else if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
        
        [UIView animateWithDuration:self.config.modelAlertOpenAnimationDuration animations:^{
            
            weakSelf.alertWindowImageView.alpha = 1.0f;
            
            weakSelf.alertView.transform = CGAffineTransformIdentity;
            
            weakSelf.alertView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {}];
        
    }
    
}

#pragma mark close animations

- (void)closeAnimations{
    
    [self closeAnimationsWithCompletionBlock:^{
       
        _config = nil;
    }];
    
}

- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [self.alertWindow endEditing:YES]; //结束输入 收起键盘
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelAlertCloseAnimationDuration animations:^{
        
        if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeTranslucent) {
            
            weakSelf.alertWindow.backgroundColor = [weakSelf.alertWindow.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelAlertCustomBackGroundStype == LEEAlertCustomBackGroundStypeBlur) {
            
            weakSelf.alertWindowImageView.alpha = 0.0f;
        }
        
        weakSelf.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
        weakSelf.alertView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        weakSelf.alertView.transform = CGAffineTransformIdentity;
        
        weakSelf.alertView.alpha = 1.0f;
        
        weakSelf.alertWindow.hidden = YES;
        
        [weakSelf.alertWindow resignKeyWindow];
        
        if (completionBlock) {
            
            completionBlock();
        }
        
    }];

}

#pragma mark LEEAlertManagerDelegate

-(void)customAlertCloseDelegate{
    
    [self closeAnimations];
}

#pragma mark LazyLoading

- (LEEAlertConfigModel *)config{
    
    if (!_config) {
        
        _config = [[LEEAlertConfigModel alloc]init];
        
        __weak typeof(self) weakSelf = self;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        _config.modelFinishConfig = ^(UIViewController *vc){
            
            [strongSelf configAlert];
        };
        
    }
    
    return _config;
}

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) {
        
        _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    return _currentKeyWindow;
    
}

- (UIWindow *)alertWindow{
    
    if (!_alertWindow) {
        
        _alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _alertWindow.backgroundColor = [self.config.modelAlertWindowBackGroundColor colorWithAlphaComponent:0.0f];
        
        _alertWindow.windowLevel = UIWindowLevelAlert + 1994;
        
        _alertWindow.hidden = YES;
        
        UITapGestureRecognizer *alertWindowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertWindowTapAction:)];
        
        [_alertWindow addGestureRecognizer:alertWindowTap];
    }
    
    return _alertWindow;
}

- (UIImageView *)alertWindowImageView{
    
    if (!_alertWindowImageView) {
        
        _alertWindowImageView = [[UIImageView alloc]initWithFrame:self.alertWindow.frame];
        
        _alertWindowImageView.alpha = 0.0f;
        
        UIGraphicsBeginImageContext(self.currentKeyWindow.frame.size);
        
        [self.currentKeyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        _alertWindowImageView.image = [image applyTintEffectWithColor:self.config.modelAlertWindowBackGroundColor];
    }
    
    return _alertWindowImageView;
}

-(UIView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 280, 100)];
        
        _alertView.backgroundColor = self.config.modelAlertViewColor;
        
        _alertView.directionalLockEnabled = YES;
        
        UITapGestureRecognizer *alertViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertViewTapAction:)];
        
        [_alertView addGestureRecognizer:alertViewTap];
    }
    
    return _alertView;
}

-(NSMutableArray *)alertButtonArray{
    
    if (!_alertButtonArray) {
        
        _alertButtonArray = [NSMutableArray array];
    }
    
    return _alertButtonArray;
}

@end

#pragma mark - ====================工具类====================


@implementation UIImage (LEEImageEffects)

-(UIImage*)applyLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    
    return[self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyExtraLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    
    return[self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyDarkEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    
    return[self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor {
    
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
    return[self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:1.0f maskImage:nil];
}
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage {
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
