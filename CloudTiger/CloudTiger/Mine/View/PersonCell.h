//
//  PersonCell.h
//  CloudTiger
//
//  Created by cyan on 16/10/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassWordModel.h"
@protocol PassWordCellDelegate <NSObject>
//-(void)messWithText:(NSString *)text BySection:(NSInteger )section;
-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath;
@end
@interface PersonCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)PassWordModel *passWordModel;

@property(nonatomic,weak)id<PassWordCellDelegate>delegete;
@end
