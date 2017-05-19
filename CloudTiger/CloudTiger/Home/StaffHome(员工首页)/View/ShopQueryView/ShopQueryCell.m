//
//  ShopQueryCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopQueryCell.h"
@interface ShopQueryCell(){
    
    UIView *bgView;

}
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *phoneLab;
@property(nonatomic,strong)UILabel *timeLab;
@end
@implementation ShopQueryCell

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

-(void)setQueryModel:(QueryShopModel *)queryModel{
    if (_queryModel != queryModel) {
        _queryModel = queryModel;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
//  
//    if (IsNilOrNull(_queryModel.RegisterTime)  ) {
//        _timeLab.text = @"空";
//    }else{
//        NSString *time = [NSString stringWithFormat:@"%@",_queryModel.RegisterTime];
//        NSRange range = {6,time.length-2-6};
//        NSString *time2 = [time substringWithRange:range];
//      _timeLab.text  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
//  
// 
//    }
//    
//    _numberLab.text =[NSString stringWithFormat:@"%@",_queryModel.SysNo];
//
//    _phoneLab.text =[NSString stringWithFormat:@"%@",_queryModel.Phone];
    
    _nameLab.text =[NSString stringWithFormat:@"%@",_queryModel.CustomerName];

}


-(void)createUI{
    
    
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (60 -36)/2, 36, 36)];
    //    _imageV.backgroundColor = [UIColor yellowColor];
    _imageV.image = [UIImage imageNamed:@"shop_list2"];
    [bgView addSubview:_imageV];
    

    
    _nameLab  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right +10 , 0, MainScreenWidth - 15 - _imageV.right - 10, 60)];
//    _nameLab.backgroundColor = [UIColor redColor];
    _nameLab.text = @"测试商户111";
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.numberOfLines = 24;
    _nameLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_nameLab];
    
    
    /*
    _phoneLab  = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.right, 0, MainScreenWidth -_nameLab.right  - 15, 40)];
    //    _numberLab.backgroundColor = [UIColor greenColor];
    _phoneLab.text = @"13943060540";
    _phoneLab.textColor = UIColorFromRGB(0x737373, 1);
    _phoneLab.textAlignment = NSTextAlignmentRight;
    _phoneLab.font = [UIFont systemFontOfSize:14];
    _phoneLab.numberOfLines = 2;
    [bgView addSubview:_phoneLab];
    
    _timeLab  = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLab.left, _phoneLab.bottom, _phoneLab.width, 20)];
//        _timeLab.backgroundColor = [UIColor cyanColor];
    _timeLab.text = @"2016-5-11 13:23:30";
    _timeLab.textColor = UIColorFromRGB(0xb8b8b8, 1);
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.font = [UIFont systemFontOfSize:12];
    
    [bgView addSubview:_timeLab];
    */
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _nameLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [bgView addSubview:lineView];
    
    
}

@end
