//
//  PersonFooter.m
//  CloudTiger
//
//  Created by cyan on 16/12/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "PersonFooter.h"

@implementation PersonFooter

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
//    self.contentView.backgroundColor = [UIColor yellowColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    view.backgroundColor = PaleColor;
    [self.contentView addSubview:view];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 10 , MainScreenWidth - 30, 40);
    button.backgroundColor = BlueColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changePerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    
    
}

-(void)changePerson:(UIButton *)btn{
    
    NSLog(@"确定");
    if ([self.delegate respondsToSelector:@selector(changePerson:)]) {
        [self.delegate changePerson:btn];
    }
}


@end
