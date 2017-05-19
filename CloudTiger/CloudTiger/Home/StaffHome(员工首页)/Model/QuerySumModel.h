//
//  QuerySumModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/27.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseModel.h"

@interface QuerySumModel : BaseModel
/**员工名称*/
@property(nonatomic,copy)NSString *DisplayName;
/**
 2017,05,08   Cash_fee 修改为  Total_fee 
 */
/**交易金额*/
@property(nonatomic,copy)NSString *Total_fee;
/**实际交易金额*/
@property(nonatomic,copy)NSString *fee;
/**交易币种*/
@property(nonatomic,copy)NSString *Cash_fee_type;

/**交易笔数*/
@property(nonatomic,copy)NSString *Tradecount;
@end
