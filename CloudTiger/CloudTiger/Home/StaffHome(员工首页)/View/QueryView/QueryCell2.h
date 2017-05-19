//
//  QueryCell2.h
//  CloudTiger
//
//  Created by cyan on 16/9/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"
@protocol QueryCell2Delegate <NSObject>

//-(void)messWithText:(NSString *)text BySection:(NSInteger )section;
-(void)messWithText2:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath;

@end
@interface QueryCell2 : UITableViewCell
@property(nonatomic,strong)QueryCellModel *queryCellmodel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<QueryCell2Delegate>delegete;

@end
