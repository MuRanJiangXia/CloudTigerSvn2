//
//  StaffHomeFooterView.m
//  CloudTiger
//
//  Created by cyan on 16/9/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffHomeFooterView.h"
#import "CyCycleScrollView.h"
@interface StaffHomeFooterView()<CycleScrollViewDelegate>

@end
@implementation StaffHomeFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}


-(void)createUI{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, MainScreenWidth, 90)];
    view.backgroundColor = [UIColor cyanColor];
    [self addSubview:view];
    NSArray *imageNames = @[@"staff_banner1",@"staff_banner2"];

    CyCycleScrollView *scrollView = [[CyCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 90)];
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.imageNames = imageNames;
    scrollView.delegate =self;
    scrollView.currentPageDotColor = BlueColor;
    scrollView.pageDotColor = PaleColor;
    [view addSubview:scrollView];
    
}
- (void)cycleScrollView:(CyCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
//    NSLog(@"index :%ld",index);
}

@end
