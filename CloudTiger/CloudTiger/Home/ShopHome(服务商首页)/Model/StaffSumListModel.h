//
//  StaffSumListModel.h
//  CloudTiger
//
//  Created by cyan on 16/12/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseModel.h"

@interface StaffSumListModel : BaseModel

/**
 {
 DisplayName = "\U9648\U5c1a\U5c1a";
 Fee = 1;
 LoginName = css;
 PhoneNumber = 13080014309;
 SystemUserTopSysNo = 1;
 "Total_fee" = 38;
 Tradecount = 17;
 count = 1;
 "refund_fee" = 37;
 }
 */

/**员工登陆名*/
@property(nonatomic,copy)NSString *LoginName;
/**真实姓名*/
@property(nonatomic,copy)NSString *DisplayName;
/**电话*/
@property(nonatomic,copy)NSString *PhoneNumber;
/**交易金额*/
@property(nonatomic,copy)NSString *Total_fee;
/**退款金额*/
@property(nonatomic,copy)NSString *refund_fee;

/**实际金额*/
@property(nonatomic,copy)NSString *Fee;


@end
