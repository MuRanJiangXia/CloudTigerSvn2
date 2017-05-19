//
//  RegisterShopCell3.m
//  CloudTiger
//
//  Created by cyan on 16/12/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RegisterShopCell3.h"
@interface RegisterShopCell3 ()<UITextFieldDelegate>{
    UILabel *_titleLab;
    UITextField *_cellTextField;
    UISwitch *_chooseView;
}

@end
@implementation RegisterShopCell3

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
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.6*4, 60)];
    //        titleLab.backgroundColor = [UIColor redColor];
    _titleLab.text = @"中信银行";
    _titleLab.textColor = GrayColor;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLab];
    
    //默认高度 ：31 宽度 ： 51
    _chooseView = [[UISwitch alloc]initWithFrame:CGRectMake(MainScreenWidth - 51 - 15 ,(60 -31)/2.0, 51, 31)];
    _chooseView.on = NO;
    //    只能设置缩放比例改变大小
    _chooseView.transform = CGAffineTransformMakeScale(1, 1);
    
    [self.contentView addSubview:_chooseView];
    
//    [_chooseView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
    
}

@end
