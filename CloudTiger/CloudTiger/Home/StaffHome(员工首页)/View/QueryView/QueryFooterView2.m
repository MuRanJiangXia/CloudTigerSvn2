//
//  QueryFooterView.m
//  CloudTiger
//
//  Created by cyan on 16/9/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryFooterView2.h"

@implementation QueryFooterView2

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
    
//    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    view.backgroundColor = PaleColor;
    [self addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, view.bottom, MainScreenWidth - 30, 40);
    button.backgroundColor = BlueColor;
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    button.tag = 20160927 +0;
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(15, button.bottom + 10, MainScreenWidth - 30, 40);
    button2.backgroundColor = GreenColor;
    [button2 setTitle:@"汇总" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    
    button2.tag = 20160927 +1;
    
    button2.layer.cornerRadius = 5;
    button2.layer.masksToBounds = YES;
    
    
    
    
}

-(void)queryAction:(UIButton *)btn{
    if (btn.tag - 20160927==0) {
        NSLog(@"查询");
        if ([self.delegete respondsToSelector:@selector(queryAction)]) {
            [self.delegete queryAction];
        }
    }else{
        
        NSLog(@"汇总");
        
        if ([self.delegete respondsToSelector:@selector(sumAction)]) {
            [self.delegete sumAction];
        }
    }
    
    
}
@end
