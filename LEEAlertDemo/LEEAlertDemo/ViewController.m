
/*!
 *  @header ViewController.m
 *          LEEAlertDemo
 *
 *  @brief  系统Alert视图控制器
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/3/29.
 */

#import "ViewController.h"

#import "LEEAlert.h"

@interface ViewController ()

@property (nonatomic , copy ) NSString *firstText; //第一个文本输入框内容

@property (nonatomic , copy ) NSString *secondText; //第二个文本输入框内容

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化子视图
    
    [self initSubviews];
    
}

- (void)initSubviews{
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button1.frame = CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button1 setTitle:@"弹出系统Alert" forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button2.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button2 setTitle:@"弹出系统Alert" forState:UIControlStateNormal];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button3.frame = CGRectMake(20, 180, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button3 setTitle:@"弹出系统Alert" forState:UIControlStateNormal];
    
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(button3Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button4.frame = CGRectMake(20, 240, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button4 setTitle:@"弹出系统Alert" forState:UIControlStateNormal];
    
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button4 addTarget:self action:@selector(button4Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button5.frame = CGRectMake(20, 300, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button5 setTitle:@"弹出系统Alert" forState:UIControlStateNormal];
    
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button5 addTarget:self action:@selector(button5Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button5];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件

- (void)button1Action{
    
    //一个按钮 Alert
    
    //[LEEAlert shareAlert].system.config.title(@"标题").content(@"内容").cancelButtonTitle(@"取消").show();
    
    [LEEAlert alert]
    .system.config
    .title(@"标题")
    .content(@"内容")
    .cancelButtonTitle(@"取消")
    .show();
    
}

- (void)button2Action{
    
    //一个按钮 取消事件 Alert
    
//    [LEEAlert shareAlert].system.config.title(@"标题").content(@"内容").cancelButtonTitle(@"取消").cancelButtonAction(^(){  NSLog(@"点击了取消按钮");  }).show();

    [LEEAlert alert]
    .system.config
    .title(@"标题")
    .content(@"内容")
    .cancelButtonTitle(@"取消")
    .cancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .showFromViewController(self);
    
}


- (void)button3Action{
    
    //两个按钮 Alert
    
    [LEEAlert alert]
    .system.config
    .title(@"标题")
    .content(@"内容")
    .cancelButtonTitle(@"取消")
    .cancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .addButton(@"确认" , ^(){
    
        NSLog(@"点击了确认按钮");
    
    })
    .show();
    
}


- (void)button4Action{

    //多按钮 Alert
    
    [LEEAlert alert]
    .system.config
    .title(@"标题")
    .content(@"内容")
    .cancelButtonTitle(@"取消")
    .cancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .addButton(@"确认" , ^(){
        
        NSLog(@"点击了确认按钮");
        
    })
    .addButton(@"关注" , ^(){
        
        NSLog(@"点击了关注按钮");
        
    })
    .addButton(@"喜欢" , ^(){
        
        NSLog(@"点击了喜欢按钮");
        
    })
    .show();
    
}

- (void)button5Action{
    
    //多按钮 多输入框 Alert (系统类型的输入框个数建议在2个以下)
    
    [LEEAlert alert]
    .system.config
    .title(@"标题")
    .content(@"内容")
    .cancelButtonTitle(@"取消")
    .cancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .addButton(@"确认" , ^(){
        
        NSLog(@"点击了确认按钮 : %@ , %@" , self.firstText , self.secondText);
        
    })
    .addButton(@"关注" , ^(){
        
        NSLog(@"点击了关注按钮");
        
    })
    .addButton(@"喜欢" , ^(){
        
        NSLog(@"点击了喜欢按钮");
        
    })
    .addTextField(^(UITextField *textField){
        
        textField.placeholder = @"请输入LEE是帅比";
        
        //添加事件 获取文本输入框内容的改变
        
        [textField addTarget:self action:@selector(firstTextField:) forControlEvents:UIControlEventEditingChanged];
        
    })
    .addTextField(^(UITextField *textField){
        
        textField.placeholder = @"请输入LEE我爱你";
        
        //添加事件 获取文本输入框内容
        
        [textField addTarget:self action:@selector(secondTextField:) forControlEvents:UIControlEventEditingDidEnd];
        
    })
    .show();
    
}

- (void)firstTextField:(UITextField *)textField{
    
    self.firstText = textField.text;
    
    NSLog(@"第一个文本框内容 : %@" , textField.text);
    
}

- (void)secondTextField:(UITextField *)textField{
    
    self.secondText = textField.text;
    
    NSLog(@"第二个文本框内容 : %@" , textField.text);
    
}

@end
