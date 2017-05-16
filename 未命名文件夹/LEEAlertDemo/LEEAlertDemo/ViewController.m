//
//  ViewController.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/3/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"

#import "LEEAlert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self alert1WithTitle:@"yyyyyy"];
    
//    [self alert1WithTitle:@"eeeeeee"];
    
    [self alert2];
    
    [self alert2];
    
    [self actionsheet1];
}

- (void)alert1WithTitle:(NSString *)title{
    
    [LEEAlert alert].config
    .LeeAction(^(LEEAction *action) {
      
        action.title = @"一";
        
        action.titleColor = [UIColor grayColor];
        
        action.clickBlock = ^{
          
            [LEEAlert closeWithCompletionBlock:^{

                NSLog(@"关闭完成");
            }];
            
            [LEEAlert closeWithCompletionBlock:^{
                
                NSLog(@"关闭完成");
            }];
            
            [self alert1WithTitle:@"aaaaaaaa"];
            
            [self alert1WithTitle:@"BBBBBBBBB"];
            
            NSLog(@"点击了1");
        };
        
    })
    .LeeAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = @"二";
        
        action.titleColor = [UIColor grayColor];
        
        action.clickBlock = ^{
            
            NSLog(@"点击了2");
        };
        
    })
    .LeeAction(^(LEEAction *action) {
        
        action.title = @"三";
        
        action.titleColor = [UIColor grayColor];
        
        action.clickBlock = ^{
            
            NSLog(@"点击了3");
        };
        
    })
    .LeeAddTextField(^(UITextField *textField) {
        
        
    })
//    .LeeTitle(title)
    .LeeAddContent(^(UILabel *label){
        
        label.frame = CGRectMake(0, 0, 0, 100);
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = @"哈哈内容内容内容内容内容内容内容";
        
        label.textColor = [UIColor redColor];
        
        label.numberOfLines = 0;
    })
    .LeeAddTitle(^(UILabel *label){
        
        label.frame = CGRectMake(0, 0, 0, 100);
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = title;
        
        label.textColor = [UIColor redColor];
    })
    
    .LeeAddTitle(^(UILabel *label){
        
        label.frame = CGRectMake(0, 0, 0, 100);
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = title;
        
        label.textColor = [UIColor redColor];
    })
    .LeeAddQueue()
    .LeeShow();
}

- (void)alert2{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    
    view.backgroundColor = [UIColor redColor];
    
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeAction(^(LEEAction *action) {
        
        action.title = @"一";
        
        action.titleColor = [UIColor grayColor];
        
        action.clickBlock = ^{
            
            [LEEAlert closeWithCompletionBlock:^{
                
                NSLog(@"关闭完成");
            }];
            
            [LEEAlert closeWithCompletionBlock:^{
                
                NSLog(@"关闭完成");
            }];
            
            NSLog(@"点击了1");
        };
        
    })
    .LeeAddQueue()
    .LeeShow();
}

- (void)actionsheet1{
 
    [LEEAlert actionsheet].config
    .LeeTitle(@"标题标题标题")
    .LeeContent(@"内容哈哈内容内容内容内容内容内容内容内容内容")
    .LeeAction(^(LEEAction *action) {
        
        action.title = @"一";
        
        action.clickBlock = ^{
          
            [LEEAlert closeWithCompletionBlock:^{
               
                NSLog(@"关闭完成");
            }];
            
//            [self alert1];
//            
//            [self alert1];
        };
    })
    .LeeAction(^(LEEAction *action) {
     
        action.type = LEEActionTypeCancel;
    
        action.title = @"取消";
    })
    .LeeClickBackgroundClose()
    .LeeShow();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
