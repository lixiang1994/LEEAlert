
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
{
    
    UILabel *contentLabel;
    
    UITextField *contentTextField;
    
}

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
    
    
    UIView *redView=[[UIView alloc]initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.view.frame), 200)];
    
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
//    .LeeTitle(@"标题")
    .LeeContent(@"自定义 Alert 内容")
    .LeeCustomAlertTouchClose()
    .LeeShow();
    
    //自定义的Alert 以 [LEEAlert alert].custom.config 开头 含义为 [初始化一个LEEAlert].类型.设置
    //自定义Alert 如果不设置取消按钮(包括标题,点击事件,自定义取消按钮) 默认是不会有取消按钮的, 不过这样就可能无法关闭
    //上面我添加了点击Alert背景关闭的设置.customAlertTouchClose() 为了方便演示.
    
}

- (void)button2Action{
    
    //自定义 Alert 带取消按钮 取消事件
    
    [LEEAlert alert].custom.config
    .LeeTitle(@"标题")
    .LeeContent(@"带取消按钮 取消事件")
    .LeeCustomContent(^(UILabel *label){
        
        //自定义内容Label
        
        label.textColor = [UIColor lightGrayColor];
        
    })
    .LeeCancelButtonTitle(@"确认")
    .LeeCancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeCustomAlertViewBackGroundStypeBlur(0.6f)
    .LeeCustomAlertViewBackGroundColor([UIColor whiteColor])
    .LeeShow();
    
}


- (void)button3Action{
    
    //自定义 Alert 自定义标题 两个自定义按钮
    
    [LEEAlert alert].custom.config
    .LeeCustomTitle(^(UILabel *label){
        
        //这里可以随意标题Label (不过不建议乱改frame属性)
        
//        label.font = [UIFont systemFontOfSize:16.0f];
        
    })
    .LeeTitle(@"自定义标题")
    .LeeContent(@"自定义内容")
    .LeeCustomContent(^(UILabel *label){
        
        //自定义内容Label
        
        label.textColor = [UIColor lightGrayColor];
        
    })
    .LeeCancelButtonAction(^(){
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeAddCustomButton(^(UIButton *button){
        
        //button为你添加的自定义按钮对象 , 这里可以随意自定义button对象的属性 , 但注意一点: 尽量不要修改button的frame属性 可能会造成位置错乱
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    })
    .LeeShow();
    
    /*
     不需要可以直接注释掉 整体看下来就是整个Alert的代码是由一个一个的小模块组成 就像是一辆火车,只要有车头和车尾,中间随便你扔多少车厢都能跑起来.
     这里自定义Alert上采用的布局方式与系统风格相同, 如果同时存在两个按钮,那么会水平排列, 如果存在一个或三个以上那么会垂直排列.
     如果你觉得默认的布局无法满足你的需求, 建议使用customView(自定义的视图)方式来实现.
     */
    
}


- (void)button4Action{
    
    //演示提示框输入内容为空 提交按钮点击内容部分会提示并不关闭提示框 , 输入内容不为空时点击提交按钮则关闭提示框并打印输入的内容.
    
    [LEEAlert alert].custom.config
    .LeeTitle(@"自定义标题")
    .LeeContent(@"自定义内容")
    .LeeCustomContent(^(UILabel *label){
        
        contentLabel = label;
        
    })
    .LeeAddTextField(^(UITextField *textField){
        
        //添加输入框 并进行自定义设置
        
        textField.placeholder = @"输入框";
        
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.delegate = self;
        
        contentTextField = textField;
        
    })
    .LeeCancelButtonTitle(@"取消")
    .LeeAddCustomButton(^(UIButton *button){
        
        [button setTitle:@"提交" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(submitbButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    })
    .LeeCustomButtonClickNotClose()
    .LeeShow();
    
}

-(void)submitbButtonAction:(UIButton *)sender{
    
    NSString *contentTextFieldString = contentTextField.text;
    
    if (contentTextFieldString.length > 0) {
        
        NSLog(@"输入的内容: %@" , contentTextFieldString);
        
        //关闭自定义Alert
        
        [LEEAlert closeCustomAlert];
        
    } else {
        
        //设置内容提示文字
        
        contentLabel.text = @"不能为空";
        
    }
    
}

- (void)button5Action{
    
    /**
     下面为全部自定义设置方法的演示说明
     */
    
    //初始化一个自定义视图
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 240, 100)];
    
    customView.backgroundColor = [UIColor grayColor];
    
    UIButton *customViewCloseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    customViewCloseButton.frame = CGRectMake(0, 0, 90, 30);
    
    [customViewCloseButton setBackgroundColor:[UIColor lightGrayColor]];
    
    [customViewCloseButton setTitle:@"关闭Alert" forState:UIControlStateNormal];
    
    [customViewCloseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [customViewCloseButton addTarget:self action:@selector(customViewCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:customViewCloseButton];
    
    UIButton *customViewChangeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    customViewChangeButton.frame = CGRectMake(90, 0, 150, 30);
    
    [customViewChangeButton setBackgroundColor:[UIColor blackColor]];
    
    [customViewChangeButton setTitle:@"改变自定义视图大小" forState:UIControlStateNormal];
    
    [customViewChangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [customViewChangeButton addTarget:self action:@selector(customViewChangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:customViewChangeButton];
    
    
    //使用自定义Alert
    
    [LEEAlert alert].custom.config
    .LeeCustomTitle(^(UILabel *label){
        
        //自定义标题Label
        
    })
    .LeeTitle(@"自定义标题")    //添加标题
    .LeeContent(@"自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容自定义内容")   //添加内容
    .LeeCustomContent(^(UILabel *label){
        
        //自定义内容Label
        
    })
    .LeeAddTextField(^(UITextField *textField){
        
        //添加一个输入框 自定义textField
        
        textField.placeholder = @"输入框";
        
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.delegate = self;
        
    })
    .LeeAddTextField(^(UITextField *textField){
        
        //添加一个输入框 自定义textField
        
        textField.placeholder = @"输入框";
        
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.delegate = self;
        
    })
    .LeeCustomView(customView) //添加自定义视图
    .LeeAddButton(@"添加的按钮" , ^(){
        
        //添加按钮 传入按钮标题 和点击事件的Block
        
        NSLog(@"点击了添加的按钮");
        
    })
    .LeeCancelButtonTitle(@"取消")   //设置取消按钮标题
    .LeeCancelButtonAction(^(){
        
        //获取取消按钮点击事件
        
        NSLog(@"点击了取消按钮");
        
    })
    .LeeCustomCancelButton(^(UIButton *button){
        
        //自定义取消按钮
        
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
    })
    .LeeAddCustomButton(^(UIButton *button){
        
        //添加自定义按钮 设置按钮字体颜色为红色(演示用)
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    })
    .LeeAddCustomButton(^(UIButton *button){
        
        //button为你添加的自定义按钮对象 , 这里可以随意自定义button对象的属性 , 但注意一点: 尽量不要修改button的frame 可能会造成位置错乱
        //如果需要特殊样式的button 建议在customView中自行玩耍
        
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    })
    .LeeCustomCornerRadius(20.0f)  //设置自定义Alert的圆角半径 默认为 10
    .LeeCustomAlertMaxWidth(280.0f)   //设置自定义Alert的最大宽度 默认为 280 (也就是最小设备屏幕宽度 320 去除两边20的间距)
    .LeeCustomAlertMaxHeight(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 50)   //设置自定义Alert的最大高度 默认为屏幕高度的80%
    .LeeCustomSubViewMargin(10.0f)  //设置自定义Alert的子控件上下边距 默认为 10
    .LeeCustomTopSubViewMargin(20.0f)   //设置自定义Alert的第一个子控件距离Alert上边缘的边距 默认 20
    .LeeCustomBottomSubViewMargin(20.0f)   //设置自定义Alert的最后一个子控件距离Alert下边缘的边距 (如果有按钮存在 则是距离按钮部分的边距) 默认 20
    .LeeCustomLeftSubViewMargin(20.0f)   //设置自定义ActionSheet的子控件距离左侧边缘间距 //默认为20
    .LeeCustomRightSubViewMargin(20.0f)   //设置自定义ActionSheet的子控件距离右侧边缘间距 //默认为20
    .LeeCustomAlertOpenAnimationDuration(0.3f)   //设置自定义Alert的打开动画效果时长 默认0.3秒
    .LeeCustomAlertCloseAnimationDuration(0.2f)   //设置自定义Alert的关闭动画效果时长 默认0.2秒
    .LeeCustomAlertViewColor([UIColor whiteColor])   //设置自定义Alert的颜色 默认为白色
    .LeeCustomAlertViewBackGroundColor([UIColor blackColor])   //设置自定义Alert的半透明或者模糊的背景渲染颜色
    .LeeCustomAlertTouchClose()   //设置自定义Alert的背景点击关闭功能
    .LeeCustomButtonClickNotClose()   //设置自定义Alert的自定义按钮点击不关闭Alert
//    .LeeCustomAlertViewBackGroundStypeTranslucent(0.6f) //设置自定义Alert的背景样式为半透明样式 并传入透明度 默认为0.6f;
    .LeeCustomAlertViewBackGroundStypeBlur(0.6f)   //设置自定义Alert的背景样式为高斯模糊样式 并传入透明度 默认为0.6f (如果不设置这项 默认为半透明样式 0.6f透明度)
    .LeeShow();    //显示Alert
    
    //补充说明: 自定义Alert的标题 内容 自定义视图 文本输入框 这些设置时默认会有先后顺序之分 , 如果你先设置了自定义视图 再设置了标题, 那么实际效果是自定义视图会在标题上面 以此类推 这样垂直排列下来, 遵守系统布局风格, 默认样式只能添加一个标题 一个内容 一个自定义视图 一堆按钮 或一堆输入框, 其中按钮的位置为最下方.
    
}


#pragma mark - 自定义视图关闭按钮点击事件

- (void)customViewCloseButtonAction:(UIButton *)sender{
    
    //关闭自定义Alert
    
    [LEEAlert closeCustomAlert];
    
}

#pragma mark - 自定义视图改变按钮点击事件

- (void)customViewChangeButtonAction:(UIButton *)sender{
    
    UIView *customView = sender.superview;
    
    CGRect customViewFrame = customView.frame;
    
    if (customViewFrame.size.height == 200) {
        
        customViewFrame.size.height = 100;
        
    } else {
        
        customViewFrame.size.height = 200;
    }
    
    customView.frame = customViewFrame;
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return NO;
}


@end
