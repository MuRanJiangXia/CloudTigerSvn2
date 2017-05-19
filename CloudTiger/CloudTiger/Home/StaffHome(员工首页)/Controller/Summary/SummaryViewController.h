//
//  SummaryViewController.h
//  CloudTiger
//
//  Created by cyan on 16/9/27.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"

@interface SummaryViewController : BaseViewController
@property(nonatomic,strong)NSMutableDictionary *paramters;

/**
 订单四个状态
 */
@property(nonatomic,assign)enum QueryOrderState queryOrderState;
/**员工 sysno*/
@property(nonatomic,copy)NSString *userSysNo;
@end
