//
//  FontSizeView.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/7/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "FontSizeView.h"

#import "SDAutoLayout.h"

#import "LEEAlert.h"

@interface FontSizeView ()

@property (nonatomic , strong ) UIButton *decreaseButton; //减少按钮

@property (nonatomic , strong ) UISlider *slider;

@property (nonatomic , strong ) UIButton *increaseButton; //增加按钮

@property (nonatomic , strong ) NSArray *promptInfoArray; //提示信息数组

@property (nonatomic , strong ) NSMutableArray *promptLabelArray; //提示Label数组

@end

@implementation FontSizeView
{
    NSInteger currentIndex; //当前下标
}

- (void)dealloc{
    
    _decreaseButton = nil;
    
    _slider = nil;
    
    _increaseButton = nil;
}

#pragma mark - 初始化

- (instancetype)init{
    
    self = [super init];
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
    
    _promptInfoArray = @[@"小",@"中",@"大",@"特大",@"巨大"];

    _promptLabelArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0f];
 
    currentIndex = 1;
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //初始化减小按钮
    
    _decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_decreaseButton setImage:[UIImage imageNamed:@"infor_poptypebar_wordsmall"] forState:UIControlStateNormal];
    
    [_decreaseButton addTarget:self action:@selector(decreaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_decreaseButton];
    
    //初始化slider
    
    _slider = [[UISlider alloc] init];
    
    [_slider setThumbImage:[UIImage imageNamed:@"infor_poptypebar_slider"] forState:UIControlStateNormal];
    
    [_slider setMaximumTrackTintColor:[UIColor clearColor]];
    
    [_slider setMinimumTrackTintColor:[UIColor clearColor]];
    
    [_slider setMinimumValue:0];
    
    [_slider setMaximumValue:_promptInfoArray.count - 1];
    
    [_slider setValue: currentIndex];
    
    [_slider addTarget:self action:@selector(sliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self addSubview:_slider];
    
    //初始化增加按钮
    
    _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_increaseButton setImage:[UIImage imageNamed:@"infor_poptypebar_wordbig"] forState:UIControlStateNormal];
    
    [_increaseButton addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_increaseButton];

    //循环创建提示label 和 分段线
    
    [_promptInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger i, BOOL * _Nonnull stop) {
       
        //初始化
        
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = [UIColor grayColor];
        
        label.font = [UIFont systemFontOfSize:14.0f];
        
        label.text = title;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.alpha = currentIndex == i ? 1.0f : 0.0f;
        
        [self addSubview:label];
        
        [self.promptLabelArray addObject:label];
    }];

}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    self.width = CGRectGetHeight([[UIScreen mainScreen] bounds]) > CGRectGetWidth([[UIScreen mainScreen] bounds]) ? CGRectGetWidth([[UIScreen mainScreen] bounds]) : CGRectGetHeight([[UIScreen mainScreen] bounds]);
    
    self.height = 140.0f;
    
    //减少按钮
    
    _decreaseButton.sd_layout
    .leftSpaceToView(self , 10)
    .topSpaceToView(self , 60)
    .widthIs(40)
    .heightIs(40);
    
    //增加按钮
    
    _increaseButton.sd_layout
    .rightSpaceToView(self , 10)
    .topSpaceToView(self , 60)
    .widthIs(40)
    .heightIs(40);
    
    //slider
    
    _slider.sd_layout
    .centerYEqualToView(_decreaseButton)
    .leftSpaceToView(_decreaseButton , 5)
    .rightSpaceToView(_increaseButton , 5)
    .heightIs(20);
    
    //绘制slider线
    
    __weak typeof(self) weakSelf = self;
    
    [self.slider updateLayout];
    
    CGFloat lineWith = self.slider.width - 22;
    
    UIBezierPath *rootPath = [UIBezierPath bezierPath];
    
    [rootPath moveToPoint:CGPointMake(0, 0)];
    
    [rootPath addLineToPoint:CGPointMake(0, 6)];
    
    [rootPath addLineToPoint:CGPointMake(lineWith, 6)];
    
    [rootPath addLineToPoint:CGPointMake(lineWith, 0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.frame = CGRectMake(11, 4, lineWith, 6);
    
    shapeLayer.path = rootPath.CGPath;
    
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.slider.layer insertSublayer:shapeLayer atIndex:0];
    
    CGFloat offset = lineWith / (self.promptInfoArray.count - 1);
    
    NSInteger i = 1;
    
    while (offset * i != lineWith) {
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        [linePath moveToPoint:CGPointMake(offset * i , 0)];
        
        [linePath addLineToPoint:CGPointMake(offset * i , 6)];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        
        lineLayer.path = linePath.CGPath;
        
        lineLayer.strokeColor = [UIColor grayColor].CGColor;
        
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        
        [shapeLayer insertSublayer:lineLayer atIndex:0];
        
        i++;
    }
    
    //循环布局提示Label
    
    [self.promptLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL * _Nonnull stop) {
        
        if (weakSelf) {
            
            NSInteger centerX = (weakSelf.slider.left + 11) + offset * index;
            
            if (index) {
                
                label.sd_layout
                .bottomSpaceToView(weakSelf.slider , 5.0f)
                .centerXIs(centerX)
                .widthIs(30.0f)
                .heightIs(20.0f);
                
            } else {
                
                label.sd_layout
                .bottomSpaceToView(weakSelf.slider , 5.0f)
                .centerXIs(centerX)
                .widthIs(30.0f)
                .heightIs(20.0f);
            }
            
        }
        
    }];
    
}

#pragma mark - 减小按钮点击事件

- (void)decreaseButtonAction:(UIButton *)sender{
    
    self.slider.value -= 1;
    
    [self sliderChangeAction:self.slider];
    
    //设置字体大小
    
    [self configFontSize];
}

#pragma mark - 增加按钮点击事件

- (void)increaseButtonAction:(UIButton *)sender{
    
    self.slider.value += 1;
    
    [self sliderChangeAction:self.slider];
    
    //设置字体大小
    
    [self configFontSize];
}

#pragma mark - slider事件

- (void)sliderAction:(UISlider *)slider{
    
    [slider setValue:[[self numberFormat:slider.value] floatValue] animated:YES];
    
    //设置字体大小
    
    [self configFontSize];
}

#pragma mark - slider改变事件

- (void)sliderChangeAction:(UISlider *)slider{
    
    [self.promptLabelArray[currentIndex] setAlpha:0.0f];
    
    currentIndex = [[self numberFormat:slider.value] integerValue];
    
    [self.promptLabelArray[currentIndex] setAlpha:1.0f];
}

#pragma mark - 设置字体大小

- (void)configFontSize{
    
    int sliderValue = (int)self.slider.value;
    
    if (self.changeBlock) self.changeBlock(sliderValue);
}

/**
 *  四舍五入
 *
 *  @param num 待转换数字
 *
 *  @return 转换后的数字
 */
- (NSString *)numberFormat:(CGFloat)num{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setPositiveFormat:@"0"];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

@end
