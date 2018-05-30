//
//  SignFinishView.h
//  LEEAlertDemo
//
//  Created by 李响 on 2017/5/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignFinishView : UIView

/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);

@end
