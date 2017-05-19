//
//  StaffSumListCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffSumListCell.h"

@implementation StaffSumListCell{
    UILabel *_firstLab;
    UILabel *_countLab;
    UILabel *_moneyLab;
}


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

-(void)setQuerySumModel:(StaffSumListModel *)querySumModel{
    
    if (_querySumModel != querySumModel) {
        _querySumModel = querySumModel;
        [self setNeedsLayout];
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _firstLab.text = [NSString stringWithFormat:@"%@",_querySumModel.DisplayName];
    
    NSString *money1 =  [CyTools  folatByStr:_querySumModel.Fee];
    _countLab.text = [NSString stringWithFormat:@"实际 %@元",money1];
    
    NSString *money =  [CyTools  folatByStr:_querySumModel.Total_fee];
    _moneyLab.text = [NSString stringWithFormat:@"交易 %@元",money];
    
    
}

-(void)createUI{
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (60 -36)/2, 36, 36)];
    //    _imageV.backgroundColor = [UIColor yellowColor];
    //    _imageV.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_imageV];
    
    _firstLab  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right + 10, 0,100, 60)];
    //        _firstLab.backgroundColor = [UIColor yellowColor];
    _firstLab.text = @"员工名称";
    _firstLab.textColor = [UIColor blackColor];
    _firstLab.textAlignment = NSTextAlignmentLeft;
    _firstLab.font = [UIFont systemFontOfSize:14];
    _firstLab.numberOfLines = 2;
    [self.contentView addSubview:_firstLab];
    
    
    
    _countLab= [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.right +5, 0, MainScreenWidth -_firstLab.right -5 -15 , 30)];
    //    _countLab.backgroundColor = [UIColor redColor];
    _countLab.text = @"实际金额";
    _countLab.textColor = GrayColor;
    _countLab.textAlignment = NSTextAlignmentRight;
    _countLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_countLab];
    
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(_countLab.left, _countLab.bottom , _countLab.width, 30)];
//        _moneyLab.backgroundColor = [UIColor redColor]; 
    _moneyLab.text = @"交易金额";
    _moneyLab.textColor = GrayColor;
    _moneyLab.font = [UIFont systemFontOfSize:14];
    _moneyLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLab];
    

    
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _firstLab.bottom -1, MainScreenWidth, 1)];
    //
    lineView.backgroundColor =  PaleColor;
    [self.contentView addSubview:lineView];
    
}
@end
