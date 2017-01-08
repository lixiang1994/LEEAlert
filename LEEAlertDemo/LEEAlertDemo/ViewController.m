
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
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()

@property (nonatomic , copy ) NSString *firstText; //第一个文本输入框内容

@property (nonatomic , copy ) NSString *secondText; //第二个文本输入框内容

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    .LeeTitle(@"标题")
    .LeeContent(@"内容")
    .LeeShow();
    
    //可以不设置取消按钮的标题 默认为"取消",标题和内容这两个最基本的参数建议不要不设置. 最后结尾调用.show()来显示Alert
    
}

- (void)button2Action{
    
    //一个按钮 取消事件 Alert
    
    //    [LEEAlert shareAlert].system.config.title(@"标题").content(@"内容").cancelButtonTitle(@"取消").cancelButtonAction(^(){  NSLog(@"点击了取消按钮");  }).show();
    
    [LEEAlert alert]
    .system.config
    .LeeTitle(@"标题")
    .LeeContent(@"内容")
    .LeeCancelButtonTitle(@"取消")
    .LeeCancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeShowFromViewController(self);
    
    //如果需要获取取消按钮的点击事件 可以添加.cancelButtonAction(^(){})方法 在block块内可以添加点击后你要做的事. 当然取消按钮的标题也开始随你更改.
    
}


- (void)button3Action{
    
    //两个按钮 Alert
    
    [LEEAlert alert]
    .system.config
    .LeeTitle(@"标题")
    .LeeContent(@"内容")
    //.cancelButtonTitle(@"取消") //暂时不需要可以直接注释掉,是不是很方便
    .LeeCancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeAddButton(@"确认" , ^(){
        
        NSLog(@"点击了确认按钮");
        
    })
    .LeeShow();
    
    //一个按钮不够? 再加几个都可以,这里系统风格样式是2个按钮会左右水平排列,1个或3个以上按钮是上下垂直排列 ╮(╯▽╰)╭这个好像不用我来说
    
}


- (void)button4Action{
    
    //多按钮 Alert
    
    [LEEAlert alert]
    .system.config
    .LeeTitle(@"标题")
    .LeeContent(@"内容")
    .LeeCancelButtonTitle(@"取消")
    .LeeCancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeAddButton(@"确认" , ^(){
        
        NSLog(@"点击了确认按钮");
        
    })
    .LeeAddButton(@"关注" , ^(){
        
        NSLog(@"点击了关注按钮");
        
    })
    .LeeAddButton(@"喜欢" , ^(){
        
        NSLog(@"点击了喜欢按钮");
        
    })
    .LeeShow();
    
    //同上, 各种加.
    
}

- (void)button5Action{
    
    //多按钮 多输入框 Alert (系统类型的输入框个数建议在2个以下)
    
    [LEEAlert alert]
    .system.config
    .LeeTitle(@"标题")
    .LeeContent(@"内容")
    .LeeCancelButtonTitle(@"取消")
    .LeeCancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeAddButton(@"确认" , ^(){
        
        NSLog(@"点击了确认按钮 : \n输入了:%@ , %@" , self.firstText , self.secondText);
        
    })
    .LeeAddButton(@"关注" , ^(){
        
        NSLog(@"点击了关注按钮");
        
    })
    .LeeAddButton(@"喜欢" , ^(){
        
        NSLog(@"点击了喜欢按钮");
        
    })
    .LeeAddTextField(^(UITextField *textField){
        
        textField.placeholder = @"请输入LEE是帅比";
        
        //添加事件 获取文本输入框内容的改变
        
        [textField addTarget:self action:@selector(firstTextField:) forControlEvents:UIControlEventEditingChanged];
        
    })
    .LeeAddTextField(^(UITextField *textField){
        
        textField   .placeholder = @"请输入LEE我爱你";
        
        //添加事件 获取文本输入框内容
        
        [textField addTarget:self action:@selector(secondTextField:) forControlEvents:UIControlEventEditingDidEnd];
        
    })
    .LeeShow();
    //添加文本输入框,这里值得强调一点,iOS8以下系统用到的是UIAlertView,所以建议遵循系统Alert规则 添加2个以下的输入框. 如果你需要更多,建议使用自定义Alert
    //添加文本输入框的block中可以获取textField对象,当然拿到对象后你可以进行一大坨的设置,不过不要忘记这是基于系统Alert封装的,所以有一些属性是改了也没用的,比如Frame..
    //还是那句话 如果系统类型的Alert满足不了你的需求,请移步自定义Alert区,那里异常奔放.
    
    
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
