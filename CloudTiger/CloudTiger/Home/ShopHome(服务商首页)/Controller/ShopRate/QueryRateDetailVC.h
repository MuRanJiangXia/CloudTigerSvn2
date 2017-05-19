//
//  ShopRateDetailVC.h
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopRateModel.h"
@interface QueryRateDetailVC : BaseViewController
/**
 订单四个状态
 */
@property(nonatomic,assign)enum QueryOrderState queryOrderState;

@property(nonatomic,strong)ShopRateModel *queryModel;
@end
