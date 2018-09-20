//
//  NibView.m
//  LEEAlertDemo
//
//  Created by 李响 on 2018/9/20.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "NibView.h"

@implementation NibView

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"NibView"
                                          owner:nil options:nil]lastObject];
}

@end
