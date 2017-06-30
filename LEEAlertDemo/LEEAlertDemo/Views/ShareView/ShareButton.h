
/*!
 *  @header ShareButton.h
 *          MierMilitaryNews
 *
 *  @brief  分享按钮
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 miercn. All rights reserved.
 *  @version    16/4/19.
 */

#import <UIKit/UIKit.h>

typedef enum {
    
    ShareTypeToQQFriend = 0,//QQ好友
    
    ShareTypeToQZone,//QQ空间
    
    ShareTypeToWechat,//微信好友
    
    ShareTypeToWechatTimeline,//微信朋友圈
    
    ShareTypeToSina,//新浪微博
    
} ShareType;

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
