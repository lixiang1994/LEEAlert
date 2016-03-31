
/*!
 *  @header CustomViewController.m
 *          LEEAlertDemo
 *
 *  @brief  自定义Alert视图控制器
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/3/30.
 */

#import "CustomViewController.h"

#import "LEEAlert.h"

@interface CustomViewController ()<UITextFieldDelegate>

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化子视图
    
    [self initSubviews];

}

- (void)initSubviews{
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button1.frame = CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button1 setTitle:@"弹出自定义Alert" forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button2.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button2 setTitle:@"弹出自定义Alert" forState:UIControlStateNormal];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button3.frame = CGRectMake(20, 180, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button3 setTitle:@"弹出自定义Alert" forState:UIControlStateNormal];
    
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(button3Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button4.frame = CGRectMake(20, 240, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button4 setTitle:@"弹出自定义Alert" forState:UIControlStateNormal];
    
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button4 addTarget:self action:@selector(button4Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button5.frame = CGRectMake(20, 300, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button5 setTitle:@"弹出自定义Alert" forState:UIControlStateNormal];
    
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button5 addTarget:self action:@selector(button5Action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button5];
    
    
    UIView *redView=[[UIView alloc]initWithFrame:CGRectMake(0, 400, 320, 200)];
    
    redView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:redView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件

- (void)button1Action{
    
    //自定义 Alert 默认无取消按钮
    
    [LEEAlert alert].custom.config
    .title(@"1234")
    .content(@"abcdefg")
    .customAlertTouchClose()
    .show();
    
}

- (void)button2Action{
    
    //自定义 Alert 带取消按钮 取消事件
    
    [LEEAlert alert].custom.config
    .title(@"标题")
    .content(@"带取消按钮 取消事件")
    .cancelButtonTitle(@"确认")
    .cancelButtonAction(^(){
    
        NSLog(@"点击了取消按钮");
        
    })
    .customAlertViewBackGroundStypeBlur()
    .show();
    
}


- (void)button3Action{
    
    //自定义 Alert 自定义标题 两个自定义按钮
    
    [LEEAlert alert].custom.config
    .customTitle(^(UILabel *label){
    
        //自定义标题Label
        
        label.textColor = [UIColor redColor];
        
    })
    .title(@"自定义标题")
    .content(@"自定义内容")
    .customContent(^(UILabel *label){
        
        //自定义内容Label
        
        label.textColor = [UIColor greenColor];
        
    })
    .cancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
//    .addCustomButton(^(UIButton *button){
//    
//        //添加自定义按钮 设置按钮字体颜色为红色
//        
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        
//    })
    .addCustomButton(^(UIButton *button){
        
        //button为你添加的自定义按钮对象 , 这里可以随意自定义button对象的属性 , 但注意一点: 尽量不要修改button的frame属性 可能会造成位置错乱
        
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    })
    .show();
    
}


- (void)button4Action{
    
    //自定义 Alert
    
    [LEEAlert alert].custom.config
    .customTitle(^(UILabel *label){
        
        //自定义标题Label
        
        label.textColor = [UIColor redColor];
        
    })
    .title(@"自定义标题")
    .content(@"自定义内容")
    .customContent(^(UILabel *label){
        
        //自定义内容Label
        
        label.textColor = [UIColor greenColor];
        
    })
    .addTextField(^(UITextField *textField){
        
        textField.placeholder = @"输入框";
        
    })
    .addCustomButton(^(UIButton *button){
        
        //添加自定义按钮 设置按钮字体颜色为红色
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    })
    .addCustomButton(^(UIButton *button){
        
        //button为你添加的自定义按钮对象 , 这里可以随意自定义button对象的属性 , 但注意一点: 尽量不要修改buttonframe的y轴 可能会造成位置错乱 如果需要特殊样式的button 建议在customView中自行玩耍
        
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    })
    .show();

}

- (void)button5Action{
    
    //
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 240, 100)];
    
    customView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *customViewCloseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    customViewCloseButton.frame = CGRectMake(0, 0, 100, 30);
    
    [customViewCloseButton setTitle:@"关闭Alert" forState:UIControlStateNormal];
    
    [customViewCloseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [customViewCloseButton addTarget:self action:@selector(customViewCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:customViewCloseButton];
    
    
    [LEEAlert alert].custom.config
    .customTitle(^(UILabel *label){
        
        //自定义标题Label
        
        label.textColor = [UIColor redColor];
        
    })
    .title(@"自定义标题")
    .content(@"自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容")
    .customContent(^(UILabel *label){
        
        //自定义内容Label
        
        label.textColor = [UIColor greenColor];
        
    })
    .addTextField(^(UITextField *textField){
        
        textField.placeholder = @"输入框";
        
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.delegate = self;
        
    })
    .addTextField(^(UITextField *textField){
        
        textField.placeholder = @"输入框";
        
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.delegate = self;
        
    })
    .customView(customView)
    .addButton(@"添加的按钮" , ^(){
        
        NSLog(@"点击了添加的按钮");
        
    })
    .cancelButtonTitle(@"取消")
    .cancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .customCancelButton(^(UIButton *button){
    
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
    })
    .addCustomButton(^(UIButton *button){
        
        //添加自定义按钮 设置按钮字体颜色为红色
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    })
    .addCustomButton(^(UIButton *button){
        
        //button为你添加的自定义按钮对象 , 这里可以随意自定义button对象的属性 , 但注意一点: 尽量不要修改button的frame 可能会造成位置错乱 如果需要特殊样式的button 建议在customView中自行玩耍
        
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, CGRectGetWidth(button.frame) , 100);
        
    })
    .show();

    
}


#pragma mark - 自定义视图关闭按钮点击事件

- (void)customViewCloseButtonAction:(UIButton *)sender{
    
    //关闭自定义Alert
    
    [LEEAlert closeCustomAlert];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return NO;
}


@end
