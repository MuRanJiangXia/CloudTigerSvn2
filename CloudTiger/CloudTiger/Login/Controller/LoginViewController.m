//
//  LoginViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginChooseView.h"
#define BaseTag 20160906



@interface LoginViewController ()<LoginChooseDelegate>{
    
    NSInteger _btnTag;
    UIImageView *bgImageV;
    NSString *_perText;
    NSString *_passwordText;
    LoginChooseView *loginChooseView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PaleColor;
//    self.view.backgroundColor = [UIColor whiteColor];

    [self creatUI];
    
    
    /**
     服务商，商户 isStaff = NO（自己加） ； 服务商、商户下员工 isStaff = YES（自己加)
     
     服务商，商户 登陆 -->  SysNo (主键) 登陆成功 isFirst= YES；（登录失败 isFirst = NO ）
     
     服务商、商户下员工登陆 -->  DisplayName（员工名） SysNO（主键） 【账号密码记录】
          -->  第二次请求； 主键请求  --> "1,0,云网科技" 第一个是商户主键 ，第二个是（类型0代表服务商，1代表商户），第三个服务商名称
     --->登陆成功  isFirst= YES ；登录失败（跳回登录页 isFirst = NO）
     
     */
}

-(void)creatUI{
//    1080 × 438
    CGFloat  height = MainScreenWidth * (438 /1080.0);
    NSLog(@"height :%f",height);
    bgImageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, height)];
    bgImageV.backgroundColor = [UIColor blueColor];
    bgImageV.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageV];

    bgImageV.userInteractionEnabled = YES;
    
    loginChooseView = [[LoginChooseView alloc]initWithFrame:CGRectMake(0, bgImageV.bottom, MainScreenWidth, 165)];
    [self.view addSubview:loginChooseView];
    loginChooseView.loginChooseDelegete = self;
  
    
//    #0086e7
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    text2
    loginBtn.frame = CGRectMake(15,loginChooseView.bottom + 10, MainScreenWidth -30, 40);
    [loginBtn setBackgroundImage:[CyTools imageWithColor:BlueColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0x0086e7, 1)] forState:UIControlStateHighlighted];

    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    
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

-(void)postLogin{
    
    if (!_perText.length) {
        NSLog(@"账号为空");
        [MessageView showMessage:@"账号输入为空"];
        return;
    }
    if (!_passwordText.length) {
        NSLog(@"密码为空");
        [MessageView showMessage:@"密码输入为空"];

        return;
    }
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    
    NSDictionary *parameters  = @{
                                 @"UserName":_perText,
                                 @"PassWord":_passwordText
                                  
                                  };
    NSString *url = @"";
    
    if (_btnTag - BaseTag == 0) {//商户
        url = [BaseUrl stringByAppendingString:LoginShopUrl];
    }else{
        url = [BaseUrl stringByAppendingString:LoginStaffUrl] ;
        
    }
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        NSInteger code  = [responseObject[@"Code"] integerValue];
        NSString *description = responseObject[@"Description"];
        if (code == 0) {
            NSLog(@"成功");
            if (_btnTag -BaseTag == 0) {//服务商
                NSLog(@"responseObject :%@",responseObject);
                [self dismissSVP];
                    CyanManager *manager = [CyanManager shareSingleTon];
                    NSDictionary *dataDic = [responseObject objectForKey:@"Data"];
                    NSString *sysNO = [NSString stringWithFormat:@"%@",dataDic[@"SysNo"]];
                    //                NSString *sysNO = dataDic[@"SysNo"];
                    
                    NSString *loginName   = [dataDic objectForKey:@"Customer"];//账号
                    NSString *displayName   = [dataDic objectForKey:@"CustomerName"];
                    NSString *customersType   = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"CustomersType"]];
                    
                //不储存 密码了
//                    NSString *passWord = _passwordText;
                    manager.sysNO = sysNO;
                    manager.isStaff = [NSString stringWithFormat:@"%ld",_btnTag - BaseTag];
                    manager.loginName = loginName;
                    manager.displayName = displayName;
//                    manager.passWord = passWord;
                    manager.customersType = customersType;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:sysNO forKey:@"sysNO"];
                [defaults setObject:[NSString stringWithFormat:@"%ld",_btnTag - BaseTag] forKey:@"isStaff"];
                [defaults setObject:loginName forKey:@"loginName"];
                [defaults setObject:displayName forKey:@"displayName"];
//                [defaults setObject:passWord forKey:@"passWord"];
                [defaults setObject:customersType forKey:@"customersType"];
                
                [defaults synchronize];
                
                
                /**
                 tabbar  需要从新刷新
                 */
                if (manager.isLoadTabar) {
                    TabBarViewController *tabVC=[TabBarViewController share];
                    [tabVC creatVC];
                    manager.isLoadTabar = NO;
                }
                /**
                 2017,05,03
                 */
                //延时加载
                [self performSelector:@selector(goHome) withObject:nil afterDelay:.1];
   
            
            }else{//员工
                
                /**
                 Data =     {
                 "Alipay_store_id" = "<null>";
                 CustomerServiceSysNo = "<null>";
                 DepartmentName = bb;
                 DisplayName = "\U9648\U5c1a\U5c1a";
                 EditDate = "/Date(1475992233780)/";
                 EditUser = "<null>";
                 Email = "2419280336@qq.com";
                 InDate = "/Date(1466842077230)/";
                 InUser = 1;
                 LoginName = css;
                 OldPassword = "<null>";
                 OpenID = "<null>";
                 Password = 123;
                 PhoneNumber = 13080014309;
                 Status = 0;
                 SysNO = 1;
                 };
                 */
//                PhoneNumber Email OpenID
                NSDictionary *dataDic = [responseObject objectForKey:@"Data"];
                NSString *sysNO = [NSString stringWithFormat:@"%@",dataDic[@"SysNO"]];
                NSString *loginName   = [dataDic objectForKey:@"LoginName"];
                NSString *displayName   = [dataDic objectForKey:@"DisplayName"];
                NSString *passWord = _passwordText;
                
                NSString *phoneNumber   = [dataDic objectForKey:@"PhoneNumber"];
                NSString *email   = [dataDic objectForKey:@"Email"];
                NSString *storeID   = [dataDic objectForKey:@"Alipay_store_id"];
                //可能是null 设置成@“”
                if (IsNilOrNull(storeID)) {
                    storeID = @"";
                }
                if (IsNilOrNull(phoneNumber)) {
                    phoneNumber = @"";
                }
                if (IsNilOrNull(email)) {
                    email = @"";
                }
                if (IsNilOrNull(loginName)) {
                    loginName = @"";
                }
                if (IsNilOrNull(displayName)) {
                    displayName = @"";
                }
                
                CyanManager *manager = [CyanManager shareSingleTon];
                manager.sysNO = sysNO;
                manager.isStaff = [NSString stringWithFormat:@"%ld",_btnTag - BaseTag];
                manager.loginName = loginName;
                manager.displayName = displayName;
                manager.passWord = passWord;
                manager.phoneNumber = phoneNumber;
                manager.email = email;
                manager.storeID = storeID;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:sysNO forKey:@"sysNO"];
                [defaults setObject:[NSString stringWithFormat:@"%ld",_btnTag - BaseTag] forKey:@"isStaff"];
                [defaults setObject:loginName forKey:@"loginName"];
                [defaults setObject:displayName forKey:@"displayName"];
                [defaults setObject:passWord forKey:@"passWord"];
                
                [defaults setObject:email forKey:@"email"];
                [defaults setObject:storeID forKey:@"storeID"];
                [defaults setObject:phoneNumber forKey:@"phoneNumber"];
                
                [defaults synchronize];
 
                
                [self loadCustomersType];
            }
        }else{
            
            [self dismissSVP];
            [self alterWith:description];
            NSLog(@"失败");
  
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissSVP];
        IsNilOrNull(error.userInfo[@"NSLocalizedDescription"])?  [self alterWith:@"网络错误"]:  [self alterWith:error.userInfo[@"NSLocalizedDescription"]];
        
        NSLog(@"error :%@",error);
    }];
}


/**
 请求类别
 */
-(void)loadCustomersType{
    CyanManager *cyanManager = [CyanManager shareSingleTon];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    
    
    //修改了
    /**
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     //    AFPropertyListResponseSerializer AFHTTPResponseSerializer AFJSONResponseSerializer
     这两个 必须设置
     
     manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
     */
    
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    //    NSString *sysNo = @"";
    
    //    _cyanManager.sysNO
    NSDictionary *parameters  = @{
                                  @"SystemUserSysNo":cyanManager.sysNO
                                  
                                  };
    
    //    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    //    NSString *json = [writer stringWithObject:parameters];
    
    //    TopGradeUrl LoginShopUrl
    NSString *url = [BaseUrl stringByAppendingString:TopGradeUrl];;
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject :%@",responseObject);
        NSDictionary *dataDic = responseObject;
        
           [self dismissSVP];
        
        if (![dataDic isKindOfClass:[NSDictionary class]]) {
            [self alterWith:@"获取员工类别失败"];
            NSLog(@"不是字典");
        }else{
            
            if (dataDic.count ==0) {
                
                [self alterWith:@"获取员工类别失败"];
                NSLog(@"字典个数为空");
                
                
            }else{
                
                [CyTools loginSuccess];
                
                cyanManager.shopSysNo = dataDic[@"CustomerSysNo"];
                cyanManager.customersType = dataDic[@"CustomersType"];
                cyanManager.shopName = dataDic[@"CustomerName"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:dataDic[@"CustomerSysNo"] forKey:@"shopSysNo"];
                [defaults setObject:dataDic[@"CustomersType"] forKey:@"customersType"];
                [defaults setObject:dataDic[@"CustomerName"] forKey:@"shopName"];
                
                [defaults synchronize];
                
                NSString *customersType  = [defaults objectForKey:@"customersType"];
                NSLog(@"customersType : %@",customersType);
                /**
                 tabbar  需要从新刷新
                 */
                if (cyanManager.isLoadTabar) {
                    TabBarViewController *tabVC=[TabBarViewController share];
                    [tabVC creatVC];
                    
                    cyanManager.isLoadTabar = NO;
                }
                
            //延时加载
                [self performSelector:@selector(goHome) withObject:nil afterDelay:.1];
//                [self goHome];
                NSLog(@"获取字典数据");
                
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error :%@",error);
#pragma mark 需要跳转登录页
        [self dismissSVP];
        [self alterWith:@"获取员工类别失败"];

        
    }];
}
-(void)loginAction:(UIButton *)btn{

    UITextField *perText = (UITextField *)[loginChooseView.chooseScroll viewWithTag:BaseTag + 0+ 10 * (_btnTag -BaseTag + 1)];
    UITextField *passwordText = (UITextField *)[loginChooseView.chooseScroll viewWithTag:BaseTag + 1+ 10 * (_btnTag -BaseTag + 1)];
    
    [perText resignFirstResponder];
    [passwordText resignFirstResponder];

//    [self showSVPByStatus:@"登录中。。"];

    _perText = perText.text;
    _passwordText = passwordText.text;
    
    [self postLogin];

}
#pragma mark LoginChooseDelegate
-(void)joinActionBy:(NSInteger)btnTag{
      _btnTag = btnTag;
     [self loginAction:nil];
}



-(void)chooseTag:(NSInteger)btnTag Text:(NSArray *)textArr{
    _btnTag = btnTag;
}
@end
