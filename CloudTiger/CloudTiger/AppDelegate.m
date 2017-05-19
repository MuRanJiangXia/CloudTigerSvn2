//
//  AppDelegate.m
//  CloudTiger
//
//  Created by cyan on 16/9/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

#import "IQKeyboardManager.h"
#import "LoadViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //静音模式中  仍然可以读音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error: %@", [error localizedDescription]);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@", [error localizedDescription]);
    }
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor =[UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    
//    LoginViewController *login = [[LoginViewController alloc]init];
////    
//    TabBarViewController *tabVC=[TabBarViewController share];
//    self.window.rootViewController = tabVC;

    NSLog(@"NSHomeDirectory : %@",NSHomeDirectory());
    LoadViewController *load = [LoadViewController new];
    self.window.rootViewController = load;
//    [self rooterVC];
    
    /*
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本 比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"appCurVersion : %@",appCurVersion);
    
    
    NSString *num1 = @"5.2.0";    NSString *num2 = @"5.2.0.1";
    if ([num1 compare:num2 options:NSNumericSearch] ==NSOrderedDescending)
    {
        NSLog(@"%@ is bigger",num1);
        
    }else{
        NSLog(@"%@ is bigger",num2);
    }
     */
    
    return YES;
}

-(void)rooterVC{
    NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:isFirstFilePath];
    
    BOOL isFirst = [dic[@"isFirst"] boolValue];//第一次是no
    
    if (!isFirst) {
        NSLog(@"%d",isFirst);
        LoginViewController *login = [[LoginViewController alloc]init];
                self.window.rootViewController = login;
        
        
        
    }else{
        NSLog(@"%d",isFirst);
        //获取本地数据
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *sysNO = [defaults objectForKey:@"sysNO"];
        NSString *isStaff    = [defaults objectForKey:@"isStaff"];
        NSString *loginName = [defaults objectForKey:@"loginName"];
        NSString *displayName     = [defaults objectForKey:@"displayName"];
        NSString *passWord       = [defaults objectForKey:@"passWord"];
        NSString *customersType       = [defaults objectForKey:@"customersType"];
        
        CyanManager *manager = [CyanManager shareSingleTon];
        if ([isStaff isEqualToString:@"1"]) {//员工
            NSString *shopName     = [defaults objectForKey:@"shopName"];
            NSString *shopSysNo       = [defaults objectForKey:@"shopSysNo"];
            NSString *phoneNumber = [defaults objectForKey:@"phoneNumber"];
            NSString *email  = [defaults objectForKey:@"email"];
            NSString *storeID  = [defaults objectForKey:@"storeID"];
            
            manager.shopName = shopName;
            manager.shopSysNo = shopSysNo;
            manager.phoneNumber = phoneNumber;
            manager.email = email;
            manager.storeID =storeID;
            
        }else{
            
        }
        
        manager.sysNO = sysNO;
        manager.isStaff = isStaff;
        manager.loginName = loginName;
        manager.displayName = displayName;
        manager.passWord = passWord;
        manager.customersType = customersType;
        
        TabBarViewController *tabVC=[TabBarViewController share];
                self.window.rootViewController = tabVC;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
