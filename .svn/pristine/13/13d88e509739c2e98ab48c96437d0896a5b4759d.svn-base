//
//  BaseOperationCell.h
//  CloudTiger
//
//  Created by cyan on 16/12/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OperationDelegate <NSObject>
@optional

-(void)jumpOperationBy:(enum QueryOrderState )queryOrderState;

@end
@interface BaseOperationCell : UITableViewCell

@property(nonatomic,weak)id<OperationDelegate>delegete;

@property(nonatomic,strong) UIButton *operationBtn;

@property(nonatomic,strong)NSString *btnTitle;
/**
 订单四个状态
 */
@property(nonatomic,assign)enum QueryOrderState queryOrderState;

@end
