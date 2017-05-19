//
//  QueryRefundNewCell.m
//  CloudTiger
//
//  Created by cyan on 16/10/15.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryRefundNewCell.h"

@interface QueryRefundNewCell(){
    
    UIView *bgView;
}
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *moneyLab;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UILabel *stateLab;


@end
@implementation QueryRefundNewCell


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

-(void)setRefudDesModel:(RefundQueryNewModel *)refudDesModel{
    
    if (_refudDesModel != refudDesModel) {
        _refudDesModel  = refudDesModel;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    NSInteger pay =   [_refudDesModel.Pay_Type integerValue];
    if (pay == 102) {//微信
        _imageV.image = [UIImage imageNamed:@"wxPay"];
        //           _moneyLab.text = [NSString stringWithFormat:@"¥99999.00"];
    }else{
        _imageV.image = [UIImage imageNamed:@"aliPay"];
        
        //        _moneyLab.text = [NSString stringWithFormat:@"¥11111.00"];
        
    }
    NSString *money =   [CyTools folatByStr:_refudDesModel.refund_fee];
    _moneyLab.text = [NSString stringWithFormat:@"¥%@",money];
    
    
    _numberLab.text =[NSString stringWithFormat:@"%@", _refudDesModel.Out_trade_no];
    
    _timeLab.text = [NSString stringWithFormat:@"%@",_refudDesModel.Time_Start];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
    NSString *sring1 = @"¥";
    [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:[_moneyLab.text  rangeOfString:sring1]];
    _moneyLab.attributedText = attri;
    
    _stateLab.text = [NSString stringWithFormat:@"%@",_refudDesModel.Status];
}
-(void)createUI{
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60 +21)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (60 +21 -19)/2.0, 19, 19)];
    //    _imageV.backgroundColor = [UIColor yellowColor];
    _imageV.image = [UIImage imageNamed:@"aliPay"];
    [bgView addSubview:_imageV];
    
    
    //    130
    _moneyLab  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right + 10, 0,120 , 60 +21)];
    //    _moneyLab.backgroundColor = [UIColor redColor];
    _moneyLab.text = @"￥115.00";
    _moneyLab.textColor = [UIColor blackColor];
    _moneyLab.textAlignment = NSTextAlignmentLeft;
    _moneyLab.font = [UIFont systemFontOfSize:21];
    //    _moneyLab.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:_moneyLab];
    
    
    _stateLab  = [[UILabel alloc]initWithFrame:CGRectMake(_moneyLab.right, 10, MainScreenWidth -_moneyLab.right  - 15, 11)];
//    _stateLab.backgroundColor = [UIColor redColor];
    _stateLab.text = @"完成";
    _stateLab.textColor = GrayColor;
    _stateLab.textAlignment = NSTextAlignmentRight;
    _stateLab.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:_stateLab];
    
    
    
    _numberLab  = [[UILabel alloc]initWithFrame:CGRectMake(_moneyLab.right, _stateLab.bottom +2 , MainScreenWidth -_moneyLab.right  - 15, 14 +21)];
    //    _numberLab.backgroundColor = [UIColor greenColor];
    _numberLab.text = @"1392232234395844589689459";
    _numberLab.textColor = UIColorFromRGB(0x737373, 1);
    _numberLab.textAlignment = NSTextAlignmentRight;
    _numberLab.font = [UIFont systemFontOfSize:14];
    _numberLab.numberOfLines = 2;
    [bgView addSubview:_numberLab];
    
    _timeLab  = [[UILabel alloc]initWithFrame:CGRectMake(_numberLab.left, _numberLab.bottom+2, _numberLab.width, 11)];
    //    _timeLab.backgroundColor = [UIColor cyanColor];
    _timeLab.text = @"2016-5-11 13:23:30";
    _timeLab.textColor = UIColorFromRGB(0xb8b8b8, 1);
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = [UIFont systemFontOfSize:11];
    
    [bgView addSubview:_timeLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60 +21 -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [bgView addSubview:lineView];
    
}
@end
