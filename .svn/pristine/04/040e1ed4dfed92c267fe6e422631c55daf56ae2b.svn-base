//
//  RefundDesCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RefundDesCell.h"

@implementation RefundDesCell


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


    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 56, 50)];
    //    label.backgroundColor = [UIColor redColor];
    label.text = @"订单号";
    label.textColor = GrayColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    
    _contLab  = [[UILabel alloc]initWithFrame:CGRectMake(label.right +10, 0,MainScreenWidth -  label.right, 50)];
//    _contLab.backgroundColor = [UIColor redColor];
    _contLab.text = @"label";
    _contLab.textColor = [UIColor blackColor];
    _contLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_contLab];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}


@end
