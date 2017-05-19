//
//  RegisterShopFooter.m
//  CloudTiger
//
//  Created by cyan on 16/12/9.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RegisterShopFooter.h"

@implementation RegisterShopFooter


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
//        self.contentView.backgroundColor = [UIColor yellowColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    view.backgroundColor = PaleColor;
    [self addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, view.bottom, MainScreenWidth - 30, 40);
    button.backgroundColor = BlueColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    button.tag = 20160927 +0;
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    
    
    
    
    
}

-(void)queryAction:(UIButton *)btn{
    NSLog(@"查询");
    if ([self.delegete respondsToSelector:@selector(registerSureAction)]) {
        [self.delegete registerSureAction];
    }
    
}

@end
