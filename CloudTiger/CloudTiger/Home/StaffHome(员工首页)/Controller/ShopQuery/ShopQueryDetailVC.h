//
//  ShopQueryDetailVC.h
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"
#import "QueryShopModel.h"
@interface ShopQueryDetailVC : BaseViewController
/**商户列表标识*/
@property(nonatomic,assign)enum ShopState shopState;

@property(nonatomic,copy)NSString *staffSysNo;

@property(nonatomic,strong)QueryShopModel *queryShopModel;



@end
