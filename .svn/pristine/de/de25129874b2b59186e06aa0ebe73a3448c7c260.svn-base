//
//  ShopPowerShowCell.h
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopPowerModel.h"

@protocol AssignStaffDelegate <NSObject>

-(void)switchAction:(BOOL)isSelected byIndex:(NSIndexPath *)indexPath;

@end


@interface ShopPowerShowCell : UITableViewCell

@property(nonatomic,strong)ShopPowerModel *shopPowerModel;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<AssignStaffDelegate> delegate;
@end

