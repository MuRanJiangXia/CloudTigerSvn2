//
//  CodePostViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/23.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CodePostViewController.h"
#import "ViocePlayManager.h"
@interface CodePostViewController (){
    
    BOOL _isWXPay;
    UIImageView *_payImageV;
    UILabel *_payLab;
    
    NSTimer *_timer;
    NSString *_state;//支付状态
    NSString *_tradeNumber;//订单号
    
    CyanManager  *_cyanManager;
    ViocePlayManager *_vioceManager;
    
}
@property(nonatomic,assign) NSInteger index ;

@end

@implementation CodePostViewController

-(void)dealloc{
    NSLog(@"销毁了");
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //将要消失的时候 销毁定时器 避免vc不能销毁
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付请求";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    pay_wait
    
    _payImageV = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenWidth - 130)/2.0, 100, 130, 130)];
//    _payImageV.backgroundColor = [UIColor yellowColor];
    _payImageV.image = [UIImage imageNamed:@"pay_success"];
    _payImageV.hidden = YES;
    [self.view addSubview:_payImageV];

    
    _payLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _payImageV.bottom + 20, MainScreenWidth, 50)];
//    _payLab.backgroundColor = [UIColor redColor];
    _payLab.text = @"支付成功";
    _payLab.textColor = UIColorFromRGB(0x8bc34a, 1);
    _payLab.textAlignment = NSTextAlignmentCenter;
    _payLab.hidden = YES;
    _payLab.font = [UIFont systemFontOfSize:40 weight:2];
    [self.view addSubview:_payLab];
    
    
    _cyanManager = [CyanManager shareSingleTon];
    [self postPAY:nil];
    
    NSLog(@"codeStr : %@",self.codeStr);
    //创建语音对象
    _vioceManager = [ViocePlayManager shareVioceManager];
}

-(void)backAction{
    
    if ([_state isEqualToString:@"success"]||[_state isEqualToString:@"fail"]) {
        [super backAction];
    }
}

/**清理定时器*/
-(void)cleanTimer{
    [_timer invalidate];
    _timer = nil;
//    //60 18
//    self.index = 60;
    
}
#pragma mark timer
-(void)timerAction:(NSTimer *)timer{
    
    NSLog(@"%ld",_index);
//    _timeLabel.text = [NSString stringWithFormat:@"%lds后获取",_index];
    NSString *time = [NSString stringWithFormat:@"%ld",_index--];
    [self reloadPayViewByTime:time];
    if (_index < 0) {
        
        //超时了  取消订单
        /**
         超时了 ，并且不是 订单成功状态
         清空 二维码图片 提示超时
         */
   
        [timer invalidate];
        timer = nil;
        
    }
}
//开启定时器
-(void)creatTimer{
    //60 18
    self.index = 60;
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    
}

#pragma mark 语音提示
/**语音提示支付成功*/
-(void)viocePlay{
    [_vioceManager voiceBroadCastStr:@"支付成功"];
    
}
/**语音提示暂停*/
-(void)viocePause{
    
    [_vioceManager pause];
    
}
/**语音提示停止*/
-(void)vioceStop{
    [_vioceManager stop];
}

//支付等待中
-(void)reloadPayViewByTime:(NSString *)time{
    
    _payLab.hidden = NO;
    _payImageV.hidden = NO;
    _payLab.textColor = UIColorFromRGB(0x8bc34a, 1);
    _payLab.text = [NSString stringWithFormat:@"%@s",time];
    _payImageV.image = [UIImage imageNamed:@"pay_wait"];
    
}
//支付结果
-(void)reloadPayView:(BOOL)isSuccess{
    
    _payLab.hidden = NO;
    _payImageV.hidden = NO;
    if (isSuccess) {
        _payLab.textColor = UIColorFromRGB(0x8bc34a, 1);

        _payLab.text = @"支付成功";
        _payImageV.image = [UIImage imageNamed:@"pay_success"];

        
    }else{
        _payLab.textColor = UIColorFromRGB(0xfc771d, 1);
        _payLab.text = @"支付失败";
        _payImageV.image = [UIImage imageNamed:@"pay_fail"];
        
    }
}
-(void)backVC:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
}

/**
   先根据 支付授权码 获取订单号
 
   把订单号支付  （同时 插入订单号到服务器）
 
   最后 支付成功推送
 */

-(void)postPAY:(UIButton *)btn{
    
    
    if (!self.codeStr.length) {
        NSLog(@"没有code二维码");
        [self alterWith:@"扫描结果为空"];
        return;
    }else{
        
        
        if (_cyanManager.payState == kNoPay) {
            [self reloadPayView:NO];
            [self alterWith:@"该用户没有扫码支付权限"];
            _state = @"fail";

            return;
        }
        
        if ([self.codeStr hasPrefix:@"13"]) {//微信
            
            if (_cyanManager.payState == kAliPay) {
                [self reloadPayView:NO];
                [self alterWith:@"该用户没有微信扫码支付权限"];
                _state = @"fail";

                return;
            }
            _isWXPay = YES;
            
        }else if ([self.codeStr hasPrefix:@"28"]){//支付宝
            
            if (_cyanManager.payState == kWXPay) {
                [self reloadPayView:NO];
                [self alterWith:@"该用户没有支付宝扫码支付权限"];
                _state = @"fail";

                return;
            }
            _isWXPay = NO;
 
        }else {
            
            _state = @"fail";
            [self reloadPayView:NO];
            [self alterWith:[NSString stringWithFormat:@"%@,不是支付二维码",self.codeStr]];
            
            return;
        }
        
        
       
    }

    //获取订单号
    [self   getPayNumber];
    
}
/**支付*/
-(void)codePay{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    
    [manager.requestSerializer setTimeoutInterval:_index];
    
    
//    NSString *shopNane = _cyanManager.shopName;
    NSString *fee =  [CyTools  interByStr:self.moneyStr];
    NSString *url ;
    
    NSDictionary *parameters;
    NSLog(@"_isWXPay : %d",_isWXPay);
    if (_isWXPay) {
        //微信
        url =[BaseUrl stringByAppendingString:WXCodePayUrl];
        parameters =         @{
                               @"out_trade_no":_tradeNumber,
                               @"Total_fee":fee,
                               @"auth_code":self.codeStr,
                               @"POSID":@"11",
                               @"CustomerSysNo":_cyanManager.shopSysNo,
                               @"Old_SysNo":_cyanManager.sysNO
                               };
        
        
    }else{
        //        支付宝
        url =[BaseUrl stringByAppendingString:AliCodePayUrl];
        parameters =         @{
                               @"out_trade_no":_tradeNumber,
                               @"Total_amount":fee,
                               @"Auth_code":self.codeStr,
                               @"CustomerSysNo":_cyanManager.shopSysNo,
                               @"Old_SysNo":_cyanManager.sysNO
                               };
    }
    
    //    [self showSVPByStatus:@"支付中。。"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [self dismissSVP];
        NSLog(@"====== 支付中  ========");

        NSLog(@"responseObject :%@",responseObject);
        
        NSInteger Code = [responseObject[@"Code"] integerValue];
        NSString *Description = responseObject[@"Description"];
        
        if (Code == 0) {
            NSLog(@"支付成功");
            [self cleanTimer];
            //            [self alterWith:@"支付成功"];
            [self reloadPayView:YES];
            _state = @"success";
            
            /**
             2017.3.8  支付成功调接口 通知支付成功
             金额 转成 元为单位
             类型 ：支付宝 ，微信
             */
//            _tradeNumber =  responseObject[@"Data"][@"WxPayData"];
            [self postPayPushMessage];
            [self viocePlay];
            
        }else{
            [self cleanTimer];
            
            [self reloadPayView:NO];
            _state = @"fail";
            [self alterWith:Description];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [self dismissSVP];
        _state = @"fail";
        
        
        [self cleanTimer];
        [self reloadPayView:NO];
        _state = @"fail";
        IsNilOrNull(error.userInfo[@"NSLocalizedDescription"])?  [self alterWith:@"网络错误"]:  [self alterWith:error.userInfo[@"NSLocalizedDescription"]];
        
        if ( error.code == -1001) {
            NSLog(@"网络请求超时");
        }
        
        NSLog(@"error :%@",error);
        
    }];
}
/**插入后台数据库*/
-(void)insertPayNumber{
    
    
    NSNumber *number = [List objectForKey:_tradeNumber];
    if (IsNilOrNull(number)) {//如果没有 记录这个数据
        //记录订单号
        NSNumber  *number2 =  [NSNumber numberWithInteger:1];
        [List setObject:number2 forKey:_tradeNumber];
    }else{
        NSInteger  count  = [number integerValue];
        if (count > 10) {
            NSLog(@"已经插入十次了，不在做操作");
            return;
        }
        
        
    }

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    AFPropertyListResponseSerializer AFHTTPResponseSerializer AFJSONResponseSerializer
//    这两个 必须设置
    
    manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:10];
    
    NSString *url  = [BaseUrl stringByAppendingString:InsertCodePayUrl];
    
    /**
     @"CustomerServiceSysNo":@"",商户主键
     @"SystemUserSysNo":@"", 员工主键
     @"Total_fee":@"",  总金额
     @"Pay_Type":@"",  支付类型
     @"Out_trade_no":@"" 订单号
     
     
     Pay_Type参数格式这样传,"支付类型-客户端"
     
     苹果：102-IOS(微信)，103-IOS（支付宝）
     
     */
    
    NSString *fee =  [CyTools  interByStr:self.moneyStr];
    NSString *payType =  @"";
    
    if (_isWXPay) {
      payType  = @"102-IOS";
    }else{
      payType  = @"103-IOS";
        
    }
    NSDictionary *parameters = @{
                                 @"CustomerServiceSysNo":_cyanManager.shopSysNo,
                                 @"SystemUserSysNo":_cyanManager.sysNO,
                                 @"Total_fee":fee,
                                 @"Pay_Type":payType,
                                 @"Out_trade_no":_tradeNumber

                                 };
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"====== 订单号插入后台  ========");
        NSLog(@"responseObject: %@",responseObject);
        
        if ([responseObject isEqualToString:@"true"]) {
            NSLog(@"订单号插入后台 成功");
            //清空保存的userdefualts
            [List removeObjectForKey:_tradeNumber];
            
            
        }else{
            NSNumber *number = [List objectForKey:_tradeNumber];

            NSInteger count = [number integerValue];
            count++;
            [List setObject:[NSNumber numberWithInteger:count] forKey:_tradeNumber];
            [self insertPayNumber];
            NSLog(@"订单号插入后台 失败");
  
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNumber *number = [List objectForKey:_tradeNumber];
        NSInteger count = [number integerValue];
        count++;
        [List setObject:[NSNumber numberWithInteger:count] forKey:_tradeNumber];
        [self insertPayNumber];
        NSLog(@"订单号插入后台失败 /n error: %@",error);

    }];
    
    
}

/**获取支付订单号*/
-(void)getPayNumber{
    //先清空一下
    [self cleanTimer];
    
    //开启时间
    [self creatTimer];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:10];
    
    NSString *url  = [BaseUrl stringByAppendingString:GetAliCodePayUrl];
    
    NSDictionary *parameters = @{};
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"====== 获取订单号  ========");

        NSLog(@"responseObject : %@",responseObject);
      NSInteger  Code = [responseObject[@"Code"] integerValue];
        if (Code == 0) {//获取订单号成功
            NSString *Data =  responseObject[@"Data"];
            //支付
            _tradeNumber = Data;
            [self codePay];
            
            //插入订单号给后台
            [self insertPayNumber];
        }else{
            
            [self reloadPayView:NO];
            _state = @"fail";
            [self alterWith:@"获取订单号失败"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self reloadPayView:NO];
        _state = @"fail";
        [self alterWith:@"获取订单号失败"];

//        IsNilOrNull(error.userInfo[@"NSLocalizedDescription"])?  [self alterWith:@"网络错误"]:  [self alterWith:error.userInfo[@"NSLocalizedDescription"]];


        NSLog(@"error : %@",error);

    }];
    
    
    
}

//支付成功 推送消息
-(void)postPayPushMessage{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
//    {CustomerServiceSysNO:2,SystemUserSysNO:2,Money:1,Out_trade_no:'12345678098774',Type:'微信'}
    
    CyanManager  *cyanManager = [CyanManager shareSingleTon];
    NSString *type = @"";
    NSMutableDictionary *parameters = [@{
                                 @"CustomerServiceSysNO":cyanManager.shopSysNo,
                                 @"SystemUserSysNO":cyanManager.sysNO,
                                 @"Money":self.moneyStr,
                                 @"Out_trade_no":_tradeNumber,
                                 @"Type":type
                                 
                                 } mutableCopy];

    if (_isWXPay) {
        type = @"微信";
        [parameters setObject:type forKey:@"Type"];
 
        [self postPayFinalWith:parameters];
        
    }else{
        type = @"支付宝";
        [parameters setObject:type forKey:@"Type"];

        //判断 是否有微信配置
//        @"IPP3Customers/IPP3WxconfigBySUsysNo"
        NSDictionary *WXParameters = @{
//                                     cyanManager.sysNO
                                    @"systemUserSysNo":cyanManager.sysNO,
                                     
                                     };
        
        NSString *url  =  [BaseUrl stringByAppendingString:WXConfigurationUrl];
        
        [manager POST:url parameters:WXParameters progress:^(NSProgress * _Nonnull uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject : %@",responseObject);
            
            //如果没有配置  推送
            if (IsNilOrNull(responseObject)) {
                
                [self postPayFinalWith:parameters];
                
            }else{
                //有微信配置 不推送
               NSLog(@"有微信配置 不推送");
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error : %@",error);
        }];
        
        
    }

 
    
}

-(void)postPayFinalWith:(NSDictionary *)dic{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    
    NSString *url  =  [BaseUrl stringByAppendingString:CodePayPushMessageUrl];
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@",error);
        
    }];
}

@end
