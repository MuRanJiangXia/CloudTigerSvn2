//
//  QueryCell.h
//  CloudTiger
//
//  Created by cyan on 16/9/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"
@protocol QueryCellDelegate <NSObject>

//-(void)messWithText:(NSString *)text BySection:(NSInteger )section;
-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath;


@end
@interface QueryCell : UITableViewCell
@property(nonatomic,assign)NSInteger  section;
@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)QueryCellModel *queryCellmodel;

@property(nonatomic,weak)id<QueryCellDelegate>delegete;
/**
 是否不让text 编辑
 */
@property(nonatomic,assign)BOOL isLockText;
@end
