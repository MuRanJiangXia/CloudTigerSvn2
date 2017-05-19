//
//  TabBarViewController.m
//  GuanJiaLaiLeApp
//
//  Created by LingJi on 16/5/24.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import "TabBarViewController.h"
#import "SignViewController.h"
#import "PositionViewController.h"
#import "MineViewController.h"

#import "ShopHomeViewController.h"
#import "StaffHomeViewController.h"
#import "NavcController.h"


@interface TabBarViewController ()<UIAlertViewDelegate>{
    
    CyanManager  *_mangager;
}

@end


@implementation TabBarViewController


+(instancetype)share{
    
    static TabBarViewController * tabbar = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbar = [[TabBarViewController alloc] init];
    });
    
    return tabbar;
}

-(void)onMultiLoginClientsChanged{
    
    
//    
//    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"账号已在另一台设备登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alter show];
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
////    1,执行  退出操作
//    //  [[CyanManger shareSingleTon] cleanUserInfo];
//    
//    
//
//    
//}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//        NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
//        NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:isFirstFilePath];
//        
//        BOOL isFirst = [dic[@"isFirst"] boolValue];//第一次是no
//    
//        if (!isFirst) {
//            
//            [self creatVC];
//            
//        }
//    
 
}
//先于 viewWillAppear
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatVC];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selecte) name:@"zoe" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainVC) name:@"zoe2" object:nil];

}


-(void)creatVC{
    
  
    
    NSLog(@"childViewControllers : %@",self.childViewControllers);
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x333333, 1.0),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x01A9EF, 1.0),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                        
                                                        } forState:UIControlStateSelected];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSString *secondTitle = @"订单查询";
    NSString *secondImageNormal = @"order_normal";
    NSString *secondImageSelected= @"order_selected";
    
    NSString *thirdTitle = @"员工列表";
    NSString *thirdImageNormal  = @"staff_normal";
    NSString *thirdImageSelected = @"staff_selected";

    _mangager = [CyanManager shareSingleTon];
    NavcController *navc;
    if ([_mangager.isStaff isEqualToString:@"0"]) {
        ShopHomeViewController *mainVC  = [[ShopHomeViewController alloc]init];
        navc=[[NavcController alloc] initWithRootViewController:mainVC];
        
    }else{
        StaffHomeViewController *mainVC  = [[StaffHomeViewController alloc]init];
        navc  =[[NavcController alloc] initWithRootViewController:mainVC];
        if ([_mangager.customersType isEqualToString:@"0"]) {//服务商员工
            
            thirdTitle = @"商户查询";
            
            thirdImageNormal  = @"shop_normal";
            thirdImageSelected = @"shop_selected";
        }else{//商户员工
            thirdTitle = @"退款";
            thirdImageNormal  = @"refund_normal";
            thirdImageSelected = @"refund_selected";
            
        }
    }
//    [CyTools  imageWithColor:[UIColor yellowColor]] wxPay
//    [UIImage imageWithOriginalName:@"home_normal"]
    navc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                    image:[UIImage imageWithOriginalName:@"home_normal"]
                                            selectedImage:[UIImage imageWithOriginalName:@"home_selected"]];
    
    SignViewController *signVC = [[SignViewController alloc] init];
    NavcController *navc2=[[NavcController alloc] initWithRootViewController:signVC];
    navc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:secondTitle
                                                     image:[UIImage imageWithOriginalName:secondImageNormal]
                                             selectedImage:[UIImage imageWithOriginalName:secondImageSelected]];
    
    
    PositionViewController *positVC = [[PositionViewController alloc] init];
    NavcController *navc3=[[NavcController alloc] initWithRootViewController:positVC];
    navc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:thirdTitle
                                                     image:[UIImage imageWithOriginalName:thirdImageNormal]
                                             selectedImage:[UIImage imageWithOriginalName:thirdImageSelected]];
    
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    NavcController *navc4=[[NavcController alloc] initWithRootViewController:mineVC];
    navc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                     image:[UIImage imageWithOriginalName:@"mine_normal"]
                                             selectedImage:[UIImage imageWithOriginalName:@"mine_selected"]];
    
    
    
    [self setViewControllers:@[navc,navc2,navc3, navc4 ] animated:NO];
}


-(void)selecte{
    [self setSelectedIndex:2];
}
-(void)mainVC{
    [self setSelectedIndex:0];

    
}
@end
