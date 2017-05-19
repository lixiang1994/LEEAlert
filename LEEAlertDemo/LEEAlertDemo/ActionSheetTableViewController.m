//
//  ActionSheetTableViewController.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/5/18.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ActionSheetTableViewController.h"

#import "LEEAlert.h"

@interface ActionSheetTableViewController ()

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation ActionSheetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ActionSheet";
    
    self.dataArray = [NSMutableArray array];
    
    
    NSMutableArray *baseArray = [NSMutableArray array];
    
    NSMutableArray *demoArray = [NSMutableArray array];
    
    [self.dataArray addObject:baseArray];
    
    [self.dataArray addObject:demoArray];
    
    [baseArray addObject:@{@"title" : @"显示一个默认的 actionSheet 菜单" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"显示一个带取消按钮的 actionSheet 菜单" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"显示一个不同顺序的 actionSheet 菜单" , @"content" : @"设置的顺序决定了控件显示的顺序"}];
    
    [baseArray addObject:@{@"title" : @"显示一个带有自定义视图的 actionSheet 菜单" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [demoArray addObject:@{@"title" : @"显示一个类似微信布局的 actionSheet 菜单" , @"content" : @"只需要调整最大宽度,取消action的间隔颜色和底部间距即可"}];
    
    [demoArray addObject:@{@"title" : @"" , @"content" : @""}];
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
            [LEEAlert actionsheet].config
            .LeeTitle(@"标题")
            .LeeContent(@"内容")
            .LeeAction(@"好的", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 1:
        {
            [LEEAlert actionsheet].config
            .LeeTitle(@"标题")
            .LeeContent(@"内容")
            .LeeAction(@"确认", ^{
                
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 2:
        {
            [LEEAlert actionsheet].config
            .LeeContent(@"内容")
            .LeeTitle(@"标题")
            .LeeAction(@"确认", ^{
                
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 3:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 100, 900)];
            
            view.backgroundColor = [UIColor colorWithRed:43/255.0f green:133/255.0f blue:208/255.0f alpha:1.0f];
            
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
            
            [LEEAlert actionsheet].config
            .LeeContent(@"内容")
            .LeeTitle(@"标题")
            .LeeCustomView(view)
            .LeeAction(@"确认1", ^{
                
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 4:
        {
            
        }
            break;
            
        case 5:
        {
            
        }
            break;
            
        case 6:
        {
            
        }
            break;
            
        case 7:
        {
            
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

#pragma mark - demo

- (void)demo:(NSInteger)index{
    
    switch (index) {
            
        case 0:
        {
            [LEEAlert actionsheet].config
            .LeeContent(@"退出后不会通知群聊中其他成员, 且不会接收此群聊消息.出后不会通知群聊中其他成员, 且不会接收此群聊消息")
            .LeeDestructiveAction(@"确定", ^{
                
                // 点击事件回调Block
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                
                action.title = @"取消";
                
                action.titleColor = [UIColor blackColor];
                
                action.font = [UIFont systemFontOfSize:18.0f];
                
            })
            .LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f])
            .LeeActionSheetBottomMargin(0.0f)
            .LeeCornerRadius(0.0f)
            .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
                
                return CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .LeeClickBackgroundClose()
            .LeeShow();
        }
            break;
            
        case 1:
        {
            
        }
            break;
            
        case 2:
        {
            
        }
            break;
            
        case 3:
        {
            
        }
            break;
            
        case 4:
        {
            
        }
            break;
            
        case 5:
        {
            
        }
            break;
            
        case 6:
        {
            
        }
            break;
            
        case 7:
        {
            
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
