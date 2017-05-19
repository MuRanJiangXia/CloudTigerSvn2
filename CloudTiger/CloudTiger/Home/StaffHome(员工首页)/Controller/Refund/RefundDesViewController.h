//
//  RefundDesViewController.h
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseViewController.h"
//#import "QueryResultModel.h"
#import "RefudDesModel.h"

@protocol RefundListDelegate <NSObject>
@optional
-(void)tableReloadBy:(NSString *)state andIndexPath:(NSIndexPath *)indexPath;
@end

@interface RefundDesViewController : BaseViewController

@property(nonatomic,strong)RefudDesModel *queryResultModel;

@property(nonatomic,weak)id<RefundListDelegate>delegete;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end
