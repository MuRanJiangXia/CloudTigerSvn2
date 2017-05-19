//
//  CyanLoadFooterView.m
//  CloudTiger
//
//  Created by cyan on 16/10/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanLoadFooterView.h"
#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define MJRefreshLabelTextColor MJColor(100, 100, 100)
@implementation CyanLoadFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    // RGB颜色
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
//    label.backgroundColor = [UIColor redColor];
    label.backgroundColor = PaleColor;
    label.text = @"暂无更多数据";
    label.textColor = MJRefreshLabelTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:label];
    
    
    
}
@end
