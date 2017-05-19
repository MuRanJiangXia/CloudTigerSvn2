//
//  CYPageControl.h
//  ExamplecycleView
//
//  Created by liran on 16/6/3.
//  Copyright © 2016年 liran. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    pageCenter,
    pageLeft,
    pageRight
}(PagePosition);

@interface CYPageControl : UIControl

/** 小圆点个数 */
@property(nonatomic,assign)NSInteger numberOfPages;
/** 当前点数 */
@property(nonatomic,assign)NSInteger currentPage;
/** 小圆点大小 */
@property(nonatomic,assign)CGSize pageSize;
/** 其他小圆点颜色 */
@property(nonatomic,strong)UIColor *pageColor;
/** 当前小圆点颜色 */
@property(nonatomic,strong)UIColor *currentColor;
/** 其他小圆点图片 */
@property(nonatomic,copy)NSString *pageImageUrl;
/** 当前小圆点图片 */
@property(nonatomic,copy)NSString *currentImageUrl;
/** 位置：左，右，中；默认：中 */
@property(nonatomic,assign)PagePosition pagePosition;

@end
