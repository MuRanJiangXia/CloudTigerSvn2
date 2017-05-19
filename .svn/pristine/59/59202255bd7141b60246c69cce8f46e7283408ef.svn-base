//
//  TopRateOperationCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "TopRateOperationCell.h"

@implementation TopRateOperationCell

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
    
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14 *4, 50)];
    //    label.backgroundColor = [UIColor redColor];
    label.text = @"操作";
    label.textColor = GrayColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    
    
    //18 字体大小默认 左右间距 7
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
    button.backgroundColor = BlueColor;
    [button setTitle:@"上级费率订单" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    //    NSLog(@"%@",button.titleLabel.font);
    
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    //    button.layer.borderColor = [UIColor blueColor].CGColor;
    //    button.layer.borderWidth = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}


-(void)refundAction:(UIButton *)btn{
    NSLog(@"跳转查询");
    if ([self.delegete respondsToSelector:@selector(jumpTopRate)]) {
        [self.delegete jumpTopRate];
    }
    
}

@end
