//
//  RefundDesCell2.h
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CellInputDelegate <NSObject>

-(void)refundDesCell:(NSString *)refundMoney;

@end
@interface RefundDesCell2 : UITableViewCell
/**可退金额*/
@property(nonatomic,strong)NSString *refundableAmount;

@property(nonatomic,strong)UITextField *moneyTextField;

@property(nonatomic,weak)id<CellInputDelegate>delegete;
@end
