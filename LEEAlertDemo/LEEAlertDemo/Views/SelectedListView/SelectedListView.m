//
//  SelectedListView.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/6/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SelectedListView.h"

@interface SelectedListView ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation SelectedListView

- (void)dealloc{
    
    _dataArray = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        //初始化数据
        
        [self initData];
    }
    
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    self.bounces = NO;
    
    self.allowsMultipleSelectionDuringEditing = YES; //支持同时选中多行
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.separatorColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f];
    
    self.dataArray = [NSMutableArray array];
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setArray:(NSArray<SelectedListModel *> *)array{
    
    _array = array;
    
    [self reloadData];
    
    [self setEditing:!self.isSingle animated:NO];
    
    CGRect selfFrame = self.frame;
    
    selfFrame.size.height = array.count * 50.0f;
    
    self.frame = selfFrame;
}

- (void)setIsSingle:(BOOL)isSingle{
    
    _isSingle = isSingle;
    
    [self setEditing:!isSingle animated:NO];
}

- (void)finish{
    
    if (self.selectedBlock) self.selectedBlock(self.dataArray);
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SelectedListModel *model = self.array[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectedBackgroundView = [UIView new];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    id model = self.array[indexPath.row];
    
    [self.dataArray addObject:model];
    
    if (self.isSingle) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self finish];
    
    } else {
        
        if (self.changedBlock) self.changedBlock(self.dataArray);
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    id model = self.array[indexPath.row];
    
    if (!self.isSingle) {
        
        [self.dataArray removeObject:model];
        
        if (self.changedBlock) self.changedBlock(self.dataArray);
    }
}

@end
