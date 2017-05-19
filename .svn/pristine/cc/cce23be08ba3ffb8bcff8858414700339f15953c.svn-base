//
//  ShopQueryCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffListCell.h"
@interface StaffListCell(){
    
    UIView *bgView;
    
}
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *phoneLab;
@property(nonatomic,strong)UILabel *timeLab;
@end
@implementation StaffListCell

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

-(void)setQueryStaffModel:(QueryStaffModel *)queryStaffModel{
    if (_queryStaffModel != queryStaffModel) {
        _queryStaffModel = queryStaffModel;
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (IsNilOrNull(_queryStaffModel.InDate)  ) {
        _timeLab.text = @"空";
    }else{
        NSString *time = [NSString stringWithFormat:@"%@",_queryStaffModel.InDate];
        NSRange range = {6,time.length-2-6};
        NSString *time2 = [time substringWithRange:range];
        _timeLab.text  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
        
        
    }
    
    _numberLab.text =[NSString stringWithFormat:@"%@",_queryStaffModel.SysNO];
    _nameLab.text =[NSString stringWithFormat:@"%@",_queryStaffModel.DisplayName];
    _phoneLab.text =[NSString stringWithFormat:@"%@",_queryStaffModel.PhoneNumber];
    
}


-(void)createUI{
    
    
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (60 -36)/2, 36, 36)];
    //    _imageV.backgroundColor = [UIColor yellowColor];
    _imageV.image = [UIImage imageNamed:@"staff_list"];
    [bgView addSubview:_imageV];
    
    
    
    _numberLab  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right + 10, 0, 60, 60)];
    //    _moneyLab.backgroundColor = [UIColor redColor];
    _numberLab.text = @"16233";
    _numberLab.textColor = [UIColor blackColor];
    _numberLab.textAlignment = NSTextAlignmentLeft;
    _numberLab.font = [UIFont systemFontOfSize:16];
//    [bgView addSubview:_numberLab];

    
    _phoneLab  = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 130 -15, (60 - 12 -18 -5)/2.0,130, 18)];
//    _phoneLab.backgroundColor = [UIColor greenColor];
    _phoneLab.text = @"13943060540";
    _phoneLab.textColor = [UIColor blackColor];
    _phoneLab.textAlignment = NSTextAlignmentRight;
    _phoneLab.font = [UIFont systemFontOfSize:18];
    _phoneLab.numberOfLines = 2;
    [bgView addSubview:_phoneLab];
    
    
    _nameLab  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right + 10, 0,MainScreenWidth - _phoneLab.width - 15  - 10 -_imageV.right , 60)];
//        _nameLab.backgroundColor = [UIColor redColor];
    _nameLab.text = @"测试商户111";
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.numberOfLines = 2;
    [bgView addSubview:_nameLab];
    
    _timeLab  = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLab.left, _phoneLab.bottom +5 , _phoneLab.width, 12)];
//    _timeLab.backgroundColor = [UIColor cyanColor];
    _timeLab.text = @"2016-5-11 13:23:30";
    _timeLab.textColor = UIColorFromRGB(0xb8b8b8, 1);
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = [UIFont systemFontOfSize:12];
    
    [bgView addSubview:_timeLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60 -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [bgView addSubview:lineView];
    
    
}

@end
