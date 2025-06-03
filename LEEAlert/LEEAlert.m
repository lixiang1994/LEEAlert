/*
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
 *  @copyright    Copyright © 2016 - 2024年 lee. All rights reserved.
 *  @version    V1.8.0
 */

#import "LEEAlert.h"

#import <Accelerate/Accelerate.h>

#import <objc/runtime.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define VIEW_WIDTH CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)
#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

NS_INLINE void lee_cleanupFunc(__strong dispatch_block_t *block) {
    (*block)();
}

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, LEEBackgroundStyle) {
    /** 背景样式 模糊 */
    LEEBackgroundStyleBlur,
    /** 背景样式 半透明 */
    LEEBackgroundStyleTranslucent,
};

@interface LEEBaseConfigModel ()

@property (nonatomic, strong) NSMutableArray *modelActionArray;
@property (nonatomic, strong) NSMutableArray *modelItemArray;
@property (nonatomic, strong) NSMutableDictionary *modelItemInsetsInfo;

@property (nonatomic, assign) CGFloat modelShadowOpacity;
@property (nonatomic, assign) CGFloat modelShadowRadius;
@property (nonatomic, assign) CGFloat modelOpenAnimationDuration;
@property (nonatomic, assign) CGFloat modelCloseAnimationDuration;
@property (nonatomic, assign) CGFloat modelBackgroundStyleColorAlpha;
@property (nonatomic, assign) NSInteger modelQueuePriority;

@property (nonatomic, assign) UIColor *modelShadowColor;
@property (nonatomic, strong) UIColor *modelHeaderColor;
@property (nonatomic, strong) UIColor *modelBackgroundColor;

@property (nonatomic, assign) BOOL modelIsClickHeaderClose;
@property (nonatomic, assign) BOOL modelIsClickBackgroundClose;
@property (nonatomic, assign) BOOL modelIsShouldAutorotate;
@property (nonatomic, assign) BOOL modelIsQueue;
@property (nonatomic, assign) BOOL modelIsContinueQueueDisplay;
@property (nonatomic, assign) BOOL modelIsAvoidKeyboard;
@property (nonatomic, assign) BOOL modelIsAlertActionVerticalLayout;
@property (nonatomic, assign) BOOL modelIsScrollEnabled;
@property (nonatomic, assign) BOOL modelIsShowsScrollIndicator;

@property (nonatomic, assign) BOOL modelIsActionFollowScrollEnabled;

@property (nonatomic, assign) CGSize modelShadowOffset;
@property (nonatomic, assign) CGPoint modelAlertCenterOffset;
@property (nonatomic, assign) UIEdgeInsets modelHeaderInsets;

@property (nonatomic, copy) NSString *modelIdentifier;

@property (nonatomic, copy) CGFloat (^modelMaxWidthBlock)(LEEScreenOrientationType, CGSize);
@property (nonatomic, copy) CGFloat (^modelMaxHeightBlock)(LEEScreenOrientationType, CGSize);

@property (nonatomic, copy) void(^modelOpenAnimationConfigBlock)(void (^animatingBlock)(void), void (^animatedBlock)(void));
@property (nonatomic, copy) void(^modelCloseAnimationConfigBlock)(void (^animatingBlock)(void), void (^animatedBlock)(void));
@property (nonatomic, copy) void (^modelFinishConfig)(void);
@property (nonatomic, copy) BOOL (^modelShouldClose)(void);
@property (nonatomic, copy) BOOL (^modelShouldActionClickClose)(NSInteger);
@property (nonatomic, copy) void (^modelCloseComplete)(void);

@property (nonatomic, assign) LEEBackgroundStyle modelBackgroundStyle;
@property (nonatomic, assign) LEEAnimationStyle modelOpenAnimationStyle;
@property (nonatomic, assign) LEEAnimationStyle modelCloseAnimationStyle;

@property (nonatomic, assign) UIStatusBarStyle modelStatusBarStyle;
@property (nonatomic, assign) UIBlurEffectStyle modelBackgroundBlurEffectStyle;
@property (nonatomic, assign) UIInterfaceOrientationMask modelSupportedInterfaceOrientations;
@property (nonatomic, assign) UIUserInterfaceStyle modelUserInterfaceStyle API_AVAILABLE(ios(13.0), tvos(13.0));

@property (nonatomic, assign) CornerRadii modelCornerRadii;
@property (nonatomic, assign) CornerRadii modelActionSheetHeaderCornerRadii;
@property (nonatomic, assign) CornerRadii modelActionSheetCancelActionCornerRadii;

@property (nonatomic, strong) UIColor *modelActionSheetBackgroundColor;
@property (nonatomic, strong) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic, assign) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic, assign) CGFloat modelActionSheetBottomMargin;

@property (nonatomic, strong) LEEPresentation* modelPresentation;

@end

@implementation LEEBaseConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemArray = nil;
    _modelItemInsetsInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        _modelShadowOpacity = 0.3f; //默认阴影不透明度
        _modelShadowRadius = 5.0f; //默认阴影半径
        _modelShadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
        
        
        _modelActionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
        if (@available(iOS 13.0, *)) {
            _modelHeaderColor = [UIColor tertiarySystemBackgroundColor]; //默认颜色
            
        } else {
            _modelHeaderColor = [UIColor whiteColor]; //默认颜色
        }
        _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsShouldAutorotate = YES; //默认支持自动旋转
        _modelIsQueue = NO; //默认不加入队列
        _modelIsContinueQueueDisplay = YES; //默认继续队列显示
        _modelIsAvoidKeyboard = YES; //默认闪避键盘
        _modelIsAlertActionVerticalLayout = NO; //默认2个Action时水平布局
        _modelIsScrollEnabled = YES; //默认可以滑动
        _modelIsShowsScrollIndicator = YES; //默认显示滑动指示器
        
        _modelIsActionFollowScrollEnabled = YES; //默认 Action 跟随 Item 滚动
        
        _modelBackgroundStyle = LEEBackgroundStyleTranslucent; //默认为半透明背景样式
        _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
        _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
        
        _modelCornerRadii = CornerRadiiMake(13.0f, 13.0f, 13.0f, 13.0f); //默认圆角半径
        _modelActionSheetHeaderCornerRadii = CornerRadiiMake(13.0f, 13.0f, 13.0f, 13.0f); //默认圆角半径
        _modelActionSheetCancelActionCornerRadii = CornerRadiiMake(13.0f, 13.0f, 13.0f, 13.0f); //默认圆角半径
        
        
        if (@available(iOS 13.0, *)) {
            _modelUserInterfaceStyle = UIUserInterfaceStyleUnspecified; //默认支持全部样式
        }
        
        __weak typeof(self) weakSelf = self;
        
        _modelOpenAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelOpenAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelCloseAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelCloseAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelShouldClose = ^{
            return YES;
        };
        
        _modelShouldActionClickClose = ^(NSInteger index){
            return YES;
        };
        
        _modelPresentation = [LEEPresentation windowLevel:UIWindowLevelAlert];
    }
    return self;
}

- (LEEConfigToString)LeeTitle{
    
    return ^(NSString *str){
        
        return self.LeeAddTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (LEEConfigToString)LeeContent{
    
    return ^(NSString *str){
        
        return  self.LeeAddContent(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}

- (LEEConfigToView)LeeCustomView{
    
    return ^(UIView *view){
        
        return self.LeeAddCustomView(^(LEECustomView *custom) {
            
            custom.view = view;
        });
        
    };
    
}

- (LEEConfigToStringAndBlock)LeeAction{
    
    return ^(NSString *title, void(^block)(void)){
        
        return self.LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            
            action.title = title;
            
            action.clickBlock = block;
        });
        
    };
    
}

- (LEEConfigToStringAndBlock)LeeCancelAction{
    
    return ^(NSString *title, void(^block)(void)){
        
        return self.LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            
            action.title = title;
            
            action.font = [UIFont boldSystemFontOfSize:18.0f];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (LEEConfigToStringAndBlock)LeeDestructiveAction{
    
    return ^(NSString *title, void(^block)(void)){
        
        return self.LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDestructive;
            
            action.title = title;
            
            action.titleColor = [UIColor systemRedColor];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (LEEConfigToConfigLabel)LeeAddTitle{
    
    return ^(void(^block)(UILabel *)){
        
        return self.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeTitle;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (LEEConfigToConfigLabel)LeeAddContent{
    
    return ^(void(^block)(UILabel *)){
        
        return self.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeContent;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (LEEConfigToCustomView)LeeAddCustomView{
    
    return ^(void(^block)(LEECustomView *custom)){
        
        return self.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeCustomView;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (LEEConfigToItem)LeeAddItem{
    
    return ^(void(^block)(LEEItem *)){
        
        if (block) [self.modelItemArray addObject:block];
        
        return self;
    };
    
}

- (LEEConfigToAction)LeeAddAction{
    
    return ^(void(^block)(LEEAction *)){
        
        if (block) [self.modelActionArray addObject:block];
        
        return self;
    };
    
}

- (LEEConfigToEdgeInsets)LeeHeaderInsets{
    
    return ^(UIEdgeInsets insets){
        
        if (insets.top < 0) insets.top = 0;
        
        if (insets.left < 0) insets.left = 0;
        
        if (insets.bottom < 0) insets.bottom = 0;
        
        if (insets.right < 0) insets.right = 0;
        
        self.modelHeaderInsets = insets;
        
        return self;
    };
    
}

- (LEEConfigToEdgeInsets)LeeItemInsets{
    
    return ^(UIEdgeInsets insets){
        
        if (self.modelItemArray.count) {
            
            if (insets.top < 0) insets.top = 0;
            
            if (insets.left < 0) insets.left = 0;
            
            if (insets.bottom < 0) insets.bottom = 0;
            
            if (insets.right < 0) insets.right = 0;
            
            [self.modelItemInsetsInfo setObject: [NSValue valueWithUIEdgeInsets:insets]
                                         forKey:@(self.modelItemArray.count - 1)];
            
        } else {
            
            NSAssert(YES, @"请在添加的某一项后面设置间距");
        }
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeMaxWidth{
    
    return ^(CGFloat number){
        
        return self.LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            
            return number;
        });
        
    };
    
}

- (LEEConfigToFloat)LeeMaxHeight{
    
    return ^(CGFloat number){
        
        return self.LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            
            return number;
        });
        
    };
    
}

- (LEEConfigToReturnMaxSize)LeeConfigMaxWidth{
    
    return ^(CGFloat(^block)(LEEScreenOrientationType type, CGSize size)){
        
        if (block) self.modelMaxWidthBlock = block;
        
        return self;
    };
    
}

- (LEEConfigToReturnMaxSize)LeeConfigMaxHeight{
    
    return ^(CGFloat(^block)(LEEScreenOrientationType type, CGSize size)){
        
        if (block) self.modelMaxHeightBlock = block;
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeCornerRadius{
    
    return ^(CGFloat number){
        
        self.modelCornerRadii = CornerRadiiMake(number, number, number, number);
        
        return self;
    };
    
}

- (LEEConfigToCornerRadii)LeeCornerRadii{
    
    return ^(CornerRadii radii){
        
        self.modelCornerRadii = radii;
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeOpenAnimationDuration{
    
    return ^(CGFloat number){
        
        self.modelOpenAnimationDuration = number;
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeCloseAnimationDuration{
    
    return ^(CGFloat number){
        
        self.modelCloseAnimationDuration = number;
        
        return self;
    };
    
}

- (LEEConfigToColor)LeeHeaderColor{
    
    return ^(UIColor *color){
        
        self.modelHeaderColor = color;
        
        return self;
    };
    
}

- (LEEConfigToColor)LeeBackGroundColor{
    
    return ^(UIColor *color){
        
        self.modelBackgroundColor = color;
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeBackgroundStyleTranslucent{
    
    return ^(CGFloat number){
        
        self.modelBackgroundStyle = LEEBackgroundStyleTranslucent;
        
        self.modelBackgroundStyleColorAlpha = number;
        
        return self;
    };
    
}

- (LEEConfigToBlurEffectStyle)LeeBackgroundStyleBlur{
    
    return ^(UIBlurEffectStyle style){
        
        self.modelBackgroundStyle = LEEBackgroundStyleBlur;
        
        self.modelBackgroundBlurEffectStyle = style;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeClickHeaderClose{
    
    return ^(BOOL is){
        
        self.modelIsClickHeaderClose = is;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeClickBackgroundClose{
    
    return ^(BOOL is){
        
        self.modelIsClickBackgroundClose = is;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeIsScrollEnabled{
    
    return ^(BOOL is){
        
        self.modelIsScrollEnabled = is;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeIsShowsScrollIndicator{
    
    return ^(BOOL is){
        
        self.modelIsShowsScrollIndicator = is;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeIsActionFollowScrollEnabled{
    
    return ^(BOOL is){
        
        self.modelIsActionFollowScrollEnabled = is;
        
        return self;
    };
    
}

- (LEEConfigToSize)LeeShadowOffset{
    
    return ^(CGSize size){
        
        self.modelShadowOffset = size;
        
        return self;
    };
}

- (LEEConfigToFloat)LeeShadowOpacity{
    
    return ^(CGFloat number){
        
        self.modelShadowOpacity = number;
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeShadowRadius{
    
    return ^(CGFloat number){
        
        self.modelShadowRadius = number;
        
        return self;
    };
    
}

- (LEEConfigToColor)LeeShadowColor{
    
    return ^(UIColor *color){
        
        self.modelShadowColor = color;
        
        return self;
    };
    
}

- (LEEConfigToString)LeeIdentifier{
    
    return ^(NSString *string){
        
        self.modelIdentifier = string;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeQueue{
    
    return ^(BOOL is){
        
        self.modelIsQueue = is;
        
        return self;
    };
    
}

- (LEEConfigToInteger)LeePriority{
    
    return ^(NSInteger number){
        
        self.modelQueuePriority = number > 0 ? number : 0;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeContinueQueueDisplay{
    
    return ^(BOOL is){
        
        self.modelIsContinueQueueDisplay = is;
        
        return self;
    };
    
}

- (LEEConfigToPresentation)LeePresentation{
    
    return ^(LEEPresentation *presentation){
        
        self.modelPresentation = presentation;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeShouldAutorotate{
    
    return ^(BOOL is){
        
        self.modelIsShouldAutorotate = is;
        
        return self;
    };
    
}

- (LEEConfigToInterfaceOrientationMask)LeeSupportedInterfaceOrientations{
    
    return ^(UIInterfaceOrientationMask mask){
        
        self.modelSupportedInterfaceOrientations = mask;
        
        return self;
    };
    
}

- (LEEConfigToBlockAndBlock)LeeOpenAnimationConfig{
    
    return ^(void(^block)(void (^animatingBlock)(void), void (^animatedBlock)(void))){
        
        self.modelOpenAnimationConfigBlock = block;
        
        return self;
    };
    
}

- (LEEConfigToBlockAndBlock)LeeCloseAnimationConfig{
    
    return ^(void(^block)(void (^animatingBlock)(void), void (^animatedBlock)(void))){
        
        self.modelCloseAnimationConfigBlock = block;
        
        return self;
    };
    
}

- (LEEConfigToAnimationStyle)LeeOpenAnimationStyle{
    
    return ^(LEEAnimationStyle style){
        
        self.modelOpenAnimationStyle = style;
        
        return self;
    };
    
}

- (LEEConfigToAnimationStyle)LeeCloseAnimationStyle{
    
    return ^(LEEAnimationStyle style){
        
        self.modelCloseAnimationStyle = style;
        
        return self;
    };
    
}

- (LEEConfigToStatusBarStyle)LeeStatusBarStyle{
    
    return ^(UIStatusBarStyle style){
        
        self.modelStatusBarStyle = style;
        
        return self;
    };
    
}

- (LEEConfigToUserInterfaceStyle)LeeUserInterfaceStyle {
    
    return ^(UIUserInterfaceStyle style){
        
        self.modelUserInterfaceStyle = style;
        
        return self;
    };
}


- (LEEConfig)LeeShow{
    
    return ^{
        
        if (self.modelFinishConfig) self.modelFinishConfig();
        
        return self;
    };
    
}

- (LEEConfigToBlockReturnBool)leeShouldClose{
    
    return ^(BOOL (^block)(void)){
        
        self.modelShouldClose = block;
        
        return self;
    };
    
}

- (LEEConfigToBlockIntegerReturnBool)leeShouldActionClickClose{
    
    return ^(BOOL (^block)(NSInteger index)){
        
        self.modelShouldActionClickClose = block;
        
        return self;
    };
    
}

- (LEEConfigToBlock)LeeCloseComplete{
    
    return ^(void (^block)(void)){
        
        self.modelCloseComplete = block;
        
        return self;
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

@implementation LEEBaseConfigModel (Alert)

- (LEEConfigToConfigTextField)LeeAddTextField{
    
    return ^(void (^block)(UITextField *)){
        
        return self.LeeAddItem(^(LEEItem *item) {
            
            item.type = LEEItemTypeTextField;
            
            item.insets = UIEdgeInsetsMake(10, 0, 10, 0);
            
            item.block = block;
        });
        
    };
    
}

- (LEEConfigToPoint)LeeAlertCenterOffset {
    
    return ^(CGPoint offset){
        
        self.modelAlertCenterOffset = offset;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeAvoidKeyboard{
    
    return ^(BOOL is){
        
        self.modelIsAvoidKeyboard = is;
        
        return self;
    };
    
}

- (LEEConfigToBool)LeeAlertActionVerticalLayout{
    
    return ^(BOOL is){
        
        self.modelIsAlertActionVerticalLayout = is;
        
        return self;
    };
    
}

@end

@implementation LEEBaseConfigModel (ActionSheet)

- (LEEConfigToFloat)LeeActionSheetCancelActionSpaceWidth{
    
    return ^(CGFloat number){
        
        self.modelActionSheetCancelActionSpaceWidth = number;
        
        return self;
    };
    
}

- (LEEConfigToColor)LeeActionSheetCancelActionSpaceColor{
    
    return ^(UIColor *color){
        
        self.modelActionSheetCancelActionSpaceColor = color;
        
        return self;
    };
    
}

- (LEEConfigToFloat)LeeActionSheetBottomMargin{
    
    return ^(CGFloat number){
        
        self.modelActionSheetBottomMargin = number;
        
        return self;
    };
    
}

- (LEEConfigToColor)LeeActionSheetBackgroundColor{
    
    return ^(UIColor *color){
        
        self.modelActionSheetBackgroundColor = color;
        
        return self;
    };
    
}

- (LEEConfigToCornerRadii)LeeActionSheetHeaderCornerRadii{
    
    return ^(CornerRadii radii){
        
        self.modelActionSheetHeaderCornerRadii = radii;
        
        return self;
    };
    
}

- (LEEConfigToCornerRadii)LeeActionSheetCancelActionCornerRadii{
    
    return ^(CornerRadii radii){
        
        self.modelActionSheetCancelActionCornerRadii = radii;
        
        return self;
    };
    
}

@end

@interface LEEAlert ()

@property (nonatomic, strong) UIWindow *mainWindow;

@property (nonatomic, strong) LEEAlertWindow *leeWindow;

@property (nonatomic, strong) NSMutableArray <LEEBaseConfig *>*queueArray;

@property (nonatomic, strong) LEEBaseViewController *viewController;

@end

@protocol LEEAlertProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

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
    
    return [[LEEAlertConfig alloc] init];
}

+ (LEEActionSheetConfig *)actionsheet{
    
    return [[LEEActionSheetConfig alloc] init];
}

+ (LEEAlertWindow *)getAlertWindow{
    
    return [LEEAlert shareManager].leeWindow;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [LEEAlert shareManager].mainWindow = window;
}

+ (void)continueQueueDisplay{
    
    if ([LEEAlert shareManager].queueArray.count) [LEEAlert shareManager].queueArray.lastObject.config.modelFinishConfig();
}

+ (void)clearQueue{
    if ([self isQueueEmpty]) return;
    
    LEEBaseConfig * _Nullable last = [LEEAlert shareManager].queueArray.lastObject;
    
    [[LEEAlert shareManager].queueArray removeAllObjects];
    
    if ([last respondsToSelector:@selector(close)]) [last performSelector:@selector(close)];
}

+ (BOOL)isQueueEmpty{
    
    return [LEEAlert shareManager].queueArray.count == 0;
}

+ (BOOL)containsQueueWithIdentifier:(NSString *)identifier {
    
    for (LEEBaseConfig *config in [LEEAlert shareManager].queueArray) {
        if ([config.config.modelIdentifier isEqualToString:identifier]) return YES;
    }
    
    return NO;
}

+ (void)closeWithIdentifier:(NSString *)identifier completionBlock:(void (^ _Nullable)(void))completionBlock{
    
    [self closeWithIdentifier:identifier force:NO completionBlock:completionBlock];
}

+ (void)closeWithIdentifier:(NSString *)identifier force:(BOOL)force completionBlock:(void (^)(void))completionBlock{
    
    if ([LEEAlert shareManager].queueArray.count) {
        
        BOOL isLast = false;
        
        NSUInteger count = [LEEAlert shareManager].queueArray.count;
        
        NSMutableIndexSet *indexs = [[NSMutableIndexSet alloc] init];
        
        for (NSUInteger i = 0; i < count; i++) {
            
            LEEBaseConfig *config = [LEEAlert shareManager].queueArray[i];
            
            LEEBaseConfigModel *model = config.config;
            
            if (model.modelIdentifier != nil && [identifier isEqualToString: model.modelIdentifier]) {
                
                if (i == count - 1 && [[LEEAlert shareManager] viewController]) {
                    if (force) {
                        model.modelShouldClose = ^{ return YES; };
                    }
                    
                    isLast = true;
                    
                } else {
                    
                    [indexs addIndex:i];
                }
            }
        }
        
        [[LEEAlert shareManager].queueArray removeObjectsAtIndexes:indexs];
        
        if (isLast) {
        
            [LEEAlert closeWithCompletionBlock:completionBlock];
        
        } else {
            
            if (completionBlock) completionBlock();
        }
        
    } else {
        
        if (completionBlock) completionBlock();
    }
}

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([LEEAlert shareManager].queueArray.count) {
        
        LEEBaseConfig *item = [LEEAlert shareManager].queueArray.lastObject;
        
        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
        
    } else {
        
        if (completionBlock) completionBlock();
    }
}

#pragma mark LazyLoading

- (void)setMainWindow:(UIWindow *)mainWindow {
    _mainWindow = mainWindow;
    
    if (@available(iOS 13.0, *)) {
     
        if (mainWindow.windowScene && _leeWindow) {
            
            _leeWindow.windowScene = mainWindow.windowScene;
        }
    }
}

- (NSMutableArray <LEEBaseConfig *>*)queueArray{
    
    if (!_queueArray) _queueArray = [NSMutableArray array];
    
    return _queueArray;
}

- (LEEAlertWindow *)leeWindow{
    
    if (!_leeWindow) {
        
        if (@available(iOS 13.0, *)) {
            
            if (_mainWindow.windowScene) {
                
                _leeWindow = [[LEEAlertWindow alloc] initWithWindowScene: _mainWindow.windowScene];
                
            } else {
                _leeWindow = [[LEEAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            }
            
        } else {
            _leeWindow = [[LEEAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        
        _leeWindow.rootViewController = [[UIViewController alloc] init];
        
        _leeWindow.backgroundColor = [UIColor clearColor];
        
        _leeWindow.windowLevel = UIWindowLevelAlert;
        
        _leeWindow.hidden = YES;
    }
    
    return _leeWindow;
}

@end

@interface UIView (LEEAlertExtension)

@property (nonatomic, assign) CornerRadii lee_alert_cornerRadii;

@end

@implementation UIView (LEEAlertExtension)

CornerRadii CornerRadiiMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    return (CornerRadii){
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
    };
}

CornerRadii CornerRadiiZero(void) {
    return (CornerRadii){0, 0, 0, 0};
}

CornerRadii CornerRadiiNull(void) {
    return (CornerRadii){-1, -1, -1, -1};
}

BOOL CornerRadiiEqualTo(CornerRadii lhs, CornerRadii rhs) {
    return lhs.topLeft == rhs.topRight
    && lhs.topRight == rhs.topRight
    && lhs.bottomLeft == rhs.bottomLeft
    && lhs.bottomRight == lhs.bottomRight;
}

// 切圆角函数
CGPathRef _Nullable LEECGPathCreateWithRoundedRect(CGRect bounds, CornerRadii cornerRadii) {
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX + cornerRadii.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
    
    const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
    const CGFloat topRightCenterY = minY + cornerRadii.topRight;
    
    const CGFloat bottomLeftCenterX = minX + cornerRadii.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX - cornerRadii.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
    // 虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
    
    CGMutablePathRef path = CGPathCreateMutable();
    // 顶 左
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY, cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
    // 顶 右
    CGPathAddArc(path, NULL, topRightCenterX, topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
    // 底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight, 0, M_PI_2, NO);
    // 底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    return path;
}

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_alert_view_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            BOOL isAddedMethod = class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(leeMethod), method_getTypeEncoding(leeMethod));
            
            if (isAddedMethod) {
                
                class_replaceMethod(self, NSSelectorFromString(leeSelString), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
                
            } else {
                
                method_exchangeImplementations(originalMethod, leeMethod);
            }
            
        }];
        
    });
    
}

- (void)lee_alert_updateCornerRadii{
    
    if (!CornerRadiiEqualTo([self lee_alert_cornerRadii], CornerRadiiNull())) {

        CAShapeLayer *lastLayer = (CAShapeLayer *)self.layer.mask;
        CGPathRef lastPath = CGPathCreateCopy(lastLayer.path);
        CGPathRef path = LEECGPathCreateWithRoundedRect(self.bounds, [self lee_alert_cornerRadii]);

        // 防止相同路径多次设置
        if (!CGPathEqualToPath(lastPath, path)) {
            // 移除原有路径动画
            [lastLayer removeAnimationForKey:@"path"];
            // 重置新路径mask
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = path;
            self.layer.mask = maskLayer;
            // 同步视图大小变更动画
            CAAnimation *temp = [self.layer animationForKey:@"bounds.size"];
            if (temp) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
                animation.duration = temp.duration;
                animation.fillMode = temp.fillMode;
                animation.timingFunction = temp.timingFunction;
                animation.fromValue = (__bridge id _Nullable)(lastPath);
                animation.toValue = (__bridge id _Nullable)(path);
                [maskLayer addAnimation:animation forKey:@"path"];
            }

        }
        
        CGPathRelease(lastPath);
        
        CGPathRelease(path);
    }
}

- (void)lee_alert_view_layoutSubviews{
    
    [self lee_alert_view_layoutSubviews];
    
    [self lee_alert_updateCornerRadii];
}

- (CornerRadii)lee_alert_cornerRadii{
    
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    
    CornerRadii cornerRadii;
    
    if (value) {
        
        [value getValue:&cornerRadii];
    
    } else {
    
        cornerRadii = CornerRadiiNull();
    }
    
    return cornerRadii;
}

- (void)setLee_alert_cornerRadii:(CornerRadii)cornerRadii{
    
    NSValue *value = [NSValue valueWithBytes:&cornerRadii objCType:@encode(CornerRadii)];
    
    objc_setAssociatedObject(self, @selector(lee_alert_cornerRadii), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface UIButton (LEEAlertExtension)

@end

@implementation UIButton (LEEAlertExtension)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_alert_button_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            BOOL isAddedMethod = class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(leeMethod), method_getTypeEncoding(leeMethod));
            
            if (isAddedMethod) {
                
                class_replaceMethod(self, NSSelectorFromString(leeSelString), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
                
            } else {
                
                method_exchangeImplementations(originalMethod, leeMethod);
            }
            
        }];
        
    });
    
}

- (void)lee_alert_button_layoutSubviews{
    
    [self lee_alert_button_layoutSubviews];
    
    [self lee_alert_updateCornerRadii];
}

@end

@implementation LEEAlertWindow

@end

@interface LEEItem ()

@property (nonatomic, copy) void (^updateBlock)(LEEItem *);

@end

@implementation LEEItem

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface LEEAction ()

@property (nonatomic, copy) void (^updateBlock)(LEEAction *);

@end

@implementation LEEAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numberOfLines = 1;
        _textAlignment = NSTextAlignmentLeft;
        _adjustsFontSizeToFitWidth = NO;
        _lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return self;
}

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface LEEItemView : UIView

@property (nonatomic, strong) LEEItem *item;

+ (LEEItemView *)view;

@end

@implementation LEEItemView

+ (LEEItemView *)view{
    
    return [[LEEItemView alloc] init];
}

@end

@interface LEEItemLabel : UILabel

@property (nonatomic, strong) LEEItem *item;

@property (nonatomic, copy) void (^textChangedBlock)(void);

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

@property (nonatomic, strong) LEEItem *item;

+ (LEEItemTextField *)textField;

@end

@implementation LEEItemTextField

+ (LEEItemTextField *)textField{
    
    return [[LEEItemTextField alloc] init];
}

@end

@interface LEEActionButton : UIButton

@property (nonatomic, strong) LEEAction *action;

@property (nonatomic, copy) void (^heightChangedBlock)(void);

+ (LEEActionButton *)button;

@end

@interface LEEActionButton ()

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) CALayer *topLayer;

@property (nonatomic, strong) CALayer *bottomLayer;

@property (nonatomic, strong) CALayer *leftLayer;

@property (nonatomic, strong) CALayer *rightLayer;

@end

@implementation LEEActionButton

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    /// 刷新Action设置
    self.action = self.action;
}

+ (LEEActionButton *)button{
    
    return [LEEActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(LEEAction *)action{
    
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    [self.titleLabel setNumberOfLines:action.numberOfLines];
    
    [self.titleLabel setTextAlignment:action.textAlignment];
    
    [self setContentEdgeInsets: action.contentEdgeInsets];
    
    [self setContentVerticalAlignment:action.contentVerticalAlignment];
    
    [self setContentHorizontalAlignment:action.contentHorizontalAlignment];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    [self.titleLabel setAdjustsFontSizeToFitWidth:action.adjustsFontSizeToFitWidth];
    
    [self.titleLabel setLineBreakMode:action.lineBreakMode];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.backgroundImage) [self setBackgroundImage:action.backgroundImage forState:UIControlStateNormal];
    
    if (action.backgroundHighlightImage) [self setBackgroundImage:action.backgroundHighlightImage forState:UIControlStateHighlighted];
    
    if (action.borderColor) [self setBorderColor:action.borderColor];
    
    if (action.borderWidth > 0) [self setBorderWidth:action.borderWidth < DEFAULTBORDERWIDTH ? DEFAULTBORDERWIDTH : action.borderWidth]; else [self setBorderWidth:0.0f];
    
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    if (action.height) [self setActionHeight:action.height];
    
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

- (CGFloat)actionHeight{
    
    return self.frame.size.height;
}

- (void)setActionHeight:(CGFloat)height{
    
    BOOL isChange = [self actionHeight] == height ? NO : YES;
    
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
    [self removeTopBorder];
    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{
    [self removeBottomBorder];
    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{
    [self removeLeftBorder];
    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{
    [self removeRightBorder];
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

@property (nonatomic, strong) LEEItem *item;

@property (nonatomic, strong) UIView *container;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, copy) void (^sizeChangedBlock)(void);

@end

@implementation LEECustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _positionType = LEECustomViewPositionTypeCenter;
    }
    return self;
}

- (void)dealloc{
    self.view = nil;
    
    if (_container) {
        
        [_container removeObserver:self forKeyPath:@"frame"];
        [_container removeObserver:self forKeyPath:@"bounds"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    UIView *view = (UIView *)object;
    
    if ([view isEqual:self.container] && self.isAutoWidth) {
        
        if ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"bounds"]) {
            
            for (UIView *subView in view.subviews) {
                CGRect temp = subView.frame;
                temp.size.width = view.bounds.size.width;
                subView.frame = temp;
            }
        }
    }
    
    if ([view isEqual:self.view]) {
        
        if ([keyPath isEqualToString:@"frame"]) {
            
            if (self.isAutoWidth) {
                self.size = CGSizeMake(view.frame.size.width, self.size.height);
            }
            
            if (!CGSizeEqualToSize(self.size, view.frame.size)) {
                
                self.size = view.frame.size;
                
                [self updateContainerFrame:view];
                
                if (self.sizeChangedBlock) self.sizeChangedBlock();
            }
        }
        
        if ([keyPath isEqualToString:@"bounds"]) {
            
            if (self.isAutoWidth) {
                self.size = CGSizeMake(view.bounds.size.width, self.size.height);
            }
            
            if (!CGSizeEqualToSize(self.size, view.bounds.size)) {
                
                self.size = view.bounds.size;
                
                [self updateContainerFrame:view];
                
                if (self.sizeChangedBlock) self.sizeChangedBlock();
            }
        }
    }
    
    [CATransaction commit];
}

- (void)updateContainerFrame:(UIView *)view {
    
    view.frame = view.bounds;
    
    self.container.bounds = view.bounds;
}

- (UIView *)container{
   
    if (!_container) {
        
        _container = [[UIView alloc] initWithFrame:CGRectZero];
        
        _container.backgroundColor = UIColor.clearColor;
        
        _container.clipsToBounds = true;
        
        [_container addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
        [_container addObserver: self forKeyPath: @"bounds" options: NSKeyValueObservingOptionNew context: nil];
    }
    
    return _container;
}

- (void)setView:(UIView *)view{
    
    if (_view) {
        [_view removeFromSuperview];
        
        [_view removeObserver:self forKeyPath:@"frame"];
        [_view removeObserver:self forKeyPath:@"bounds"];
    }
    
    _view = view;
    
    if (_view) {
        [view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
        [view addObserver: self forKeyPath: @"bounds" options: NSKeyValueObservingOptionNew context: nil];
        
        [view layoutIfNeeded];
        [view layoutSubviews];
        
        _size = view.frame.size;
        
        [self updateContainerFrame:view];
        
        [self.container addSubview:view];
        
        // 保证使用AutoLayout的自定义视图在容器视图内的位置正确
        if (view.translatesAutoresizingMaskIntoConstraints == NO) {
            {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.container
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1
                                                                               constant:0];
                [self.container addConstraint: constraint];
            }
            {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.container
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1
                                                                               constant:0];
                [self.container addConstraint: constraint];
            }
        }
    }
}

@end

@interface LEEPresentationWindow: LEEPresentation

@property (nonatomic, assign) UIWindowLevel windowLevel;

@end

@interface LEEPresentationViewController: LEEPresentation

@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation LEEPresentation

+ (LEEPresentationWindow *)windowLevel:(UIWindowLevel)level {
    LEEPresentationWindow *presentation = [[LEEPresentationWindow alloc] init];
    presentation.windowLevel = level;
    return presentation;
}

+ (LEEPresentationViewController *)viewController:(UIViewController *)controller {
    LEEPresentationViewController *presentation = [[LEEPresentationViewController alloc] init];
    presentation.viewController = controller;
    return presentation;
}

@end

@implementation LEEPresentationWindow

@end

@implementation LEEPresentationViewController

@end


@interface LEEBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) LEEBaseConfigModel *config;

@property (nonatomic, strong) UIWindow *currentKeyWindow;

@property (nonatomic, strong) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic, assign) LEEScreenOrientationType orientationType;

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, assign) BOOL isClosing;

@property (nonatomic, copy) void (^openFinishBlock)(void);

@property (nonatomic, copy) void (^closeFinishBlock)(void);

@end

@implementation LEEBaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundVisualEffectView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic push
    if (self.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
        
        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        
        self.backgroundVisualEffectView.frame = self.view.frame;
        
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
    
    [super touchesBegan:touches withEvent:event];
    
    if (self.config.modelIsClickBackgroundClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [self.currentKeyWindow endEditing:YES];
    
    [self.view setUserInteractionEnabled:NO];
    
    [self.view layoutIfNeeded];
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [[LEEAlert shareManager].leeWindow endEditing:YES];
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LEEAlert shareManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 ", UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LEEAlert shareManager].mainWindow) [LEEAlert shareManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

#pragma mark - 旋转

- (BOOL)shouldAutorotate{
    
    return self.config.modelIsShouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.config.modelSupportedInterfaceOrientations;
}

#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return self.config.modelStatusBarStyle;
}

@end

#pragma mark - Alert

@interface LEEAlertViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *itemsScrollView;

@property (nonatomic, strong) UIScrollView *actionsScrollView;

@property (nonatomic, strong) NSMutableArray <id>*alertItemArray;

@property (nonatomic, strong) NSMutableArray <LEEActionButton *>*alertActionArray;

@end

@implementation LEEAlertViewController
{
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _containerView = nil;
    
    _contentView = nil;
    
    _itemsScrollView = nil;
    
    _actionsScrollView = nil;
    
    _alertItemArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configAlert];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    
    BOOL local = YES;
    
    if (@available(iOS 9.0, *)) {
        
        local = [[[notify userInfo] objectForKey:UIKeyboardIsLocalUserInfoKey] boolValue];
    }
    
    if (self.config.modelIsAvoidKeyboard && local) {
        
        double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        UIViewAnimationCurve curve = [[[notify userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        
        keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        isShowingKeyboard = roundf(keyboardFrame.origin.y) < SCREEN_HEIGHT;

        [UIView beginAnimations:@"keyboardWillChangeFrame" context:NULL];

        [UIView setAnimationDuration:duration];

        [UIView setAnimationCurve:curve];

        [self updateAlertLayout];

        [UIView commitAnimations];
    }
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self updateAlertLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateAlertLayout];
}

- (void)updateAlertLayout{
    
    [self updateAlertLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType, CGSizeMake(viewWidth, viewHeight));
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType, CGSizeMake(viewWidth, viewHeight));
    
    CGPoint offset = self.config.modelAlertCenterOffset;
    
    // 解决设置 transform 导致触发layoutsubviews的问题 (动画效果异常)
    CGAffineTransform transform = self.containerView.transform;
    
    self.containerView.transform = CGAffineTransformIdentity;
    
    if (isShowingKeyboard) {
        
        if (keyboardFrame.size.height) {
            
            // 处理非全屏时当前视图在窗口中的位置 解决键盘遮挡范围计算问题
            CGRect current = [self.view convertRect:self.view.bounds toView:self.view.window];
            
            CGFloat keyboardY = keyboardFrame.origin.y - current.origin.y;
            
            alertViewMaxHeight = keyboardY - 20;
            
            if (@available(iOS 11.0, *)) {
                alertViewMaxHeight -= self.view.safeAreaInsets.top;
            }
            
            CGRect contentViewFrame = self.contentView.frame;
            
            contentViewFrame.size.width = alertViewMaxWidth;
            
            if (self.config.modelIsActionFollowScrollEnabled) {
                
                CGFloat itemsHeight = [self updateItemsLayoutWithMaxWidth:alertViewMaxWidth];
                
                contentViewFrame.size.height = itemsHeight > alertViewMaxHeight ? alertViewMaxHeight : itemsHeight;
                
                self.itemsScrollView.frame = contentViewFrame;
                
                self.itemsScrollView.contentSize = CGSizeMake(alertViewMaxWidth, itemsHeight);
                
                self.actionsScrollView.frame = CGRectMake(0, contentViewFrame.size.height, alertViewMaxWidth, 0);
                
                self.actionsScrollView.contentSize = CGSizeZero;
                
            } else {
                
                CGFloat itemsHeight = [self updateItemsLayoutWithMaxWidth:alertViewMaxWidth];
                
                CGFloat actionsHeight = [self updateActionsLayoutWithInitialPosition:0 MaxWidth:alertViewMaxWidth];
                
                self.itemsScrollView.contentSize = CGSizeMake(alertViewMaxWidth, itemsHeight);
                
                self.actionsScrollView.contentSize = CGSizeMake(alertViewMaxWidth, actionsHeight);
                
                if ((itemsHeight + actionsHeight) > alertViewMaxHeight) {
                    
                    contentViewFrame.size.height = alertViewMaxHeight;
                    
                    CGFloat maxActionsHeight = alertViewMaxHeight * 0.5;
                    
                    actionsHeight = actionsHeight < maxActionsHeight ? actionsHeight : maxActionsHeight;
                    
                    CGFloat maxItemsHeight = alertViewMaxHeight - actionsHeight;
                    
                    itemsHeight = itemsHeight < maxItemsHeight ? itemsHeight : maxItemsHeight;
                     
                    actionsHeight = alertViewMaxHeight - itemsHeight;
                    
                    self.itemsScrollView.frame = CGRectMake(0, 0, alertViewMaxWidth, itemsHeight);
                    
                    self.actionsScrollView.frame = CGRectMake(0, itemsHeight, alertViewMaxWidth, actionsHeight);
                    
                } else {
                    
                    contentViewFrame.size.height = itemsHeight + actionsHeight;
                    
                    self.itemsScrollView.frame = CGRectMake(0, 0, alertViewMaxWidth, itemsHeight);
                    
                    self.actionsScrollView.frame = CGRectMake(0, itemsHeight, alertViewMaxWidth, actionsHeight);
                }
            }
            
            self.contentView.frame = contentViewFrame;
            
            CGFloat tempAlertViewY = keyboardY - contentViewFrame.size.height - 10;
            
            CGFloat originalAlertViewY = (viewHeight - contentViewFrame.size.height) * 0.5f + offset.y;
            
            CGRect containerFrame = self.containerView.frame;
            
            containerFrame.size.width = contentViewFrame.size.width;
            
            containerFrame.size.height = contentViewFrame.size.height;
            
            containerFrame.origin.x = (viewWidth - contentViewFrame.size.width) * 0.5f + offset.x;
            
            containerFrame.origin.y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY;
            
            self.containerView.frame = containerFrame;
            
            [self.itemsScrollView scrollRectToVisible:[self findFirstResponder:self.itemsScrollView].frame animated:YES];
        }
        
    } else {
        
        alertViewMaxHeight -= ABS(offset.y);
        
        CGRect contentViewFrame = self.contentView.frame;
        
        contentViewFrame.size.width = alertViewMaxWidth;
        
        if (self.config.modelIsActionFollowScrollEnabled) {
            
            CGFloat itemsHeight = [self updateItemsLayoutWithMaxWidth:alertViewMaxWidth];
            
            contentViewFrame.size.height = itemsHeight > alertViewMaxHeight ? alertViewMaxHeight : itemsHeight;
            
            self.itemsScrollView.frame = contentViewFrame;
            
            self.itemsScrollView.contentSize = CGSizeMake(alertViewMaxWidth, itemsHeight);
            
            self.actionsScrollView.frame = CGRectMake(0, contentViewFrame.size.height, alertViewMaxWidth, 0);
            
            self.actionsScrollView.contentSize = CGSizeZero;
            
        } else {
            
            CGFloat itemsHeight = [self updateItemsLayoutWithMaxWidth:alertViewMaxWidth];
            
            CGFloat actionsHeight = [self updateActionsLayoutWithInitialPosition:0 MaxWidth:alertViewMaxWidth];
            
            self.itemsScrollView.contentSize = CGSizeMake(alertViewMaxWidth, itemsHeight);
            
            self.actionsScrollView.contentSize = CGSizeMake(alertViewMaxWidth, actionsHeight);
            
            if ((itemsHeight + actionsHeight) > alertViewMaxHeight) {
                
                contentViewFrame.size.height = alertViewMaxHeight;
                
                CGFloat maxActionsHeight = alertViewMaxHeight * 0.5;
                
                actionsHeight = actionsHeight < maxActionsHeight ? actionsHeight : maxActionsHeight;
                
                CGFloat maxItemsHeight = alertViewMaxHeight - actionsHeight;
                
                itemsHeight = itemsHeight < maxItemsHeight ? itemsHeight : maxItemsHeight;
                 
                actionsHeight = alertViewMaxHeight - itemsHeight;
                
                self.itemsScrollView.frame = CGRectMake(0, 0, alertViewMaxWidth, itemsHeight);
                
                self.actionsScrollView.frame = CGRectMake(0, itemsHeight, alertViewMaxWidth, actionsHeight);
                
            } else {
                
                contentViewFrame.size.height = itemsHeight + actionsHeight;
                
                self.itemsScrollView.frame = CGRectMake(0, 0, alertViewMaxWidth, itemsHeight);
                
                self.actionsScrollView.frame = CGRectMake(0, itemsHeight, alertViewMaxWidth, actionsHeight);
            }
        }
        
        self.contentView.frame = contentViewFrame;
        
        CGRect containerFrame = self.containerView.frame;
        
        containerFrame.size.width = contentViewFrame.size.width;
        
        containerFrame.size.height = contentViewFrame.size.height;
        
        containerFrame.origin.x = (viewWidth - alertViewMaxWidth) * 0.5f + offset.x;
        
        containerFrame.origin.y = (viewHeight - contentViewFrame.size.height) * 0.5f + offset.y;
        
        self.containerView.frame = containerFrame;
    }
    
    self.containerView.transform = transform;
}

- (CGFloat)updateItemsLayoutWithMaxWidth:(CGFloat)maxWidth{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    __block CGFloat finalHeight = 0.0f;
    
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) finalHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            LEEItemView *view = (LEEItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = finalHeight + view.item.insets.top;
            
            viewFrame.size.width = maxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            finalHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:LEECustomView.class]) {
            
            LEECustomView *custom = (LEECustomView *)item;
            
            CGRect viewFrame = custom.container.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = LEECustomViewPositionTypeCenter;
                
                viewFrame.size.width = maxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                case LEECustomViewPositionTypeCenter:
                    viewFrame.origin.x = (maxWidth - viewFrame.size.width) * 0.5f;
                    break;
                    
                case LEECustomViewPositionTypeLeft:
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    break;
                
                case LEECustomViewPositionTypeRight:
                    viewFrame.origin.x = maxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = finalHeight + custom.item.insets.top;
            
            custom.container.frame = viewFrame;
            
            finalHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) finalHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    if (self.config.modelIsActionFollowScrollEnabled) {
        
        finalHeight += [self updateActionsLayoutWithInitialPosition:finalHeight MaxWidth:maxWidth];
    }
    
    [CATransaction commit];
    
    return finalHeight;
}

- (CGFloat)updateActionsLayoutWithInitialPosition:(CGFloat)initialPosition MaxWidth:(CGFloat)maxWidth{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGFloat finalHeight = initialPosition;
    
    for (LEEActionButton *button in self.alertActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = finalHeight + button.action.insets.top;
        
        buttonFrame.size.width = maxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        finalHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    if (self.alertActionArray.count == 2 && !self.config.modelIsAlertActionVerticalLayout) {
        
        LEEActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;
        
        LEEActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;
        
        UIEdgeInsets buttonAInsets = buttonA.action.insets;
        
        UIEdgeInsets buttonBInsets = buttonB.action.insets;
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;
        
        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);
        
        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (maxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);
        
        buttonB.frame = CGRectMake((maxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (maxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);
        
        finalHeight -= minHeight;
    }
    
    [CATransaction commit];
    
    return finalHeight - initialPosition;
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    _contentView = [UIView new];
    
    [self.contentView addSubview: self.itemsScrollView];
    
    [self.contentView addSubview: self.actionsScrollView];
    
    [self.containerView addSubview: self.contentView];
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.contentView.lee_alert_cornerRadii = self.config.modelCornerRadii;
    
    self.contentView.backgroundColor = self.config.modelHeaderColor;
    
    self.itemsScrollView.scrollEnabled = self.config.modelIsScrollEnabled;
    
    self.itemsScrollView.showsVerticalScrollIndicator = self.config.modelIsShowsScrollIndicator;
    
    self.actionsScrollView.scrollEnabled = self.config.modelIsScrollEnabled;
    
    self.actionsScrollView.showsVerticalScrollIndicator = self.config.modelIsShowsScrollIndicator;
    
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
                
                [self.itemsScrollView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                if (@available(iOS 13.0, *)) {
                    label.textColor = [UIColor labelColor];
                    
                } else {
                    label.textColor = [UIColor blackColor];
                }
                
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
                
                [self.itemsScrollView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                if (@available(iOS 13.0, *)) {
                    label.textColor = [UIColor labelColor];
                    
                } else {
                    label.textColor = [UIColor blackColor];
                }
                
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
                
                [self.itemsScrollView addSubview:custom.container];
                
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
                
                [self.itemsScrollView addSubview:textField];
                
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
    
    // 根据 modelIsActionFollowScrollEnabled 属性控制Action添加到哪个父视图
    UIView *actionContainerView = self.config.modelIsActionFollowScrollEnabled ? self.itemsScrollView : self.actionsScrollView;
    
    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) {
            if (@available(iOS 13.0, *)) {
                action.titleColor = [UIColor systemBlueColor];
                
            } else {
                action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
            }
        }
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) {
            if (@available(iOS 13.0, *)) {
                action.backgroundHighlightColor = [UIColor systemGray6Color];
                
            } else {
                action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
            }
        }
        
        if (!action.borderColor) {
            if (@available(iOS 13.0, *)) {
                action.borderColor = [UIColor systemGray3Color];
                
            } else {
                action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
            }
        }
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.borderPosition) action.borderPosition = (self.config.modelActionArray.count == 2 && idx == 0) ? LEEActionBorderPositionTop | LEEActionBorderPositionRight : LEEActionBorderPositionTop;
        
        if (!action.height) action.height = 45.0f;
        
        LEEActionButton *button = [LEEActionButton button];
        
        button.action = action;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [actionContainerView addSubview:button];
        
        [self.alertActionArray addObject:button];
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateAlertLayout];
        };
        
    }];
    
    // 更新布局
    
    [self updateAlertLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf updateAlertLayout];
    }];
    
}

- (void)buttonAction:(LEEActionButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    switch (sender.action.type) {
            
        case LEEActionTypeDefault:
            
            isClose = sender.action.isClickNotClose ? NO : YES;
            
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
    
    clickBlock = sender.action.clickBlock;
    
    NSInteger index = [self.alertActionArray indexOfObject:sender];
    
    if (isClose) {
        
        if (self.config.modelShouldActionClickClose && self.config.modelShouldActionClickClose(index)) {
            
            [self closeAnimationsWithCompletionBlock:^{
                
                if (clickBlock) clickBlock();
            }];
            
        } else {
            
            if (clickBlock) clickBlock();
        }
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    if (self.config.modelShouldClose && !self.config.modelShouldClose()) return;
    
    self.isClosing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelBackgroundStyle == LEEBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.alpha = 0.0f;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationNone) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
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

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.itemsScrollView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIScrollView *)itemsScrollView{
    
    if (!_itemsScrollView) {
        
        _itemsScrollView = [[UIScrollView alloc] init];
        
        _itemsScrollView.backgroundColor = [UIColor clearColor];
        
        _itemsScrollView.directionalLockEnabled = YES;
        
        _itemsScrollView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_itemsScrollView addGestureRecognizer:tap];
    }
    
    return _itemsScrollView;
}

- (UIScrollView *)actionsScrollView{
    
    if (!_actionsScrollView) {
        
        _actionsScrollView = [[UIScrollView alloc] init];
        
        _actionsScrollView.backgroundColor = [UIColor clearColor];
        
        _actionsScrollView.directionalLockEnabled = YES;
        
        _actionsScrollView.bounces = NO;
    }
    
    return _actionsScrollView;
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

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *itemsScrollView;

@property (nonatomic, strong) UIScrollView *actionsScrollView;

@property (nonatomic, strong) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic, strong) NSMutableArray <LEEActionButton *>*actionSheetActionArray;

@property (nonatomic, strong) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic, strong) LEEActionButton *actionSheetCancelAction;

@end

@implementation LEEActionSheetViewController
{
    BOOL isShowed;
}

- (void)dealloc{
    
    _containerView = nil;
    
    _itemsScrollView = nil;
    
    _actionsScrollView = nil;
    
    _actionSheetItemArray = nil;
    
    _actionSheetCancelActionSpaceView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self updateActionSheetLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateActionSheetLayout];
}

- (void)updateActionSheetLayout{
    
    [self updateActionSheetLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType, CGSizeMake(viewWidth, viewHeight));
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType, CGSizeMake(viewWidth, viewHeight));
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.actionHeight + self.config.modelActionSheetCancelActionSpaceWidth : 0.0f;
    
    CGRect contentViewFrame = self.contentView.frame;
    
    contentViewFrame.size.width = actionSheetViewMaxWidth;
    
    if (self.config.modelIsActionFollowScrollEnabled) {
        
        CGFloat itemsHeight = [self updateItemsLayoutWithMaxWidth:actionSheetViewMaxWidth];
        
        contentViewFrame.size.height = itemsHeight > actionSheetViewMaxHeight - cancelActionTotalHeight ? actionSheetViewMaxHeight - cancelActionTotalHeight : itemsHeight;
        
        self.itemsScrollView.frame = contentViewFrame;
        
        self.itemsScrollView.contentSize = CGSizeMake(actionSheetViewMaxWidth, itemsHeight);
        
        self.actionsScrollView.frame = CGRectMake(0, contentViewFrame.size.height, actionSheetViewMaxWidth, 0);
        
        self.actionsScrollView.contentSize = CGSizeZero;
        
    } else {
        
        CGFloat itemsHeight = [self updateItemsLayoutWithMaxWidth:actionSheetViewMaxWidth];
        
        CGFloat actionsHeight = [self updateActionsLayoutWithInitialPosition:0 MaxWidth:actionSheetViewMaxWidth];
        
        self.itemsScrollView.contentSize = CGSizeMake(actionSheetViewMaxWidth, itemsHeight);
        
        self.actionsScrollView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionsHeight);
        
        CGFloat availableHeight = actionSheetViewMaxHeight - cancelActionTotalHeight;
        
        if ((itemsHeight + actionsHeight) > availableHeight) {
            
            contentViewFrame.size.height = availableHeight;
            
            CGFloat maxActionsHeight = availableHeight * 0.5;
            
            actionsHeight = actionsHeight < maxActionsHeight ? actionsHeight : maxActionsHeight;
            
            CGFloat maxItemsHeight = availableHeight - actionsHeight;
            
            itemsHeight = itemsHeight < maxItemsHeight ? itemsHeight : maxItemsHeight;
             
            actionsHeight = availableHeight - itemsHeight;
            
            self.itemsScrollView.frame = CGRectMake(0, 0, actionSheetViewMaxWidth, itemsHeight);
            
            self.actionsScrollView.frame = CGRectMake(0, itemsHeight, actionSheetViewMaxWidth, actionsHeight);
            
        } else {
            
            contentViewFrame.size.height = itemsHeight + actionsHeight;
            
            self.itemsScrollView.frame = CGRectMake(0, 0, actionSheetViewMaxWidth, itemsHeight);
            
            self.actionsScrollView.frame = CGRectMake(0, itemsHeight, actionSheetViewMaxWidth, actionsHeight);
        }
    }
    
    self.contentView.frame = contentViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;
        
        spaceFrame.origin.x = contentViewFrame.origin.x;
        
        spaceFrame.origin.y = contentViewFrame.origin.y + contentViewFrame.size.height;
        
        spaceFrame.size.width = actionSheetViewMaxWidth;
        
        spaceFrame.size.height = self.config.modelActionSheetCancelActionSpaceWidth;
        
        self.actionSheetCancelActionSpaceView.frame = spaceFrame;
        
        CGRect buttonFrame = self.actionSheetCancelAction.frame;
        
        buttonFrame.origin.x = contentViewFrame.origin.x;
        
        buttonFrame.origin.y = contentViewFrame.origin.y + contentViewFrame.size.height + spaceFrame.size.height;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        self.actionSheetCancelAction.frame = buttonFrame;
    }
    
    [CATransaction commit];
    
    CGRect containerFrame = self.containerView.frame;
    
    containerFrame.size.width = actionSheetViewMaxWidth;
    
    containerFrame.size.height = contentViewFrame.size.height + cancelActionTotalHeight + VIEWSAFEAREAINSETS(self.view).bottom + self.config.modelActionSheetBottomMargin;
    
    containerFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
    
    if (isShowed) {
        
        containerFrame.origin.y = viewHeight - containerFrame.size.height;
        
    } else {
        
        containerFrame.origin.y = viewHeight;
    }
    
    self.containerView.frame = containerFrame;
}

- (CGFloat)updateItemsLayoutWithMaxWidth:(CGFloat)maxWidth{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    __block CGFloat finalHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) finalHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            LEEItemView *view = (LEEItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = finalHeight + view.item.insets.top;
            
            viewFrame.size.width = maxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            finalHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:LEECustomView.class]) {
            
            LEECustomView *custom = (LEECustomView *)item;
            
            CGRect viewFrame = custom.container.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = LEECustomViewPositionTypeCenter;
                
                viewFrame.size.width = maxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case LEECustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (maxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case LEECustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case LEECustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = maxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = finalHeight + custom.item.insets.top;
            
            custom.container.frame = viewFrame;
            
            finalHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) finalHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    if (self.config.modelIsActionFollowScrollEnabled) {
        
        finalHeight += [self updateActionsLayoutWithInitialPosition:finalHeight MaxWidth:maxWidth];
    }
    
    [CATransaction commit];
    
    return finalHeight;
}

- (CGFloat)updateActionsLayoutWithInitialPosition:(CGFloat)initialPosition MaxWidth:(CGFloat)maxWidth{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGFloat finalHeight = initialPosition;
    
    for (LEEActionButton *button in self.actionSheetActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = finalHeight + button.action.insets.top;
        
        buttonFrame.size.width = maxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        finalHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    [CATransaction commit];
    
    return finalHeight - initialPosition;
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    UIView *shadowView = [UIView new];
    
    shadowView.frame = self.view.bounds;
    
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    shadowView.backgroundColor = [UIColor clearColor];
    
    shadowView.layer.shadowOffset = self.config.modelShadowOffset;
    
    shadowView.layer.shadowRadius = self.config.modelShadowRadius;
    
    shadowView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    shadowView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    [self.view addSubview: shadowView];
    
    _containerView = [UIView new];
    
    [shadowView addSubview: _containerView];
    
    _contentView = [UIView new];
    
    [self.contentView addSubview: self.itemsScrollView];
    
    [self.contentView addSubview: self.actionsScrollView];
    
    [self.containerView addSubview: self.contentView];
    
    self.contentView.backgroundColor = self.config.modelHeaderColor;
    
    self.containerView.backgroundColor = self.config.modelActionSheetBackgroundColor;
    
    self.containerView.lee_alert_cornerRadii = self.config.modelCornerRadii;
    
    self.contentView.lee_alert_cornerRadii = self.config.modelActionSheetHeaderCornerRadii;
    
    self.itemsScrollView.scrollEnabled = self.config.modelIsScrollEnabled;
    
    self.itemsScrollView.showsVerticalScrollIndicator = self.config.modelIsShowsScrollIndicator;
    
    self.actionsScrollView.scrollEnabled = self.config.modelIsScrollEnabled;
    
    self.actionsScrollView.showsVerticalScrollIndicator = self.config.modelIsShowsScrollIndicator;
    
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
                
                [self.itemsScrollView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                if (@available(iOS 13.0, *)) {
                    label.textColor = [UIColor secondaryLabelColor];
                    
                } else {
                    label.textColor = [UIColor darkGrayColor];
                }
                
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
                
                [self.itemsScrollView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                if (@available(iOS 13.0, *)) {
                    label.textColor = [UIColor tertiaryLabelColor];
                    
                } else {
                    label.textColor = [UIColor grayColor];
                }
                
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
                
                [self.itemsScrollView addSubview:custom.container];
                
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
    
    // 根据 modelIsActionFollowScrollEnabled 属性控制Action添加到哪个父视图
    UIView *actionContainerView = self.config.modelIsActionFollowScrollEnabled ? self.itemsScrollView : self.actionsScrollView;
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(LEEAction *action) = item;
        
        LEEAction *action = [[LEEAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) {
            if (@available(iOS 13.0, *)) {
                action.titleColor = [UIColor systemBlueColor];
                
            } else {
                action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
            }
        }
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) {
            if (@available(iOS 13.0, *)) {
                action.backgroundHighlightColor = [UIColor systemGray6Color];
                
            } else {
                action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
            }
        }
        
        if (!action.borderColor) {
            if (@available(iOS 13.0, *)) {
                action.borderColor = [UIColor systemGray3Color];
                
            } else {
                action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
            }
        }
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.height) action.height = 57.0f;
        
        LEEActionButton *button = [LEEActionButton button];
        
        switch (action.type) {
            case LEEActionTypeCancel:
            {
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                button.lee_alert_cornerRadii = self.config.modelActionSheetCancelActionCornerRadii;
                
                button.backgroundColor = action.backgroundColor;
                
                [self.containerView addSubview:button];
                
                self.actionSheetCancelAction = button;
                
                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];
                
                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
                
                [self.containerView addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;
                
            default:
            {
                if (!action.borderPosition) action.borderPosition = LEEActionBorderPositionTop;
                
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [actionContainerView addSubview:button];
                
                [self.actionSheetActionArray addObject:button];
            }
                break;
        }
        
        button.action = action;
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }
    
    // 更新布局
    
    [self updateActionSheetLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf updateActionSheetLayout];
    }];
    
}

- (void)buttonAction:(LEEActionButton *)sender{
    
    BOOL isClose = NO;
    NSInteger index = 0;
    void (^clickBlock)(void) = nil;
    
    switch (sender.action.type) {
        case LEEActionTypeDefault:
            
            isClose = sender.action.isClickNotClose ? NO : YES;
            
            index = [self.actionSheetActionArray indexOfObject:sender];
            
            break;
            
        case LEEActionTypeCancel:
            
            isClose = YES;
            
            index = self.actionSheetActionArray.count;
            
            break;
            
        case LEEActionTypeDestructive:
            
            isClose = YES;
            
            index = [self.actionSheetActionArray indexOfObject:sender];
            
            break;
            
        default:
            break;
    }
    
    clickBlock = sender.action.clickBlock;
    
    if (isClose) {
        
        if (self.config.modelShouldActionClickClose && self.config.modelShouldActionClickClose(index)) {
            
            [self closeAnimationsWithCompletionBlock:^{
                
                if (clickBlock) clickBlock();
            }];
            
        } else {
            
            if (clickBlock) clickBlock();
        }
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & LEEAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
    
    if (self.config.modelOpenAnimationStyle & LEEAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case LEEBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
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
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight - containerFrame.size.height;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    if (self.config.modelShouldClose && !self.config.modelShouldClose()) return;
    
    self.isClosing = YES;
    
    isShowed = NO;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
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
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationNone) {
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & LEEAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.itemsScrollView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIView *)itemsScrollView{
    
    if (!_itemsScrollView) {
        
        _itemsScrollView = [[UIScrollView alloc] init];
        
        _itemsScrollView.backgroundColor = [UIColor clearColor];
        
        _itemsScrollView.directionalLockEnabled = YES;
        
        _itemsScrollView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_itemsScrollView addGestureRecognizer:tap];
    }
    
    return _itemsScrollView;
}

- (UIScrollView *)actionsScrollView{
    
    if (!_actionsScrollView) {
        
        _actionsScrollView = [[UIScrollView alloc] init];
        
        _actionsScrollView.backgroundColor = [UIColor clearColor];
        
        _actionsScrollView.directionalLockEnabled = YES;
        
        _actionsScrollView.bounces = NO;
    }
    
    return _actionsScrollView;
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

@interface LEEBaseConfig ()<LEEAlertProtocol>

@property (nonatomic, assign) BOOL isShowing;

- (void)show;

@end

@implementation LEEBaseConfig

- (void)dealloc{
    
    _config = nil;
}

- (nonnull instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.isShowing = NO;
        
        __block typeof(self) strongSelf = self;
        
        self.config.modelFinishConfig = ^{
            
            __attribute__((cleanup(lee_cleanupFunc), unused)) __auto_type x = ^{
                // break circular reference after leaving the scope.
                strongSelf = nil;
            };
            
            if (!strongSelf) {
                return;
            }
            
            if ([LEEAlert shareManager].queueArray.count) {
                
                LEEBaseConfig *last = [LEEAlert shareManager].queueArray.lastObject;
                
                // 当前未加入队列 同时 已显示的优先级高于当前 跳过
                if (!strongSelf.config.modelIsQueue && last.config.modelQueuePriority > strongSelf.config.modelQueuePriority) {
                    return;
                }
                // 已显示的未加入队列 同时已显示的优先级小于等于当前 关闭已显示的并移除
                if (!last.config.modelIsQueue && last.config.modelQueuePriority <= strongSelf.config.modelQueuePriority) {
                    
                    [last close];
                    
                    [[LEEAlert shareManager].queueArray removeObject:last];
                }
                // 已显示的已加入队列 同时已显示的优先级小于等于当前 关闭已显示的不移除
                if (last.config.modelIsQueue && last.config.modelQueuePriority <= strongSelf.config.modelQueuePriority) {
                    [last close];
                }
                
                if (![[LEEAlert shareManager].queueArray containsObject:strongSelf]) {
                    
                    [[LEEAlert shareManager].queueArray addObject:strongSelf];
                    
                    [[LEEAlert shareManager].queueArray sortUsingComparator:^NSComparisonResult(LEEBaseConfig *configA, LEEBaseConfig *configB) {
                        
                        return configA.config.modelQueuePriority > configB.config.modelQueuePriority ? NSOrderedDescending
                        : configA.config.modelQueuePriority == configB.config.modelQueuePriority ? NSOrderedSame : NSOrderedAscending;
                    }];
                    
                }
                
                if ([LEEAlert shareManager].queueArray.lastObject == strongSelf) [strongSelf show];
                
            } else {
                
                [strongSelf show];
                
                [[LEEAlert shareManager].queueArray addObject:strongSelf];
            }
            
        };
        
    }
    
    return self;
}

- (void)show{
    
    if (![LEEAlert shareManager].viewController) return;
    
    [LEEAlert shareManager].viewController.config = self.config;
    
    if ([self.config.modelPresentation isKindOfClass:LEEPresentationWindow.class]) {
        
        LEEPresentationWindow *presentation = (LEEPresentationWindow *)self.config.modelPresentation;
        
        [LEEAlert shareManager].leeWindow.rootViewController = [LEEAlert shareManager].viewController;
        
        [LEEAlert shareManager].leeWindow.windowLevel = presentation.windowLevel;
        
        [LEEAlert shareManager].leeWindow.hidden = NO;
        
        if (@available(iOS 13.0, *)) {
            [LEEAlert shareManager].leeWindow.overrideUserInterfaceStyle = self.config.modelUserInterfaceStyle;
        }
        
        [[LEEAlert shareManager].leeWindow makeKeyAndVisible];
        
        self.isShowing = YES;
    }
    
    if ([self.config.modelPresentation isKindOfClass:LEEPresentationViewController.class]) {
        
        LEEPresentationViewController *presentation = (LEEPresentationViewController *)self.config.modelPresentation;
        
        if (!presentation.viewController) return;
        
        [presentation.viewController addChildViewController:[LEEAlert shareManager].viewController];
        
        [presentation.viewController.view addSubview:[LEEAlert shareManager].viewController.view];
        
        if (@available(iOS 13.0, *)) {
            [LEEAlert shareManager].viewController.view.overrideUserInterfaceStyle = self.config.modelUserInterfaceStyle;
        }
        
        [LEEAlert shareManager].viewController.view.frame = presentation.viewController.view.bounds;
        
        [LEEAlert shareManager].viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [[LEEAlert shareManager].viewController didMoveToParentViewController:presentation.viewController];
        
        self.isShowing = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert shareManager].viewController.openFinishBlock = ^{
        
    };
    
    [LEEAlert shareManager].viewController.closeFinishBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return;
        
        if ([LEEAlert shareManager].queueArray.lastObject == strongSelf) {
            
            [strongSelf close];
            
            [[LEEAlert shareManager].queueArray removeObject:strongSelf];
            
            if (strongSelf.config.modelIsContinueQueueDisplay) [LEEAlert continueQueueDisplay];
            
        } else {
            
            [[LEEAlert shareManager].queueArray removeObject:strongSelf];
        }
        
        if (strongSelf.config.modelCloseComplete) strongSelf.config.modelCloseComplete();
    };
    
}

- (void)close{
    
    if (!self.isShowing) return;
    
    if ([self.config.modelPresentation isKindOfClass:LEEPresentationWindow.class]) {
        
        [LEEAlert shareManager].leeWindow.hidden = YES;
        
        if (@available(iOS 16.0, *)) {
            
        } else {
            [[LEEAlert shareManager].leeWindow resignKeyWindow];
        }
        
        [LEEAlert shareManager].leeWindow.rootViewController = nil;
    }
    
    if ([self.config.modelPresentation isKindOfClass:LEEPresentationViewController.class]) {
        
        [[LEEAlert shareManager].viewController willMoveToParentViewController:nil];
        
        [[LEEAlert shareManager].viewController.view removeFromSuperview];
        
        [[LEEAlert shareManager].viewController removeFromParentViewController];
    }
    
    [LEEAlert shareManager].viewController = nil;
}

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([LEEAlert shareManager].viewController) [[LEEAlert shareManager].viewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark - LazyLoading

- (LEEBaseConfigModel *)config{
    
    if (!_config) _config = [[LEEBaseConfigModel alloc] init];
    
    return _config;
}

@end

@implementation LEEAlertConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.config
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            
            return 280.0f;
        })
        .LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type, CGSize size) {
           
            return size.height - 40.0f - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).bottom;
        })
        .LeeOpenAnimationStyle(LEEAnimationStyleOrientationNone | LEEAnimationStyleFade | LEEAnimationStyleZoomEnlarge)
        .LeeCloseAnimationStyle(LEEAnimationStyleOrientationNone | LEEAnimationStyleFade | LEEAnimationStyleZoomShrink);
    }
    return self;
}

- (void)show {
    
    [LEEAlert shareManager].viewController = [[LEEAlertViewController alloc] init];
    
    [super show];
}

@end

@implementation LEEActionSheetConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.config
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            
            return type == LEEScreenOrientationTypeHorizontal ? size.height - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).bottom - 20.0f : size.width - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).left - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).right - 20.0f;
        })
        .LeeConfigMaxHeight(^CGFloat(LEEScreenOrientationType type, CGSize size) {
            
            return size.height - 40.0f - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([LEEAlert getAlertWindow]).bottom;
        })
        .LeeOpenAnimationStyle(LEEAnimationStyleOrientationBottom)
        .LeeCloseAnimationStyle(LEEAnimationStyleOrientationBottom)
        .LeeClickBackgroundClose(YES);
    }
    return self;
}

- (void)show {
    
    [LEEAlert shareManager].viewController = [[LEEActionSheetViewController alloc] init];
    
    [super show];
}

@end
