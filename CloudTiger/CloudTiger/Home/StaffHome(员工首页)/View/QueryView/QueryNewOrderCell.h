//
//  QueryNewOrderCell.h
//  CloudTiger
//
//  Created by cyan on 16/10/15.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"
//退款查询列表cell
@protocol QueryNewOrderCellDelegate <NSObject>

//-(void)messWithText:(NSString *)text BySection:(NSInteger )section;
-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath;

-(void)codePost:(NSString *)code;

@end
@interface QueryNewOrderCell : UITableViewCell

@property(nonatomic,assign)NSInteger  section;
@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)QueryCellModel *queryCellmodel;

@property(nonatomic,weak)id<QueryNewOrderCellDelegate>delegete;
/**
 是否不让text 编辑
 */
@property(nonatomic,assign)BOOL isLockText;
@end
