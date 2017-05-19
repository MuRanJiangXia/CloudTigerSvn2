//
//  UIView+UIViewController.m
//  05 Responder
//
//  Created by SPkirito on 15-12-10.
//  Copyright (c) 2015年 www.feiWork.com. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)
/** view所在的VC */
- (UIViewController *)viewController {
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

@end
