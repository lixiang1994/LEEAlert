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

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation LEEAlert

-(void)dealloc{
    
    _system = nil;
    
    _custom = nil;
    
}

+(LEEAlert *)alert{
    
    LEEAlert *alert = [[LEEAlert alloc]init];

    return alert;
}

#pragma mark LazyLoading

-(LEEAlertSystem *)system{
    
    if (!_system) {
        
        _system = [[LEEAlertSystem alloc]init];
    }
    
    return _system;
}

-(LEEAlertCustom *)custom{
    
    if (!_custom) {
        
        _custom = [[LEEAlertCustom alloc]init];
    }
    
    return _custom;
}

@end

#pragma mark - ===================配置模型===================

@implementation LEEAlertConfigModel

-(void)dealloc{
    
    _modelTitleStr = nil;
    
    _modelContentStr = nil;
    
    _modelButtonArray = nil;
    
    _modelTextFieldArray = nil;
    
    _modelCancelButtonTitleStr = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

-(LEEConfigAlertToString)title{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        _modelTitleStr = str;
      
        return weakSelf;
    };
    
}

-(LEEConfigAlertToString)content{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        _modelContentStr = str;
        
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
        
        [weakSelf.modelButtonArray addObject:@{@"title" : title , @"block" : buttonAction}];
        
        return weakSelf;
    };
    
}

-(LEEConfigAlertToTextField)addTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addTextField)(UITextField *textField)){
        
        [weakSelf.modelTextFieldArray addObject:addTextField];
        
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

@end

@implementation LEEAlertConfigCustomModel

typedef NS_ENUM(NSInteger, LEEAlertCustomBackGroundStype) {
    
    /** 自定义背景样式 模糊 */
    LEEAlertCustomBackGroundStypeBlur,
    
    /** 自定义背景样式 半透明 */
    LEEAlertCustomBackGroundStypeTranslucent,
};

-(void)dealloc{
    
    _modelCustomContentView = nil;
}

-(LEEConfigAlertToView)customView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        _modelCustomContentView = view;
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

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
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (weakSelf.config.modelCancelButtonAction) {
                
                weakSelf.config.modelCancelButtonAction();
            }
            
        }];
        
        [alertController addAction:alertAction];
        
        for (NSDictionary *buttonDic in self.config.modelButtonArray) {
            
            NSString *buttonTitle = buttonDic[@"title"];
            
            void (^buttonAction)() = buttonDic[@"block"];
            
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
            
            void (^buttonAction)() = buttonDic[@"block"];
            
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

@implementation LEEAlertCustom

- (void)dealloc{
    
    _config = nil;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)configAlert{
    
    
    
    
}


#pragma mark LazyLoading

- (LEEAlertConfigCustomModel *)config{
    
    if (!_config) {
        
        _config = [[LEEAlertConfigCustomModel alloc]init];
        
        __weak typeof(self) weakSelf = self;
        
        _config.modelFinishConfig = ^(UIViewController *vc){
            
            [weakSelf configAlert];
            
        };
        
    }
    
    return _config;
    
}

@end