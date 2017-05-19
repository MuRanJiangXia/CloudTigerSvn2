//
//  ShopRefundListCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopRefundListCell.h"


@interface ShopRefundListCell(){
    
    UIView *bgView;
}
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *moneyLab;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UILabel *timeLab;

@end
@implementation ShopRefundListCell


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


-(void)setShopRefundModel:(ShopRefundModel *)shopRefundModel{
    
    if (_shopRefundModel != shopRefundModel) {
        _shopRefundModel = shopRefundModel;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    NSInteger pay =   [_shopRefundModel.Pay_Type integerValue];
    if (pay == 102) {//微信
        _imageV.image = [UIImage imageNamed:@"wxPay"];
        //      _moneyLab.text = [NSString stringWithFormat:@"¥99999.00"];
    }else if (pay == 103){
        //        wft_wx aliPay
        _imageV.image = [UIImage imageNamed:@"aliPay"];
    }
    else{
        _imageV.image = [UIImage imageNamed:@"wft_wx"];
        //      _moneyLab.text = [NSString stringWithFormat:@"¥11111.00"];
        
    }
    NSString *money =   [CyTools folatByStr:_shopRefundModel.Refund_fee];
    _moneyLab.text = [NSString stringWithFormat:@"¥%@",money];
    
    
    _numberLab.text =[NSString stringWithFormat:@"%@", _shopRefundModel.Out_trade_no];
    
    _timeLab.text = [NSString stringWithFormat:@"%@",_shopRefundModel.Time_Start];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
    NSString *sring1 = @"¥";
    [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:[_moneyLab.text  rangeOfString:sring1]];
    _moneyLab.attributedText = attri;
}
-(void)createUI{
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (60 -19)/2, 19, 19)];
    //    _imageV.backgroundColor = [UIColor yellowColor];
    _imageV.image = [UIImage imageNamed:@"aliPay"];
    [bgView addSubview:_imageV];
    
    
    //    130
    _moneyLab  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right + 10, 0,120 , 60)];
    //    _moneyLab.backgroundColor = [UIColor redColor];
    _moneyLab.text = @"￥115.00";
    _moneyLab.textColor = [UIColor blackColor];
    _moneyLab.textAlignment = NSTextAlignmentLeft;
    _moneyLab.font = [UIFont systemFontOfSize:21];
    //    _moneyLab.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:_moneyLab];
    
    
    _numberLab  = [[UILabel alloc]initWithFrame:CGRectMake(_moneyLab.right, 6.5, MainScreenWidth -_moneyLab.right  - 15, 36)];
    //    _numberLab.backgroundColor = [UIColor greenColor];
    _numberLab.text = @"1392232234395844589689459";
    _numberLab.textColor = UIColorFromRGB(0x737373, 1);
    _numberLab.textAlignment = NSTextAlignmentRight;
    _numberLab.font = [UIFont systemFontOfSize:14];
    _numberLab.numberOfLines = 2;
    [bgView addSubview:_numberLab];
    
    _timeLab  = [[UILabel alloc]initWithFrame:CGRectMake(_numberLab.left, _numberLab.bottom, _numberLab.width, 11)];
    //    _timeLab.backgroundColor = [UIColor cyanColor];
    _timeLab.text = @"2016-5-11 13:23:30";
    _timeLab.textColor = UIColorFromRGB(0xb8b8b8, 1);
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = [UIFont systemFontOfSize:11];
    
    [bgView addSubview:_timeLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60 -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [bgView addSubview:lineView];
    
}

@end
