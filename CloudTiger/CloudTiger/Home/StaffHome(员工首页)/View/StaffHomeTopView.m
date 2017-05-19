//
//  StaffHomeTopView.m
//  CloudTiger
//
//  Created by cyan on 16/9/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffHomeTopView.h"
@interface StaffHomeTopView(){
    UIImageView *bgImageView ;
    UILabel *nameLab;
    
    UILabel *companyLab;
    UIView *_view;
}
@end

@implementation StaffHomeTopView
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}


-(void)createUI{
    
    self.backgroundColor = PaleColor;
    
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 180)];
    bgImageView.backgroundColor = BlueColor;
    bgImageView.image = [UIImage imageNamed:@"staff_bg"];
    [self addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = CGRectMake(15, 15 + 20, 24, 24);
//    listBtn.backgroundColor = [UIColor yellowColor];
    [listBtn setBackgroundImage:[UIImage imageNamed:@"staff_list_btn"] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bgImageView addSubview:listBtn];

    UIButton *newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newsBtn.frame = CGRectMake(MainScreenWidth -24 -15 , 15 + 20, 24, 24);
//    newsBtn.backgroundColor = [UIColor purpleColor];
    [newsBtn setBackgroundImage:[UIImage imageNamed:@"staff_new_btn"] forState:UIControlStateNormal];
    [newsBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bgImageView addSubview:newsBtn];
    
    
    UIImageView *userImageV = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenWidth -80)/2, 20+20, 80, 80)];
    userImageV.backgroundColor = [UIColor yellowColor];
    userImageV.image = [UIImage imageNamed:@"user_normal"];
    [bgImageView addSubview:userImageV];
    userImageV.layer.cornerRadius = 40;
    userImageV.layer.masksToBounds = YES;
    userImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    userImageV.layer.borderWidth = 2;
    
    userImageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpMine:)];
    
    [userImageV addGestureRecognizer:tap];
    
    
    nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, userImageV.bottom +5, MainScreenWidth, 20)];
//    nameLab.backgroundColor = [UIColor redColor];
    nameLab.text = @"员工-商户";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont boldSystemFontOfSize:16];
    [bgImageView addSubview:nameLab];
    
    companyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLab.bottom, MainScreenWidth, 15)];
//    companyLab.backgroundColor = [UIColor redColor];
    companyLab.text = @"云网科技有限公司";
    companyLab.textColor = [UIColor whiteColor];
    companyLab.textAlignment = NSTextAlignmentCenter;
    companyLab.font = CommFont12;
    [bgImageView addSubview:companyLab];
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(0,  bgImageView.bottom+10,MainScreenWidth, 80)];
    _view.backgroundColor = [UIColor whiteColor];
    [self addSubview:_view];
    
//    [self createBtnView];
    
}
/**
 服务商员工
 
 上级费率订单查询       "/OrderFund/orderfund?Top=1"
 费率订单查询          "/OrderFund/orderfund"
 交易订单查询          "/Order/order_search"
 商户查询             "/Business/business"
 
 */
//根据权限 显示 btn
-(void)setPowerArr:(NSArray *)powerArr{
    
    _powerArr = powerArr;
    [self reloadBtn];
    
}


-(void)setIsShopStaff:(NSString *)isShopStaff{
    _isShopStaff = isShopStaff;
    [self createBtnView];
}
//刷新 btn
-(void)reloadBtn{

      
      
    if (IsNilOrNull(_powerArr)) {
        
        
    }else{
        CyanManager *manager =  [CyanManager shareSingleTon];
        if ([manager.customersType isEqualToString:@"0"]) {//服务商 员工
            NSArray  *btnArr = @[@"order_query_disabled",@"staff_shop_query_d"];
            NSArray *keyArr = @[ CyanOrderQuery,CyanShopQuery];
            
            for (NSInteger index = 0; index < keyArr.count; index++) {
                NSString *key = keyArr[index];
                
                if ( [_powerArr indexOfObject:key] != NSNotFound) {
                    UIButton *btn = (UIButton *)[self viewWithTag:20160915 + index];
                    [btn setBackgroundImage:[UIImage imageNamed:btnArr[index]] forState:UIControlStateDisabled];
                    btn.enabled = YES;
                }
            }
            
        }else{//商户 员工
            //支付宝扫码支付 微信扫码支付 支付二维码   交易订单查询

//            @"/Pay/scan_code_payment_Alipay",@"/Pay/scan_code_payment",@"/Wxpay/native",@"/Order/order_search"
            NSArray  *btnArr = @[@"order_query_disabled",@"code_disabled",@"order_query_disabled"];
//            NSArray *keyArr = @[@"/Pay/scan_code_payment_Alipay",@"/Pay/scan_code_payment",@"/Wxpay/native",@"/Order/order_search"];
            
                 NSArray *keyArr = @[CyanAliScanPay,CyanWXScanPay,CyanPayCode,CyanOrderQuery];
            
            for (NSInteger index = 0; index < btnArr.count; index++) {
                
                UIButton *btn = (UIButton *)[self viewWithTag:20160915 + index];
                
                if (index == 0 ||index ==1) {
                    
                    btn.enabled = YES;

                }else{
                    
                    NSString *key = keyArr[index + 1];
                    if ( [_powerArr indexOfObject:key] != NSNotFound) {
                      [btn setBackgroundImage:[UIImage imageNamed:btnArr[index]] forState:UIControlStateDisabled];
                        btn.enabled = YES;
                    }
                }
          
            }
            
            
            
        }
        
 
    
    }



    
}

-(void)createBtnView{
    [_view removeAllSubviews];
    NSArray *btnArr = @[@"scan_code_normal",@"code_normal",@"order_query_normal"];
    NSArray *btnSetectedArr = @[@"scan_code_selected",@"code_selected",@"order_query_selected"];
    NSArray *titleArr ;
    CGFloat width;
    
    CyanManager *manager =  [CyanManager shareSingleTon];
    if ([self.isShopStaff isEqualToString:@"0"]) {//服务商下员工
        btnArr = @[@"order_query_normal",@"staff_shop_query_n"];
        btnSetectedArr = @[@"order_query_selected",@"staff_shop_query_s"];
         titleArr = @[@"订单查询",@"商户查询"];
         width = (MainScreenWidth - 46 *2)/ 4.0;
       
    }else{
        
        titleArr = @[@"智能扫码",@"二维码",@"订单查询"];
        width = (MainScreenWidth - 46 *3)/ 6.0;
        
    }
    /**
     员工信息 
     */
    nameLab.text = manager.displayName;
    companyLab.text = manager.shopName;
    
    for (NSInteger index  = 0; index < titleArr.count;index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( width +index * (46 + width *2) , 4.5, 46, 46);
//        button.backgroundColor = [UIColor purpleColor];
        [button addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:button];
      
        [button setBackgroundImage:[UIImage imageNamed:btnArr[index]] forState:  UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:btnSetectedArr[index]] forState:  UIControlStateHighlighted];
        UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(button.left, button.bottom +5, 70, 20)];
//        label.backgroundColor = [UIColor redColor];
        label.text = titleArr[index];
        label.textColor = BlueColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_view addSubview:label];
        
        label.center = CGPointMake(button.center.x, label.center.y);
        button.enabled = NO;
        button.tag = 20160915 + index;
    }
    
}

-(void)codeAction:(UIButton *)btn{
    NSLog(@"扫码");
    if ([self.delegete respondsToSelector:@selector(chooseIndex:)]) {
        [self.delegete chooseIndex:btn.tag - 20160915];
    }
}

-(void)listAction:(UIButton *)btn{
    NSLog(@"list");
    
}

-(void)jumpMine:(UITapGestureRecognizer *)tap{
    
    if ([self.delegete respondsToSelector:@selector(jumpMine)]) {
        [self.delegete jumpMine];
    }
    NSLog(@"跳转我的");
}

@end
