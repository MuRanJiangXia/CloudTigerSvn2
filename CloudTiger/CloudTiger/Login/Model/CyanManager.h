//
//  CyanManager.h
//  CloudTiger
//
//  Created by cyan on 16/9/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CyanManager : NSObject
+(instancetype)shareSingleTon;

@property(nonatomic,assign)BOOL isLoadTabar;
/**是否是员工*/
@property(nonatomic,copy)NSString *isStaff;

//员工专属
/**员工上一级 名称(首页获取)*/
@property(nonatomic,copy)NSString *shopName;
/**员工上一级 主键(首页获取)*/
@property(nonatomic,copy)NSString *shopSysNo;

//shop专属


//服务商 商户类别 (员工 shop公用 ；员工要在首页获取)
/**类型0代表服务商，1代表商户*/
@property(nonatomic,copy)NSString *customersType;


/**
   共有的
 */
@property(nonatomic,copy)NSString *loginName;
@property(nonatomic,copy)NSString *passWord;
@property(nonatomic,copy)NSString *displayName;
@property(nonatomic,copy)NSString *phoneNumber;
@property(nonatomic,copy)NSString *email;
/**门店id*/
@property(nonatomic,copy)NSString *storeID;
@property(nonatomic,copy)NSString *sysNO;
//   PhoneNumber Email OpenID

/**是否完全登录*/
@property(nonatomic,copy)NSString *isFirst;


/**扫码支付权限*/
@property(nonatomic,assign)enum PayState payState;


/**已有权限数组*/
@property(nonatomic,strong)NSArray *powers;

/**
 *  清除用户信息
 */
- (void)cleanUserInfo;

@end
