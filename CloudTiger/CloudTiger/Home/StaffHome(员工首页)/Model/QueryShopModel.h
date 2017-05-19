//
//  QueryShopModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseModel.h"

@interface QueryShopModel : BaseModel
/**商户号*/
@property(nonatomic,copy)NSString *SysNo;
/**商户用户名*/
@property(nonatomic,copy)NSString *CustomerName;
/**用户名称*/
@property(nonatomic,copy)NSString *Customer;
/**联系电话*/
@property(nonatomic,copy)NSString *Phone;

/**商户类型*/
@property(nonatomic,copy)NSString *type;

/**注册时间*/
@property(nonatomic,copy)NSString *RegisterTime;
/**电子邮箱*/
@property(nonatomic,copy)NSString *Email;
/**传真*/
@property(nonatomic,copy)NSString *Fax;
/**联系地址*/
@property(nonatomic,copy)NSString *DwellAddress;

//当前登录用户名
@property(nonatomic,copy)NSString *staff;



/**f费率*/
@property(nonatomic,copy)NSString *Rate;

/**上级费率*/
@property(nonatomic,copy)NSString *UserRate;

//
///**上级员工 id*/
//@property(nonatomic,copy)NSString *SystemUserSysNo;

/**操作*/

@end
