//
//  ShopAssignStaffCell.h
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopAssignStaffDelegate <NSObject>
@optional

-(void)jumpShopAssignStaff;

@end
@interface ShopAssignStaffCell : UITableViewCell
@property(nonatomic,weak)id<ShopAssignStaffDelegate>delegete;

@end
