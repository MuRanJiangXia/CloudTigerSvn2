//
//  CodeViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/19.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CodeViewController.h"
#import "CustomQRCode.h"
#import "SBJSON.h"
#import "ViocePlayManager.h"
@interface CodeViewController ()<UITextFieldDelegate>{
    
    UIImageView *codeImageV ;
    UITextField *moneyText;
    NSInteger _btnTag;
    BOOL isHaveDian ;
    
    UILabel *_moneyLab;
    NSTimer *_timer;
    
    UILabel *_stateLab;
/**二维码 生成后的订单号*/
    NSString *_out_trade_no;//二维码 生成后的订单号
/**二维码 生成后的订单号状态*/
    NSString *_orderState;
    
    ViocePlayManager *_vioceManager;

}
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,assign) NSInteger index ;

@end

@implementation CodeViewController

-(void)dealloc{
    
    
    NSLog(@"销毁了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码支付";
    self.view.backgroundColor = PaleColor;
    [self creatUI];
    
    //创建语音对象
    _vioceManager = [ViocePlayManager shareVioceManager];



}

//将要已经消失的时候 停一下
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [moneyText resignFirstResponder];
    
    //如果生成二维码  取消一下这个订单
        [_timer invalidate];
        _timer = nil;
}

-(void)creatUI{
//    260/70
    CGFloat with = 130 ;
    CGFloat x = (MainScreenWidth - 260)/4.0;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 70/260.0 * with  + 20)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
//    code_ali_n_2
    NSArray *btnArr  = @[@"code_wx_s_2",@"code_ali_s_2"];
    NSArray *btnArr2  = @[@"code_wx_n_2",@"code_ali_n_2"];

    for (NSInteger index = 0; index < btnArr.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(index * (with + 2 *x) +x , 10, with, 70/260.0 * with);
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:btnArr[index]] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:btnArr2[index]] forState:UIControlStateNormal];
        button.tag = 20160919 +index;
        if (index == 0) {
            button.selected = YES;
            _btnTag = button.tag;
        }
    }

    //    750/290
    UIImageView *topBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.bottom+10, MainScreenWidth,  145)];
//    topBgView.backgroundColor = [UIColor yellowColor];
    topBgView.image = [UIImage imageNamed:@"code_wx_bg"];
    [self.view addSubview:topBgView];
    
    topBgView.userInteractionEnabled = YES;
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 50)];
//    label.backgroundColor = [UIColor redColor];
    label.text = @"￥";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:14];
//    [topBgView addSubview:label];
    
    moneyText = [[UITextField alloc]initWithFrame:CGRectMake(15,  37.5/2.0, MainScreenWidth -30, 50)];
    moneyText.placeholder = @"输入金额";
    //    moneyText.font = [UIFont systemFontOfSize:50];
    moneyText.font = [UIFont boldSystemFontOfSize:50];

//    moneyText.font = [UIFont systemFontOfSize:50 weight:8];
//    UIKeyboardTypeNumberPad UIKeyboardTypeNumbersAndPunctuation UIKeyboardTypeDecimalPad
    moneyText.keyboardType = UIKeyboardTypeDecimalPad;
    moneyText.textAlignment = NSTextAlignmentCenter;

    moneyText.delegate = self;
    [topBgView addSubview:moneyText];
    
    [moneyText addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    //label超出不显示
    moneyText.clipsToBounds = YES;
    
    /**
     监听textfield 的text变化，加上 ￥
     */
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 20, 30)];
    //    _moneyLab.backgroundColor = [UIColor redColor];
    _moneyLab.text = @"￥";
    _moneyLab.textColor = [UIColor blackColor];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    //    _moneyLab.center = moneyText.center;
    _moneyLab.font = [UIFont systemFontOfSize:14];
    _moneyLab.hidden = YES;
    [moneyText addSubview:_moneyLab];

    //    230/230
    //二维码btn
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((MainScreenWidth - 115)/2.0, 0, 115, 115);
//    button.backgroundColor = [UIColor purpleColor];
    [button setBackgroundImage:[UIImage imageNamed:@"code_n"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"code_n"] forState:UIControlStateHighlighted];

//    [button setBackgroundImage:[UIImage imageNamed:@"code_s"] forState:UIControlStateHighlighted];

//    code_s
    [button addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = CGPointMake(button.center.x, topBgView.bottom);
    
    //二维码显示
//    438 /438
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenWidth -219)/2.0, button.bottom + 20, 219, 219)];
//    imageView.backgroundColor = [UIColor cyanColor];
    imageView.image = [UIImage imageNamed:@"code_bg"];
    [self.view addSubview:imageView];

    
    codeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
//    codeImageV.backgroundColor = [UIColor yellowColor];
//    codeImageV.image = [UIImage imageNamed:@""];
    [self.view addSubview:codeImageV];

    codeImageV.center = imageView.center;
  
 
    
//测试显示 秒
    _timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth -100)/2, codeImageV.bottom +10, 100, 40)];
    _timeLabel.backgroundColor = [UIColor redColor];
    _timeLabel.text = @"60s";
    _timeLabel.textColor = [UIColor yellowColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.hidden = YES;
    [self.view addSubview:_timeLabel];
    
    
//    _statueLab 订单状态
    
    _stateLab  = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth -200)/2, codeImageV.bottom + 5, 200, 80)];
    _stateLab.center = codeImageV.center;
//    _stateLab.backgroundColor = [UIColor redColor];
//    _stateLab.text = @"订单状态";
//#42af35  成功
//#ff5b11  失败
    _stateLab.text = @"支付失败\n请重新生成二维码";
    _stateLab.textColor = UIColorFromRGB(0xff5b11, 1);
    _stateLab.textAlignment = NSTextAlignmentCenter;
    _stateLab.font = [UIFont systemFontOfSize:24];
    _stateLab.numberOfLines = 2;
    _stateLab.hidden = YES;
    [self.view addSubview:_stateLab];
    
    
    
}
/**清空order的订单状态*/
-(void)cleanOrderState{
    _orderState = @"";
}
/**清理二维码*/
-(void)cleanCodeImage{
    //清空一下 二维码图片
    codeImageV.image = [CyTools imageWithColor:[UIColor clearColor]];
    
}

/**清理定时器*/
-(void)cleanTimer{
    [_timer invalidate];
    _timer = nil;
    //60 18
    self.index = 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%lds",  self.index ];
}
#pragma mark timer
-(void)timerAction:(NSTimer *)timer{
    _index = _index - 3;
    NSLog(@"%ld",_index);
    _timeLabel.text = [NSString stringWithFormat:@"%lds后获取",_index];
    
    if (_index == 0) {
      if (![_orderState isEqualToString:@"SUCCESS"]) {
            //取消二维码
            [self postCanelOrder:_out_trade_no];
        }
    }
    if (_index < -3) {
        
        //超时了  取消订单
        /**
         超时了 ，并且不是 订单成功状态
         清空 二维码图片 提示超时
         */
        _stateLab.hidden = NO;
        //清空一下 二维码图片
        codeImageV.image = [CyTools imageWithColor:[UIColor clearColor]];
        //            [MessageView showMessage:@"支付超时。。"];
        _stateLab.textColor = UIColorFromRGB(0xff5b11, 1);
        _stateLab.text = @"支付失败\n请重新生成二维码";
        _timeLabel.text = @"获取订单号";
        [timer invalidate];
        timer = nil;
       
    }else{
         [self postCodeNumber:_out_trade_no];
    }
}
//开启定时器
-(void)creatTimer{
    //60 18
    self.index = 60;
    _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];

}

/**取消订单*/
-(void)postCanelOrder:(NSString *)codeNumber{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:10];
//    NSString *money =   [CyTools interByStr:moneyText.text];
    CyanManager *mangager = [CyanManager shareSingleTon];
    
    //            Payment/Payments/WXCloseOrder 微信
    
    //
    /**
     out_trade_no 订单号
     systemUserSysNo 员工主键
     */
    
    if (codeNumber.length == 0) {
        codeNumber = @"";
    }
    NSDictionary *parameters  = @{
                                  @"out_trade_no":codeNumber,
                                  @"systemUserSysNo":mangager.sysNO
                                  };
    NSString *url = [NSString stringWithFormat:@""];
    if (_btnTag - 20160919 == 0) {  //微信
        url  = [BaseUrl stringByAppendingString:WXOrderCancelUrl];
        
    }else{  // 支付宝
        url  = [BaseUrl stringByAppendingString:AliOrderCancelUrl];
        
        
    }
    
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject :%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@",error );
    }];
}

/**
 responseObject :{
 Code = 0;
 Data = 20161013095254751204328;
 Description = "https://qr.alipay.com/bax07075zpu8phsscdyt403d";
 }
  微信 ： 133268090120161013100151835   。。133268090120161013105123914 （支付成功的）
 支付宝 ： 20161013095254751204328 、、20161013100735823191416（支付成功的）
 */


/**
 生成二维码 -->成功 --> 60s 超时设置
 【60s 内循环请求 3s（2秒）查询订单接口 --> 订单成功（关闭二维码，提升成功）；订单失败（不作操作）】
 
 60s 超时 关闭订单（关闭二维码，支付失败）
 */

//查询订单 状态
-(void)postCodeNumber:(NSString *)codeNumber{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:10];
    NSString *money =   [CyTools interByStr:moneyText.text];
    CyanManager *mangager = [CyanManager shareSingleTon];
    
    NSDictionary *parameters  = @{
                                  @"out_trade_no":codeNumber,
                                  @"systemUserSysNo":mangager.sysNO
                                  };
    NSString *url = [NSString stringWithFormat:@""];
    if (_btnTag - 20160919 == 0) {  //微信
        url  = [BaseUrl stringByAppendingString:QueryWXOrderUrl];
        
    }else{  // 支付宝
        url  = [BaseUrl stringByAppendingString:QueryAliOrderUrl];
        
        
    }
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject :%@",responseObject);
        NSInteger  Code = [responseObject[@"Code"] integerValue];
        if (Code == 0) {
            if (_btnTag -20160919 == 0) {//微信
                if (!_out_trade_no.length) {
                    NSLog(@"上一次的订单号改变了");
                    return ;
                }
                
                NSDictionary *Data = responseObject[@"Data"];
                NSDictionary *WxPayData = Data[@"WxPayData"];
                NSDictionary *m_values = WxPayData[@"m_values"];
                NSString *trade_state = m_values[@"trade_state"];
                
                if ([trade_state isEqualToString:@"SUCCESS"]) {//支付成功 不在请求网络了 定时器停止
                    NSLog(@"支付成功");
                    if (_btnTag == 20160919 ) {//如果是微信 没有切换
              
                        [self reloadPayView];
                    }
                
                    
                }else{
//                    _stateLab.text = @"支付中。。";
                    
                    NSLog(@"支付失败");
                }
                
            }else{
                    NSDictionary *data = responseObject[@"Data"];
                    NSString *wxStr = data[@"WxPayData"];
                    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
                    NSDictionary *jsonObjects = [jsonParser objectWithString:wxStr];
                    NSDictionary *m_values = jsonObjects[@"alipay_trade_query_response"];
                if (NotNilAndNull(m_values)) {
                
                      NSString *trade_state = m_values[@"trade_status"];
                    if ([trade_state isEqualToString:@"TRADE_SUCCESS"]) {//支付成功 不在请求网络了 定时器停止
                        
                    if (_btnTag == 20160920 ) {//如果是支付宝 没有切换
                        if (!_out_trade_no.length) {
                            NSLog(@"上一次的订单号改变了");
                            return ;
                        }
                        [self reloadPayView];
                        
                        
                    }
                    
                    }
                    
                }
                
            }
            
  
            
        }else{
//            _stateLab.text = @"支付中。。";
            NSLog(@"支付失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error :%@",error);
    }];
    
}
/**最后刷新支付成功提示*/
-(void)reloadPayView{
    _stateLab.hidden = NO;
    _stateLab.text = @"支付成功";
    _stateLab.textColor = UIColorFromRGB(0x42af35, 1);
    
    _orderState = @"SUCCESS";
    //清空一下 二维码图片
    codeImageV.image = [CyTools imageWithColor:[UIColor clearColor]];
    
    _timeLabel.text = @"获取订单号";
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"====text :  %@",moneyText.text);
    [self viocePlay];
    
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
#pragma mark TextField ChangeValue
-(void)changeValue:(UITextField *)textField{
    NSLog(@"textField.text :%@",textField.text);
    if (!textField.text.length) {
        _moneyLab.hidden = YES;
    }else{
        _moneyLab.hidden = NO;
        //        [self reloadMoneyLocation:textField];
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {//有小数点
            NSLog(@"没有小数点");
            /**
             判断一下 ，可能是复制粘贴过来的 。。。
             */
            if (textField.text.length > 6) {
                NSString *changeStr = textField.text;
                textField.text = [changeStr substringToIndex:6];
            }
            
        }else{
            
            //判断小数点的位数
            NSRange ran = [textField.text rangeOfString:@"."];
            NSLog(@"textField.text :%@",textField.text);
            
            if (textField.text.length - ran.location >2) {
                NSMutableString *muteString = [[NSMutableString alloc]initWithFormat:@"%@",textField.text];
                //                49543  49.54
                //           123.456  --> 123.45
                [muteString deleteCharactersInRange:NSMakeRange(ran.location + 3,textField.text.length - ran.location - 3)];
                
                NSLog(@"muteString :%@",muteString);
                textField.text = [muteString copy];
                
            }
        }
        //刷新￥ 位置
        [self reloadMoneyLocation:textField];
        
    }
    
}
/**
 刷新 ￥ 标识的位置
 */
-(void)reloadMoneyLocation:(UITextField *)textF{
    
    CGSize textSize = [moneyText.text sizeWithAttributes:@{NSFontAttributeName:moneyText.font}] ;
    NSLog(@"width : %f,height :%f",textSize.width,textSize.height);
    CGFloat  with =     (  textF.frame.size.width  - textSize.width)/2.0 -20 ;
    _moneyLab.left = with;
}

-(void)payAction:(UIButton *)btn{
    NSLog(@"切换btn");
    btn.selected = YES;
    if (_btnTag!= 0) {
        if (_btnTag != btn.tag) {
            UIButton *preBtn =   [self.view viewWithTag:_btnTag];
            preBtn.selected = !preBtn.selected;
            
            _stateLab.hidden = YES;
            //清空上一次订单状态
            [self cleanOrderState];
             //清空一下 二维码图片
            [self cleanCodeImage];
           //清空 定时器
            [self cleanTimer];
        
            
        }
    }
    _btnTag = btn.tag;
    
}

-(void)codeAction:(UIButton *)btn{

    
    NSLog(@"二维码");
//    UIImage *codeImage =   [CustomQRCode generateCustomQRCode:@"Description" andSize:200.f andColor:  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1]];
//    codeImageV.image = codeImage;
    
    [self cleanTimer];
    [moneyText resignFirstResponder];
    [self postCode];
}

-(void)postCode{
    
    CyanManager *cyanManager = [CyanManager shareSingleTon];
    
    if (cyanManager.payState == kNoPay) {
        [self alterWith:@"该用户没有二维码支付权限"];
        return;
    }
    if (_btnTag - 20160919 == 0) {  //微信
        if (cyanManager.payState == kAliPay) {
            [self alterWith:@"该用户没有微信支付权限"];
            return;
        }
        
    }else{  // 支付宝
        if (cyanManager.payState == kWXPay) {
            [self alterWith:@"该用户没有支付宝支付权限"];
            return;
        }
        
        
    }
    
    
    
    if (!moneyText.text.length) {
        
//        [self showSVPErrorStatus:@"输入为空"];
        [MessageView showMessage:@"输入为空"];
        return;
    }
    CGFloat money1 = [moneyText.text floatValue];
    NSLog(@"money1 :%f",money1);
    if ([moneyText.text floatValue] <= 0.0) {
        NSString *money =   [CyTools interByStr:moneyText.text];
        //金额格式化显示
        moneyText.text =[CyTools folatByStr:money];
        [self changeValue:moneyText];
        [MessageView showMessage:@"输入金额不能为0元"];
        return;
    }
    
    NSString *money =   [CyTools interByStr:moneyText.text];
    NSLog(@"money :%@",money);
    
    //金额格式化显示
    moneyText.text =[CyTools folatByStr:money];
    [self changeValue:moneyText];
    
    //清空一下 订单号
    [self cleanOrderState];
    
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:10];

    
  
    CyanManager *mangager = [CyanManager shareSingleTon];
    
//    total_fee 1为0.01元
    NSDictionary *parameters  = @{
                                  @"Total_fee":money,
                                  @"systemUserSysNo":mangager.sysNO
                                  };
    NSString *url = [NSString stringWithFormat:@""];
    if (_btnTag - 20160919 == 0) {  //微信
        url  = [BaseUrl stringByAppendingString:GetWXCodeUrl];
        
    }else{  // 支付宝
        url  = [BaseUrl stringByAppendingString:GetAliCodeUrl];


    }

    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        NSInteger Code = [responseObject[@"Code"] integerValue];
        if (Code == 0) {
            NSString *Description = responseObject[@"Description"];
            NSString *Data = responseObject[@"Data"];
            UIImage *codeImage =   [CustomQRCode generateCustomQRCode:Description andSize:200.f andColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1]];
            codeImageV.image = codeImage;
            
            /**
             生成二维码 -->成功 --> 60s 超时设置
             【60s 内循环请求 3s（2秒）查询订单接口 --> 订单成功（关闭二维码，提升成功）；订单失败（不作操作）】
             
             60s 超时 关闭订单（关闭二维码，支付失败）
             */
            
            _out_trade_no = Data;
            _stateLab.hidden = YES;
            [self creatTimer];
            
            
        }else{
            [MessageView showMessage:@"请求错误"];

            NSLog(@"请求错误");
        }
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        [MessageView showMessage:@"生成二维码请求失败"];
        NSLog(@"error : %@",error);
        if (error.code == -1001) {
            NSLog(@"生成二维码 请求超时");
        }else{
            NSLog(@"生成二维码 请求失败");

        }
    }];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    if (textField.text.length) {
        if (![textField.text containsString:@"."]) {
            textField.text = [NSString stringWithFormat:@"%@.00",textField.text];
            _moneyLab.hidden = NO;
            CGSize textSize = [moneyText.text sizeWithAttributes:@{NSFontAttributeName:moneyText.font}] ;
            NSLog(@"width : %f,height :%f",textSize.width,textSize.height);
            CGFloat  with =     (  textField.frame.size.width  - textSize.width)/2.0 -20 ;
            _moneyLab.left = with;
        }
    }

    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    
    [textField resignFirstResponder];
    return YES;
}
/**
 12 3456.00
 
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    /**
     有无小数点  -> 无小数点 6 位
     
     ->  有小数点 -> 小数点后两位可以输入
     
     */
    
    if ([string isEqualToString:@""]) {//清空不处理
        return YES;
    }
    
    unichar single = [string characterAtIndex:0];//当前输入的字符
    
    if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
        
    }else{
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {//无小数点
        
        
        if (textField.text.length >= 6) {
            
            if ([string isEqualToString:@"."]) {
                
                
                return YES;
            }
            if ([string isEqualToString:@""]) {
                return YES;
            }
            
            return NO;
        }
        
        
    }else{//有小数点
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        
        
        if (textField.text.length >= 3 + 6) {
            NSLog(@"没有小数点 不能输入超过 10 0000 ");
            return NO;
        }
        
        //判断小数点的位数
        NSRange ran = [textField.text rangeOfString:@"."];
        
        NSLog(@"ran.location : %ld,range.location : %ld",ran.location,range.location);
        
        
        
        if (range.location > ran.location) {//小数点后边输入
            //有小数点 不能输入超过 10 0000 ；
            
            if (textField.text.length - ran.location == 3) {
                return NO;
            }
            
            return YES;
            
        }else{//小数点前边输入
            
            if (textField.text.length >= 3 + 6) {
                NSLog(@"没有小数点 不能输入超过 10 0000 ");
                return NO;
            }
            
            return YES;
            
        }
        
        
        
        
        
        
    }
    
    
    return YES;

}
- (void)showError:(NSString *)errorString
{

    [SVProgressHUD showErrorWithStatus:errorString];
    // setMinimumDismissTimeInterval 要和 提示字符串长度作比较 时间长的是消失时间
    [SVProgressHUD setMinimumDismissTimeInterval:1];

    [SVProgressHUD setKeyBoardMove:NO];
    
    
    [moneyText resignFirstResponder];
}

-(void)playDiss{
     [self dismissSVP];
}


@end
