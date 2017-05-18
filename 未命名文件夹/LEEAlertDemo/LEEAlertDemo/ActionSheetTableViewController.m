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
    
    [self.dataArray addObject:@{@"title" : @"显示一个默认的 actionSheet 菜单" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"显示一个带取消按钮的 actionSheet 菜单" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"显示一个不同顺序的 actionSheet 菜单" , @"content" : @"设置的顺序决定了控件显示的顺序"}];
    
    [self.dataArray addObject:@{@"title" : @"显示一个带有自定义视图的 actionSheet 菜单" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"" , @"content" : @""}];
    
    [self.dataArray addObject:@{@"title" : @"" , @"content" : @""}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *info = self.dataArray[indexPath.row];
    
    cell.textLabel.text = info[@"title"];
    
    cell.detailTextLabel.text = info[@"content"];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
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
            
            [LEEAlert actionsheet].config
            .LeeContent(@"内容")
            .LeeTitle(@"标题")
            .LeeCustomView(view)
            .LeeAction(@"确认1", ^{
                
            })
            .LeeAction(@"确认2", ^{
                
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
