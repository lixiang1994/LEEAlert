//
//  SelectedListView.h
//  LEEAlertDemo
//
//  Created by 李响 on 2017/6/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectedListModel.h"

@interface SelectedListView : UITableView

@property (nonatomic , strong ) NSArray<SelectedListModel *>* array;

/**
 已选中Block
 */
@property (nonatomic , copy ) void (^selectedBlock)(NSArray <SelectedListModel *>*);

/**
 选择改变Block (多选情况 当选择改变时调用)
 */
@property (nonatomic , copy ) void (^changedBlock)(NSArray <SelectedListModel *>*);

/**
 是否单选
 */
@property (nonatomic , assign ) BOOL isSingle;

/**
 完成选择 (多选会调用selectedBlock回调所选结果)
 */
- (void)finish;

@end
