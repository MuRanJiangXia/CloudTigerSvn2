//
//  CYPageControl.m
//  ExamplecycleView
//
//  Created by liran on 16/6/3.
//  Copyright © 2016年 liran. All rights reserved.
//

#import "CYPageControl.h"
#import "UIViewExt.h"
@interface CYPageControl(){
    
    UIImage *_image1 ;
    UIImage *_image2 ;
}
/**
 *  小圆点数组
 */
@property (strong, nonatomic) NSMutableArray *dots;


@end
@implementation CYPageControl

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

-(void)initialization{
    //    self.bounds.size.height
    //    self.bounds.size.width
    self.dots = [NSMutableArray new];
    self.pageColor = [UIColor grayColor];
    self.currentColor = [UIColor whiteColor];
    self.pageSize = CGSizeMake(8, 8);
    self.backgroundColor = [UIColor clearColor];
}
-(void)setCurrentImageUrl:(NSString *)currentImageUrl{
    if (!currentImageUrl) {
        NSLog(@"没有图片");
    }
    if (_currentImageUrl != currentImageUrl) {
        _currentImageUrl = currentImageUrl;
    }
}

-(void)setPageImageUrl:(NSString *)pageImageUrl{
    if (!pageImageUrl) {
        NSLog(@"没有图片");
    }
    if (_pageImageUrl != pageImageUrl) {
        _pageImageUrl = pageImageUrl;
    }
    
}
-(void)setNumberOfPages:(NSInteger)numberOfPages{
    
    
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        if (_numberOfPages) {
            //            [self creatPages];
        }
    }
}
-(void)setPageColor:(UIColor *)pageColor{
    
    if (_pageColor != pageColor) {
        _pageColor = pageColor;
        //        [self  updatePages];
    }
}
-(void)setCurrentColor:(UIColor *)currentColor{
    if (_currentColor != currentColor) {
        _currentColor = currentColor;
        //        [self updatePages];
    }
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        
        [self updatePages];
    }
}
-(void)setPageSize:(CGSize)pageSize{
    if (pageSize.width <= 0 || pageSize.height <= 0 ) {
        return;
    }
    _pageSize = pageSize;
}
-(void)creatPages{
    if (self.numberOfPages == 0) {
        return;
    }
    if (self.dots.count) {
        [self.dots removeAllObjects];
    }
    for (UIView *dotView in self.subviews) {
        [dotView removeFromSuperview];
    }
    for (NSInteger index = 0; index < self.numberOfPages; index ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
#warning 两个状态 一个是设置颜色，一个设置图片，
        [self pageImageView:imageView With:index];
        //        imageView.layer.borderColor  = [UIColor whiteColor].CGColor;
        //        imageView.layer.borderWidth  = 2;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.dots addObject:imageView];
        [self addSubview:imageView];
    }
    
}

-(void)updatePages{
    for (NSInteger index = 0; index < self.dots.count; index++) {
        UIImageView *imageView = self.dots[index];
        if (self.pageImageUrl||self.currentImageUrl) {
            if (index == _currentPage)imageView.image = _image1;
            else imageView.image = _image2;
        }else{
            if (index == _currentPage)imageView.backgroundColor = self.currentColor;
            else imageView.backgroundColor = self.pageColor;
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.userInteractionEnabled) {
        return;
    }
    NSLog(@"有几个触摸点%ld",touches.count);
    UITouch *touch = [touches anyObject];
    if (touches.count == 1) {
        CGPoint point = [touch locationInView:self];
        if (point.x >   self.width/2) {
            self.currentPage ++;
            if (self.currentPage == self.numberOfPages) {
                self.currentPage = 0;
            }
        }else{
            self.currentPage --;
            if (self.currentPage < 0) {
                self.currentPage = self.numberOfPages-1;
            }
        }
        
    }
}
//小圆点颜色或图片
-(void)pageImageView:(UIImageView *)imageView With:(NSInteger )index{
    
    _image1 = [UIImage imageNamed:self.currentImageUrl];
    
    imageView.width = _image1.size.width;
    imageView.height = _image1.size.height;
    _image2 = [UIImage imageNamed:self.pageImageUrl];
    
    if (self.pageImageUrl||self.currentImageUrl) {
        imageView.backgroundColor    = [UIColor clearColor];
        CGFloat log_x =   [self log_xBy:_image1.size With:index];
        imageView.frame = CGRectMake(log_x, self.height - _image1.size.height*1.5, _image1.size.width,_image1.size.height);
        if (index == _currentPage) {
            imageView.image = _image1;
            
        }else{
            imageView.image = _image2;
        }
    }else{
        if (index == _currentPage) {
            imageView.backgroundColor = self.currentColor;
            
        }else{
            imageView.backgroundColor = self.pageColor;
        }
        CGFloat log_x =  [self log_xBy:self.pageSize With:index];
        imageView.frame = CGRectMake(log_x, self.height - self.pageSize.height * 1.5, self.pageSize.width,self.pageSize.height);
        imageView.layer.cornerRadius = CGRectGetWidth(imageView.frame) / 2;
    }
}

//小圆点 位置
-(CGFloat)log_xBy:(CGSize )size With:(NSInteger)index{
    CGFloat log_x ;
    switch (self.pagePosition) {
        case pageRight:
            log_x = index *size.width*2 + self.width - (self.numberOfPages*2  - 1 ) *size.width;
            break;
        case pageLeft:
            log_x = index *size.width*2 ;
            break;
        default:
            log_x = index *size.width*2   + (self.width - (self.numberOfPages*2  - 1 ) *size.width)/2 ;
            
            break;
    }
    return log_x;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self creatPages];
    
}

@end
