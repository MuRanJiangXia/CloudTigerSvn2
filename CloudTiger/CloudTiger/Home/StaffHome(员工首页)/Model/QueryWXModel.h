//
//  QueryWXModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface QueryWXModel : BaseModel
/**订单号*/
@property(nonatomic,copy)NSString *out_trade_no ;
/**支付类型*/
@property(nonatomic,copy)NSString *pay_Type;
/**金额*/
@property(nonatomic,copy)NSString *total_fee;
///**交易币种*/
@property(nonatomic,copy)NSString *fee_type;
/**交易时间*/
@property(nonatomic,copy)NSString *time_end;
///**交易状态*/
@property(nonatomic,copy)NSString *trade_state;



@end
