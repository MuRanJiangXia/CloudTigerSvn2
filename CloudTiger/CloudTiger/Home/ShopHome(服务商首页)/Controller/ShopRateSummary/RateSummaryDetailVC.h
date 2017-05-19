//
//  RateSummaryDetailVC.h
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"
#import "StaffRateSumModel.h"
@interface RateSummaryDetailVC : BaseViewController
@property(nonatomic,strong)StaffRateSumModel *queryModel;
/**
 订单四个状态
 */
@property(nonatomic,assign)enum QueryOrderState queryOrderState;
@end
