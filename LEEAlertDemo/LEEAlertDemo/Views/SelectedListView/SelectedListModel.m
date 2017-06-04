//
//  SelectedListModel.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/6/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SelectedListModel.h"

@implementation SelectedListModel

- (instancetype)initWithSid:(NSInteger)sid
                      Title:(NSString *)title{
    
    return [[SelectedListModel alloc] initWithSid:sid Title:title Context:nil];
}

- (instancetype)initWithSid:(NSInteger)sid
                      Title:(NSString *)title
                    Context:(id)context{
    
    self = [super init];
    
    if (self) {
        
        _sid = sid;
        
        _title = title;
        
        _context = context;
    }
    
    return self;
}

@end
