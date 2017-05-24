
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

#import "SDAutoLayout.h"

@interface ShareView () <UIScrollViewDelegate>

@property (nonatomic , strong ) UIScrollView *scrollView;

@property (nonatomic , strong ) UIPageControl *pageControl;

@property (nonatomic , strong ) NSArray *infoArray;

@property (nonatomic , strong ) NSMutableArray *buttonArray;

@property (nonatomic , strong ) NSMutableArray *pageViewArray;

@end

@implementation ShareView
{
    NSInteger lineMaxNumber; //最大行数
    
    NSInteger singleMaxCount; //单行最大个数
}

- (void)dealloc{
    
    _scrollView = nil;
    
    _pageControl = nil;
    
    _infoArray = nil;
    
    _buttonArray = nil;
    
    _pageViewArray = nil;
}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
                    InfoArray:(NSArray *)infoArray
                MaxLineNumber:(NSInteger)maxLineNumber
               MaxSingleCount:(NSInteger)maxSingleCount{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _infoArray = infoArray;
        
        _buttonArray = [NSMutableArray array];
        
        _pageViewArray = [NSMutableArray array];
        
        lineMaxNumber = maxLineNumber;
        
        singleMaxCount = maxSingleCount;
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    return [self initWithFrame:frame InfoArray:nil MaxLineNumber:0 MaxSingleCount:0];
}

#pragma mark - 初始化数据

- (void)initData{
    
    //非空判断 设置默认数据
    
    if (!_infoArray) {
        
        _infoArray = @[
                       @{@"title" : @"微信" , @"image" : @"popup_share_weixing" , @"highlightedImage" : @"popup_share_weixing_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToWXFriend]} ,
                       
                       @{@"title" : @"微信朋友圈" , @"image" : @"popup_share_penyouquan" , @"highlightedImage" : @"popup_share_penyouquan_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToWXQuan]} ,
                       
                       /** 多复制几个 用来演示分页 */
                       
                       @{@"title" : @"新浪微博" , @"image" : @"popup_share_sina" , @"highlightedImage" : @"popup_share_sina_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToSina]} ,
                       
                       @{@"title" : @"QQ好友" , @"image" : @"popup_share_qq" , @"highlightedImage" : @"popup_share_qq_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToQQFriend]} ,
                       
                       @{@"title" : @"QQ空间" , @"image" : @"popup_share_kongjian" , @"highlightedImage" : @"popup_share_kongjian_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToQZone]} ,
                       
                       /** 结束 */
//                       
                       @{@"title" : @"新浪微博" , @"image" : @"popup_share_sina" , @"highlightedImage" : @"popup_share_sina_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToSina]} ,
//
                       @{@"title" : @"QQ好友" , @"image" : @"popup_share_qq" , @"highlightedImage" : @"popup_share_qq_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToQQFriend]} ,
//
                       @{@"title" : @"QQ空间" , @"image" : @"popup_share_kongjian" , @"highlightedImage" : @"popup_share_kongjian_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToQZone]} ,
                       
                       @{@"title" : @"腾讯微博" , @"image" : @"popup_share_ten Weibo" , @"highlightedImage" : @"popup_share_ten Weibo_night" , @"type" : [NSNumber numberWithInteger:ShareTypeToTencetnwb]}];
        
    }
    
    lineMaxNumber = lineMaxNumber > 0 ? lineMaxNumber : 2;
    
    singleMaxCount = singleMaxCount > 0 ? singleMaxCount : 3;
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //初始化滑动视图
    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _scrollView.delegate = self;
    
    _scrollView.bounces = YES;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    
    //初始化pageControl
    
    _pageControl = [[UIPageControl alloc] init];
    
    _pageControl.currentPage = 0;
    
    _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [self addSubview:_pageControl];
    
    //循环初始化分享按钮
    
    NSInteger index = 0;
    
    UIView *pageView = nil;
    
    for (NSDictionary *info in _infoArray) {
        
        //判断是否需要分页
        
        if (index % (lineMaxNumber * singleMaxCount) == 0) {
            
            //初始化页视图
            
            pageView = [[UIView alloc] init];
            
            [_scrollView addSubview:pageView];
            
            [_pageViewArray addObject:pageView];
            
        }
        
        //初始化按钮
        
        ShareButton *button = [ShareButton buttonWithType:UIButtonTypeCustom];
        
        [button configTitle:info[@"title"] Image:[UIImage imageNamed:info[@"image"]]];
        
        [button setImage:[UIImage imageNamed:info[@"highlightedImage"]] forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [pageView addSubview:button];
        
        [_buttonArray addObject:button];
        
        index++;
        
    }
    
    //设置总页数
    
    _pageControl.numberOfPages = _pageViewArray.count > 1 ? _pageViewArray.count : 0;
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //使用SDAutoLayout循环布局分享按钮
    
    NSInteger lineNumber = ceilf((double)_infoArray.count / singleMaxCount); //所需行数 小数向上取整
    
    NSInteger singleCount = ceilf((double)_infoArray.count / lineNumber); //单行个数 小数向上取整
    
    singleCount = singleCount >= _infoArray.count ? singleCount : singleMaxCount ; //处理单行个数
    
    CGFloat buttonWidth = self.width / singleCount;
    
    CGFloat buttonHeight = 100.0f;
    
    NSInteger index = 0;
    
    NSInteger currentPageCount = 0;
    
    UIView *pageView = nil;
    
    for (ShareButton *button in _buttonArray) {
        
        //判断是否分页
        
        if (index % (lineMaxNumber * singleMaxCount) == 0) {
            
            pageView = _pageViewArray[currentPageCount];
            
            //布局页视图
            
            if (currentPageCount == 0) {
                
                pageView.sd_layout
                .leftSpaceToView(_scrollView , 0)
                .topSpaceToView(_scrollView , 0)
                .rightSpaceToView(_scrollView , 0)
                .heightIs((lineNumber > lineMaxNumber ? lineMaxNumber : lineNumber ) * buttonHeight);
                
            } else {
                
                pageView.sd_layout
                .leftSpaceToView(_pageViewArray[currentPageCount - 1] , 0)
                .topSpaceToView(_scrollView , 0)
                .widthRatioToView(_pageViewArray[currentPageCount - 1] , 1)
                .heightRatioToView(_pageViewArray[currentPageCount - 1] , 1);
            }
            
            currentPageCount ++;
        }
        
        //布局按钮
        
        if (index == 0) {
            
            button.sd_layout
            .leftSpaceToView(pageView , 0)
            .topSpaceToView(pageView , 0)
            .widthIs(buttonWidth)
            .heightIs(buttonHeight);
            
        } else {
            
            if (index % singleCount == 0) {
                
                //判断是否分页 如果分页 重新调整按钮布局参照
                
                if (index % (lineMaxNumber * singleMaxCount) == 0) {
                    
                    button.sd_layout
                    .leftSpaceToView(pageView , 0)
                    .topSpaceToView(pageView , 0)
                    .widthIs(buttonWidth)
                    .heightIs(buttonHeight);
                    
                } else {
                    
                    button.sd_layout
                    .leftSpaceToView(pageView , 0)
                    .topSpaceToView(_buttonArray[index - singleCount] , 0)
                    .widthIs(buttonWidth)
                    .heightIs(buttonHeight);
                }
                
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
    
    //滑动视图
    
    _scrollView.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self , 0.0f)
    .heightRatioToView(_pageViewArray.lastObject , 1);
    
    [_scrollView setupAutoContentSizeWithRightView:_pageViewArray.lastObject rightMargin:0.0f];
    
    [_scrollView setupAutoContentSizeWithBottomView:_pageViewArray.lastObject bottomMargin:0.0f];
    
    //pageControl
    
    _pageControl.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(_scrollView , 5.0f)
    .heightIs(10.0f);
    
    [self setupAutoHeightWithBottomView:_pageControl bottomMargin:0.0f];
}

#pragma mark - 分享按钮点击事件

- (void)shareButtonAction:(UIButton *)sender{
    
    NSInteger index = [self.buttonArray indexOfObject:sender];
    
    ShareType type = (ShareType)[self.infoArray[index][@"type"] integerValue];
    
    if (self.OpenShareBlock) {
        
        self.OpenShareBlock(type);
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //通过最终的偏移量offset值 来确定pageControl当前应该显示第几页
    
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
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
