//
//  QueryOrderViewController.h
//  CloudTiger
//
//  Created by cyan on 16/9/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"
#import "QueryResultModel.h"
@interface QueryOrderViewController : BaseViewController
/**
 订单四个状态
 */
@property(nonatomic,assign)enum QueryOrderState queryOrderState;

@property(nonatomic,strong)QueryResultModel *queryModel;
@end
