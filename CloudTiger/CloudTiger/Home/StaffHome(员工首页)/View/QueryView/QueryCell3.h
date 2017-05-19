//
//  QueryCell3.h
//  CloudTiger
//
//  Created by cyan on 16/9/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"

@protocol QueryCell3Delegate <NSObject>

//-(void)messWithText:(NSString *)text BySection:(NSInteger )section;
-(void)messWithText3:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath;

@end
@interface QueryCell3 : UITableViewCell
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)QueryCellModel *queryCellmodel;
@property(nonatomic,weak)id<QueryCell3Delegate>delegete;

@end
