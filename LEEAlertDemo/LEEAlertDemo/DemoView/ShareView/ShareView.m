
/*!
 *  @header ShareView.m
 *          LEEActionSheetDemo
 *
 *  @brief  分享视图
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/4/26.
 */

#import "ShareView.h"

#import "UIView+SDAutoLayout.h"

@interface ShareView ()

@property (nonatomic , strong ) NSArray *infoArray;

@property (nonatomic , strong ) NSMutableArray *buttonArray;

@end

@implementation ShareView

-(void)dealloc{
    
    _infoArray = nil;
    
    _buttonArray = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
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
    
    _infoArray = @[@{@"title" : @"微信" , @"image" : @"popup_share_weixing" , @"highlightedImage" : @"popup_share_weixing_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToWXFriend]} ,
                   
                   @{@"title" : @"微信朋友圈" , @"image" : @"popup_share_penyouquan" , @"highlightedImage" : @"popup_share_penyouquan_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToWXQuan]} ,
                   
                   @{@"title" : @"新浪微博" , @"image" : @"popup_share_sina" , @"highlightedImage" : @"popup_share_sina_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToSina]} ,
                   
                   @{@"title" : @"QQ好友" , @"image" : @"popup_share_qq" , @"highlightedImage" : @"popup_share_qq_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToQQFriend]} ,
                   
                   @{@"title" : @"QQ空间" , @"image" : @"popup_share_kongjian" , @"highlightedImage" : @"popup_share_kongjian_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToQZone]} ,
                   
                   @{@"title" : @"腾讯微博" , @"image" : @"popup_share_ten Weibo" , @"highlightedImage" : @"popup_share_ten Weibo_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToTencetnwb]}];
    
    _buttonArray = [NSMutableArray array];
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //循环初始化分享按钮
    
    for (NSDictionary *info in _infoArray) {
        
        ShareButton *button = [ShareButton buttonWithType:UIButtonTypeCustom];
        
        [button configTitle:info[@"title"] Image:[UIImage imageNamed:info[@"image"]]];
        
        [button setImage:[UIImage imageNamed:info[@"highlightedImage"]] forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [_buttonArray addObject:button];
    }
    
}


#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //使用SDAutoLayout循环布局分享按钮
    
    NSInteger lineNumber = ceilf((double)_infoArray.count / 3); //小数向上取整
    
    NSInteger singleCount = ceilf((double)_infoArray.count / lineNumber);
    
    CGFloat buttonWidth = self.width / singleCount;
    
    CGFloat buttonHeight = 100.0f;
    
    NSInteger index = 0;
    
    for (ShareButton *button in _buttonArray) {
        
        if (index == 0) {
            
            button.sd_layout
            .leftSpaceToView(self , 0)
            .topSpaceToView(self , 10)
            .widthIs(buttonWidth)
            .heightIs(buttonHeight);
            
        } else {
            
            if (index % singleCount == 0) {
                
                button.sd_layout
                .leftSpaceToView(self , 0)
                .topSpaceToView(_buttonArray[index - singleCount] , 10)
                .widthIs(buttonWidth)
                .heightIs(buttonHeight);
                
            } else {
                
                button.sd_layout
                .leftSpaceToView(_buttonArray[index - 1] , 0)
                .topEqualToView(_buttonArray[index - 1])
                .widthIs(buttonWidth)
                .heightIs(buttonHeight);
                
            }
            
        }
        
        index ++;
        
    }
    
    [self setupAutoHeightWithBottomView:_buttonArray.lastObject bottomMargin:10.0f];
    
}

#pragma mark - 分享按钮点击事件

- (void)shareButtonAction:(UIButton *)sender{
    
    NSInteger index = [self.buttonArray indexOfObject:sender];
    
    ShareType type = (ShareType)[self.infoArray[index][@"type"] integerValue];
    
    if (self.OpenShareBlock) {
        
        self.OpenShareBlock(type);
        
    }
    
}


@end

#pragma mark - -----------------分享按钮-----------------

@implementation ShareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _range = 10.0f;
        
    }
    return self;
}

- (void)setRange:(CGFloat)range{
    
    _range = range;
    
    [self layoutSubviews];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //图片
    
    CGPoint center = self.imageView.center;
    
    center.x = self.frame.size.width/2;
    
    center.y = self.imageView.frame.size.height/2;
    
    self.imageView.center = center;
    
    //修正位置
    
    CGRect imageFrame = [self imageView].frame;
    
    imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height - self.titleLabel.frame.size.height - _range ) / 2;
    
    self.imageView.frame = imageFrame;
    
    //标题
    
    CGRect titleFrame = [self titleLabel].frame;
    
    titleFrame.origin.x = 0;
    
    titleFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + _range;
    
    titleFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = titleFrame;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)configTitle:(NSString *)title Image:(UIImage *)image{
    
    [self setTitle:title forState:UIControlStateNormal];
    
    [self setImage:image forState:UIControlStateNormal];
    
}

@end
