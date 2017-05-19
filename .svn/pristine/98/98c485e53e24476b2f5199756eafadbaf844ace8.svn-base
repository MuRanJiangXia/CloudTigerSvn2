//
//  RegisterShopCell.h
//  CloudTiger
//
//  Created by cyan on 16/12/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassWordModel.h"
@protocol RegisterShopDelegate <NSObject>
//-(void)messWithText:(NSString *)text BySection:(NSInteger )section;
-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath;
@end
@interface RegisterShopCell : UITableViewCell


@property(nonatomic,strong)UITextField *cellTextField;

/** 是否可编辑 */
@property(nonatomic,assign)BOOL isEdite;

/** 键盘类型*/
@property(nonatomic,assign)UIKeyboardType keyboardType;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)PassWordModel *passWordModel;

@property(nonatomic,weak)id<RegisterShopDelegate>delegete;


@end
