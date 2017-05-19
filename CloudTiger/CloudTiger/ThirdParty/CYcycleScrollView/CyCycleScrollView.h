//
//  CyCycleScrollView.h
//  CYCycleScrollView
//
//  Created by liran on 16/6/1.
//  Copyright © 2016年 liran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CyCycleScrollView;
@protocol CycleScrollViewDelegate <NSObject>
@optional

/** 点击图片回调 */
- (void)cycleScrollView:(CyCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
/** 图片滚动回调 */
- (void)cycleScrollView:(CyCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;
@end

@interface CyCycleScrollView : UIView
/**
 *  所有图片名
 */
@property(nonatomic,strong)NSArray *imageNames;

/** 是否无限循环,默认Yes */
@property(nonatomic,assign) BOOL infiniteLoop;
/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/** 是否自动滚动,默认Yes */
@property(nonatomic,assign) BOOL autoScroll;

@property (nonatomic, weak) id<CycleScrollViewDelegate> delegate;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, copy) NSString *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, copy) NSString *pageDotImage;

@end
