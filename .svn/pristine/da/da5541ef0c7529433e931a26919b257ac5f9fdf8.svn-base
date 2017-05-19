//
//  ShopHomeCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopHomeCell.h"
@interface ShopHomeCell()
@property(nonatomic,strong)UIButton *chooseBtn;
@property(nonatomic,strong)UILabel *titleLab;

@end
@implementation ShopHomeCell
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)setModel:(StaffModel *)model{
    
    _model  = model;
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    _chooseBtn.frame = CGRectMake((self.contentView.width - 60)/2, 10, 60, 60);
    _titleLab.frame = CGRectMake(0, _chooseBtn.bottom +2, self.contentView.width, 15);
    
    if (_model.isHave) {
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnNormal] forState:UIControlStateDisabled];
    }else{
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnDisabled] forState:UIControlStateDisabled];
    }

    [_chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnSelected] forState:UIControlStateHighlighted];
    _titleLab.text = _model.title;
    
    
    //    [chooseBtn setTitle:@"微信订单" forState:UIControlStateNormal];
}
-(void)createUI{
//    self.contentView.backgroundColor = [UIColor whiteColor];
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseBtn.frame = CGRectZero;
//    _chooseBtn.backgroundColor = [UIColor purpleColor];
    _chooseBtn.enabled = NO;

//    [_chooseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chooseBtn];

    
    
    _titleLab  = [[UILabel alloc]initWithFrame:CGRectZero];
//    _cellLab.backgroundColor = [UIColor redColor];
    _titleLab.text = @"微信配置";
    _titleLab.textColor = BlackColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = CommFont12;
    [self.contentView addSubview:_titleLab];
    
    
}




@end
