//
//  ShopHomeNavView.m
//  CloudTiger
//
//  Created by cyan on 16/9/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopHomeNavView.h"
@interface ShopHomeNavView(){
    
    UILabel *_moneyLab;//实际交易金额
    UILabel *_tranCountLab;//交易笔数
    UILabel *_allLab;//交易总金额
}

@end

@implementation ShopHomeNavView
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)setQuerySumModel:(QuerySumModel *)querySumModel{
    
    if (_querySumModel != querySumModel) {
        _querySumModel = querySumModel;
//        _moneyLab.text = [NSString stringWithFormat:@"￥223234,223"];

        _moneyLab.text = [NSString stringWithFormat:@"￥%@", [CyTools folatByStr:_querySumModel.fee]];
        
        _tranCountLab.text = [NSString stringWithFormat:@"交易笔数:%@",_querySumModel.Tradecount];
        _allLab.text = [NSString stringWithFormat:@"汇总金额:%@",[CyTools folatByStr:_querySumModel.Total_fee]];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
        NSString *sring1 = @"￥";
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[_moneyLab.text  rangeOfString:sring1]];
        
        _moneyLab.attributedText = attri;
    }
}

-(void)createUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    imageView.backgroundColor = BlueColor;
    imageView.image = [UIImage imageNamed:@"staff_bg"];
    [self addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 30, 20, 20);
//    button.backgroundColor = [UIColor whiteColor];
    [button setBackgroundImage:[UIImage imageNamed:@"staff_list_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
//    [imageView addSubview:button];

    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, MainScreenWidth, 18)];
//    label.backgroundColor = [UIColor redColor];
    label.text = @"实际交易金额";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [imageView addSubview:label];
    
    
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom + 10, MainScreenWidth, 50)];
    _moneyLab.text = @"￥0.0";
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.textColor = [UIColor whiteColor];
    _moneyLab.font = [UIFont boldSystemFontOfSize:50];
//    _moneyLab.backgroundColor = [UIColor yellowColor];
    [imageView addSubview:_moneyLab];
    
  
    _tranCountLab = [[UILabel alloc]initWithFrame:CGRectMake(15, _moneyLab.bottom +30, (MainScreenWidth - 30)/2.0, 15)];
//    tranCountLab.backgroundColor = [UIColor redColor];
    _tranCountLab.text = @"交易笔数:0";
    _tranCountLab.textColor = [UIColor whiteColor];
    _tranCountLab.textAlignment = NSTextAlignmentCenter;
//    _tranCountLab.backgroundColor = [UIColor yellowColor];

    _tranCountLab.font = CommFont14;
    [imageView addSubview:_tranCountLab];
    
    UILabel *refundCountLab  = [[UILabel alloc]initWithFrame:CGRectMake(_tranCountLab.right, _tranCountLab.top, 100, 15)];
//    refundCountLab.backgroundColor = [UIColor redColor];
    refundCountLab.text = @"退款笔数:22,551";
    refundCountLab.textColor = [UIColor whiteColor];
    refundCountLab.textAlignment = NSTextAlignmentCenter;
    refundCountLab.font = CommFont14;

//    [imageView addSubview:refundCountLab];
    
    _allLab = [[UILabel alloc]initWithFrame:CGRectMake(_tranCountLab.right, _tranCountLab.top, MainScreenWidth - _tranCountLab.right - 15 , 15)];
//    _allLab.backgroundColor = [UIColor cyanColor];
    _allLab.text = @"汇总金额:0";
    _allLab.textColor = [UIColor whiteColor];
    _allLab.textAlignment = NSTextAlignmentCenter;
    _allLab.font = CommFont14;
    [imageView addSubview:_allLab];
    
    UILabel *noticeLab  = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom -35, MainScreenWidth, 35)];
    noticeLab.backgroundColor = [UIColor whiteColor];
    noticeLab.text = @" 通知:欢迎使用云网支付app,新功能敬请期待!";
    noticeLab.textColor = [UIColor redColor];
    noticeLab.textAlignment = NSTextAlignmentLeft;
    noticeLab.font = CommFont14;
    [imageView addSubview:noticeLab];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
    NSString *sring1 = @"￥";
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[_moneyLab.text  rangeOfString:sring1]];
    
    _moneyLab.attributedText = attri;
}

-(void)listAction:(UIButton *)btn{
    NSLog(@"。。。");
    
}

@end
