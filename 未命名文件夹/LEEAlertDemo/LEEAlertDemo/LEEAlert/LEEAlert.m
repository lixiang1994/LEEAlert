//
//  LEEAlert.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/3/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LEEAlert.h"

#import <Accelerate/Accelerate.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })

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
    
    config.type = IS_IPAD ? LEEAlertTypeAlert : LEEAlertTypeActionSheet;
    
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

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelSubViewsQueue;

@property (nonatomic , strong ) UIView *modelCustomView;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelSubViewMargin;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;

@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@property (nonatomic , strong ) UIColor *modelColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsClickActionClose;
@property (nonatomic , assign ) BOOL modelIsAddQueue;

@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) CGFloat(^modelMaxWidthBlock)(LEEScreenOrientationType);
@property (nonatomic , copy ) CGFloat(^modelMaxHeightBlock)(LEEScreenOrientationType);

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
        
        _modelCornerRadius = 13.0f; //默认警示框圆角半径
        _modelSubViewMargin = 10.0f; //默认警示框内部控件之间间距
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认警示框打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认警示框关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
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
            
            weakSelf.LeeConfigTitle(^(UILabel *label) {
                
                label.text = str;
            });
            
        }
        
        return weakSelf;
    };
    
}


- (LEEConfigToString)LeeContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.LeeConfigContent(^(UILabel *label) {
               
                label.text = str;
            });
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToStringAndBlock)LeeAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)()){
        
        if (weakSelf) {
        
            weakSelf.LeeAddAction(^(LEEAction *action) {
                
                action.title = title;
                
                action.clickBlock = block;
            });

        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToStringAndBlock)LeeCancelAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)()){
        
        if (weakSelf) {
            
            weakSelf.LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                
                action.title = title;
                
                action.font = [UIFont boldSystemFontOfSize:18.0f];
                
                action.clickBlock = block;
            });
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToConfigLabel)LeeConfigTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        if (weakSelf) {
            
            NSDictionary *info = @{@"type" : @(LEESubViewTypeTitle) , @"block" : block};
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeTitle];
            
            NSArray *result = [weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate];
            
            if (result.count) {
                
                [weakSelf.modelSubViewsQueue replaceObjectAtIndex:[weakSelf.modelSubViewsQueue indexOfObject:result.firstObject] withObject:info];
                
            } else {
                
                [weakSelf.modelSubViewsQueue addObject:info];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToConfigLabel)LeeConfigContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        if (weakSelf) {
            
            NSDictionary *info = @{@"type" : @(LEESubViewTypeContent) , @"block" : block};
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeContent];
            
            NSArray *result = [weakSelf.modelSubViewsQueue filteredArrayUsingPredicate:predicate];
            
            if (result.count) {
                
                [weakSelf.modelSubViewsQueue replaceObjectAtIndex:[weakSelf.modelSubViewsQueue indexOfObject:result.firstObject] withObject:info];
                
            } else {
                
                [weakSelf.modelSubViewsQueue addObject:info];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToAction)LeeAddAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(LEEAction *)){
        
        if (weakSelf) [weakSelf.modelActionArray addObject:block];
        
        return weakSelf;
    };

}

- (LEEConfigToConfigTextField)LeeAddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(UITextField *)){
        
        if (weakSelf) [weakSelf.modelSubViewsQueue addObject:@{@"type" : @(LEESubViewTypeTextField) , @"block" : block}];
        
        return weakSelf;
    };
    
}

- (LEEConfigToView)LeeCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            if (!weakSelf.modelCustomView) {
                
                [weakSelf.modelSubViewsQueue addObject:@{@"type" : @(LEESubViewTypeCustomView)}];
            }
            
            weakSelf.modelCustomView = view;
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

- (LEEConfigToEdgeInsets)LeeHeaderInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) weakSelf.modelHeaderInsets = insets;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeActionSheetBottomMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetBottomMargin = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloat)LeeMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (LEEConfigToFloat)LeeMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (LEEConfigToFloatBlock)LeeConfigMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(LEEScreenOrientationType type)){
        
        if (weakSelf) weakSelf.modelMaxWidthBlock = block;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloatBlock)LeeConfigMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(LEEScreenOrientationType type)){
        
        if (weakSelf) weakSelf.modelMaxHeightBlock = block;
        
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


@interface LEEActionButton : UIButton

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

- (void)addTopBorder;

- (void)addBottomBorder;

- (void)addLeftBorder;

- (void)addRightBorder;

@end

@interface LEEActionButton ()

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation LEEActionButton

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_topLayer) _topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.borderWidth);
    
    if (_bottomLayer) _bottomLayer.frame = CGRectMake(0, self.frame.size.height - self.borderWidth, self.frame.size.width, self.borderWidth);
    
    if (_leftLayer) _leftLayer.frame = CGRectMake(0, 0, self.borderWidth, self.frame.size.height);
    
    if (_rightLayer) _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, 0, self.borderWidth, self.frame.size.height);
}

- (void)addTopBorder{
    
    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{
    
    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{
    
    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{
    
    [self.layer addSublayer:self.rightLayer];
}

- (CALayer *)createLayer{
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = self.borderColor.CGColor;
    
    return layer;
}

- (CALayer *)topLayer{
    
    if (!_topLayer) _topLayer = [self createLayer];
    
    return _topLayer;
}

- (CALayer *)bottomLayer{
    
    if (!_bottomLayer) _bottomLayer = [self createLayer];
    
    return _bottomLayer;
}

- (CALayer *)leftLayer{
    
    if (!_leftLayer) _leftLayer = [self createLayer];
    
    return _leftLayer;
}

- (CALayer *)rightLayer{
    
    if (!_rightLayer) _rightLayer = [self createLayer];
    
    return _rightLayer;
}

@end

@interface LEEAction ()

@property (nonatomic , strong ) LEEActionButton *button;

@end

@implementation LEEAction

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setHighlight:(NSString *)highlight{
    
    _highlight = highlight;
    
    [self.button setTitle:highlight forState:UIControlStateHighlighted];
}

- (void)setFont:(UIFont *)font{
    
    _font = font;
    
    [self.button.titleLabel setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    _titleColor = titleColor;
    
    [self.button setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setHighlightColor:(UIColor *)highlightColor{
    
    _highlightColor = highlightColor;
    
    [self.button setTitleColor:highlightColor forState:UIControlStateHighlighted];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
    _backgroundColor = backgroundColor;
    
    [self.button setBackgroundImage:[self getImageWithColor:backgroundColor] forState:UIControlStateNormal];
}

- (void)setBackgroundHighlightColor:(UIColor *)backgroundHighlightColor{
    
    _backgroundHighlightColor = backgroundHighlightColor;
    
    [self.button setBackgroundImage:[self getImageWithColor:backgroundHighlightColor] forState:UIControlStateHighlighted];
}

- (void)setBorderColor:(UIColor *)borderColor{
    
    _borderColor = borderColor;
    
    self.button.borderColor = borderColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    
    if (borderWidth < 0.35f) borderWidth = 0.35f;
    
    _borderWidth = borderWidth;
    
    self.button.borderWidth = borderWidth;
}

- (void)setImage:(UIImage *)image{
    
    _image = image;
    
    [self.button setImage:image forState:UIControlStateNormal];
}

- (void)setHighlightImage:(UIImage *)highlightImage{
    
    _highlightImage = highlightImage;
    
    [self.button setImage:highlightImage forState:UIControlStateHighlighted];
}

- (void)setHeight:(CGFloat)height{
    
    _height = height;
    
    CGRect buttonFrame = self.button.frame;
    
    buttonFrame.size.height = height;
    
    self.button.frame = buttonFrame;
}

- (void)setEnabled:(BOOL)enabled{
    
    _enabled = enabled;
    
    self.button.enabled = enabled;
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

#pragma mark LazyLoading

- (LEEActionButton *)button{
    
    if (!_button) _button = [LEEActionButton buttonWithType:UIButtonTypeCustom];
    
    return _button;
}

@end

@interface LEEBaseViewController ()

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIImageView *backgroundImageView;

@property (nonatomic , assign ) LEEScreenOrientationType orientationType;

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundImageView];

    self.view.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
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

- (LEEScreenOrientationType)orientationType{
    
    return CGRectGetHeight([[UIScreen mainScreen] bounds]) > CGRectGetWidth([[UIScreen mainScreen] bounds]) ? LEEScreenOrientationTypeVertical : LEEScreenOrientationTypeHorizontal;
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
    CGFloat alertViewHeight;
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
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
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
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    if (!isShowingKeyboard) {
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.width = alertViewMaxWidth;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        alertViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - alertViewFrame.size.height) / 2;
        
        self.alertView.frame = alertViewFrame;
        
        self.alertView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.alertView.center.y);
    }
    
    self.backgroundImageView.frame = self.view.frame;
}

- (void)updateAlertViewSubViewsLayout{
    
    alertViewHeight = 0.0f;
    
    CGFloat alertViewWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    if (self.alertSubViewArray.count > 0) alertViewHeight += self.config.modelHeaderInsets.top;
    
    for (UIView *subView in self.alertSubViewArray) {
        
        CGRect subViewFrame = subView.frame;
        
        subViewFrame.origin.x = self.config.modelHeaderInsets.left;
        
        subViewFrame.origin.y = alertViewHeight;
        
        subViewFrame.size.width = alertViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right;
        
        if (subView == self.config.modelCustomView) customViewHeight = subViewFrame.size.height;
        
        subView.frame = subViewFrame;
        
        alertViewHeight += subViewFrame.size.height;
        
        alertViewHeight += self.config.modelSubViewMargin;
    }
    
    if (self.alertSubViewArray.count > 0) {
        
        alertViewHeight -= self.config.modelSubViewMargin;
        
        alertViewHeight += self.config.modelHeaderInsets.bottom;
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
    
    CGFloat alertViewWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    [self.view addSubview: self.alertView];
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    for (NSDictionary *item in self.config.modelSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEESubViewTypeTitle:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.config.modelHeaderInsets.left, alertViewHeight, alertViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right, 0)];
                
                [self.alertView addSubview:label];
                
                [self.alertSubViewArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                CGRect labelRect = [self getLabelTextHeight:label];
                
                CGRect labelFrame = label.frame;
                
                labelFrame.size.height = labelRect.size.height;
                
                label.frame = labelFrame;
            }
                break;
            
            case LEESubViewTypeContent:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelHeaderInsets.left, alertViewHeight, alertViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right, 0)];
                
                [self.alertView addSubview:label];
                
                [self.alertSubViewArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                CGRect labelRect = [self getLabelTextHeight:label];
                
                CGRect labelFrame = label.frame;
                
                labelFrame.size.height = labelRect.size.height;
                
                label.frame = labelFrame;
            }
                break;
            
            case LEESubViewTypeCustomView:
            {
                if (self.config.modelCustomView) {
                    
                    CGRect customViewFrame = self.config.modelCustomView.frame;
                    
                    customViewFrame.origin.y = alertViewHeight;
                    
                    customViewHeight = customViewFrame.size.height;
                    
                    self.config.modelCustomView.frame = customViewFrame;
                    
                    [self.alertView addSubview:self.config.modelCustomView];
                    
                    [self.alertSubViewArray addObject:self.config.modelCustomView];
                    
                    [self.config.modelCustomView addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
                    
                    [self.config.modelCustomView layoutSubviews];
                }
                
            }
                break;
           
            case LEESubViewTypeTextField:
            {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.config.modelHeaderInsets.left, alertViewHeight, alertViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right , 40.0f)];
                
                [self.alertView addSubview:textField];
                
                [self.alertSubViewArray addObject:textField];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                void(^block)(UITextField *textField) = item[@"block"];
                
                if (block) block(textField);
            }
                break;
                
            default:
                break;
        }
        
    }
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor lightGrayColor];
        
        if (!action.borderWidth) action.borderWidth = 0.35f;
        
        if (!action.height) action.height = 45.0f;
        
        [action.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        action.button.frame = CGRectMake(0, alertViewHeight, alertViewWidth, action.height);
        
        [action.button addTopBorder];
        
        [self.alertView addSubview:action.button];
        
        [self.alertActionArray addObject:action];
    }
    
    if (self.alertActionArray.count == 2) [self.alertActionArray.lastObject.button addLeftBorder];
    
    // 更新子视图布局
    
    [self updateAlertViewSubViewsLayout];
    
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
        
        _alertView = [[UIScrollView alloc] init];
        
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
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    if (isShowed) actionSheetViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - actionSheetViewFrame.size.height) - self.config.modelActionSheetBottomMargin;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    [self updateActionSheetViewSubViewsLayout]; //更新子视图布局
    
    self.actionSheetView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.actionSheetView.center.y);
    
    self.backgroundImageView.frame = self.view.frame;
}

- (void)updateActionSheetViewSubViewsLayout{
    
    CGRect actionSheetScrollViewFrame = self.actionSheetScrollView.frame;
    
    actionSheetScrollViewFrame.size.width = CGRectGetWidth(self.actionSheetView.frame);
    
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
    
    CGFloat actionSheetViewWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    if (self.actionSheetSubViewArray.count > 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
    
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
        
        actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
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
    
    CGFloat actionSheetViewWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    self.actionSheetScrollView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.actionSheetView addSubview:self.actionSheetScrollView];
    
    [self.view addSubview: self.actionSheetView];
    
    for (NSDictionary *item in self.config.modelSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEESubViewTypeTitle:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.config.modelHeaderInsets.left, actionSheetViewHeight, actionSheetViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right, 0)];
                
                [self.actionSheetScrollView addSubview:label];
                
                [self.actionSheetSubViewArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                CGRect labelRect = [self getLabelTextHeight:label];
                
                CGRect labelFrame = label.frame;
                
                labelFrame.size.height = labelRect.size.height;
                
                label.frame = labelFrame;
            }
                break;
                
            case LEESubViewTypeContent:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.config.modelHeaderInsets.left, actionSheetViewHeight, actionSheetViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right, 0)];
                
                [self.actionSheetScrollView addSubview:label];
                
                [self.actionSheetSubViewArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                CGRect labelRect = [self getLabelTextHeight:label];
                
                CGRect labelFrame = label.frame;
                
                labelFrame.size.height = labelRect.size.height;
                
                label.frame = labelFrame;
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
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:20.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor lightGrayColor];
        
        if (!action.borderWidth) action.borderWidth = 0.35f;
        
        if (!action.height) action.height = 57.0f;
        
        switch (action.type) {
                
            case LEEActionTypeCancel:
            {
                action.button.frame = CGRectMake(0, 10.0f, actionSheetViewWidth, action.height);
                
                [action.button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                action.button.clipsToBounds = YES;
                
                action.button.layer.cornerRadius = self.config.modelCornerRadius;
                
                [self.actionSheetView addSubview:action.button];
                
                self.actionSheetCancelAction = action;
            }
                break;
                
            default:
            {
                action.button.frame = CGRectMake(0, actionSheetViewHeight, actionSheetViewWidth, action.height);
                
                [action.button addTopBorder];
                
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
        
        _actionSheetView = [[UIScrollView alloc] init];
        
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

- (void)setType:(LEEAlertType)type{
    
    _type = type;
    
    // 处理默认值
    
    switch (type) {
            
        case LEEAlertTypeAlert:
            
            self.config
            .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
               
                return 280.0f;
            })
            .LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type) {
                
                return CGRectGetHeight([[UIScreen mainScreen] bounds]) - 40.0f;
            });
            
            break;
            
        case LEEAlertTypeActionSheet:
            
            self.config
            .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
                
                return type == LEEScreenOrientationTypeHorizontal ? CGRectGetHeight([[UIScreen mainScreen] bounds]) - 20.0f : CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20.0f;
            })
            .LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type) {
                
                return CGRectGetHeight([[UIScreen mainScreen] bounds]) - 40.0f;
            });
            
            break;
            
        default:
            break;
    }
    
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
    
    [LEEAlert shareManager].leeWindow.rootViewController = [LEEAlert shareManager].viewController;
    
    [LEEAlert shareManager].leeWindow.hidden = NO;
    
    [[LEEAlert shareManager].leeWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert shareManager].viewController.openFinishBlock = ^{
        
    };
    
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
