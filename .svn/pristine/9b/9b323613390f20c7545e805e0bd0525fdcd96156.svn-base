//
//  StaffHomeCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffHomeCell.h"
@interface StaffHomeCell(){
    
    UIButton *chooseBtn;
    UILabel *titleLab;
}
@end
@implementation StaffHomeCell
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
//    self.contentView.backgroundColor = [UIColor whiteColor];
    chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectZero ;
    chooseBtn.enabled = NO;
    //    chooseBtn.backgroundColor = [UIColor purpleColor];
//    [chooseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chooseBtn];
 
    titleLab  = [[UILabel alloc]initWithFrame: CGRectZero];
//    titleLab.backgroundColor = [UIColor redColor];
    titleLab.text = @"微信订单";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLab];
    //MainScreenWidth /4
//0.3
//    NSLog(@"cell width%f",MainScreenWidth /4.0);
    CGFloat width = 0.3 * (MainScreenWidth / 4.0);
//    NSLog(@" width : %f",width);

//    NSLog(@"MainScreenWidth ：%f ，width :%f",MainScreenWidth ,width);
    chooseBtn.frame = CGRectMake((MainScreenWidth /4.0 - width)/2.0, (MainScreenWidth /4.0 - width - 25)/2.0, width, width);
//    chooseBtn.backgroundColor = [UIColor yellowColor];
    
    titleLab.frame = CGRectMake(0, chooseBtn.bottom + 5, MainScreenWidth /4.0, 20);

//    titleLab.backgroundColor = [UIColor cyanColor];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenWidth /4.0-1, MainScreenWidth /4.0, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth /4.0 -1, 0, 1, MainScreenWidth /4.0)];
    lineView2.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView2];
}
-(void)setModel:(StaffModel *)model{
    
    _model  = model;
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
//    [chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnNormal] forState:UIControlStateNormal];
    
    if (_model.isHave) {
         [chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnNormal] forState:UIControlStateDisabled];
    }else{
        
        [chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnDisabled] forState:UIControlStateDisabled];
    }

    [chooseBtn setBackgroundImage:[UIImage imageNamed:_model.btnSelected] forState:UIControlStateHighlighted];
    titleLab.text = _model.title;
    

//    [chooseBtn setTitle:@"微信订单" forState:UIControlStateNormal];
}
@end
