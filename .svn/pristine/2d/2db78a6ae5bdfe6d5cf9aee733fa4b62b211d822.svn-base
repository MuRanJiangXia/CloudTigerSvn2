//
//  StaffCodeViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffCodeViewController.h"

@interface StaffCodeViewController (){
    UIImageView *codeImageV;
    NSInteger _btnTag;
}

@end

@implementation StaffCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CyanManager *cyanManager = [CyanManager shareSingleTon];
    if ([cyanManager.isStaff isEqualToString:@"1"]) {//员工进入 
        self.title = @"支付二维码";
  
    }else{
        self.title = @"员工二维码";

    }
    self.view.backgroundColor = PaleColor;
    [self creatUI];
    
    /**底部返回首页按钮*/
    [self homeBtnView];
}

-(void)creatUI{
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
    scroll.backgroundColor = PaleColor;
    
    [self.view addSubview:scroll];
    scroll.showsVerticalScrollIndicator = YES;
    scroll.bounces = YES;
    
    scroll.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight -64 + 78);
    
    
    //二维码显示
    //    438 /438
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenWidth -219)/2.0, 20, 219, 219)];
    //    imageView.backgroundColor = [UIColor cyanColor];
    imageView.image = [UIImage imageNamed:@"code_bg"];
    [scroll addSubview:imageView];
 
    codeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    codeImageV.backgroundColor = [UIColor clearColor];
    //    codeImageV.image = [UIImage imageNamed:@""];
    [scroll addSubview:codeImageV];
    
    codeImageV.center = imageView.center;
    
    
    NSArray *titleArr = @[@"智能付款",@"微信付款",@"支付宝付款",@"核销员",@"删除核销员"];
    for (NSInteger index = 0; index < 5; index++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(imageView.left, imageView.bottom + 20 + index *(40 + 10) , imageView.width, 40);
    
        [button addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:button];

        [button setTitle:titleArr[index] forState:UIControlStateNormal];
        [button setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0xababae, 1)] forState:UIControlStateNormal];
        [button setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0x00aaee, 1)] forState:UIControlStateSelected];
        button.tag = 20160924 + index;
        
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
//        button.layer.borderColor = [UIColor blueColor].CGColor;
//        button.layer.borderWidth = 1;
    }
    

}


-(void)chooseAction:(UIButton *)btn{
    
    NSLog(@"btn.tag : %ld",btn.tag - 20160924);
    
    btn.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
    
        btn.frame = CGRectMake(0, btn.top, MainScreenWidth, btn.height);
    } completion:^(BOOL finished) {
        
    }];
    if (_btnTag!= 0) {
        if (_btnTag != btn.tag) {
            UIButton *preBtn =   [self.view viewWithTag:_btnTag];
            preBtn.selected = !preBtn.selected;
            
            if (!preBtn.selected) {
                [UIView animateWithDuration:0.2 animations:^{
                    
                    preBtn.frame = CGRectMake((MainScreenWidth -219)/2.0, preBtn.top, 219, 40);
                } completion:^(BOOL finished) {
                    
                }];
                
            }

            
            //清空一下 二维码图片
            codeImageV.image = [CyTools imageWithColor:[UIColor clearColor]];
        }
    }
    _btnTag = btn.tag;
    
    
}

@end
