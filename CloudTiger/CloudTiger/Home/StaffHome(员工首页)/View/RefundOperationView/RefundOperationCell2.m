//
//  RefundOperationCell2.m
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RefundOperationCell2.h"
#import "RefundDesView.h"
#import "SBJSON.h"
@interface RefundOperationCell2()<RefundDesViewDelegate>{
    
    UIButton *refundBtn;
}
@property(nonatomic,strong)RefundDesView *refundDesView;

@end
@implementation RefundOperationCell2



-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
        
    }
    return self;
}



-(void)creatgoodsView{
    
    self.refundDesView = [[RefundDesView alloc]initWithFrame:CGRectMake(0,MainScreenHeight  , MainScreenWidth, MainScreenHeight -20)];
    //    _goodsView.backgroundColor = [UIColor greenColor];
    [[UIApplication sharedApplication].keyWindow addSubview: self.refundDesView ];
    [self.refundDesView bgViewTop];
    self.refundDesView.refunDesModel = self.refundDesModel;
    self.refundDesView.refundDesViewDelegate = self;
}


-(void)setRefundDesModel:(RefudDesModel *)refundDesModel{
    
    if (_refundDesModel != refundDesModel) {
        _refundDesModel = refundDesModel;
        
            /**
             判断 是否是当天时间，不是当天的订单不可以退款
             */
            
            /**
             获取当地时间  。。。
             */
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval dis = [date timeIntervalSince1970];
            NSString *time = [CyTools getYearAndMonthAndDayByTimeInterval:dis];
            NSString *time2 = [CyTools  getYearAndMonthByYear:self.refundDesModel.Time_Start];
            if ([time2  isEqualToString:time]) {
//                refundBtn.backgroundColor = UIColorFromRGB(0x26a005, 1);
                
                refundBtn.enabled = YES;
                //可退金额小于  总金额 为部分退款 ；可退金额 ==  总金额  为退款
                NSInteger totalMoney = [self.refundDesModel.Cash_fee integerValue];
                NSInteger refunMoney = [self.refundDesModel.fee integerValue];

                if (refunMoney == totalMoney) {
                    refundBtn.width = 50;
                    refundBtn.frame = CGRectMake(MainScreenWidth - 50 -15 , 10,50, 30);
                    [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
                       
                }else if(refunMoney ==  0){
                    refundBtn.frame =CGRectMake(MainScreenWidth - 82 -15 , 10,82, 30);
                    [refundBtn setTitle:@"退款完成" forState:UIControlStateDisabled];
                    refundBtn.enabled = NO;
                    [refundBtn setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0x27a005, 1)] forState:UIControlStateDisabled];
                }else{
                    refundBtn.frame =CGRectMake(MainScreenWidth - 82 -15 , 10,82, 30);
                    [refundBtn setTitle:@"部分退款" forState:UIControlStateNormal];
                }
             

            }else{
//                不可退款
                refundBtn.frame =CGRectMake(MainScreenWidth - 82 -15 , 10,82, 30);
                [refundBtn setTitle:@"不可退款" forState:UIControlStateDisabled];
                refundBtn.enabled = NO;
                [refundBtn setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0xababae, 1)] forState:UIControlStateDisabled];
//                refundBtn.backgroundColor = UIColorFromRGB(0xababae, 1);

//                [refundBtn setTitle:@"不可退款" forState:UIControlStateDisabled];

                
            }

        }

}
-(void)createUI{
    
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.5 *4, 50)];
    //    label.backgroundColor = [UIColor redColor];
    label.text = @"退款操作";
    label.textColor = GrayColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    
    
    
    refundBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    refundBtn.frame = CGRectMake(MainScreenWidth - 50 -15 , 10,50, 30);
    refundBtn.backgroundColor = [UIColor orangeColor];
    [refundBtn setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0xff5c11, 1)] forState:UIControlStateNormal];
    [refundBtn setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0xababae, 1)] forState:UIControlStateDisabled];
    [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
    [refundBtn setTitle:@"完成" forState:UIControlStateDisabled];
    refundBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [refundBtn addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:refundBtn];

    refundBtn.layer.cornerRadius = 5;
    refundBtn.layer.masksToBounds = YES;
//    button.layer.borderColor = [UIColor blueColor].CGColor;
//    button.layer.borderWidth = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}

-(void)refundAction:(UIButton *)btn{
    
    NSLog(@"退款");
    [self creatgoodsView];
}
#pragma mark RefundDesViewDelegate

-(void)refundDesView:(NSArray *)refundArr{
    NSString *refunMoney = refundArr[0];
    NSString *password = refundArr[1];
    
    CyanManager *cyManager = [CyanManager shareSingleTon];
    
    if (password.length == 0 ||refunMoney.length == 0) {
        NSLog(@"密码，输入金额为空");
        [MessageView showMessage:@"密码，输入金额为空"];
//        [SVProgressHUD showErrorWithStatus:@"密码，输入金额为空"];
//        // setMinimumDismissTimeInterval 要和 提示字符串长度作比较 时间长的是消失时间
//        [SVProgressHUD setMinimumDismissTimeInterval:1];
//        
//        [SVProgressHUD setKeyBoardMove:NO];
        return;
    }
    
    
    if ([[CyTools interByStr:refunMoney] integerValue] == 0  ) {
        NSLog(@"输入金额为0");
        [MessageView showMessage:@"输入金额为0"];
        
        
        
        return;
    }
    
    
    if ([[CyTools interByStr:refunMoney] integerValue] > [self.refundDesModel.fee integerValue]) {
        NSLog(@"输入金额超过可退金额");
        [MessageView showMessage:@"输入金额超过可退金额"];
        return;
    }
#pragma mark 从新请求一下登录
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    
    NSDictionary *parameters  = @{
                                  @"UserName":cyManager.loginName,
                                  @"PassWord":password
                                  
                                  };
    NSString *url = [BaseUrl stringByAppendingString:LoginStaffUrl] ;;
    [SVProgressHUD showWithStatus:@"加载中..."];

    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


        NSLog(@"responseObject :%@",responseObject);
        NSInteger code  = [responseObject[@"Code"] integerValue];
//        NSString *description = responseObject[@"Description"];
        if (code == 0) {
            
            NSString *postFee =    [CyTools interByStr:refunMoney];
            [self postBy:postFee];
            NSLog(@"登录成功");
        }else{
            [SVProgressHUD dismiss];
            [MessageView showMessage:@"密码错误"];
            NSLog(@"登录失败");
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [MessageView showMessage:@"请求错误"];
        NSLog(@"error : %@",error);
    }];

//

    
    

}
-(void)postBy:(NSString *)postFee{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSString *payType = [NSString stringWithFormat:@"%@",self.refundDesModel.Pay_Type] ;
    NSString *url = @"";
    if ([payType isEqualToString:@"102"]) {//微信
        url = [BaseUrl stringByAppendingString:RefundWXUrl];
        
    }else{
        url = [BaseUrl stringByAppendingString:RefundAliUrl];
    }
    //    YwMch_id2 主键
    //    {
    //        "out_trade_no": "133268090120160914145907812",
    //        "refund_fee": "1",
    //        "total_fee": "1",
    //        "SOSysNo": "12399",
    //        "YwMch_id2": 2
    //    }
    //refund_fee
//    NSString *postFee =    [CyTools interByStr:refundArr[0]];
    CyanManager *cyManager = [CyanManager shareSingleTon];
    
    NSDictionary *paramters = @{
                                @"out_trade_no":self.refundDesModel.Out_trade_no,
                                @"refund_fee" :postFee,
                                @"total_fee":self.refundDesModel.Cash_fee,
                                @"SOSysNo":self.refundDesModel.SysNo,
                                @"YwMch_id2":cyManager.sysNO
                                };
    
//    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
//    NSString *jsonString = [writer stringWithObject:paramters];
    
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        //        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        
        NSLog(@"responseObject :%@",responseObject);
        
        NSInteger Code = [responseObject[@"Code"] integerValue];
        if (Code == 0) {//退款成功
            NSLog(@"退款成功");
            [MessageView showMessage:@"退款成功"];
            //            [SVProgressHUD showWithStatus:@"退款成功"];
            //            [SVProgressHUD dismissWithDelay:2];
            if ([self.delegete respondsToSelector:@selector(tableReloadBy:)]) {
                [self.delegete tableReloadBy:YES];
            }
        }else{
            if ([self.delegete respondsToSelector:@selector(tableReloadBy:)]) {
                [self.delegete tableReloadBy:NO];
            }
            NSLog(@"退款失败");
            [MessageView showMessage:@"退款失败"];
            //            [SVProgressHUD showErrorWithStatus:@"退款失败"];
            //            [SVProgressHUD dismissWithDelay:.5];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [MessageView showMessage:@"请求失败"];


        //        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        //        [SVProgressHUD dismissWithDelay:2];
        if ([self.delegete respondsToSelector:@selector(tableReloadBy:)]) {
            [self.delegete tableReloadBy:NO];
        }
        
        NSLog(@"error :%@",error);
    }];
}


@end
