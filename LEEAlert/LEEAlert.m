
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
 *  @version    V1.0.3
 */

#import "LEEAlert.h"

#import <Accelerate/Accelerate.h>

#import <objc/runtime.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define VIEW_WIDTH CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)

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
    
    config.config.LeeClickBackgroundClose(YES);
    
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

@interface LEEAlertConfigModel ()

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelItemArray;
@property (nonatomic , strong ) NSMutableDictionary *modelItemInsetsInfo;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelShadowOpacity;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;

@property (nonatomic , strong ) UIColor *modelHeaderColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsAddQueue;

@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) CGFloat (^modelMaxWidthBlock)(LEEScreenOrientationType);
@property (nonatomic , copy ) CGFloat (^modelMaxHeightBlock)(LEEScreenOrientationType);

@property (nonatomic , copy ) void (^modelFinishConfig)();

@property (nonatomic , assign ) LEEBackgroundStyle modelBackgroundStyle;

@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;

@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@end

@implementation LEEAlertConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemArray = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 13.0f; //默认圆角半径
        _modelShadowOpacity = 0.3f; //默认阴影不透明度
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelHeaderColor = [UIColor whiteColor]; //默认颜色
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
        
        return weakSelf.LeeAddTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (LEEConfigToString)LeeContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return  weakSelf.LeeAddContent(^(UILabel *label) {
            
            label.text = str;
        });

    };
    
}

- (LEEConfigToView)LeeCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        return weakSelf.LeeAddCustomView(^(LEECustomView *custom) {
            
            custom.view = view;
            
            custom.positionType = LEECustomViewPositionTypeCenter;
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

- (LEEConfigToConfigLabel)LeeAddTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeTitle;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        ;
    };
    
}

- (LEEConfigToConfigLabel)LeeAddContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeContent;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (LEEConfigToCustomView)LeeAddCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(LEECustomView *custom)){
        
        return weakSelf.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeCustomView;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (LEEConfigToItem)LeeAddItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(LEEItem *)){
        
        if (weakSelf) if (block) [weakSelf.modelItemArray addObject:block];
        
        return weakSelf;
    };
    
}

- (LEEConfigToAction)LeeAddAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(LEEAction *)){
        
        if (weakSelf) if (block) [weakSelf.modelActionArray addObject:block];
        
        return weakSelf;
    };
    
}

- (LEEConfigToEdgeInsets)LeeHeaderInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (insets.top < 0) insets.top = 0;
            
            if (insets.left < 0) insets.left = 0;
            
            if (insets.bottom < 0) insets.bottom = 0;
            
            if (insets.right < 0) insets.right = 0;
            
            weakSelf.modelHeaderInsets = insets;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigToEdgeInsets)LeeItemInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (weakSelf.modelItemArray.count) {
                
                if (insets.top < 0) insets.top = 0;
                
                if (insets.left < 0) insets.left = 0;
                
                if (insets.bottom < 0) insets.bottom = 0;
                
                if (insets.right < 0) insets.right = 0;
                
                [weakSelf.modelItemInsetsInfo setObject:[NSValue valueWithUIEdgeInsets:insets] forKey:@(weakSelf.modelItemArray.count - 1)];
                
            } else {
                
                NSAssert(YES, @"请在添加的某一项后面设置间距");
            }
            
        }
        
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
        
        if (weakSelf) if (block) weakSelf.modelMaxWidthBlock = block;
        
        return weakSelf;
    };
    
}

- (LEEConfigToFloatBlock)LeeConfigMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(LEEScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxHeightBlock = block;
        
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

- (LEEConfigToFloat)LeeShadowOpacity{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelShadowOpacity = number;
        
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

- (LEEConfigToColor)LeeHeaderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelHeaderColor = color;
        
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

- (LEEConfigToBool)LeeClickBackgroundClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickBackgroundClose = is;
        
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
        
        return weakSelf.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeTextField;
            
            item.insets = UIEdgeInsetsMake(10, 0, 10, 0);
            
            item.block = block;
        });
        
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

- (NSMutableArray *)modelItemArray{
    
    if (!_modelItemArray) _modelItemArray = [NSMutableArray array];
    
    return _modelItemArray;
}

- (NSMutableDictionary *)modelItemInsetsInfo{
    
    if (!_modelItemInsetsInfo) _modelItemInsetsInfo = [NSMutableDictionary dictionary];
    
    return _modelItemInsetsInfo;
}

@end

@interface LEEItem ()

@property (nonatomic , copy ) void (^updateBlock)(LEEItem *);

@end

@implementation LEEItem

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface LEEAction ()

@property (nonatomic , copy ) void (^updateBlock)(LEEAction *);

@end

@implementation LEEAction

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface LEEItemView : UIView

@property (nonatomic , strong ) LEEItem *item;

+ (LEEItemView *)view;

@end

@implementation LEEItemView

+ (LEEItemView *)view{
    
    return [[LEEItemView alloc] init];;
}

@end

@interface LEEItemLabel : UILabel

@property (nonatomic , strong ) LEEItem *item;

@property (nonatomic , copy ) void (^textChangedBlock)();

+ (LEEItemLabel *)label;

@end

@implementation LEEItemLabel

+ (LEEItemLabel *)label{
    
    return [[LEEItemLabel alloc] init];
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    
    [super setNumberOfLines:numberOfLines];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

@end

@interface LEEItemTextField : UITextField

@property (nonatomic , strong ) LEEItem *item;

+ (LEEItemTextField *)textField;

@end

@implementation LEEItemTextField

+ (LEEItemTextField *)textField{
    
    return [[LEEItemTextField alloc] init];
}

@end

@interface LEEActionButton : UIButton

@property (nonatomic , strong ) LEEAction *action;

@property (nonatomic , copy ) void (^heightChangedBlock)();

+ (LEEActionButton *)button;

@end

@interface LEEActionButton ()

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation LEEActionButton

+ (LEEActionButton *)button{
    
    return [LEEActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(LEEAction *)action{
    
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.borderColor) [self setBorderColor:action.borderColor];
    
    if (action.borderWidth) [self setBorderWidth:action.borderWidth < 0.35f ? 0.35f : action.borderWidth];
    
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    if (action.height) [self setHeight:action.height];
    
    if (action.cornerRadius) [self.layer setCornerRadius:action.cornerRadius];
    
    [self setImageEdgeInsets:action.imageEdgeInsets];
    
    [self setTitleEdgeInsets:action.titleEdgeInsets];
    
    if (action.borderPosition & LEEActionBorderPositionTop &&
        action.borderPosition & LEEActionBorderPositionBottom &&
        action.borderPosition & LEEActionBorderPositionLeft &&
        action.borderPosition & LEEActionBorderPositionRight) {
        
        self.layer.borderWidth = action.borderWidth;
        
        self.layer.borderColor = action.borderColor.CGColor;
        
        [self removeTopBorder];
        
        [self removeBottomBorder];
        
        [self removeLeftBorder];
        
        [self removeRightBorder];
    
    } else {
        
        self.layer.borderWidth = 0.0f;
     
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (action.borderPosition & LEEActionBorderPositionTop) [self addTopBorder]; else [self removeTopBorder];
        
        if (action.borderPosition & LEEActionBorderPositionBottom) [self addBottomBorder]; else [self removeBottomBorder];
        
        if (action.borderPosition & LEEActionBorderPositionLeft) [self addLeftBorder]; else [self removeLeftBorder];
        
        if (action.borderPosition & LEEActionBorderPositionRight) [self addRightBorder]; else [self removeRightBorder];
    }
    
    __weak typeof(self) weakSelf = self;
    
    action.updateBlock = ^(LEEAction *act) {
        
        if (weakSelf) weakSelf.action = act;
    };
    
}

- (CGFloat)height{
    
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    
    BOOL isChange = [self height] == height ? NO : YES;
    
    CGRect buttonFrame = self.frame;
    
    buttonFrame.size.height = height;
    
    self.frame = buttonFrame;
    
    if (isChange) {
        
        if (self.heightChangedBlock) self.heightChangedBlock();
    }
    
}

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

- (void)removeTopBorder{
    
    if (_topLayer) [_topLayer removeFromSuperlayer]; _topLayer = nil;
}

- (void)removeBottomBorder{
    
    if (_bottomLayer) [_bottomLayer removeFromSuperlayer]; _bottomLayer = nil;
}

- (void)removeLeftBorder{
    
    if (_leftLayer) [_leftLayer removeFromSuperlayer]; _leftLayer = nil;
}

- (void)removeRightBorder{
    
    if (_rightLayer) [_rightLayer removeFromSuperlayer]; _rightLayer = nil;
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

@end

@interface LEECustomView ()

@property (nonatomic , strong ) LEEItem *item;

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangedBlock)();

@end

@implementation LEECustomView

- (void)dealloc{
    
    if (_view) [_view removeObserver:self forKeyPath:@"frame"];
}

- (void)setSizeChangedBlock:(void (^)())sizeChangedBlock{
    
    _sizeChangedBlock = sizeChangedBlock;
    
    if (_view) {
        
        [_view layoutSubviews];
        
        _size = _view.frame.size;
        
        [_view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *view = (UIView *)object;
    
    if (!CGSizeEqualToSize(self.size, view.frame.size)) {
        
        self.size = view.frame.size;
        
        if (self.sizeChangedBlock) self.sizeChangedBlock();
    }
    
}

@end

@interface UIView (LEEShadowViewHandle)

@end

@implementation UIView (LEEShadowViewHandle)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"dealloc" , @"layoutSubviews" , @"removeFromSuperview" , @"setFrame:" , @"setCenter:" , @"setHidden:" , @"setAlpha:" , @"setTransform:" , @"setBackgroundColor:"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_alert_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            method_exchangeImplementations(originalMethod, leeMethod);
        }];
        
    });
    
}

- (void)lee_alert_dealloc{
    
    if ([self isAddShadow]) {
        
        [self removeShadow];
        
        objc_removeAssociatedObjects(self);
    }
    
    [self lee_alert_dealloc];
}

- (void)lee_alert_layoutSubviews{
    
    if ([self isAddShadow]) [[self shadowView] layoutSubviews];
    
    [self lee_alert_layoutSubviews];
}

- (void)lee_alert_removeFromSuperview{
    
    [self removeShadow];
    
    [self lee_alert_removeFromSuperview];
}

- (void)lee_alert_setFrame:(CGRect)frame{
    
    [self lee_alert_setFrame:frame];
    
    if ([self isAddShadow]) [self shadowView].frame = self.frame;
}

- (void)lee_alert_setCenter:(CGPoint)center{
    
    [self lee_alert_setCenter:center];
    
    if ([self isAddShadow]) [self shadowView].center = center;
}

- (void)lee_alert_setHidden:(BOOL)hidden{
    
    [self lee_alert_setHidden:hidden];
    
    if ([self isAddShadow]) [self shadowView].hidden = hidden;
}

- (void)lee_alert_setAlpha:(CGFloat)alpha{
    
    [self lee_alert_setAlpha:alpha];
    
    if ([self isAddShadow]) [self shadowView].alpha = alpha;
}

- (void)lee_alert_setTransform:(CGAffineTransform)transform{
    
    [self lee_alert_setTransform:transform];
    
    if ([self isAddShadow]) [self shadowView].transform = transform;
}

- (void)lee_alert_setBackgroundColor:(UIColor *)backgroundColor{
    
    [self lee_alert_setBackgroundColor:backgroundColor];
    
    if ([self isAddShadow]) [self shadowView].backgroundColor = backgroundColor;
}

- (void)cornerRadius:(CGFloat)cornerRadius{
    
    self.layer.cornerRadius = cornerRadius;

    if ([self isAddShadow]) [self shadowView].layer.cornerRadius = cornerRadius;
}

- (void)addShadowWithShadowOpacity:(CGFloat)shadowOpacity{
    
    if (self.superview) {
        
        if (![self shadowView]) {
            
            UIView *shadowView = [[UIView alloc] initWithFrame:self.frame];
            
            shadowView.backgroundColor = self.backgroundColor;
            
            shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
            
            shadowView.layer.shadowRadius = 5;
            
            shadowView.layer.shadowOffset = CGSizeMake(0, 2);
            
            shadowView.layer.shadowOpacity = shadowOpacity;
         
            [self.superview insertSubview:shadowView belowSubview:self];
            
            objc_setAssociatedObject(self, @selector(shadowView), shadowView , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        [self setIsAddShadow:YES];
    }
    
}

- (void)removeShadow{
    
    if ([self isAddShadow]) {
    
        [[self shadowView] removeFromSuperview];
    }
    
}

- (UIView *)shadowView{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)isAddShadow{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAddShadow:(BOOL)isAddShadow{
    
    objc_setAssociatedObject(self, @selector(isAddShadow), @(isAddShadow) , OBJC_ASSOCIATION_ASSIGN);
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
    
    self.orientationType = VIEW_HEIGHT > VIEW_WIDTH ? LEEScreenOrientationTypeVertical : LEEScreenOrientationTypeHorizontal;
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (self.backgroundVisualEffectView) self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.orientationType = size.height > size.width ? LEEScreenOrientationTypeVertical : LEEScreenOrientationTypeHorizontal;
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

@end

#pragma mark - Alert

@interface LEEAlertViewController ()

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <LEEActionButton *>*alertActionArray;

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
    
    [self updateAlertLayout];
    
    [UIView commitAnimations];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self updateAlertLayoutWithViewWidth:size.width ViewHeight:size.height];
}

- (void)updateAlertLayout{
    
    [self updateAlertLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
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
            
            alertViewFrame.origin.x = (viewWidth - alertViewFrame.size.width) * 0.5f;
            
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
        
        alertViewFrame.origin.x = (viewWidth - alertViewMaxWidth) * 0.5f;
        
        alertViewFrame.origin.y = (viewHeight - alertViewFrame.size.height) / 2;
        
        self.alertView.frame = alertViewFrame;
    }
    
}

- (void)updateAlertItemsLayout{
    
    alertViewHeight = 0.0f;
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx == 0) alertViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            LEEItemView *view = (LEEItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left;
            
            viewFrame.origin.y = alertViewHeight + view.item.insets.top;
            
            viewFrame.size.width = alertViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            alertViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:LEECustomView.class]) {
            
            LEECustomView *custom = (LEECustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = LEECustomViewPositionTypeCenter;
                
                viewFrame.size.width = alertViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                
                case LEECustomViewPositionTypeCenter:
                   
                    viewFrame.origin.x = (alertViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case LEECustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case LEECustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = alertViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = alertViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            alertViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) alertViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (LEEActionButton *button in self.alertActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = alertViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = alertViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    if (self.alertActionArray.count == 2) {
        
        LEEActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;
        
        LEEActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;
        
        UIEdgeInsets buttonAInsets = buttonA.action.insets;
        
        UIEdgeInsets buttonBInsets = buttonB.action.insets;
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;
        
        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);
        
        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (alertViewMaxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);
        
        buttonB.frame = CGRectMake((alertViewMaxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (alertViewMaxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);
        
        alertViewHeight -= minHeight;
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewMaxWidth, alertViewHeight);
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview: self.alertView];
    
    [self.alertView addShadowWithShadowOpacity:self.config.modelShadowOpacity];
    
    [self.alertView cornerRadius:self.config.modelCornerRadius];
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        void (^itemBlock)(LEEItem *) = obj;
        
        LEEItem *item = [[LEEItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case LEEItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                LEEItemLabel *label = [LEEItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case LEEItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                LEEItemLabel *label = [LEEItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                  
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case LEEItemTypeCustomView:
            {
                void(^block)(LEECustomView *) = item.block;
                
                LEECustomView *custom = [[LEECustomView alloc] init];
                
                block(custom);
                
                [self.alertView addSubview:custom.view];
                
                [self.alertItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case LEEItemTypeTextField:
            {
                LEEItemTextField *textField = [LEEItemTextField textField];
                
                textField.frame = CGRectMake(0, 0, 0, 40.0f);
                
                [self.alertView addSubview:textField];
                
                [self.alertItemArray addObject:textField];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                void(^block)(UITextField *textField) = item.block;
                
                if (block) block(textField);
                
                textField.item = item;
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = 0.35f;
        
        if (!action.borderPosition) action.borderPosition = (self.config.modelActionArray.count == 2 && idx == 0) ? LEEActionBorderPositionTop | LEEActionBorderPositionRight : LEEActionBorderPositionTop;
        
        if (!action.height) action.height = 45.0f;
        
        LEEActionButton *button = [LEEActionButton button];
        
        button.action = action;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        [self.alertActionArray addObject:button];
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateAlertLayout];
        };
        
    }];
    
    // 更新布局
    
    [self updateAlertLayout];
    
    [self showAnimationsWithCompletionBlock:^{
    
        if (weakSelf) {
            
            [weakSelf configNotification];
            
            [weakSelf updateAlertLayout];
        }
        
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)() = nil;
    
    for (LEEActionButton *button in self.alertActionArray) {
        
        if (button == sender) {
        
            switch (button.action.type) {
                
                case LEEActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
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
            
            clickBlock = button.action.clickBlock;
            
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
        
        _alertView.backgroundColor = self.config.modelHeaderColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.bounces = NO;
    }
    
    return _alertView;
}

- (NSMutableArray *)alertItemArray{
    
    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];
    
    return _alertItemArray;
}

- (NSMutableArray <LEEActionButton *>*)alertActionArray{
    
    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];
    
    return _alertActionArray;
}

@end

#pragma mark - ActionSheet

@interface LEEActionSheetViewController ()

@property (nonatomic , strong ) UIScrollView *actionSheetView;

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <LEEActionButton *>*actionSheetActionArray;

@property (nonatomic , strong ) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic , strong ) LEEActionButton *actionSheetCancelAction;

@end

@implementation LEEActionSheetViewController
{
    BOOL isShowed;
}

- (void)dealloc{
    
    _actionSheetView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)configNotification{
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self updateActionSheetLayoutWithViewWidth:size.width ViewHeight:size.height];
}

- (void)updateActionSheetLayout{
    
    [self updateActionSheetLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    
    __block CGFloat actionSheetViewHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            LEEItemView *view = (LEEItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left;
            
            viewFrame.origin.y = actionSheetViewHeight + view.item.insets.top;
            
            viewFrame.size.width = actionSheetViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            actionSheetViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:LEECustomView.class]) {
            
            LEECustomView *custom = (LEECustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = LEECustomViewPositionTypeCenter;
                
                viewFrame.size.width = actionSheetViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case LEECustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case LEECustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case LEECustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = actionSheetViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (LEEActionButton *button in self.actionSheetActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = actionSheetViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = actionSheetViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    self.actionSheetView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);
    
    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.height + self.config.modelActionSheetCancelActionSpaceWidth : 0.0f;
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight - cancelActionTotalHeight ? actionSheetViewMaxHeight - cancelActionTotalHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
    
    if (isShowed) {
        
        CGFloat actionSheetTotalHeight = actionSheetViewFrame.size.height + cancelActionTotalHeight;
        
        actionSheetViewFrame.origin.y = (viewHeight - actionSheetTotalHeight) - self.config.modelActionSheetBottomMargin;
        
    } else {
        
        actionSheetViewFrame.origin.y = viewHeight;
    }
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;
        
        spaceFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
        
        spaceFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height;
        
        spaceFrame.size.width = actionSheetViewMaxWidth;
        
        spaceFrame.size.height = self.config.modelActionSheetCancelActionSpaceWidth;
        
        self.actionSheetCancelActionSpaceView.frame = spaceFrame;
        
        CGRect buttonFrame = self.actionSheetCancelAction.frame;
        
        buttonFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
        
        buttonFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height + spaceFrame.size.height;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        self.actionSheetCancelAction.frame = buttonFrame;
    }
    
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview: self.actionSheetView];
    
    [self.actionSheetView addShadowWithShadowOpacity:self.config.modelShadowOpacity];
    
    [self.actionSheetView cornerRadius:self.config.modelCornerRadius];
    
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        void (^itemBlock)(LEEItem *) = obj;
        
        LEEItem *item = [[LEEItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case LEEItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                LEEItemLabel *label = [LEEItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case LEEItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                LEEItemLabel *label = [LEEItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case LEEItemTypeCustomView:
            {
                void(^block)(LEECustomView *) = item.block;
                
                LEECustomView *custom = [[LEECustomView alloc] init];
                
                block(custom);
                
                [self.actionSheetView addSubview:custom.view];
                
                [self.actionSheetItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
            default:
                break;
        }
        
    }];
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = 0.35f;
        
        if (!action.height) action.height = 57.0f;
        
        LEEActionButton *button = [LEEActionButton button];
        
        button.action = action;
        
        switch (action.type) {
                
            case LEEActionTypeCancel:
            {
                [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                button.backgroundColor = action.backgroundColor;
                
                [self.view addSubview:button];
                
                [button addShadowWithShadowOpacity:self.config.modelShadowOpacity];
                
                [button cornerRadius:self.config.modelCornerRadius];
                
                self.actionSheetCancelAction = button;
                
                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];
                
                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
                
                [self.view addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;
                
            default:
            {
                if (!action.borderPosition) action.borderPosition = LEEActionBorderPositionTop;
                
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetView addSubview:button];
                
                [self.actionSheetActionArray addObject:button];
            }
                break;
        }
        
        button.heightChangedBlock = ^{
          
            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }
    
    // 更新布局
    
    [self updateActionSheetLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) {
            
            [weakSelf configNotification];
            
            [weakSelf updateActionSheetLayout];
        }
        
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)() = nil;
    
    for (LEEActionButton *button in self.actionSheetActionArray) {
        
        if (button == sender) {
            
            switch (button.action.type) {
                    
                case LEEActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
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
            
            clickBlock = button.action.clickBlock;
            
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
    
    void (^clickBlock)() = self.actionSheetCancelAction.action.clickBlock;
    
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
         
         [weakSelf updateActionSheetLayout];
      
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
        
        [self updateActionSheetLayout];
        
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
        
        _actionSheetView.backgroundColor = self.config.modelHeaderColor;
        
        _actionSheetView.directionalLockEnabled = YES;
        
        _actionSheetView.bounces = NO;
    }
    
    return _actionSheetView;
}

- (NSMutableArray <id>*)actionSheetItemArray{
    
    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];
    
    return _actionSheetItemArray;
}

- (NSMutableArray <LEEActionButton *>*)actionSheetActionArray{
    
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
