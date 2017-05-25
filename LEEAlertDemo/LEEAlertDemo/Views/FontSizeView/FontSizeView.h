//
//  FontSizeView.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/7/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontSizeView : UIView

@property (nonatomic , copy ) void (^changeBlock)(NSInteger);

@end
