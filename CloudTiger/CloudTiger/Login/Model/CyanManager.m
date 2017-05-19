//
//  CyanManager.m
//  CloudTiger
//
//  Created by cyan on 16/9/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanManager.h"
static id singleTon;

@implementation CyanManager
+(instancetype)shareSingleTon{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [[self alloc]init];
    
    });
    return singleTon;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [super allocWithZone:zone];

    });
    return singleTon;
}

/**
 *  清除用户信息
 */
- (void)cleanUserInfo{
    
    NSString *isStaff  = @"";
    NSString *shopName  = @"";
    NSString *shopSysNo  = @"";
    NSString *customersType  = @"";
    NSString *loginName  = @"";
    NSString *passWord  = @"";
    NSString *displayName  = @"";
    NSString *phoneNumber  = @"";
    NSString *sysNO  = @"";

    NSString *email  = @"";
    NSString *storeID  = @"";
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:isStaff forKey:@"isStaff"];
    [defaults setObject:shopName forKey:@"shopName"];
    [defaults setObject:customersType forKey:@"customersType"];
    [defaults setObject:loginName forKey:@"loginName"];
    [defaults setObject:passWord forKey:@"passWord"];
    [defaults setObject:displayName forKey:@"displayName"];
    [defaults setObject:phoneNumber forKey:@"phoneNumber"];
    [defaults setObject:sysNO forKey:@"sysNO"];
    [defaults setObject:email forKey:@"email"];
    [defaults setObject:storeID forKey:@"storeID"];
    
    [defaults synchronize];
    
    
    //清空权限
    [List removeObjectForKey:UserPowers];
    
    self.powers = @[];
    self.isStaff =isStaff;
    self.shopName = shopName;
    self.shopSysNo = shopSysNo;
    self.customersType = customersType;
    self.loginName = loginName;
    self.passWord = passWord;
    self.displayName = displayName;
    self.phoneNumber = phoneNumber;
    self.sysNO = sysNO;
    
    self.email = email;
    self.storeID = storeID;
    
}
@end
