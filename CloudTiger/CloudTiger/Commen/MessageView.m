//
//  MessageView.m
//  GuanJiaLaiLeApp
//
//  Created by LingJi on 16/7/5.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import "MessageView.h"


@implementation MessageView

+(void)showMessage:(NSString *)message{
    
    
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [keywindow addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize LabelSize = CGSizeZero;
    
    
    if (message.length) {
        LabelSize = [message boundingRectWithSize:CGSizeMake(MainScreenWidth-60, 9000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                                                                                                  }context:nil].size;
    }
    
    
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((MainScreenWidth - LabelSize.width - 20)/2, MainScreenHeight - 130, LabelSize.width+20, LabelSize.height+10);
    showview.center=keywindow.center;
    [UIView animateWithDuration:3 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
    
    
    
    
}





@end
