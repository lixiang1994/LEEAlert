//
//  AlertTableViewController.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/5/18.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "AlertTableViewController.h"

#import "LEEAlert.h"

#import "ShareView.h"

#import "OpenPushView.h"

#import "SignFinishView.h"

#import "SelectedListView.h"

@interface AlertTableViewController ()

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation AlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Alert";
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.dataArray = [NSMutableArray array];
    
    NSMutableArray *baseArray = [NSMutableArray array];
    
    NSMutableArray *demoArray = [NSMutableArray array];
    
    [self.dataArray addObject:baseArray];
    
    [self.dataArray addObject:demoArray];
    
    [baseArray addObject:@{@"title" : @"显示一个默认的 alert 弹框" , @"content" : @""}];
 
    [baseArray addObject:@{@"title" : @"显示一个带输入框的 alert 弹框" , @"content" : @"可以添加多个输入框."}];
    
    [baseArray addObject:@{@"title" : @"显示一个不同控件顺序的 alert 弹框" , @"content" : @"设置的顺序决定了控件显示的顺序."}];
    
    [baseArray addObject:@{@"title" : @"显示一个带自定义视图的 alert 弹框" , @"content" : @"自定义视图的size发生改变时 会自动适应其改变."}];
    
    [baseArray addObject:@{@"title" : @"显示一个横竖屏不同宽度的 alert 弹框" , @"content" : @"可以对横竖屏的最大宽度进行设置"}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义标题和内容的 alert 弹框" , @"content" : @"除了标题和内容 其他控件均支持自定义."}];
    
    [baseArray addObject:@{@"title" : @"显示一个多种action的 alert 弹框" , @"content" : @"action分为三种类型 可添加多个 设置的顺序决定了显示的顺序."}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义action的 alert 弹框" , @"content" : @"action的自定义属性可查看\"LEEAction\"类."}];
    
    [baseArray addObject:@{@"title" : @"显示一个可动态改变action的 alert 弹框" , @"content" : @"已经显示后 可再次对action进行调整"}];
    
    [baseArray addObject:@{@"title" : @"显示一个可动态改变标题和内容的 alert 弹框" , @"content" : @"已经显示后 可再次对其进行调整"}];
    
    [baseArray addObject:@{@"title" : @"显示一个模糊背景样式的 alert 弹框" , @"content" : @"传入UIBlurEffectStyle枚举类型 默认为Dark"}];
    
    [baseArray addObject:@{@"title" : @"显示多个加入队列和优先级的 alert 弹框" , @"content" : @"当多个同时需要显示时, 队列和优先级决定了如何去显示"}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义动画配置的 alert 弹框" , @"content" : @"可自定义打开与关闭的动画配置(UIView 动画)"}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义动画样式的 alert 弹框" , @"content" : @"动画样式可设置动画方向, 淡入淡出, 缩放等"}];
    
    [demoArray addObject:@{@"title" : @"显示一个蓝色自定义风格的 alert 弹框" , @"content" : @"弹框背景等颜色均可以自定义"}];
    
    [demoArray addObject:@{@"title" : @"显示一个分享登录的 alert 弹框" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个提示打开推送的 alert 弹框" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个提示签到成功的 alert 弹框" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个单选选择列表的 alert 弹框" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个省市区选择列表的 alert 弹框" , @"content" : @"自定义的Action 通过设置其间距范围和边框等属性实现"}];
    
    [demoArray addObject:@{@"title" : @"显示一个评分的 alert 弹框" , @"content" : @"自定义的Action 通过设置其间距范围和边框等属性实现"}];
    
    [demoArray addObject:@{@"title" : @"显示一个新手红包的 alert 弹框" , @"content" : @"包含自定义视图 自定义title 自定义Action"}];
}

#pragma mark - 自定义视图点击事件 (随机调整size)

- (void)viewTapAction:(UITapGestureRecognizer *)tap{
    
    CGFloat randomWidth = arc4random() % 240 + 10;
    
    CGFloat randomHeight = arc4random() % 400 + 10;
    
    CGRect viewFrame = tap.view.frame;
    
    viewFrame.size.width = randomWidth;
    
    viewFrame.size.height = randomHeight;
    
    tap.view.frame = viewFrame;
}

#pragma mark - 基础

- (void)base:(NSInteger)index{
    
    switch (index) {
            
        case 0:
        {
            [LEEAlert alert].config
            .LeeTitle(@"标题")
            .LeeContent(@"内容")
            .LeeCancelAction(@"取消", ^{
                
                // 取消点击事件Block
            })
            .LeeAction(@"确认", ^{
                
                // 确认点击事件Block
            })
            .LeeShow(); // 设置完成后 别忘记调用Show来显示
        }
            break;
            
        case 1:
        {
            // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
            
            __block UITextField *tf = nil;
            
            [LEEAlert alert].config
            .LeeTitle(@"标题")
            .LeeContent(@"内容")
            .LeeAddTextField(^(UITextField *textField) {
                
                // 这里可以进行自定义的设置
                
                textField.placeholder = @"输入框";
                
                textField.textColor = [UIColor darkGrayColor];
                
                tf = textField; //赋值
            })
            .LeeAction(@"好的", ^{
                
                [tf resignFirstResponder];
            })
            .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
            .LeeShow();
        }
            break;
            
        case 2:
        {
            // 添加设置的顺序决定了显示的顺序 可根据需要去调整
            
            [LEEAlert alert].config
            .LeeAddTextField(nil) // 如果不需要其他设置 也可以传入nil 输入框会按照默认样式显示
            .LeeContent(@"内容1")
            .LeeTitle(@"标题")
            .LeeContent(@"内容2")
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框2";
            })
            .LeeAction(@"好的", nil)
            .LeeCancelAction(@"取消", nil)
            .LeeShow();
        }
            break;
            
        case 3:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
            
            view.backgroundColor = [UIColor colorWithRed:43/255.0f green:133/255.0f blue:208/255.0f alpha:1.0f];
            
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
            
            [LEEAlert alert].config
            .LeeTitle(@"标题")
            .LeeAddCustomView(^(LEECustomView *custom) {
                
                custom.view = view;
                
                custom.positionType = LEECustomViewPositionTypeCenter;
            })
            .LeeItemInsets(UIEdgeInsetsMake(30, 10, 30, 10)) // 想为哪一项设置间距范围 直接在其后面设置即可 ()
            .LeeContent(@"内容")
            .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10)) // 这个间距范围就是对content设置的
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框";
            })
            .LeeAction(@"确认", nil)
            .LeeCancelAction(@"取消", nil)
            .LeeShow();
        }
            break;
            
        case 4:
        {
            // 宽度发生变化 标题和内容的高度也会自动适应 无需操心
            
            [LEEAlert alert].config
            .LeeTitle(@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题")
            .LeeContent(@"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框";
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeAction(@"确认", ^{
                
            })
            .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type) {
                
                switch (type) {
                        
                    case LEEScreenOrientationTypeHorizontal:
                        
                        // 横屏时最大宽度
                        
                        return CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.7f;
                        
                        break;
                    
                    case LEEScreenOrientationTypeVertical:
                        
                        // 竖屏时最大宽度
                        
                        return CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.9f;
                        
                        break;
                        
                    default:
                        return 0.0f;
                        break;
                }
            })
            .LeeShow();
        }
            break;
            
        case 5:
        {
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"已经退出该群组";
                
                label.textColor = [UIColor darkGrayColor];
                
                label.textAlignment = NSTextAlignmentLeft;
            })
            .LeeAddContent(^(UILabel *label) {
                
                label.text = @"以后将不会再收到该群组的任何消息";
                
                label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
                
                label.textAlignment = NSTextAlignmentLeft;
            })
            .LeeAction(@"好的", nil)
            .LeeShow();
        }
            break;
            
        case 6:
        {
            [LEEAlert alert].config
            .LeeTitle(@"这是一个alert 它有三个不同类型的action!")
            .LeeAction(@"一个默认action", ^{
                
                // 点击事件Block
            })
            .LeeDestructiveAction(@"一个销毁action", ^{
                
                // 点击事件Block
            })
            .LeeCancelAction(@"一个取消action", ^{
                
                // 点击事件Block
            })
            .LeeShow();
        }
            break;
            
        case 7:
        {
            [LEEAlert alert].config
            .LeeTitle(@"自定义 Action 的 Alert!")
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                
                action.title = @"自定义";
                
                action.titleColor = [UIColor brownColor];
                
                action.highlight = @"被点啦";
                
                action.highlightColor = [UIColor orangeColor];
                
                action.image = [UIImage imageNamed:@"smile"];
                
                action.highlightImage = [UIImage imageNamed:@"tongue"];
                
                action.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
                
                action.height = 60.0f;
                
                action.clickBlock = ^{
                    
                    // 点击事件Block
                };
                
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                
                action.title = @"自定义";
                
                action.titleColor = [UIColor orangeColor];
                
                action.highlightColor = [UIColor brownColor];
                
                action.image = [UIImage imageNamed:@"smile"];
                
                action.highlightImage = [UIImage imageNamed:@"tongue"];
                
                action.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
                
                action.height = 60.0f;
                
                action.clickBlock = ^{
                    
                    // 点击事件Block
                };
                
            })
            .LeeShow();
        }
            break;
            
        case 8:
        {
            __block LEEAction *tempAction = nil;
            
            [LEEAlert alert].config
            .LeeContent(@"点击改变 第一个action会长高哦")
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"我是action";
                
                tempAction = action;
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"改变";
                
                action.isClickNotClose = YES; // 设置点击不关闭 (仅适用于默认类型的action)
                
                action.clickBlock = ^{
                    
                    tempAction.height += 40;
                    
                    tempAction.title = @"我长高了";
                    
                    tempAction.titleColor = [UIColor redColor];
                    
                    [tempAction update]; // 更改设置后 调用更新
                };
            })
            .LeeCancelAction(@"取消", nil)
            .LeeShow();
        }
            break;
            
        case 9:
        {
            __block UILabel *tempTitle = nil;
            __block UILabel *tempContent = nil;
            
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"动态改变标题和内容的alert";
                
                tempTitle = label;
            })
            .LeeAddContent(^(UILabel *label) {
                
                label.text = @"点击调整 action 即可改变";
                
                tempContent = label;
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"调整";
                
                action.isClickNotClose = YES; // 设置点击不关闭 (仅适用于默认类型的action)
                
                action.clickBlock = ^{
                    
                    tempTitle.text = @"一个改变后的标题 ...................................................................";
                    
                    tempTitle.textColor = [UIColor grayColor];
                    
                    tempTitle.textAlignment = NSTextAlignmentLeft;
                    
                    tempContent.text = @"一个改变后的内容";
                    
                    tempContent.textColor = [UIColor lightGrayColor];
                    
                    tempContent.textAlignment = NSTextAlignmentLeft;
                    
                    // 其他控件同理 ,
                };
                
            })
            .LeeCancelAction(@"取消" , nil)
            .LeeShow();
        }
            break;
            
        case 10:
        {
            [LEEAlert alert].config
            .LeeTitle(@"这是一个毛玻璃背景样式的alert")
            .LeeContent(@"通过UIBlurEffectStyle枚举设置效果样式")
            .LeeAction(@"确认", nil)
            .LeeCancelAction(@"取消", nil)
            .LeeBackgroundStyleBlur(UIBlurEffectStyleLight)
            .LeeShow();
        }
            break;
            
        case 11:
        {
            // 队列: 加入队列后 在显示过程中 如果有一个更高优先级的alert要显示 那么当前的alert会暂时关闭 显示新的 待新的alert显示结束后 继续显示.
            // 优先级: 按照优先级从高到低的顺序显示, 优先级相同时 优先显示最新的.
            // 队列和优先级: 当两者结合时 两者的特性会相互融合
            
            // 下面代码可自行调试理解
            
            [LEEAlert alert].config
            .LeeTitle(@"alert 1")
            .LeeCancelAction(@"取消", nil)
            .LeeAction(@"确认", nil)
//            .LeeQueue(YES) // 添加到队列
            .LeePriority(1) // 设置优先级
            .LeeShow();
            
            
            [LEEAlert alert].config
            .LeeTitle(@"alert 2")
            .LeeCancelAction(@"取消", nil)
            .LeeAction(@"确认", nil)
            .LeeQueue(YES) // 添加到队列
            .LeePriority(3) // 设置优先级
            .LeeShow();
            
            
            [LEEAlert alert].config
            .LeeTitle(@"alert 3")
            .LeeCancelAction(@"取消", nil)
            .LeeAction(@"确认", nil)
            .LeeQueue(YES) // 添加到队列
            .LeePriority(2) // 设置优先级
            .LeeShow();
        }
            break;
            
        case 12:
        {
            [LEEAlert alert].config
            .LeeTitle(@"自定义动画配置的 Alert")
            .LeeContent(@"支持 自定义打开动画配置和关闭动画配置 基于 UIView 动画API")
            .LeeAction(@"好的", ^{
                
                // 点击事件Block
            })
            .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
                
                [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    animatingBlock(); //调用动画中Block
                    
                } completion:^(BOOL finished) {
                    
                    animatedBlock(); //调用动画结束Block
                }];
                
            })
            .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
                
                [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    animatingBlock();
                    
                } completion:^(BOOL finished) {
                    
                    animatedBlock();
                }];
                
            })
            .LeeShow();
        }
            break;
            
        case 13:
        {
            /*
             动画样式的方向只可以设置一个 其他样式枚举可随意增加.
             动画样式和动画配置可同时设置 这里不多做演示 欢迎自行探索
             */
            
            [LEEAlert alert].config
            .LeeTitle(@"自定义动画样式的 Alert")
            .LeeContent(@"动画样式可设置动画方向, 淡入淡出, 缩放等")
            .LeeAction(@"好的", ^{
                
                // 点击事件Block
            })
            .LeeOpenAnimationStyle(LEEAnimationStyleOrientationTop | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
            .LeeCloseAnimationStyle(LEEAnimationStyleOrientationBottom | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
            //.LeeOpenAnimationStyle(LEEAnimationStyleOrientationLeft | LEEAnimationStyleZoomEnlarge) //这里设置打开动画样式的方向为左 以及缩放效果.
            //.LeeCloseAnimationStyle(LEEAnimationStyleOrientationRight | LEEAnimationStyleZoomEnlarge) //这里设置关闭动画样式的方向为右 以及缩放效果
            .LeeShow();
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - demo

- (void)demo:(NSInteger)index{
    
    switch (index) {
            
        case 0:
        {
            UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
            
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"确认删除?";
                
                label.textColor = [UIColor whiteColor];
            })
            .LeeAddContent(^(UILabel *label) {
                
                label.text = @"删除后将无法恢复, 请慎重考虑";
                
                label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                
                action.title = @"取消";
                
                action.titleColor = blueColor;
                
                action.backgroundColor = [UIColor whiteColor];
                
                action.clickBlock = ^{
                    
                    // 取消点击事件Block
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                
                action.title = @"删除";
                
                action.titleColor = blueColor;
                
                action.backgroundColor = [UIColor whiteColor];
                
                action.clickBlock = ^{
                    
                    // 删除点击事件Block
                };
            })
            .LeeHeaderColor(blueColor)
            .LeeShow();
        }
            break;
            
        case 1:
        {
            // 初始化分享视图
            
            ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) InfoArray:nil MaxLineNumber:2 MaxSingleCount:3];
            
            shareView.openShareBlock = ^(ShareType type){
                
                NSLog(@"%d" , type);  
            };
            
            [LEEAlert alert].config
            .LeeAddCustomView(^(LEECustomView *custom) {
                
                custom.view = shareView;
                
                custom.positionType = LEECustomViewPositionTypeCenter;
            })
            .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                
                action.title = @"取消";
                
                action.titleColor = [UIColor grayColor];
            })
            .LeeShow();
        }
            break;
            
        case 2:
        {
            OpenPushView *view = [[OpenPushView alloc] initWithFrame:CGRectMake(0, 0, 280, 0)];
            
            view.closeBlock = ^{
              
                [LEEAlert closeWithCompletionBlock:nil];
            };
            
            [LEEAlert alert].config
            .LeeCustomView(view)
            .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeShow();
        }
            break;
            
        case 3:
        {
            SignFinishView *view = [[SignFinishView alloc] initWithFrame:CGRectMake(0, 0, 280, 0)];
            
            view.closeBlock = ^{
                
                [LEEAlert closeWithCompletionBlock:nil];
            };
            
            [LEEAlert alert].config
            .LeeCustomView(view)
            .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeHeaderColor([UIColor clearColor])
            .LeeShow();
        }
            break;
            
        case 4:
        {
            SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
            
            view.isSingle = YES;
            
            view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"垃圾广告"] ,
                           [[SelectedListModel alloc] initWithSid:1 Title:@"淫秽色情"] ,
                           [[SelectedListModel alloc] initWithSid:2 Title:@"低俗辱骂"] ,
                           [[SelectedListModel alloc] initWithSid:3 Title:@"涉政涉密"] ,
                           [[SelectedListModel alloc] initWithSid:4 Title:@"欺诈谣言"] ];
            
            view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                
                [LEEAlert closeWithCompletionBlock:^{
                    
                    NSLog(@"选中的%@" , array);
                }];
                
            };
            
            [LEEAlert alert].config
            .LeeTitle(@"举报内容问题")
            .LeeItemInsets(UIEdgeInsetsMake(20, 0, 20, 0))
            .LeeCustomView(view)
            .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
            .LeeClickBackgroundClose(YES)
            .LeeShow();
        }
            break;
            
        case 5:
        {
            __block NSString *province = nil;
            
            __block NSString *city = nil;
            
            __block NSString *area = nil;
            
            void (^resultBlock)(void) = ^{
            
                // 显示结果Block
                
                [LEEAlert alert].config
                .LeeTitle(@"结果")
                .LeeContent([NSString stringWithFormat:@"%@ %@ %@" , province ?: @"" , city ?: @"" , area ?: @""])
                .LeeAction(@"好的", nil)
                .LeeShow();
            };
            
            // 获取plist数据
            
            NSDictionary *addressInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"]];
            
            if (!addressInfo) return;
            
            NSArray *provinceArray = addressInfo[@"address"];
            
            if (provinceArray.count) {
                
                // 获取省数据 并显示
                
                NSMutableArray *array = [NSMutableArray array];
                
                [provinceArray enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [array addObject:[[SelectedListModel alloc] initWithSid:idx Title:info[@"name"] Context:info]];
                }];
                
                SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
                
                view.isSingle = YES;
                
                view.array = array;
                
                view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                    
                    [LEEAlert closeWithCompletionBlock:^{
                        
                        // 根据选中的省获取市数据 并显示
                        
                        SelectedListModel *model = array.firstObject;
                        
                        province = model.title; //设置省
                        
                        NSArray *cityArray = model.context[@"sub"];
                        
                        if (cityArray.count) {
                            
                            NSMutableArray *array = [NSMutableArray array];
                            
                            [cityArray enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                [array addObject:[[SelectedListModel alloc] initWithSid:idx Title:info[@"name"] Context:info]];
                            }];
                            
                            SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
                            
                            view.isSingle = YES;
                            
                            view.array = array;
                            
                            view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                                
                                [LEEAlert closeWithCompletionBlock:^{
                                
                                    // 根据选中的市获取区数据 并显示
                                    
                                    SelectedListModel *model = array.firstObject;
                                    
                                    city = model.title; //设置市
                                    
                                    NSArray *areaArray = model.context[@"sub"];
                                    
                                    if (areaArray.count) {
                                        
                                        NSMutableArray *array = [NSMutableArray array];
                                        
                                        [areaArray enumerateObjectsUsingBlock:^(NSString *area, NSUInteger idx, BOOL * _Nonnull stop) {
                                            
                                            [array addObject:[[SelectedListModel alloc] initWithSid:idx Title:area]];
                                        }];
                                        
                                        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
                                        
                                        view.isSingle = YES;
                                        
                                        view.array = array;
                                        
                                        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                                            
                                            [LEEAlert closeWithCompletionBlock:^{
                                                
                                                // 获取区数据 并显示最终结果
                                                
                                                SelectedListModel *model = array.firstObject;
                                                
                                                area = model.title; //设置区
                                                
                                                if (resultBlock) resultBlock();
                                            }];
                                            
                                        };
                                        
                                        [LEEAlert alert].config
                                        .LeeTitle(model.title)
                                        .LeeCustomView(view)
                                        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
                                        .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
                                        .LeeClickBackgroundClose(YES)
                                        .LeeShow();
                                    
                                    } else {
                                        
                                        if (resultBlock) resultBlock();
                                    }
                                    
                                }];
                                
                            };
                            
                            [LEEAlert alert].config
                            .LeeTitle(model.title)
                            .LeeCustomView(view)
                            .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
                            .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
                            .LeeClickBackgroundClose(YES)
                            .LeeShow();
                        
                        } else {
                            
                            if (resultBlock) resultBlock();
                        }
                        
                    }];
                    
                };
                
                [LEEAlert alert].config
                .LeeTitle(@"选择省")
                .LeeCustomView(view)
                .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
                .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
                .LeeClickBackgroundClose(YES)
                .LeeShow();
            }
            
        }
            break;
            
        case 6:
        {
            [LEEAlert alert].config
            .LeeTitle(@"评个分吧")
            .LeeAddContent(^(UILabel *label) {
                
                label.text = @"如果您觉得不错, 那就给个五星好评吧 亲~";
                
                label.textColor = [UIColor grayColor];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"果断拒绝";
                
                action.titleColor = [UIColor darkGrayColor];
                
                action.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
                
                action.backgroundHighlightColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
                
                action.insets = UIEdgeInsetsMake(0, 10, 10, 10);
                
                action.borderPosition = LEEActionBorderPositionTop | LEEActionBorderPositionBottom | LEEActionBorderPositionLeft | LEEActionBorderPositionRight;
                
                action.borderWidth = 1.0f;
                
                action.borderColor = action.backgroundHighlightColor;
                
                action.cornerRadius = 5.0f;
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"立刻吐槽";
                
                action.titleColor = [UIColor darkGrayColor];
                
                action.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
                
                action.backgroundHighlightColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
                
                action.insets = UIEdgeInsetsMake(0, 10, 10, 10);
                
                action.borderPosition = LEEActionBorderPositionTop | LEEActionBorderPositionBottom | LEEActionBorderPositionLeft | LEEActionBorderPositionRight;
                
                action.borderWidth = 1.0f;
                
                action.borderColor = action.backgroundHighlightColor;
                
                action.cornerRadius = 5.0f;
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                
                action.title = @"五星好评";
                
                action.titleColor = [UIColor whiteColor];
                
                action.backgroundColor = [UIColor colorWithRed:243/255.0f green:94/255.0f blue:83/255.0f alpha:1.0f];
                
                action.backgroundHighlightColor = [UIColor colorWithRed:219/255.0f green:100/255.0f blue:94/255.0f alpha:1.0f];
                
                action.insets = UIEdgeInsetsMake(0, 10, 10, 10);
                
                action.borderPosition = LEEActionBorderPositionTop | LEEActionBorderPositionBottom | LEEActionBorderPositionLeft | LEEActionBorderPositionRight;
                
                action.borderWidth = 1.0f;
                
                action.borderColor = action.backgroundHighlightColor;
                
                action.cornerRadius = 5.0f;
            })
            .LeeCornerRadius(2.0f)
            .LeeShow();
        }
            break;
            
        case 7:
        {
            UIColor *redColor = [UIColor colorWithRed:221/255.0f green:86/255.0f blue:78/255.0f alpha:1.0f];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 280 * 0.4f)];
            
            imageView.image = [UIImage imageNamed:@"infor_pop_hongbao"];
            
            [LEEAlert alert].config
            .LeeCustomView(imageView)
            .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"注册后您将获得";
                
                label.textColor = redColor;
                
                label.font = [UIFont systemFontOfSize:16.0f];
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, 10, 0))
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"¥10.0";
                
                label.textColor = [UIColor blackColor];
                
                label.font = [UIFont boldSystemFontOfSize:35.0f];
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, 10, 0))
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"注册后存入您的余额";
                
                label.textColor = [UIColor grayColor];
                
                label.font = [UIFont systemFontOfSize:12.0f];
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, 10, 0))
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                
                action.title = @"立即注册";
                
                action.titleColor = [UIColor whiteColor];
                
                action.backgroundColor = redColor;
                
                action.backgroundHighlightColor = [UIColor colorWithRed:219/255.0f green:100/255.0f blue:94/255.0f alpha:1.0f];
                
                action.insets = UIEdgeInsetsMake(10, 10, 10, 10);
                
                action.cornerRadius = 5.0f;
            })
            .LeeCornerRadius(5.0f)
            .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .LeeHeaderColor([UIColor colorWithRed:239 / 255.0f green:225 / 255.0f blue:212 / 255.0f alpha:1.0f])
            .LeeClickBackgroundClose(YES)
            .LeeShow();
        }
            break;
            
        case 8:
        {
            
        }
            break;
            
        case 9:
        {
            
        }
            break;
            
        case 10:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *info = self.dataArray[indexPath.section][indexPath.row];
    
    cell.textLabel.text = info[@"title"];
    
    cell.detailTextLabel.text = info[@"content"];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        
        case 0:
            
            return @"基础";
            
            break;
            
        case 1:
            
            return @"Demo";
            
            break;
            
        default:
            
            return @"";
            
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        
        case 0:
        
            [self base:indexPath.row];
            
            break;
            
        case 1:
            
            [self demo:indexPath.row];
            
            break;
            
        default:
            break;
    }
    
}

@end
