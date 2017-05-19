//
//  QueryResultModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface QueryResultModel : BaseModel

//序号  商户名称 订单号 交易类型  交易金额 交易币种  交易时间


/**序号*/
@property(nonatomic,copy)NSString *SysNo;


/**商户名称*/
@property(nonatomic,copy)NSString *CustomerName;


/**登录名*/
@property(nonatomic,copy)NSString *LoginName;

/**真实姓名*/
@property(nonatomic,copy)NSString *DisplayName;


/**订单号*/
@property(nonatomic,copy)NSString *Out_trade_no;

/**支付类型*/
@property(nonatomic,copy)NSString *Pay_Type;

/**金额*/
@property(nonatomic,copy)NSString *Total_fee;

/**折后金额*/
@property(nonatomic,copy)NSString *Cash_fee;

/**交易币种*/
@property(nonatomic,copy)NSString *Cash_fee_type;

/**交易时间*/
@property(nonatomic,copy)NSString *Time_Start;



///**订单状态*/
//@property(nonatomic,copy)NSString *Status;

@end
