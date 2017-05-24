
/*!
 *  @header ShareView.h
 *          LEEActionSheetDemo
 *
 *  @brief  分享视图
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/4/26.
 */

#import <UIKit/UIKit.h>

typedef enum {
    
    ShareTypeToQQFriend = 0,//QQ好友
    
    ShareTypeToQZone,//QQ空间
    
    ShareTypeToTencetnwb,//腾讯微博
    
    ShareTypeToWXFriend,//微信好友
    
    ShareTypeToWXQuan,//微信朋友圈
    
    ShareTypeToSina,//新浪微博
    
} ShareType;

@interface ShareView : UIView

/**
 *  打开分享Block
 */
@property (nonatomic , copy ) void (^OpenShareBlock)(ShareType type);

/**
 *  初始化分享视图
 *
 *  @param frame          frame
 *  @param infoArray      信息数组
 *  @param maxLineNumber  最大行数
 *  @param maxSingleCount 单行最大个数
 *
 *  @return 分享视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    InfoArray:(NSArray *)infoArray
                MaxLineNumber:(NSInteger)maxLineNumber
               MaxSingleCount:(NSInteger)maxSingleCount;

@end



@interface ShareButton : UIButton

/**
 *  上下间距
 */
@property (nonatomic , assign ) CGFloat range;

/**
 *  设置标题图标
 *
 *  @param title 标题
 *  @param image 图标
 */
- (void)configTitle:(NSString *)title Image:(UIImage *)image;

@end