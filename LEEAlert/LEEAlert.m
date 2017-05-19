
/*!
 *  @header LEEAlert.m
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
 *  @version    V1.0.0
 */

#import "LEEAlert.h"

#import <Accelerate/Accelerate.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])

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
@property (nonatomic , strong ) NSMutableArray *modelItemsQueue;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelSubViewMargin;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;

@property (nonatomic , strong ) UIColor *modelColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsAddQueue;

@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) CGFloat(^modelMaxWidthBlock)(LEEScreenOrientationType);
@property (nonatomic , copy ) CGFloat(^modelMaxHeightBlock)(LEEScreenOrientationType);

@property (nonatomic , copy ) void(^modelFinishConfig)();

@property (nonatomic , assign ) LEEBackgroundStyle modelBackgroundStyle;

@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;

@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@end

@implementation LEEAlertConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemsQueue = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 13.0f; //默认圆角半径
        _modelSubViewMargin = 10.0f; //默认内部控件之间间距
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelColor = [UIColor whiteColor]; //默认颜色
        _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsAddQueue = NO; //默认不加入队列
        
        _modelBackgroundStyle = LEEBackgroundStyleTranslucent; //默认为半透明背景样式
        
        _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
        
    }
    return self;
}

- (LEEConfigToString)LeeTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return weakSelf.LeeConfigTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (LEEConfigToString)LeeContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return  weakSelf.LeeConfigContent(^(UILabel *label) {
            
            label.text = str;
        });

    };
    
}

- (LEEConfigToStringAndBlock)LeeAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)()){
        
        return weakSelf.LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            
            action.title = title;
            
            action.clickBlock = block;
        });
        
    };
    
}

- (LEEConfigToStringAndBlock)LeeCancelAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)()){
        
        return weakSelf.LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            
            action.title = title;
            
            action.font = [UIFont boldSystemFontOfSize:18.0f];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (LEEConfigToStringAndBlock)LeeDestructiveAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)()){
        
        return weakSelf.LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDestructive;
            
            action.title = title;
            
            action.titleColor = [UIColor redColor];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (LEEConfigToConfigLabel)LeeConfigTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        if (weakSelf) {
            
            NSDictionary *info = @{@"type" : @(LEESubViewTypeTitle) , @"block" : block};
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEESubViewTypeTitle];
            
            NSArray *result = [weakSelf.modelItemsQueue filteredArrayUsingPredicate:predicate];
            
            if (result.count) {
                
                [weakSelf.modelItemsQueue replaceObjectAtIndex:[weakSelf.modelItemsQueue indexOfObject:result.firstObject] withObject:info];
                
            } else {
                
                [weakSelf.modelItemsQueue addObject:info];
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
            
            NSArray *result = [weakSelf.modelItemsQueue filteredArrayUsingPredicate:predicate];
            
            if (result.count) {
                
                [weakSelf.modelItemsQueue replaceObjectAtIndex:[weakSelf.modelItemsQueue indexOfObject:result.firstObject] withObject:info];
                
            } else {
                
                [weakSelf.modelItemsQueue addObject:info];
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

- (LEEConfigToView)LeeCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        return weakSelf.LeeConfigCustomView(^(LEECustomView *custom) {
        
            custom.view = view;
            
            custom.insets = UIEdgeInsetsZero;
            
            custom.positionType = LEECustomViewPositionTypeCenter;
        });
        
    };
    
}

- (LEEConfigToCustomView)LeeConfigCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(LEECustomView *custom)){
        
        if (weakSelf) [weakSelf.modelItemsQueue addObject:@{@"type" : @(LEESubViewTypeCustomView) , @"block" : block}];
        
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

- (LEEConfigToBlurEffectStyle)LeeBackgroundStyleBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIBlurEffectStyle style){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = LEEBackgroundStyleBlur;
            
            weakSelf.modelBackgroundBlurEffectStyle = style;
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

#pragma mark Alert Config

- (LEEConfigToConfigTextField)LeeAddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(UITextField *)){
        
        if (weakSelf) [weakSelf.modelItemsQueue addObject:@{@"type" : @(LEESubViewTypeTextField) , @"block" : block}];
        
        return weakSelf;
    };
    
}

#pragma mark ActionSheet Config

- (LEEConfigToFloat)LeeActionSheetCancelActionSpaceWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceWidth = number;
        
        return weakSelf;
    };
    
}

- (LEEConfigToColor)LeeActionSheetCancelActionSpaceColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceColor = color;
        
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


#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{
 
    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];
    
    return _modelActionArray;
}

- (NSMutableArray *)modelItemsQueue{
    
    if (!_modelItemsQueue) _modelItemsQueue = [NSMutableArray array];
    
    return _modelItemsQueue;
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

- (CGFloat)height{
    
    return self.button.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    
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

@interface LEECustomView ()

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangeBlock)();

@end

@implementation LEECustomView

- (void)dealloc{
    
    if (_view) [_view removeObserver:self forKeyPath:@"frame"];
}

- (void)setSizeChangeBlock:(void (^)())sizeChangeBlock{
    
    _sizeChangeBlock = sizeChangeBlock;
    
    if (_view) {
        
        [_view layoutSubviews];
        
        self.size = _view.frame.size;
        
        [_view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *view = (UIView *)object;
    
    if (!CGSizeEqualToSize(self.size, view.frame.size)) {
        
        self.size = view.frame.size;
        
        if (self.sizeChangeBlock) self.sizeChangeBlock();
    }
    
}

@end

@interface LEEBaseViewController ()

@property (nonatomic , strong ) LEEAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic , assign ) LEEScreenOrientationType orientationType;

@property (nonatomic , strong ) LEECustomView *customView;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishBlock)();

@property (nonatomic , copy ) void (^closeFinishBlock)();

@end

@implementation LEEBaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundVisualEffectView = nil;
    
    _customView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.config.modelBackgroundBlurEffectStyle];
        
        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        
        self.backgroundVisualEffectView.frame = self.view.frame;
        
        self.backgroundVisualEffectView.alpha = 0.0f;
        
        [self.view addSubview:self.backgroundVisualEffectView];
    }

    self.view.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.config.modelIsClickBackgroundClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [self.currentKeyWindow endEditing:YES];
}

#pragma mark close animations
    
- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [[LEEAlert shareManager].leeWindow endEditing:YES];
}

#pragma mark Tool

- (CGSize)getLabelTextHeight:(UILabel *)label MaxWidth:(CGFloat)maxWidth{
    
    return [label.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil].size;
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

- (LEEScreenOrientationType)orientationType{
    
    return SCREEN_HEIGHT > SCREEN_WIDTH ? LEEScreenOrientationTypeVertical : LEEScreenOrientationTypeHorizontal;
}

@end

#pragma mark - Alert

@interface LEEAlertViewController ()

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <LEEAction *>*alertActionArray;

@end

@implementation LEEAlertViewController
{
    CGFloat alertViewHeight;
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _alertView = nil;
    
    _alertItemArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
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
    
    [UIView beginAnimations:@"keyboardDidChangeFrame" context:NULL];
    
    [UIView setAnimationDuration:duration];
    
    [self updateOrientationLayout];
    
    [UIView commitAnimations];
}

- (void)changeOrientationNotification:(NSNotification *)notify{
    
    self.backgroundVisualEffectView.frame = self.view.frame;
    
    [self updateOrientationLayout];
}

- (void)updateOrientationLayout{
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    if (isShowingKeyboard) {
        
        if (keyboardFrame.size.height) {
            
            [self updateAlertItemsLayout];
            
            CGFloat keyboardY = keyboardFrame.origin.y;
            
            CGRect alertViewFrame = self.alertView.frame;
            
            CGFloat tempAlertViewHeight = keyboardY - alertViewHeight < 20 ? keyboardY - 20 : alertViewHeight;
            
            alertViewFrame.size.height = tempAlertViewHeight;
            
            alertViewFrame.size.width = alertViewMaxWidth;
            
            alertViewFrame.origin.x = (SCREEN_WIDTH - alertViewFrame.size.width) * 0.5f;
            
            alertViewFrame.origin.y = keyboardY - alertViewFrame.size.height - 10;
            
            self.alertView.frame = alertViewFrame;
            
            [self.alertView setContentOffset:CGPointZero animated:NO];
            
            [self.alertView scrollRectToVisible:[self findFirstResponder:self.alertView].frame animated:YES];
        }
        
    } else {
        
        [self updateAlertItemsLayout];
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.width = alertViewMaxWidth;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        alertViewFrame.origin.x = (SCREEN_WIDTH - alertViewMaxWidth) * 0.5f;
        
        alertViewFrame.origin.y = (SCREEN_HEIGHT - alertViewFrame.size.height) / 2;
        
        self.alertView.frame = alertViewFrame;
    }
    
}

- (void)updateAlertItemsLayout{
    
    alertViewHeight = 0.0f;
    
    CGFloat alertViewWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx == 0) alertViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            UIView *view = (UIView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left;
            
            viewFrame.origin.y = alertViewHeight;
            
            viewFrame.size.width = alertViewWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right;
            
            if ([item isKindOfClass:UILabel.class]) {
                
                viewFrame.size.height = [self getLabelTextHeight:(UILabel *)view MaxWidth:viewFrame.size.width].height;
            }
            
            view.frame = viewFrame;
            
            alertViewHeight += viewFrame.size.height;
            
            if (item != self.alertItemArray.lastObject) alertViewHeight += self.config.modelSubViewMargin;
            
        } else if ([item isKindOfClass:LEECustomView.class]) {
            
            LEECustomView *custom = (LEECustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            switch (custom.positionType) {
                
                case LEECustomViewPositionTypeCenter:
                   
                    viewFrame.origin.x = (alertViewWidth - viewFrame.size.width) * 0.5f;
                
                    break;
                    
                case LEECustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.insets.left;
                    
                    break;
                    
                case LEECustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = alertViewWidth - self.config.modelHeaderInsets.right - custom.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = alertViewHeight + custom.insets.top;
            
            custom.view.frame = viewFrame;
            
            alertViewHeight += viewFrame.size.height + custom.insets.top;
            
            alertViewHeight += custom.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) alertViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (LEEAction *action in self.alertActionArray) {
        
        CGRect buttonFrame = action.button.frame;
        
        buttonFrame.origin.y = alertViewHeight;
        
        buttonFrame.size.width = alertViewWidth;
        
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
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview: self.alertView];
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    for (NSDictionary *item in self.config.modelItemsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEESubViewTypeTitle:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc] init];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
            }
                break;
            
            case LEESubViewTypeContent:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc]init];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
            }
                break;
            
            case LEESubViewTypeCustomView:
            {
                void(^block)(LEECustomView *) = item[@"block"];
                
                if (block) {
                    
                    LEECustomView *custom = [[LEECustomView alloc] init];
                    
                    block(custom);
                    
                    [self.alertView addSubview:custom.view];
                    
                    [self.alertItemArray addObject:custom];
                    
                    custom.sizeChangeBlock = ^{
                      
                        if (weakSelf) [weakSelf updateOrientationLayout];
                    };
                    
                }
                
            }
                break;
           
            case LEESubViewTypeTextField:
            {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0 , 0, 0, 40.0f)];
                
                [self.alertView addSubview:textField];
                
                [self.alertItemArray addObject:textField];
                
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
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = 0.35f;
        
        if (!action.height) action.height = 45.0f;
        
        [action.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [action.button addTopBorder];
        
        [self.alertView addSubview:action.button];
        
        [self.alertActionArray addObject:action];
    }
    
    if (self.alertActionArray.count == 2) [self.alertActionArray.lastObject.button addLeftBorder];
    
    // 更新布局
    
    [self updateOrientationLayout];
    
    [self showAnimationsWithCompletionBlock:^{
    
        if (weakSelf) [weakSelf configNotification];
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)() = nil;
    
    for (LEEAction *action in self.alertActionArray) {
        
        if (action.button == sender) {
        
            switch (action.type) {
                
                case LEEActionTypeDefault:
                    
                    isClose = action.isClickNotClose ? NO : YES;
                    
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

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    self.alertView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    self.alertView.alpha = 0.0f;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelOpenAnimationDuration animations:^{
        
        if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.alpha = 1.0f;
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
            
            weakSelf.backgroundVisualEffectView.alpha = 0.0f;
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

- (NSMutableArray *)alertItemArray{
    
    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];
    
    return _alertItemArray;
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

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <LEEAction *>*actionSheetActionArray;

@property (nonatomic , strong ) LEEAction *actionSheetCancelAction;

@end

@implementation LEEActionSheetViewController
{
    
    CGFloat customViewHeight;
    BOOL isShowed;
}

- (void)dealloc{
    
    _actionSheetView = nil;
    
    _actionSheetScrollView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)changeOrientationNotification:(NSNotification *)notify{
    
    [self updateLayout];
}

- (void)updateLayout{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    
    __block CGFloat actionSheetViewHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            UIView *view = (UIView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left;
            
            viewFrame.origin.y = actionSheetViewHeight;
            
            viewFrame.size.width = actionSheetViewMaxWidth - self.config.modelHeaderInsets.left - self.config.modelHeaderInsets.right;
            
            if ([item isKindOfClass:UILabel.class]) {
                
                viewFrame.size.height = [self getLabelTextHeight:(UILabel *)view MaxWidth:viewFrame.size.width].height;
            }
            
            view.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height;
            
            if (item != self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelSubViewMargin;
            
        } else if ([item isKindOfClass:LEECustomView.class]) {
            
            LEECustomView *custom = (LEECustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            switch (custom.positionType) {
                    
                case LEECustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case LEECustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.insets.left;
                    
                    break;
                    
                case LEECustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.modelHeaderInsets.right - custom.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = actionSheetViewHeight + custom.insets.top;
            
            custom.view.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height + custom.insets.top;
            
            actionSheetViewHeight += custom.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (LEEAction *action in self.actionSheetActionArray) {
        
        CGRect buttonFrame = action.button.frame;
        
        buttonFrame.origin.y = actionSheetViewHeight;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        action.button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height;
    }
    
    self.actionSheetScrollView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);
    
    if (self.actionSheetCancelAction) actionSheetViewHeight += self.actionSheetCancelAction.height + self.config.modelActionSheetCancelActionSpaceWidth;
    
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.x = (SCREEN_WIDTH - actionSheetViewMaxWidth) * 0.5f;
    
    if (isShowed) {
        
        actionSheetViewFrame.origin.y = (SCREEN_HEIGHT - actionSheetViewFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else {
        
        actionSheetViewFrame.origin.y = SCREEN_HEIGHT;
    }
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    
    CGRect actionSheetScrollViewFrame = self.actionSheetScrollView.frame;
    
    actionSheetScrollViewFrame.size.width = CGRectGetWidth(self.actionSheetView.frame);
    
    actionSheetScrollViewFrame.size.height = self.actionSheetCancelAction ? CGRectGetHeight(self.actionSheetView.frame) - self.actionSheetCancelAction.height - self.config.modelActionSheetCancelActionSpaceWidth : CGRectGetHeight(self.actionSheetView.frame);
    
    self.actionSheetScrollView.frame = actionSheetScrollViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect buttonFrame = self.actionSheetCancelAction.button.frame;
        
        buttonFrame.origin.y = CGRectGetHeight(self.actionSheetScrollView.frame) + self.config.modelActionSheetCancelActionSpaceWidth;
        
        buttonFrame.size.width = actionSheetViewFrame.size.width;
        
        self.actionSheetCancelAction.button.frame = buttonFrame;
    }
    
    
    self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    self.actionSheetScrollView.layer.cornerRadius = self.config.modelCornerRadius;
    
    self.actionSheetView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
    
    [self.actionSheetView addSubview:self.actionSheetScrollView];
    
    [self.view addSubview: self.actionSheetView];
    
    for (NSDictionary *item in self.config.modelItemsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEESubViewTypeTitle:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc] init];
                
                [self.actionSheetScrollView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
            }
                break;
                
            case LEESubViewTypeContent:
            {
                void(^block)(UILabel *label) = item[@"block"];
                
                UILabel *label = [[UILabel alloc] init];
                
                [self.actionSheetScrollView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
            }
                break;
                
            case LEESubViewTypeCustomView:
            {
                
                void(^block)(LEECustomView *) = item[@"block"];
                
                if (block) {
                    
                    LEECustomView *custom = [[LEECustomView alloc] init];
                    
                    block(custom);
                    
                    [self.actionSheetScrollView addSubview:custom.view];
                    
                    [self.actionSheetItemArray addObject:custom];
                    
                    custom.sizeChangeBlock = ^{
                        
                        if (weakSelf) [weakSelf updateLayout];
                    };
                    
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
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = 0.35f;
        
        if (!action.height) action.height = 57.0f;
        
        switch (action.type) {
                
            case LEEActionTypeCancel:
            {
                [action.button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                action.button.clipsToBounds = YES;
                
                action.button.layer.cornerRadius = self.config.modelCornerRadius;
                
                [self.actionSheetView addSubview:action.button];
                
                self.actionSheetCancelAction = action;
            }
                break;
                
            default:
            {
                [action.button addTopBorder];
                
                [action.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetScrollView addSubview:action.button];
                
                [self.actionSheetActionArray addObject:action];
            }
                break;
        }
        
    }
    
    // 更新布局
    
    [self updateLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf configNotification];
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)() = nil;
    
    for (LEEAction *action in self.actionSheetActionArray) {
        
        if (action.button == sender) {
            
            switch (action.type) {
                    
                case LEEActionTypeDefault:
                    
                    isClose = action.isClickNotClose ? NO : YES;
                    
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

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES;
    
    __weak typeof(self) weakSelf = self;
    
     [UIView animateWithDuration:self.config.modelOpenAnimationDuration animations:^{
    
         switch (weakSelf.config.modelBackgroundStyle) {
                 
             case LEEBackgroundStyleBlur:
             {
                 weakSelf.backgroundVisualEffectView.alpha = 1.0f;
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
         
         [weakSelf updateLayout];
      
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
                 weakSelf.backgroundVisualEffectView.alpha = 0.0f;
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
        
        // 更新布局
        
        [self updateLayout];
        
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
    
    if (!_actionSheetView) _actionSheetView = [[UIScrollView alloc] init];
    
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

- (NSMutableArray <id>*)actionSheetItemArray{
    
    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];
    
    return _actionSheetItemArray;
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
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) return;
        
            if ([LEEAlert shareManager].queueArray.count) {
                
                LEEAlertConfig *last = [LEEAlert shareManager].queueArray.lastObject;
                
                if (!last.config.modelIsAddQueue) [[LEEAlert shareManager].queueArray removeObject:last];
            }
            
            [strongSelf show];
            
            [[LEEAlert shareManager].queueArray addObject:strongSelf];
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
                
                return SCREEN_HEIGHT - 40.0f;
            });
            
            break;
            
        case LEEAlertTypeActionSheet:
            
            self.config
            .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
                
                return type == LEEScreenOrientationTypeHorizontal ? SCREEN_HEIGHT - 20.0f : SCREEN_WIDTH - 20.0f;
            })
            .LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f;
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
