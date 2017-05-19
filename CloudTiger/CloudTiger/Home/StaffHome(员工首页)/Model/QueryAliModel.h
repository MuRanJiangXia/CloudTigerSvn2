//
//  QueryAliModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/14.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseModel.h"

@interface QueryAliModel : BaseModel
/**订单号*/
@property(nonatomic,copy)NSString *trade_no;
/**支付类型*/
@property(nonatomic,copy)NSString *pay_Type;
/**金额*/
@property(nonatomic,copy)NSString *total_amount;
///**交易币种*/
@property(nonatomic,copy)NSString *fee_type;
/**交易时间*/
@property(nonatomic,copy)NSString *send_pay_date;
///**交易状态*/
@property(nonatomic,copy)NSString *trade_status;
@end
