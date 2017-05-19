//
//  LoginChooseView.h
//  CloudTiger
//
//  Created by cyan on 16/9/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginChooseDelegate <NSObject>
/**登录*/
-(void)joinActionBy:(NSInteger)btnTag ;
-(void)chooseTag:(NSInteger)btnTag Text:(NSArray *)textArr;

@end
@interface LoginChooseView : UIView
@property(nonatomic,weak)id<LoginChooseDelegate>loginChooseDelegete;
@property(nonatomic,strong)    UIScrollView *chooseScroll;
@end
