//
//  ChangeTopRateView.h
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangeTopRateViewDelegate <NSObject>

-(void)changeTopRate:(NSArray *)changeRateArr;

@end


@interface ChangeTopRateView : UIView

@property(nonatomic,weak)id<ChangeTopRateViewDelegate> changeRateDelegate;

/**滑出*/
-(void)bgViewTop;
/**滑入*/
-(void)bgViewDown;
@end
