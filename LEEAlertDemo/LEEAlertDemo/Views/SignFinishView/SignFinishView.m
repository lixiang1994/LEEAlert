//
//  SignFinishView.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/5/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SignFinishView.h"

#import "SDAutoLayout.h"

#import "LEEAlert.h"

@interface SignFinishView ()

@property (nonatomic , strong ) UIImageView *imageView; //图片

@property (nonatomic , strong ) UILabel *scoreLabel; // 分数

@property (nonatomic , strong ) UILabel *daysLabel; // 天数

@property (nonatomic , strong ) UILabel *descLabel; // 描述

@property (nonatomic , strong ) UIButton *openButton; // 打开按钮

@property (nonatomic , strong ) UIButton *colseButton; // 关闭按钮

@end

@implementation SignFinishView

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
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signbg"]];
    
    [self addSubview:_imageView];
    
    // 分数
    
    _scoreLabel = [[UILabel alloc] init];
    
    _scoreLabel.text = @"+5";
    
    _scoreLabel.textColor = [UIColor whiteColor];
    
    _scoreLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    
    [self.imageView addSubview:_scoreLabel];
    
    // 天数
    
    _daysLabel = [[UILabel alloc] init];
    
    _daysLabel.text = @"已成功签到1天";
    
    _daysLabel.textColor = [UIColor whiteColor];
    
    _daysLabel.font = [UIFont systemFontOfSize:14.0f];
    
    _daysLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.imageView addSubview:_daysLabel];
    
    // 描述
    
    _descLabel = [[UILabel alloc] init];
    
    _descLabel.text = @"积分可用于竞猜并参与抽奖";
    
    _descLabel.textColor = [UIColor blackColor];
    
    _descLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _descLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.imageView addSubview:_descLabel];
    
    // 设置按钮
    
    _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _openButton.sd_cornerRadius = @5.0f;
    
    [_openButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    
    [_openButton setTitle:@"去竞猜" forState:UIControlStateNormal];
    
    [_openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_openButton setBackgroundColor:[UIColor colorWithRed:34/255.0f green:129/255.0f blue:239/255.0f alpha:1.0f]];
    
    [_openButton addTarget:self action:@selector(openButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_openButton];
    
    // 关闭按钮
    
    _colseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _colseButton.highlighted = NO;
    
    _colseButton.sd_cornerRadiusFromWidthRatio = @.5f;
    
    _colseButton.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
    
    [_colseButton setImage:[UIImage imageNamed:@"infor_colse_image"] forState:UIControlStateNormal];
    
    [_colseButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_colseButton];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 图片
    
    self.imageView.sd_layout
    .topSpaceToView(self , 40.0f)
    .leftSpaceToView(self , 0.0f)
    .rightSpaceToView(self , 0.0f)
    .autoHeightRatio(1.07f);
    
    // 分数
    
    self.scoreLabel.sd_layout
    .topSpaceToView(self.imageView, 60.0f)
    .rightSpaceToView(self.imageView, 80.0f)
    .widthIs(50.0f)
    .heightIs(30.0f);
    
    // 天数
    
    self.daysLabel.sd_layout
    .topSpaceToView(self.imageView , 145.0f)
    .centerXEqualToView(self)
    .widthIs(150.0f)
    .heightIs(30.0f);
    
    // 描述
    
    self.descLabel.sd_layout
    .bottomSpaceToView(self.imageView, 25.0f)
    .leftSpaceToView(self.imageView, 20.0f)
    .rightSpaceToView(self.imageView, 20.0f)
    .heightIs(30.0f);
    
    // 打开按钮
    
    self.openButton.sd_layout
    .topSpaceToView(self.imageView , 10.0f)
    .leftSpaceToView(self , 15.0f)
    .rightSpaceToView(self , 15.0f)
    .heightIs(40.0f);
    
    // 关闭按钮
    
    self.colseButton.sd_layout
    .topSpaceToView(self , 10.0f)
    .rightSpaceToView(self , 10.0f)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    [self setupAutoHeightWithBottomView:self.openButton bottomMargin:20.0f];
}

#pragma mark - 打开按钮点击事件

- (void)openButtonAction:(UIButton *)sender{
    
    [LEEAlert closeWithCompletionBlock:^{
        
        // 打开XXX
        
    }];
    
}

#pragma mark - 关闭按钮点击事件

- (void)closeButtonAction:(UIButton *)sender{
    
    if (self.closeBlock) self.closeBlock();
}

@end
