//
//  MineCell.m
//  CloudTiger
//
//  Created by cyan on 16/9/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell
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
//    self.contentView.backgroundColor = [UIColor yellowColor];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//    _titleLab.backgroundColor = [UIColor redColor];
    _titleLab.text = @"修改密码";
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLab];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth - 13 -15, (50 - 13)/2.0 , 13, 13)];
//    imageView.backgroundColor = [UIColor yellowColor];
    imageView.image = [UIImage imageNamed:@"next"];
    [self.contentView addSubview:imageView];


    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50 -1,MainScreenWidth , 1)];
    view.backgroundColor = PaleColor;
    [self.contentView addSubview:view];
    
    
    
}




@end
