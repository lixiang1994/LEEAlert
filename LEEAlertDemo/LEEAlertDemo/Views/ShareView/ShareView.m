
/*!
 *  @header ShareView.m
 *          LEEAlertDemo
 *
 *  @brief  分享视图
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/4/26.
 */

#import "ShareView.h"

#import "ShareButton.h"

#import "SDAutoLayout.h"

#import "LEEAlert.h"

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
                       @{@"title" : @"微信" , @"image" : @"infor_popshare_weixin_nor" , @"highlightedImage" : @"infor_popshare_weixin_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToWechat]} ,
                       
                       @{@"title" : @"微信朋友圈" , @"image" : @"infor_popshare_friends_nor" , @"highlightedImage" : @"infor_popshare_friends_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToWechatTimeline]} ,
                       
                       /** 多复制几个 用来演示分页 */
                       
                       @{@"title" : @"新浪微博" , @"image" : @"infor_popshare_sina_nor" , @"highlightedImage" : @"infor_popshare_sina_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToSina]} ,
                       
                       @{@"title" : @"QQ好友" , @"image" : @"infor_popshare_qq_nor" , @"highlightedImage" : @"infor_popshare_qq_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToQQFriend]} ,
                       
                       @{@"title" : @"QQ空间" , @"image" : @"infor_popshare_kunjian_nor" , @"highlightedImage" : @"infor_popshare_kunjian_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToQZone]} ,
                       
                       /** 结束 */
                        
                       @{@"title" : @"新浪微博" , @"image" : @"infor_popshare_sina_nor" , @"highlightedImage" : @"infor_popshare_sina_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToSina]} ,
                       
                       @{@"title" : @"QQ好友" , @"image" : @"infor_popshare_qq_nor" , @"highlightedImage" : @"infor_popshare_qq_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToQQFriend]} ,
                       
                       @{@"title" : @"QQ空间" , @"image" : @"infor_popshare_kunjian_nor" , @"highlightedImage" : @"infor_popshare_kunjian_pre" , @"type" : [NSNumber numberWithInteger:ShareTypeToQZone]}];
        
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
    
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert closeWithCompletionBlock:^{
        
        if (!weakSelf) return;
        
        NSInteger index = [weakSelf.buttonArray indexOfObject:sender];
        
        ShareType type = (ShareType)[weakSelf.infoArray[index][@"type"] integerValue];
        
        if (weakSelf.openShareBlock) weakSelf.openShareBlock(type);
    }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //通过最终的偏移量offset值 来确定pageControl当前应该显示第几页
    
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
}

@end
