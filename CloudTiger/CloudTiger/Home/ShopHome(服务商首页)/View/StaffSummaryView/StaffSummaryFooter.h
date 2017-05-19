//
//  StaffSummaryFooter.h
//  CloudTiger
//
//  Created by cyan on 16/12/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StaffSummaryFooterDelegate <NSObject>

-(void)queryAction;

@end
@interface StaffSummaryFooter : UITableViewHeaderFooterView

@property(nonatomic,weak)id<StaffSummaryFooterDelegate>delegete;


@end
