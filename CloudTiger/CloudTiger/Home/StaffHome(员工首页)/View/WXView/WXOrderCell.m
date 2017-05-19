//
//  WXOrderCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/28.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "WXOrderCell.h"

@implementation WXOrderCell

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

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
}



-(void)createUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _firstLab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.6 *4, 50)];
//    _firstLab.backgroundColor = [UIColor redColor];
    _firstLab.text = @"测试cell";
    _firstLab.textColor = GrayColor;
    _firstLab.textAlignment = NSTextAlignmentLeft;
    _firstLab.font = [UIFont systemFontOfSize:14];
    _firstLab.numberOfLines = 2;
    [self.contentView addSubview:_firstLab];
    
    
    _contLab  = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.right  , 0, MainScreenWidth - _firstLab.right  -15 , 50)];
//    _contLab.backgroundColor = [UIColor cyanColor];
    _contLab.text = @"desctitle";
    _contLab.textColor = [UIColor blackColor];
    _contLab.textAlignment = NSTextAlignmentRight;
    _contLab.font = [UIFont systemFontOfSize:16];
    _contLab.numberOfLines = 2;
//    _contLab.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_contLab];
    
    
  
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _firstLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
    
}


@end
