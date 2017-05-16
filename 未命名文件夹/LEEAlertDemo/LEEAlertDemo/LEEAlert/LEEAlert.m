//
//  LEEAlert.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/3/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LEEAlert.h"

#import <Accelerate/Accelerate.h>

@interface LEEAlert ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) UIWindow *leeWindow;

@property (nonatomic , strong ) NSMutableArray <LEEAlertConfig *>*queueArray;

@property (nonatomic , strong ) LEEBaseViewController *viewController;

@end

@protocol LEEAlertProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)())completionBlock;

@end

@implementation LEEAlert

+ (LEEAlert *)shareManager{
    
    static LEEAlert *alertManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alertManager = [[LEEAlert alloc] init];
    });
    
    return alertManager;
}

+ (LEEAlertConfig *)alert{
    
    LEEAlertConfig *config = [[LEEAlertConfig alloc] init];
    
    config.type = LEEAlertTypeAlert;
    
    return config;
}

+ (LEEAlertConfig *)actionsheet{
    
    LEEAlertConfig *config = [[LEEAlertConfig alloc] init];
    
    config.type = LEEAlertTypeActionSheet;
    
    return config;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [LEEAlert shareManager].mainWindow = window;
}

+ (void)closeWithCompletionBlock:(void (^)())completionBlock{
    
    if ([LEEAlert shareManager].queueArray.count) {
        
        LEEAlertConfig *item = [LEEAlert shareManager].queueArray.lastObject;
        
        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
    }
    
}

#pragma mark LazyLoading

- (NSMutableArray <LEEAlertConfig *>*)queueArray{
    
    if (!_queueArray) _queueArray = [NSMutableArray array];
    
    return _queueArray;
}

- (UIWindow *)leeWindow{
    
    if (!_leeWindow) {
        
        _leeWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _leeWindow.backgroundColor = [UIColor clearColor];
        
        _leeWindow.windowLevel = UIWindowLevelAlert;
        
        _leeWindow.hidden = YES;
    }
    
    return _leeWindow;
}

@end

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, LEEBackgroundStyle) {
    /** 背景样式 模糊 */
    LEEBackgroundStyleBlur,
    /** 背景样式 半透明 */
    LEEBackgroundStyleTranslucent,
};

typedef NS_ENUM(NSInteger, LEESubViewType) {
    /** 子视图类型 标题 */
    LEESubViewTypeTitle,
    /** 子视图类型 内容 */
    LEESubViewTypeContent,
    /** 子视图类型 输入框 */
    LEESubViewTypeTextField,
    /** 子视图类型 自定义视图 */
    LEESubViewTypeCustomView,
};

@interface LEEAlertConfigModel ()

@property (nonatomic , copy ) NSString *modelTitleStr;
@property (nonatomic , copy ) NSString *modelContentStr;

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelSubViewsQueue;

@property (nonatomic , strong ) UIView *modelCustomView;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelSubViewMargin;
@property (nonatomic , assign ) CGFloat modelTopSubViewMargin;
@property (nonatomic , assign ) CGFloat modelBottomSubViewMargin;
@property (nonatomic , assign ) CGFloat modelLeftSubViewMargin;
@property (nonatomic , assign ) CGFloat modelRightSubViewMargin;
@property (nonatomic , assign ) CGFloat modelMaxWidth;
@property (nonatomic , assign ) CGFloat modelMaxHeight;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;

@property (nonatomic , strong ) UIColor *modelColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsClickActionClose;
@property (nonatomic , assign ) BOOL modelIsAddQueue;

@property (nonatomic , copy ) void(^modelFinishConfig)();

@property (nonatomic , assign ) LEEBackgroundStyle modelBackgroundStyle;

@end

@implementation LEEAlertConfigModel

- (void)dealloc{
    
    _modelCustomView = nil;
    _modelActionArray = nil;
    _modelSubViewsQueue = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 10.0f; //默认警示框圆角半径
        _modelSubViewMargin = 10.0f; //默认警示框内部控件之间间距
        _modelTopSubViewMargin = 20.0f; //默认警示框顶部距离控件的间距
        _modelBottomSubViewMargin = 20.0f; //默认警示框底部距离控件的间距
        _modelLeftSubViewMargin = 20.0f; //默认警示框左侧距离控件的间距
        _modelRightSubViewMargin = 20.0f; //默认警示框右侧距离控件的间距
        _modelMaxWidth = 280; //默认最大宽度 设备最小屏幕宽度 320 去除20左右边距
        _modelMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.8f; //默认最大高度屏幕80%
        _modelOpenAnimationDuration = 0.3f; //默认警示框打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认警示框关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.6f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.6f
        
        _modelColor = [UIColor whiteColor]; //默认警示框颜色
        _modelBackgroundColor = [UIColor blackColor]; //默认警示框背景半透明或者模糊颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsClickActionClose = NO; //默认点击按钮不关闭
        _modelIsAddQueue = NO; //默认不加入队列
        
        _modelBackgroundStyle = LEEBackgroundStyleTranslucent; //默认为半透明背景样式
    }
    return self;
}

- (LEEConfigToString)LeeTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelTitleStr = str;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeTitle];
            
            if ([weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelSubViewsQueue addObject:@{@"type" : @(LEESubViewTypeTitle)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToConfigLabel)LeeAddTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        if (weakSelf) {
            
            NSDictionary *info = @{@"type" : @(LEESubViewTypeTitle) , @"block" : block};
            
            if (weakSelf.modelTitleStr) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeTitle];
                
                NSArray *result = [weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate];
                
                [weakSelf.modelSubViewsQueue replaceObjectAtIndex:[weakSelf.modelSubViewsQueue indexOfObject:result.firstObject] withObject:info];
                
            } else {
                
                [weakSelf.modelSubViewsQueue addObject:info];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToString)LeeContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelContentStr = str;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeContent];
            
            if ([weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelSubViewsQueue addObject:@{@"type" : @(LEESubViewTypeContent)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToConfigLabel)LeeAddContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        if (weakSelf) {
            
            NSDictionary *info = @{@"type" : @(LEESubViewTypeContent) , @"block" : block};
            
            if (weakSelf.modelContentStr) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeContent];
                
                NSArray *result = [weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate];
                
                [weakSelf.modelSubViewsQueue replaceObjectAtIndex:[weakSelf.modelSubViewsQueue indexOfObject:result.firstObject] withObject:info];
                
            } else {
                
                [weakSelf.modelSubViewsQueue addObject:info];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToAction)LeeAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(LEEAction *action)){
        
        [weakSelf.modelActionArray addObject:block];
        
        return weakSelf;
    };

}

- (LEEConfigToConfigTextField)LeeAddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(UITextField *)){
        
        if (weakSelf) {
            
            [weakSelf.modelSubViewsQueue addObject:@{@"type" : @(LEESubViewTypeTextField) , @"block" : block}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToView)LeeCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            weakSelf.modelCustomView = view;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeCustomView];
            
            if ([weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelSubViewsQueue addObject:@{@"type" : @(LEESubViewTypeCustomView)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeCornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCornerRadius = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelSubViewMargin = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeTopSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelTopSubViewMargin = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeBottomSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelBottomSubViewMargin = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeLeftSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelLeftSubViewMargin = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeRightSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelRightSubViewMargin = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelMaxWidth = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelMaxHeight = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeOpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelOpenAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeCloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCloseAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToColor)LeeColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelColor = color;
        
        return weakSelf;
    };
    
}

- (LEEConfigToColor)LeeBackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelBackgroundColor = color;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeBackgroundStyleTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = LEEBackgroundStyleTranslucent;
            
            weakSelf.modelBackgroundStyleColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeViewBackgroundStyleBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = LEEBackgroundStyleBlur;
            
            weakSelf.modelBackgroundStyleColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfig)LeeClickBackgroundClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) weakSelf.modelIsClickBackgroundClose = YES;
        
        return weakSelf;
    };
    
}

- (LEEConfig)LeeClickActionClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) weakSelf.modelIsClickActionClose = YES;
        
        return weakSelf;
    };
    
}

- (LEEConfig)LeeAddQueue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^{
        
        if (weakSelf) weakSelf.modelIsAddQueue = YES;
        
        return weakSelf;
    };
    
}

- (LEEConfig)LeeShow{
    
    __weak typeof(self) weakSelf = self;
    
    return ^{
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig();
        }
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{
 
    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];
    
    return _modelActionArray;
}

- (NSMutableArray *)modelSubViewsQueue{
    
    if (!_modelSubViewsQueue) _modelSubViewsQueue = [NSMutableArray array];
    
    return _modelSubViewsQueue;
}

@end


@interface LEEAction ()

@property (nonatomic , strong ) UIButton *button;

@end

@implementation LEEAction

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    if (_button) [_button setTitle:title forState:UIControlStateNormal];
}

- (void)setHighlight:(NSString *)highlight{
    
    _highlight = highlight;
    
    if (_button) [_button setTitle:highlight forState:UIControlStateHighlighted];
}

- (void)setFont:(UIFont *)font{
    
    _font = font;
    
    if (_button) [_button.titleLabel setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    _titleColor = titleColor;
    
    if (_button) [_button setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setHighlightColor:(UIColor *)highlightColor{
    
    _highlightColor = highlightColor;
    
    if (_button) [_button setTitleColor:highlightColor forState:UIControlStateHighlighted];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
    _backgroundColor = backgroundColor;
    
    if (_button) [_button setBackgroundColor:backgroundColor];
}

- (void)setBorderColor:(UIColor *)borderColor{
    
    _borderColor = borderColor;
    
    
}

@end

@interface LEEBaseViewController ()

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIImageView *backgroundImageView;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishBlock)();

@property (nonatomic , copy ) void (^closeFinishBlock)();

@end

@implementation LEEBaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_config.modelCustomView) [_config.modelCustomView removeObserver:self forKeyPath:@"frame"];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundImageView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundImageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.config.modelIsClickBackgroundClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAlertAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    if (self.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
        
        self.backgroundImageView.alpha = 0.0f;
        
        self.backgroundImageView.image = [[self getCurrentKeyWindowImage] Lee_ApplyBlurWithRadius:10.0f TintColor:[self.config.modelBackgroundColor colorWithAlphaComponent:self.config.modelBackgroundStyleColorAlpha] SaturationDeltaFactor:1.0f MaskImage:nil];
    }
    
    [self.currentKeyWindow endEditing:YES];
}

#pragma mark close animations
    
- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [[LEEAlert shareManager].leeWindow endEditing:YES];
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

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LEEAlert shareManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LEEAlert shareManager].mainWindow) [LEEAlert shareManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) _backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    return _backgroundImageView;
}

@end

#pragma mark - Alert

@interface LEEAlertViewController ()

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <UIView *>*alertSubViewArray;

@property (nonatomic , strong ) NSMutableArray <LEEAction *>*alertActionArray;

@end

@implementation LEEAlertViewController
{
    CGFloat alertViewMaxHeight;
    CGFloat alertViewHeight;
    CGFloat alertViewWidth;
    CGFloat customViewHeight;
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _alertView = nil;
    
    _alertSubViewArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configAlert];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notify{
    
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    isShowingKeyboard = YES;
}

- (void)keyboardWillHidden:(NSNotification *)notify{
    
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    isShowingKeyboard = NO;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notify{
    
    double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (isShowingKeyboard) {
        
        [UIView beginAnimations:@"keyboardDidChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
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
        
        [UIView commitAnimations];
        
    } else {
        
        [UIView beginAnimations:@"keyboardDidChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;;
        
        alertViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - alertViewFrame.size.height) / 2;
        
        self.alertView.frame = alertViewFrame;
        
        self.alertView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.alertView.center.y);
        
        [UIView commitAnimations];
    }
    
}

- (void)changeOrientationNotification:(NSNotification *)notify{
    
    if (self.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
        
        self.backgroundImageView.image = [[self getCurrentKeyWindowImage] Lee_ApplyTintEffectWithColor:[self.config.modelBackgroundColor colorWithAlphaComponent:self.config.modelBackgroundStyleColorAlpha]];
    }
    
    [self updateOrientationLayout];
}

- (void)updateOrientationLayout{
    
    alertViewMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) >  CGRectGetWidth([[UIScreen mainScreen] bounds]) ? self.config.modelMaxHeight : CGRectGetHeight([[UIScreen mainScreen] bounds]) - 20.0f;
    
    if (!isShowingKeyboard) {
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        alertViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - alertViewFrame.size.height) / 2;
        
        self.alertView.frame = alertViewFrame;
        
        self.alertView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.alertView.center.y);
    }
    
    self.backgroundImageView.frame = self.view.frame;
}

- (void)updateAlertViewSubViewsLayout{
    
    alertViewHeight = 0.0f;
    
    alertViewWidth = self.config.modelMaxWidth;
    
    if (self.alertSubViewArray.count > 0) alertViewHeight += self.config.modelTopSubViewMargin;
    
    for (UIView *subView in self.alertSubViewArray) {
        
        CGRect subViewFrame = subView.frame;
        
        subViewFrame.origin.x = self.config.modelLeftSubViewMargin;
        
        subViewFrame.origin.y = alertViewHeight;
        
        subViewFrame.size.width = alertViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin;
        
        if (subView == self.config.modelCustomView) customViewHeight = subViewFrame.size.height;
        
        subView.frame = subViewFrame;
        
        alertViewHeight += subViewFrame.size.height;
        
        alertViewHeight += self.config.modelSubViewMargin;
    }
    
    if (self.alertSubViewArray.count > 0) {
        
        alertViewHeight -= self.config.modelSubViewMargin;
        
        alertViewHeight += self.config.modelBottomSubViewMargin;
    }
    
    for (LEEAction *action in self.alertActionArray) {
        
        CGRect buttonFrame = action.button.frame;
        
        buttonFrame.origin.y = alertViewHeight;
        
        action.button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height;
    }
    
    if (self.alertActionArray.count == 2) {
        
        UIButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject.button : self.alertActionArray.lastObject.button;
        
        UIButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject.button : self.alertActionArray.firstObject.button;
        
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
    
    // 更新方向布局
    
    [self updateOrientationLayout];
}

- (void)configAlert{
    
    alertViewHeight = 0.0f;
    
    alertViewWidth = self.config.modelMaxWidth;
    
    [self.view addSubview: self.alertView];
    
    for (NSDictionary *item in self.config.modelSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEESubViewTypeTitle:
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
            
            case LEESubViewTypeContent:
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
            
            case LEESubViewTypeCustomView:
            {
                if (self.config.modelCustomView) {
                    
                    CGRect customContentViewFrame = self.config.modelCustomView.frame;
                    
                    customContentViewFrame.origin.y = alertViewHeight;
                    
                    customViewHeight = customContentViewFrame.size.height;
                    
                    self.config.modelCustomView.frame = customContentViewFrame;
                    
                    [self.alertView addSubview:self.config.modelCustomView];
                    
                    [self.alertSubViewArray addObject:self.config.modelCustomView];
                    
                    [self.config.modelCustomView addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
                    
                    [self.config.modelCustomView layoutSubviews];
                }
                
            }
                break;
           
            case LEESubViewTypeTextField:
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
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        action.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (block) block(action);
        
        if (!action.title) [action.button setTitle:@"按钮" forState:UIControlStateNormal];
        
        if (!action.titleColor) [action.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        if (!action.backgroundColor) [action.button setBackgroundColor:[UIColor clearColor]];
        
        [action.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        action.button.frame = CGRectMake(0, alertViewHeight, alertViewWidth, 45.0f);
        
        [self.alertView addSubview:action.button];
        
        [self.alertActionArray addObject:action];
    }
    
    [self updateAlertViewSubViewsLayout]; //更新子视图布局
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    // 开启显示警示框动画
    
    [self showAlertAnimationsWithCompletionBlock:nil];
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)() = nil;
    
    for (LEEAction *action in self.alertActionArray) {
        
        if (action.button == sender) {
        
            switch (action.type) {
                
                case LEEActionTypeDefault:
                    
                    isClose = self.config.modelIsClickActionClose ? YES : NO;
                    
                    break;
                
                case LEEActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case LEEActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
        
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *customView = (UIView *)object;
    
    if (customViewHeight != CGRectGetHeight(customView.frame)) [self updateAlertViewSubViewsLayout];
}

#pragma mark start animations

- (void)showAlertAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [super showAlertAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    self.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    self.alertView.alpha = 0.0f;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelOpenAnimationDuration animations:^{
        
        if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
            
            weakSelf.backgroundImageView.alpha = 1.0f;
        }
        
        weakSelf.alertView.transform = CGAffineTransformIdentity;
        
        weakSelf.alertView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        weakSelf.isShowing = NO;
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    }];
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelCloseAnimationDuration animations:^{
        
        if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
            
            weakSelf.backgroundImageView.alpha = 0.0f;
        }
        
        weakSelf.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
        weakSelf.alertView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        weakSelf.isClosing = NO;
        
        weakSelf.alertView.transform = CGAffineTransformIdentity;
        
        weakSelf.alertView.alpha = 1.0f;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    }];
    
}

#pragma mark Tool

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}

- (UIScrollView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.config.modelMaxWidth, 0)];
        
        _alertView.backgroundColor = self.config.modelColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.bounces = NO;
    }
    
    return _alertView;
}

- (NSMutableArray *)alertSubViewArray{
    
    if (!_alertSubViewArray) _alertSubViewArray = [NSMutableArray array];
    
    return _alertSubViewArray;
}

- (NSMutableArray <LEEAction *>*)alertActionArray{
    
    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];
    
    return _alertActionArray;
}

@end

#pragma mark - ActionSheet

@interface LEEActionSheetViewController ()

@property (nonatomic , strong ) UIView *actionSheetView;

@property (nonatomic , strong ) UIScrollView *actionSheetScrollView;

@property (nonatomic , strong ) NSMutableArray <UIView *>*actionSheetSubViewArray;

@property (nonatomic , strong ) NSMutableArray <LEEAction *>*actionSheetActionArray;

@property (nonatomic , strong ) LEEAction *actionSheetCancelAction;

@end

@implementation LEEActionSheetViewController
{
    CGFloat actionSheetViewMaxWidth;
    CGFloat actionSheetViewMaxHeight;
    CGFloat actionSheetViewWidth;
    CGFloat actionSheetViewHeight;
    CGFloat customViewHeight;
    BOOL isShowed;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _actionSheetView = nil;
    
    _actionSheetScrollView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configActionSheet];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)changeOrientationNotification:(NSNotification *)notify{
    
    if (self.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
        
        self.backgroundImageView.image = [[self getCurrentKeyWindowImage] Lee_ApplyTintEffectWithColor:[self.config.modelBackgroundColor colorWithAlphaComponent:self.config.modelBackgroundStyleColorAlpha]];
    }
    
    [self updateOrientationLayout];
}

- (void)updateOrientationLayout{
    
    actionSheetViewMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) >  CGRectGetWidth([[UIScreen mainScreen] bounds]) ? self.config.modelMaxHeight : CGRectGetHeight([[UIScreen mainScreen] bounds]) - 20.0f; //更新最大高度 (iOS 8 以上处理)
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    if (isShowed) actionSheetViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - actionSheetViewFrame.size.height) - self.config.modelBottomSubViewMargin;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    [self updateActionSheetViewSubViewsLayout]; //更新子视图布局
    
    self.actionSheetView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.actionSheetView.center.y);
    
    self.backgroundImageView.frame = self.view.frame;
}

- (void)updateActionSheetViewSubViewsLayout{
    
    CGRect actionSheetScrollViewFrame = self.actionSheetScrollView.frame;
    
    actionSheetScrollViewFrame.size.height = self.actionSheetCancelAction ? CGRectGetHeight(self.actionSheetView.frame) - CGRectGetHeight(self.actionSheetCancelAction.button.frame) - 10 : CGRectGetHeight(self.actionSheetView.frame);
    
    self.actionSheetScrollView.frame = actionSheetScrollViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect actionSheetCancelButtonFrame = self.actionSheetCancelAction.button.frame;
        
        actionSheetCancelButtonFrame.origin.y = CGRectGetHeight(self.actionSheetScrollView.frame) + 10;
        
        self.actionSheetCancelAction.button.frame = actionSheetCancelButtonFrame;
    }
    
}

- (void)updateActionSheetScrollViewSubViewsLayout{
    
    actionSheetViewHeight = 0.0f;
    
    actionSheetViewWidth = self.config.modelMaxWidth;
    
    if (self.actionSheetSubViewArray.count > 0) actionSheetViewHeight += self.config.modelTopSubViewMargin;
    
    for (UIView *subView in self.actionSheetSubViewArray) {
        
        CGRect subViewFrame = subView.frame;
        
        subViewFrame.origin.y = actionSheetViewHeight;
        
        if (subView == self.config.modelCustomView) customViewHeight = subViewFrame.size.height;
        
        subView.frame = subViewFrame;
        
        actionSheetViewHeight += subViewFrame.size.height;
        
        actionSheetViewHeight += self.config.modelSubViewMargin;
    }
    
    if (self.actionSheetSubViewArray.count > 0) {
        
        actionSheetViewHeight -= self.config.modelSubViewMargin;
        
        actionSheetViewHeight += self.config.modelBottomSubViewMargin;
    }
    
    for (LEEAction *action in self.actionSheetActionArray) {
        
        CGRect buttonFrame = action.button.frame;
        
        buttonFrame.origin.y = actionSheetViewHeight;
        
        action.button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height;
    }
    
    self.actionSheetScrollView.contentSize = CGSizeMake(actionSheetViewWidth, actionSheetViewHeight);
    
    if (self.actionSheetCancelAction) actionSheetViewHeight += CGRectGetHeight(self.actionSheetCancelAction.button.frame) + 10.0f;
    
    [self updateOrientationLayout]; // 更新方向布局
}

- (void)configActionSheet{
    
    actionSheetViewHeight = 0.0f;
    
    actionSheetViewWidth = self.config.modelMaxWidth;
    
    self.actionSheetScrollView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.actionSheetView addSubview:self.actionSheetScrollView];
    
    [self.view addSubview: self.actionSheetView];
    
    for (NSDictionary *item in self.config.modelSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEESubViewTypeTitle:
            {
                NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : @" ";
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, actionSheetViewHeight, actionSheetViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin, 0)];
                
                [self.actionSheetScrollView addSubview:titleLabel];
                
                [self.actionSheetSubViewArray addObject:titleLabel];
                
                titleLabel.textAlignment = NSTextAlignmentCenter;
                
                titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                
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
                
            case LEESubViewTypeContent:
            {
                NSString *content = self.config.modelContentStr ? self.config.modelContentStr : @" ";
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, actionSheetViewHeight, actionSheetViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin, 0)];
                
                [self.actionSheetScrollView addSubview:contentLabel];
                
                [self.actionSheetSubViewArray addObject:contentLabel];
                
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
                
            case LEESubViewTypeCustomView:
            {
                if (self.config.modelCustomView) {
                    
                    CGRect customContentViewFrame = self.config.modelCustomView.frame;
                    
                    customContentViewFrame.origin.y = actionSheetViewHeight;
                    
                    customViewHeight = customContentViewFrame.size.height;
                    
                    self.config.modelCustomView.frame = customContentViewFrame;
                    
                    [self.actionSheetScrollView addSubview:self.config.modelCustomView];
                    
                    [self.actionSheetSubViewArray addObject:self.config.modelCustomView];
                    
                    [self.config.modelCustomView addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
                    
                    [self.config.modelCustomView layoutSubviews];
                }
                
            }
                break;
            default:
                break;
        }
        
    }
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        action.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (block) block(action);
        
        if (!action.font) [action.button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
        if (!action.title) [action.button setTitle:@"按钮" forState:UIControlStateNormal];
        
        if (!action.titleColor) [action.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        if (!action.backgroundColor) [action.button setBackgroundColor:self.config.modelColor];
        
        switch (action.type) {
                
            case LEEActionTypeCancel:
            {
                action.button.frame = CGRectMake(0, 10.0f, actionSheetViewWidth, 57.0f);
                
                [action.button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                action.button.clipsToBounds = YES;
                
                action.button.layer.cornerRadius = self.config.modelCornerRadius;
                
                [self.actionSheetView addSubview:action.button];
                
                self.actionSheetCancelAction = action;
            }
                break;
                
            default:
            {
                 action.button.frame = CGRectMake(0, actionSheetViewHeight, actionSheetViewWidth, 57.0f);
             
                [action.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetScrollView addSubview:action.button];
                
                [self.actionSheetActionArray addObject:action];
            }
                break;
        }
        
    }
    
    [self updateActionSheetScrollViewSubViewsLayout];
    
    // 开启显示动画
    
    [self showActionSheetAnimationsWithCompletionBlock:nil];
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)() = nil;
    
    for (LEEAction *action in self.actionSheetActionArray) {
        
        if (action.button == sender) {
            
            switch (action.type) {
                    
                case LEEActionTypeDefault:
                    
                    isClose = self.config.modelIsClickActionClose ? YES : NO;
                    
                    break;
                    
                case LEEActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case LEEActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    void (^clickBlock)() = self.actionSheetCancelAction.clickBlock;
    
    [self closeAnimationsWithCompletionBlock:^{
        
        if (clickBlock) clickBlock();
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *customView = (UIView *)object;
    
    if (customViewHeight != CGRectGetHeight(customView.frame)) [self updateActionSheetScrollViewSubViewsLayout];
}

#pragma mark start animations

- (void)showActionSheetAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [super showAlertAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES; //显示ActionSheet
    
    __weak typeof(self) weakSelf = self;
    
     [UIView animateWithDuration:self.config.modelOpenAnimationDuration animations:^{
    
         switch (weakSelf.config.modelBackgroundStyle) {
                 
             case LEEBackgroundStyleBlur:
             {
                 weakSelf.backgroundImageView.alpha = 1.0f;
             }
                 break;
                 
             case LEEBackgroundStyleTranslucent:
             {
                 weakSelf.view.backgroundColor = [weakSelf.config.modelBackgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
             }
                 break;
                 
             default:
                 break;
         }
         
         [weakSelf updateOrientationLayout];
      
     } completion:^(BOOL finished) {
    
         weakSelf.isShowing = NO;
         
         if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
         
         if (completionBlock) completionBlock();
     }];
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    isShowed = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelCloseAnimationDuration animations:^{
        
        switch (weakSelf.config.modelBackgroundStyle) {
            
            case LEEBackgroundStyleBlur:
            {
                 weakSelf.backgroundImageView.alpha = 0.0f;
            }
                break;
                
            case LEEBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            }
                break;
                
            default:
                break;
        }
        
        [self updateOrientationLayout]; // 更新布局
        
    } completion:^(BOOL finished) {
        
        weakSelf.isClosing = NO;
        
        weakSelf.actionSheetView.transform = CGAffineTransformIdentity;
        
        weakSelf.actionSheetView.alpha = 1.0f;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    }];
    
}

#pragma mark LazyLoading

- (UIView *)actionSheetView{
    
    if (!_actionSheetView) {
        
        _actionSheetView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.config.modelMaxWidth, 0)];
        
        _actionSheetView.backgroundColor = [UIColor clearColor];
    }
    
    return _actionSheetView;
}

- (UIScrollView *)actionSheetScrollView{
    
    if (!_actionSheetScrollView) {
        
        _actionSheetScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.actionSheetView.frame), 0)];
        
        _actionSheetScrollView.backgroundColor = self.config.modelColor;
        
        _actionSheetScrollView.directionalLockEnabled = YES;
        
        _actionSheetScrollView.bounces = NO;
    }
    
    return _actionSheetScrollView;
}

- (NSMutableArray <UIView *>*)actionSheetSubViewArray{
    
    if (!_actionSheetSubViewArray) _actionSheetSubViewArray = [NSMutableArray array];
    
    return _actionSheetSubViewArray;
}

- (NSMutableArray <LEEAction *>*)actionSheetActionArray{
    
    if (!_actionSheetActionArray) _actionSheetActionArray = [NSMutableArray array];
    
    return _actionSheetActionArray;
}

@end

@interface LEEAlertConfig ()<LEEAlertProtocol>

@end

@implementation LEEAlertConfig

- (void)dealloc{
    
    _config = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        self.config.modelFinishConfig = ^{
            
            if (!weakSelf) return;
        
            if ([LEEAlert shareManager].queueArray.count) {
                
                LEEAlertConfig *last = [LEEAlert shareManager].queueArray.lastObject;
                
                if (!last.config.modelIsAddQueue) [[LEEAlert shareManager].queueArray removeObject:last];
            }
            
            [weakSelf show];
            
            [[LEEAlert shareManager].queueArray addObject:weakSelf];
        };
        
    }
    
    return self;
}

- (void)show{
    
    switch (self.type) {
            
        case LEEAlertTypeAlert:
            
            [LEEAlert shareManager].viewController = [[LEEAlertViewController alloc] init];
            
            break;
            
        case LEEAlertTypeActionSheet:
            
            [LEEAlert shareManager].viewController = [[LEEActionSheetViewController alloc] init];
            
            break;
            
        default:
            break;
    }
    
    if (![LEEAlert shareManager].viewController) return;
    
    [LEEAlert shareManager].viewController.config = self.config;
    
    [LEEAlert shareManager].leeWindow.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
    
    [LEEAlert shareManager].leeWindow.rootViewController = [LEEAlert shareManager].viewController;
    
    [LEEAlert shareManager].leeWindow.hidden = NO;
    
    [[LEEAlert shareManager].leeWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert shareManager].viewController.closeFinishBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return;
        
        if ([LEEAlert shareManager].queueArray.lastObject == strongSelf) {
            
            [LEEAlert shareManager].leeWindow.hidden = YES;
            
            [[LEEAlert shareManager].leeWindow resignKeyWindow];
            
            [LEEAlert shareManager].leeWindow.rootViewController = nil;
            
            [LEEAlert shareManager].viewController = nil;
            
            [[LEEAlert shareManager].queueArray removeObject:strongSelf];
            
            if ([LEEAlert shareManager].queueArray.count) {
                
                [LEEAlert shareManager].queueArray.lastObject.config.modelFinishConfig();
                
            } else {
                
                [LEEAlert shareManager].leeWindow = nil;
            }
            
        } else {
            
            [[LEEAlert shareManager].queueArray removeObject:strongSelf];
        }

    };
    
}

- (void)closeWithCompletionBlock:(void (^)())completionBlock{
    
    if ([LEEAlert shareManager].viewController) [[LEEAlert shareManager].viewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark - LazyLoading

- (LEEAlertConfigModel *)config{
    
    if (!_config) _config = [[LEEAlertConfigModel alloc] init];
    
    return _config;
}

@end

#pragma mark - ====================工具类====================

@implementation UIImage (LEEImageEffects)

- (UIImage*)Lee_ApplyLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    
    return[self Lee_ApplyBlurWithRadius:30 TintColor:tintColor SaturationDeltaFactor:1.8 MaskImage:nil];
}

- (UIImage*)Lee_ApplyExtraLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    
    return[self Lee_ApplyBlurWithRadius:20 TintColor:tintColor SaturationDeltaFactor:1.8 MaskImage:nil];
}

- (UIImage*)Lee_ApplyDarkEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    
    return[self Lee_ApplyBlurWithRadius:20 TintColor:tintColor SaturationDeltaFactor:1.8 MaskImage:nil];
}

- (UIImage*)Lee_ApplyTintEffectWithColor:(UIColor*)tintColor {
    
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
    
    return[self Lee_ApplyBlurWithRadius:10 TintColor:effectColor SaturationDeltaFactor:1.0f MaskImage:nil];
}

- (UIImage*)Lee_ApplyBlurWithRadius:(CGFloat)blurRadius TintColor:(UIColor*)tintColor SaturationDeltaFactor:(CGFloat)saturationDeltaFactor MaskImage:(UIImage*)maskImage{
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
