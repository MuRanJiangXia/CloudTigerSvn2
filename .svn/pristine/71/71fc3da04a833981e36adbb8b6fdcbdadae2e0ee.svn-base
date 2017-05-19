//
//  AssignStaffCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/2.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "AssignStaffCell.h"

@implementation AssignStaffCell{
    
    UILabel *_firstLab;
    
    UISwitch *_chooseView;
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

-(void)setAssignStaffModel:(AssignStaffModel *)assignStaffModel{
    
    if (_assignStaffModel != assignStaffModel) {
        _assignStaffModel = assignStaffModel;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _firstLab.text = [NSString stringWithFormat:@"%@",_assignStaffModel.DisplayName];
    [_chooseView setOn:_assignStaffModel.isChoose animated:NO];
//    _chooseView.on=  _assignStaffModel.isChoose ;
}

-(void)createUI{
    
    
    _firstLab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,MainScreenWidth - 51 -30 , 50)];
    //    _firstLab.backgroundColor = [UIColor redColor];
    _firstLab.text = @"label";
    _firstLab.textColor = [UIColor blackColor];
    _firstLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_firstLab];
    
    
    //默认高度 ：31 宽度 ： 51
    _chooseView = [[UISwitch alloc]initWithFrame:CGRectMake(MainScreenWidth - 51 -15 ,(50 -31)/2.0, 51, 31)];
    _chooseView.on = YES;
    //    只能设置缩放比例改变大小
    //    _chooseView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [self.contentView addSubview:_chooseView];
    
    [_chooseView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    //    NSLog(@"width : %f ,height : %f",_chooseView.width,_chooseView.height);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _firstLab.bottom -1, MainScreenWidth, 1)];
    view.backgroundColor = PaleColor;
    [self.contentView addSubview:view];
    

}

-(void)switchAction:(UISwitch *)switchView{
    
    if ([self.delegate respondsToSelector:@selector(switchAction:byIndex:)]) {
        [self.delegate switchAction:switchView.isOn byIndex:_indexPath];
    }
//    NSLog(@"switchView.isOn : %d",switchView.isOn);
}

@end
