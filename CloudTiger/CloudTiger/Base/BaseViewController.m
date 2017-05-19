//
//  BaseViewController.m
//  GuanJiaLaiLeApp
//
//  Created by LingJi on 16/5/24.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import "BaseViewController.h"
#import "StaffHomeViewController.h"
#import "ShopHomeViewController.h"
#import "MineViewController.h"
#import "PositionViewController.h"
#import "SignViewController.h"


@interface BaseViewController()

@end
@implementation BaseViewController


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xededed, 1.0);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets =NO;
    //设置 btn 不支持多点触控
    [[UIButton appearance] setExclusiveTouch:YES];
    
    NSInteger count = self.navigationController.viewControllers.count;
    
    if (count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalName:@"back_n.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 1. 返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    // 2. 导航控制器代理
    self.navigationController.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    if (self.navigationController.delegate == self){
//        self.navigationController.delegate = nil;
//    }
    
}
#pragma mark - Private Methods
#pragma mark -
#pragma mark Whether need Navigation Bar Hidden
- (BOOL) needHiddenBarInViewController:(UIViewController *)viewController {
    
    BOOL needHideNaivgaionBar = NO;
    if ([viewController isKindOfClass: [StaffHomeViewController class]] ||
        [viewController isKindOfClass: [ShopHomeViewController class]]) {
        needHideNaivgaionBar = YES;
    }
    
    return needHideNaivgaionBar;
}

#pragma mark - UINaivgationController Delegate
#pragma mark -
#pragma mark Will Show ViewController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden: [self needHiddenBarInViewController: viewController]
                                             animated: animated];
}


-(void)homeBtnView{
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0,  MainScreenHeight - 68  -64, MainScreenWidth, 68)];
    control.backgroundColor = [UIColor clearColor];
    [self.view addSubview:control];
    
    //     28 + 40 = 68
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 28, MainScreenWidth, 40)];
    view.backgroundColor = BlueColor;
    view.alpha = 0.7;
    [control addSubview:view];
    
    NSLog(@"MainScreenWidth :%f",MainScreenWidth);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((MainScreenWidth - 56)/2.0, 0 , 56, 56);
    //    button.backgroundColor = [UIColor purpleColor];
    [button setBackgroundImage:[UIImage imageNamed:@"bottom_btn_n"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"bottom_btn_s"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    [control addSubview:button];
    
}

-(void)topAction:(UIButton *)btn{
    
    NSLog(@"返回首页");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alterWith:(NSString *)content{
    
    if (content.length == 0) {
        
//        content = @"输入错误";
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:content message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
#warning 传递 是否选择了
            BOOL ischoose = YES;
            if (self.isChooseBlock) {
                self.isChooseBlock(ischoose);
            }
        }];
        
        
        [alert addAction:cancelAction];
        
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    

}


-(void)alterWith:(NSString *)content IsChoose:(void (^)(BOOL isSure))isSure{
    
    if (content.length == 0) {
        content = @"输入错误";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        BOOL ischoose = NO;
        isSure(ischoose);
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        BOOL ischoose = YES;
        isSure(ischoose);
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)loadingShow{
    
    //加载中。。。。
    [[CyanLoading shareLoading]show];
}

-(void)dismissLoading{
    
    [[CyanLoading shareLoading]dismiss];

}
-(void)dismissLoadingLater{
    //加载结束 。。。。
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:.5];
}

-(void)showSVP{
    [SVProgressHUD show];
    [SVProgressHUD setKeyBoardMove:YES];
}
-(void)showSVPByStatus:(NSString *)status{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setKeyBoardMove:YES];

    /**设置成不能交互*/
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 100)];// 位置 偏移

    [SVProgressHUD resetOffsetFromCenter];

/**提示错误*/
}
-(void)showSVPErrorStatus:(NSString *)str{
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD setKeyBoardMove:YES];
    /**设置成不能交互*/
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
}


-(void)dismissSVP{
    
    [SVProgressHUD dismiss];

}

-(void)dismissSVPLater{
    //加载结束 。。。。
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:.5];
    
}
@end
