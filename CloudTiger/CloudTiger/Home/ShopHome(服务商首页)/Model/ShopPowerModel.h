//
//  ShopPowerModel.h
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseModel.h"

@interface ShopPowerModel : BaseModel
/**是否已经选择*/
@property(nonatomic,assign)BOOL isChoose;

/**权限编号*/
@property(nonatomic,copy)NSString *SysNo;

/**权限名称*/
@property(nonatomic,copy)NSString *RoleName;

///**真实姓名*/
//@property(nonatomic,copy)NSString *DisplayName;


@end
