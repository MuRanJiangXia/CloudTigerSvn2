//
//  RefundDesView.h
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefudDesModel.h"
@protocol RefundDesViewDelegate <NSObject>
/**第一个：退款金额；第二个：密码*/

-(void)refundDesView:(NSArray *)refundArr;

@end
@interface RefundDesView : UIView

@property(nonatomic,strong)RefudDesModel *refunDesModel;
@property(nonatomic,weak)id<RefundDesViewDelegate> refundDesViewDelegate;
/**滑出*/
-(void)bgViewTop;
/**滑入*/
-(void)bgViewDown;
@end
