//
//  CyanLoading.m
//  沙盒
//
//  Created by liran on 16/7/5.
//  Copyright © 2016年 liran. All rights reserved.
//

#import "CyanLoading.h"
#define kWIDTH                     [UIScreen mainScreen].bounds.size.width
#define kHEIGHT                    [UIScreen mainScreen].bounds.size.height

@interface CyanLoading()
@property(strong,nonatomic)   UIActivityIndicatorView *active;
@property (strong, nonatomic)UIView *loading;
@property(nonatomic,strong)UILabel *showLab;
@end
@implementation CyanLoading
+ (instancetype)shareLoading{
    static CyanLoading *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CyanLoading alloc] init];
    });
    
    return _manager;
}

- (void)show{
    if (!_loading) {
        
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        
//        NSLog(@"%@",window);
        _loading = [[UIView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(window.bounds), CGRectGetHeight(window.bounds)-64)];
        
        _loading.backgroundColor = [UIColor clearColor];
        _loading.alpha = 0.0;
        //      将一个UIView显示在最前面只需要调用其父视图的 bringSubviewToFront（）方法。
        //      将一个UIView层推送到背后只需要调用其父视图的 sendSubviewToBack（）方法。
        [window addSubview:_loading];
        
        
    }
    _showLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    _showLab.text = @"加载成功";
    _showLab.textAlignment = NSTextAlignmentCenter;
    _showLab.backgroundColor = [UIColor redColor];
    _showLab.hidden = YES;
    [_loading addSubview:_showLab];
    _showLab.center = _loading.center;
    
    _active = [[UIActivityIndicatorView alloc]init];
    //20160827背景色，圆角
    _active.frame = CGRectMake(0, 0, 60, 60);
    _active.backgroundColor = [UIColor lightGrayColor];
    _active.layer.cornerRadius = 5;

    //设置显示样式
    _active.accessibilityLabel = @"...";
    _active.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
//    NSString * str =[[NSBundle mainBundle] pathForResource:@"等待" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:str];
//    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//    image.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
//    image.contentMode = UIViewContentModeScaleAspectFit;
//    [_loading addSubview:image];
//    image.center = _loading.center;
    _active.center = CGPointMake(_loading.center.x, _loading.center.y-64);
    [_loading addSubview:_active];
    [_active startAnimating];
    _loading.hidden = NO;
    _loading.alpha = .5;
    
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}


- (void)dismiss{
    [_active stopAnimating];
    _loading.hidden = YES;
    [self removeAllSubviewsBy:_loading];
    [_loading removeAllSubviews];
}

-(void)dismissWith:(NSString *)showStr{
    
    [_active stopAnimating];
    _active.hidden = YES;
    _showLab.hidden  = NO;
    _showLab.text = @"加载了。。";
    [self performSelector:@selector(removeAllView) withObject:nil afterDelay:.5];

}

-(void)removeAllView{
    _loading.hidden = YES;
    [self removeAllSubviewsBy:_loading];
    [_loading removeAllSubviews];

}
- (void)removeAllSubviewsBy:(UIView *)showView
{
    while (showView.subviews.count) {
        UIView* child = showView.subviews.lastObject;
        [child removeFromSuperview];
    }
}



@end
