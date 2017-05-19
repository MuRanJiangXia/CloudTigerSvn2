//
//  SumDetailCell.m
//  CloudTiger
//
//  Created by cyan on 16/10/10.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "SumDetailCell.h"

@implementation SumDetailCell


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
-(void)createUI{
    
    
    _firstLab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.6 *6, 50)];
    //    label.backgroundColor = [UIColor redColor];
    _firstLab.text = @"测试cell";
    _firstLab.textColor = GrayColor;
    _firstLab.textAlignment = NSTextAlignmentLeft;
    _firstLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_firstLab];
    
    
    _contLab  = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.right + 10 , 0, MainScreenWidth - _firstLab.right - 10 -15, 50)];
    //    _contLab.backgroundColor = [UIColor redColor];
    _contLab.text = @"desctitle";
    _contLab.textColor = [UIColor blackColor];
    _contLab.textAlignment = NSTextAlignmentRight;
    
    /**
     9.29 自适应  高度
     */
    _contLab.adjustsFontSizeToFitWidth = YES;
    
    [self.contentView addSubview:_contLab];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _firstLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}

@end
