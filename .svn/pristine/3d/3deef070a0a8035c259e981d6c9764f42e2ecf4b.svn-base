//
//  BaseViewController.h
//  GuanJiaLaiLeApp
//
//  Created by LingJi on 16/5/24.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UINavigationControllerDelegate>{
    
//    EmptyView * emptyView;
}

typedef  void (^ isChoose)(BOOL  isChoose);

-(void)alterWith:(NSString *)content;
/**选择结束后回调，判断是否确定还是取消*/
-(void)alterWith:(NSString *)content IsChoose:(void (^)(BOOL isSure))isSure;

@property(nonatomic,copy)isChoose isChooseBlock;
-(void)backAction;

/**底部返回首页按钮*/
-(void)homeBtnView;

/**加载中*/
-(void)loadingShow;
/**结束加载*/
-(void)dismissLoading;
/**结束加载状态(延迟.5秒)*/
-(void)dismissLoadingLater;

/**SVP加载中*/
-(void)showSVP;

/**SVP提示字*/
-(void)showSVPByStatus:(NSString *)status;
/**提示错误*/
-(void)showSVPErrorStatus:(NSString *)str;
/**结束加载*/
-(void)dismissSVP;

/**结束加载*/
-(void)dismissSVPLater;


@end
