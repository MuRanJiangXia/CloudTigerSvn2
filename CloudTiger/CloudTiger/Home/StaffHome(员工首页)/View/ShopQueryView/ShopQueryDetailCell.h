//
//  ShopQueryDetailCell.h
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopQueryDelegate <NSObject>
@optional

-(void)jumpQuery;

@end
@interface ShopQueryDetailCell : UITableViewCell
@property(nonatomic,weak)id<ShopQueryDelegate>delegete;

@end
