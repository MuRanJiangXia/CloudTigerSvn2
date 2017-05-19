//
//  Commen.h
//  CloudTiger
//
//  Created by cyan on 16/9/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#ifndef Commen_h
#define Commen_h

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s中%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],[[[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent] UTF8String] ,__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(FORMAT, ...) nil
#endif


#define STATE_BAR_BLACK [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]

#define STATE_BAR_WHITE [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

#define GJLLColor(R,G,B) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1]
#define COMMANDCOLOR GJLLColor(51, 15, 75)
//屏幕尺寸
#define ISIPHONE3_5  CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_0  CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_7  CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE5_5  CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
// 屏幕宽度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

/** 用十六进制创建颜色*/
#define UIColorFromRGB(rgbValue, alp)                                                                                                      \
[UIColor colorWithRed:((float) ((rgbValue & 0xFF0000) >> 16)) / 255.0                                                                  \
green:((float) ((rgbValue & 0x00FF00) >> 8)) / 255.0                                                                   \
blue:((float) (rgbValue & 0x0000FF)) / 255.0                                                                          \
alpha:(float) alp]

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref) (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) count] == 0))

#define CommFont12 [UIFont systemFontOfSize:12]

#define CommFont13 [UIFont systemFontOfSize:13]

#define CommFont14 [UIFont systemFontOfSize:14]

//常用颜色
#define BlueColor UIColorFromRGB(0x00aaee, 1)

//UIColorFromRGB(0x5bb85d, 1) 浅绿色 | UIColorFromRGB(0x27A005, 1) 深绿色
#define GreenColor UIColorFromRGB(0x5bb85d, 1)

#define RedColor UIColorFromRGB(0xE52A2A, 1)

#define OrangeColor UIColorFromRGB(0xFF5B11, 1)

#define PinkColor UIColorFromRGB(0xFF7682, 1)


#define PaleColor UIColorFromRGB(0xF5F5F9, 1)

#define GrayColor UIColorFromRGB(0xA3A3A3, 1)

#define BlackColor UIColorFromRGB(0x727272, 1)

#define CYSrceenHight   667.0f;
#define CYSrceenWidth   375.0f;
#define CYAdaptationH(x) x/667.0f*[[UIScreen mainScreen]bounds].size.height
#define CYAdaptationW(x) x/375.0f*[[UIScreen mainScreen]bounds].size.width
#define CYAdapationLabelFont(n) n*([[UIScreen mainScreen]bounds].size.width/375.0f)
/**订单查询页*/
enum QueryState{
    kQueryOrder  = 0,//订单查询
    kQueryRefund        =  10,//退款
    kQueryRefundOrder    = 20 ,//退款查询



};

/**订单查询 四种 （费率一样） */
enum QueryOrderState{
    kOrderShop   = 1000,//商户订单查询 || 商户费率订单查询
    kOrderShopUser        =  10,//商户员工订单查询
    kOrderCustomer   = 20 ,//服务商订单查询
    kOrderCustomerUser = 30,//服务商员工订单查询 || 服务商员工费率订单查询
    kTopCustomerUserRate = 40 ,//上级服务商员工费率
    kTopShopRate = 50, //上级商户费率
    
    kQueryShop       =  60,//商户查询
//    kQueryRate  = 70 ,//费率订单查询
    kQueryTopRate  = 80 ,//上级费率订单查询
    kAssignStaff  = 90 ,//调拨
    kRegisterShop  = 100 ,//商户注册
    kOriginalOrder  = 110 ,//原始的订单查询
    kChangeRate  = 120 ,//修改费率
    kChangeShopPower  = 130 ,//商户权限修改
    kChangeStaffPower  = 140 ,//员工权限修改



    
};

/** 员工列表标识 */
enum StaffState{
    kStaffList   = 0,//员工列表
    kStaffCode       =  10,//员工二维码
    kStaffPower      =  20,//员工权限配置-服务商

    
};



/** 商户列表标识 */
enum ShopState{
    kShopListOfStaff   = 0,//商户列表 --服务商员工
    kShopListOfCustomer    =  10,//商户列表 --服务商直接查询
    kShopListOfCustomerUser   =  20,//商户列表 --服务商通过查员工 查商户
    
};


/** 支付宝 微信 二维码扫描功能 */
enum PayState{
    kAllPay   = 0,//所有的权限都有
    kAliPay   =  10,//只有支付宝扫码
    kWXPay   =  20,//只有微信扫码
    kNoPay  = 30 ,//没有扫码功能
};



#endif /* Commen_h */
