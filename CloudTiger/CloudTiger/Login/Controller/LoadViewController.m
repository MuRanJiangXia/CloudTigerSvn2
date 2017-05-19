//
//  LoadViewController.m
//  CloudTiger
//
//  Created by cyan on 16/11/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "LoadViewController.h"
#import "LoginViewController.h"

@interface LoadViewController (){
    NSTimer *_timer;

    UIButton *_timeBtn;
}
@property(nonatomic,assign) NSInteger index ;

@end

@implementation LoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    imageView.backgroundColor = [UIColor yellowColor];
    imageView.image = [UIImage imageNamed:@"adView"];
    [self.view addSubview:imageView];

    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(MainScreenWidth - 15 -80, 20 +5, 80, 40);
    _timeBtn.backgroundColor = [UIColor blackColor];
    [_timeBtn setTitle:@"跳过4s" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_timeBtn addTarget:self action:@selector(jumpRootVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];

    _timeBtn.alpha = .5;
    
    _timeBtn.layer.cornerRadius = 5;
    _timeBtn.layer.masksToBounds = YES;
//    button.layer.borderColor = [UIColor blueColor].CGColor;
//    button.layer.borderWidth = 1;
    [self creatTimer];
}
#pragma mark timer
-(void)timerAction:(NSTimer *)timer{
    _index = _index - 1;
    NSLog(@"%ld",_index);
    [_timeBtn setTitle:[NSString stringWithFormat:@"跳过%lds",_index] forState:UIControlStateNormal];
    
    if (_index == 0) {
        //定时器停止
        [_timer invalidate];
        _timer = nil;
        
        [self rooterVC];
    }

}
//开启定时器
-(void)creatTimer{
    //60 18
    self.index = 4;
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    
}

-(void)jumpRootVC:(UIButton *)btn{
    //定时器停止
    [_timer invalidate];
    _timer = nil;
    [self rooterVC];
}

-(void)rooterVC{
    NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:isFirstFilePath];
    
    BOOL isFirst = [dic[@"isFirst"] boolValue];//第一次是no
    
    if (!isFirst) {
        NSLog(@"%d",isFirst);
        LoginViewController *login = [[LoginViewController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController  = login;
        
        
        
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
        
//        TabBarViewController *tabVC=[TabBarViewController share];
//        [UIApplication sharedApplication].keyWindow.rootViewController  = tabVC;
        
        [self goHome];

    }
    
}

-(void)goHome{
    TabBarViewController *tabVC=[TabBarViewController share];
    tabVC.selectedIndex = 0;
    typedef void (^Animation)(void);
    UIWindow* window =  [UIApplication sharedApplication].keyWindow;
    
    tabVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = tabVC;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
}


@end
