//
//  AlertTableViewController.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/5/18.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "AlertTableViewController.h"

#import "LEEAlert.h"

@interface AlertTableViewController ()

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation AlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Alert";
    
    self.dataArray = [NSMutableArray array];
    
    NSMutableArray *baseArray = [NSMutableArray array];
    
    NSMutableArray *demoArray = [NSMutableArray array];
    
    [self.dataArray addObject:baseArray];
    
    [self.dataArray addObject:demoArray];
    
    [baseArray addObject:@{@"title" : @"显示一个默认的 alert 弹框" , @"content" : @""}];
 
    [baseArray addObject:@{@"title" : @"显示一个带输入框的 alert 弹框" , @"content" : @"可以添加多个输入框"}];
    
    [baseArray addObject:@{@"title" : @"显示一个不同顺序的 alert 弹框" , @"content" : @"设置的顺序决定了控件显示的顺序"}];
    
    [baseArray addObject:@{@"title" : @"显示一个带自定义视图的 alert 弹框" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"显示一个带" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"" , @"content" : @""}];
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
            .LeeItemInsets(UIEdgeInsetsMake(40, 0, 40, 10))
            .LeeContent(@"内容")
            .LeeItemInsets(UIEdgeInsetsMake(40, 30, 40, 10))
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeAction(@"确认", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 1:
        {
            [LEEAlert alert].config
            .LeeTitle(@"标题")
            .LeeContent(@"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框";
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeAction(@"确认", ^{
                
            })
            .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
                
                return CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .LeeShow();
        }
            break;
            
        case 2:
        {
            __block UITextField *tf = nil;
            
            [LEEAlert alert].config
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框";
                
                tf = textField;
            })
            .LeeContent(@"内容")
            .LeeTitle(@"标题")
            .LeeAction(@"好的", ^{
                
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"确认";
                
                action.isClickNotClose = YES;
                
                action.clickBlock = ^{
                  
                    [tf resignFirstResponder];
                };
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 3:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 100, 400)];
            
            view.backgroundColor = [UIColor colorWithRed:43/255.0f green:133/255.0f blue:208/255.0f alpha:1.0f];
            
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
            view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            [LEEAlert alert].config
            .LeeContent(@"内容")
            .LeeAddCustomView(^(LEECustomView *custom) {
                
                custom.view = view;
                
                custom.positionType = LEECustomViewPositionTypeRight;
            })
            .LeeTitle(@"标题")
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框";
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"确认";
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeShow();
        }
            break;
            
        case 4:
        {
            __block LEEAction *act = nil;
            
            [LEEAlert alert].config
            .LeeAddTextField(^(UITextField *textField) {
                
                textField.placeholder = @"输入框";
            })
            .LeeContent(@"内容")
            .LeeTitle(@"标题")
            .LeeAddAction(^(LEEAction *action) {
              
                action.title = @"没变";
                
                act = action;
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.title = @"确认";
                
                action.isClickNotClose = YES;
                
                action.clickBlock = ^{
                    
                    act.height = 100;
                    
                    act.title = @"变了";
                    
                    act.titleColor = [UIColor redColor];
                    
                    [act update];
                };
            })
            .LeeCancelAction(@"取消", ^{
                
            })
            .LeeShow();
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
