//
//  CyanLab.m
//  CloudTiger
//
//  Created by cyan on 16/10/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanLab.h"
@interface CyanLab()<UIGestureRecognizerDelegate>

@end
@implementation CyanLab{
    
    CGPoint startLocation;
    CGFloat rotation;

}
-(BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action ==@selector(popSelf:) || action ==@selector(rotationSelf:)||
        
        action == @selector(ghostSelf:) || action == @selector(copy2:)){
        
        return YES;
        
    }
    
    return NO;//隐藏系统默认的菜单项
    //    return (action == @selector(copy:));
}



- (void)popSelf:(id)sender
{
    [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeScale(1.5f, 1.5f);} completion:^(BOOL Done){
        [UIView animateWithDuration:0.25 animations:^(){self.transform=CGAffineTransformIdentity;}] ;}];
}

- (void)rotationSelf:(id)sender
{
    [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeRotation(rotation+M_PI * 0.5);} completion:^(BOOL done){
        rotation=M_PI*0.5+rotation;}];
}

- (void)ghostSelf:(id)sender
{
    [UIView animateWithDuration:1.25f animations:^(){self.alpha = 0.0f;} completion:^(BOOL done){
        [UIView animateWithDuration:1.25f animations:^(){} completion:^(BOOL done){
            [UIView animateWithDuration:0.5f animations:^(){self.alpha = 1.0f;}];
        }];
    }];
}

//针对于响应方法的实现
-(void)copy2:(UIMenuController *)sender {
    NSLog(@"title :%@",  sender.menuItems);
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    
}

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler {
    
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.minimumPressDuration = 1;
    touch.delegate = self;
    
    [self addGestureRecognizer:touch];
}

//绑定事件
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self attachTapHandler];
    }
    return self;
}

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    
    if (!_isCopy) {
        
        NSLog(@"不能复制");
        return;
    }
    
//
    
//    if (recognizer.state == UIGestureRecognizerStateChanged) {//移动的时候 不添加了
//        return;
//    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        if (![self becomeFirstResponder]) {
            NSLog(@"Could not become first responder");
            return;
        }
        
  
        
        UIMenuController *menuCtrl =   [UIMenuController sharedMenuController];
        
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                          action:@selector(copy2:)];
        
        
        //    UIMenuItem *popSelf = [[UIMenuItem alloc] initWithTitle:@"缩放"
        //                                                     action:@selector(popSelf:)];
        //    //
        //    UIMenuItem *rotationSelf = [[UIMenuItem alloc] initWithTitle:@"旋转"
        //                                                          action:@selector(rotationSelf:)];
        //
        //    UIMenuItem *ghost = [[UIMenuItem alloc] initWithTitle:@"渐退"
        //                                                   action:@selector(ghostSelf:)];
        
        //    [[UIMenuController sharedMenuController] setArrowDirection:UIMenuControllerArrowDown];
        //     copyLink
        //    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink,rotate, nil]];
        //
        //    menuCtrl.menuItems = @[copyLink,popSelf,rotationSelf,ghost];
        menuCtrl.menuItems = @[copyLink];
        
        [menuCtrl setTargetRect:self.frame inView:self.superview];
        [menuCtrl setMenuVisible:YES animated:YES];
//        menuCtrl.arrowDirection =  UIMenuControllerArrowDown;
        NSLog(@"menuItems : %@",menuCtrl.menuItems);
    }
    

}


@end
