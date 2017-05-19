//
//  PersonFooter.h
//  CloudTiger
//
//  Created by cyan on 16/12/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonFooterDelegate <NSObject>
-(void)changePerson:(UIButton *)btn;
@end
@interface PersonFooter : UITableViewHeaderFooterView

@property(nonatomic,weak)id<PersonFooterDelegate> delegate;
@end
