//
//  AssignStaffCell.h
//  CloudTiger
//
//  Created by cyan on 16/12/2.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssignStaffModel.h"

@protocol AssignStaffDelegate <NSObject>

-(void)switchAction:(BOOL)isSelected byIndex:(NSIndexPath *)indexPath;

@end


@interface AssignStaffCell : UITableViewCell

@property(nonatomic,strong)AssignStaffModel *assignStaffModel;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<AssignStaffDelegate> delegate;
@end
