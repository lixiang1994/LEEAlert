//
//  OpenPushView.m
//  Headlines
//
//  Created by 李响 on 2017/1/19.
//  Copyright © 2017年 ck. All rights reserved.
//

#import "OpenPushView.h"

#import "SDAutoLayout.h"

#import "LEEAlert.h"

@interface OpenPushView ()

@property (nonatomic , strong ) UIImageView *imageView; //图片

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UILabel *contentLabel; //内容

@property (nonatomic , strong ) UIButton *settingButton; //设置按钮

@property (nonatomic , strong ) UIButton *colseButton; //关闭按钮

@end

@implementation OpenPushView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
        
    }
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    // 图片
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"open_push_image"]];
    
    [self addSubview:_imageView];
    
    // 标题
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.text = @"第一时间获知重大新闻";
    
    _titleLabel.textColor = [UIColor blackColor];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
    
    // 内容
    
    _contentLabel = [[UILabel alloc] init];
    
    _contentLabel.text = @"及时获取";
    
    _contentLabel.textColor = [UIColor grayColor];
    
    _contentLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_contentLabel];
    
    // 设置按钮
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _settingButton.sd_cornerRadius = @5.0f;
    
    [_settingButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    [_settingButton setTitle:@"去设置" forState:UIControlStateNormal];
    
    [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_settingButton setBackgroundColor:[UIColor colorWithRed:190/255.0f green:40/255.0f blue:44/255.0f alpha:1.0f]];
    
    [_settingButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_settingButton];
    

    // 关闭按钮
    
    _colseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_colseButton setImage:[UIImage imageNamed:@"infor_colse_image"] forState:UIControlStateNormal];
    
    [_colseButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_colseButton];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 图片
    
    self.imageView.sd_layout
    .topSpaceToView(self , 40.0f)
    .leftSpaceToView(self , 20.0f)
    .rightSpaceToView(self , 20.0f)
    .autoHeightRatio(0.87f);
    
    // 标题
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.imageView , 10.0f)
    .centerXEqualToView(self)
    .widthIs(200.0f)
    .heightIs(30.0f);
    
    // 内容
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.titleLabel , 0.0f)
    .centerXEqualToView(self)
    .widthIs(200.0f)
    .heightIs(30.0f);
    
    // 设置按钮
    
    self.settingButton.sd_layout
    .topSpaceToView(self.contentLabel , 10.0f)
    .leftSpaceToView(self , 30.0f)
    .rightSpaceToView(self , 30.0f)
    .heightIs(40.0f);
    
    // 关闭按钮
    
    self.colseButton.sd_layout
    .topSpaceToView(self , 10.0f)
    .rightSpaceToView(self , 10.0f)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    [self setupAutoHeightWithBottomView:self.settingButton bottomMargin:20.0f];
}

#pragma mark - 设置按钮点击事件

- (void)settingButtonAction:(UIButton *)sender{
    
    [LEEAlert closeWithCompletionBlock:^{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
}

#pragma mark - 关闭按钮点击事件

- (void)closeButtonAction:(UIButton *)sender{
    
    if (self.closeBlock) self.closeBlock();
}

@end
