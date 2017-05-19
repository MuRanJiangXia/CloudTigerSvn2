//
//  ShopListViewController.h
//  CloudTiger
//
//  Created by cyan on 16/9/19.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopListViewController : BaseViewController
/**商户列表标识*/
@property(nonatomic,assign)enum ShopState shopState;

@property(nonatomic,copy)NSString *staffSysNo;

@property(nonatomic,strong)NSMutableDictionary *paramters;

@end
