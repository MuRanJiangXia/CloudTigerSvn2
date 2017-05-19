//
//  CyCycleScrollView.m
//  CYCycleScrollView
//
//  Created by liran on 16/6/1.
//  Copyright © 2016年 liran. All rights reserved.
//

#import "CyCycleScrollView.h"
#import "CYCollectionViewCell.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "UIView+UIViewController.h"
#import "CYPageControl.h"
NSString * const ID = @"cycleCell";

@interface CyCycleScrollView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic ,weak)UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,weak)CYPageControl *pageControl;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;



@end


@implementation CyCycleScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self openFunction];
        [self creatUI];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self openFunction];
    [self creatUI];
    
    
}
//重写 set 赋值
-(void)setImageNames:(NSArray *)imageNames{
    
    if (_imageNames != imageNames) {
        _imageNames = imageNames;
        //添加一个
        if (imageNames.count) {
#pragma mark 解决拼接数组会改变里面的value，并且不会受到逗号影响
            NSMutableArray *finalArr = [NSMutableArray arrayWithArray:imageNames];
            [finalArr addObject:imageNames[0]];
            _imagePathsGroup = [NSArray arrayWithArray:finalArr];
            _totalItemsCount = _imagePathsGroup.count;
            _totalItemsCount = _imagePathsGroup.count;
#warning 这里开启定时器
            [self setAutoScroll:self.autoScroll];
        }
    
        
    }
}
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [_timer invalidate];
    _timer = nil;
    
    if (_autoScroll) {
        [self setupTimer];
    }
}
-(void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    
    if (_autoScrollTimeInterval != autoScrollTimeInterval) {
        _autoScrollTimeInterval = autoScrollTimeInterval;
        if (autoScrollTimeInterval <= 0) {
            _autoScrollTimeInterval = 2.0;
        }
        
        [self setAutoScroll:self.autoScroll];

    }
}
-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
    
}
-(void)setCurrentPageDotColor:(UIColor *)currentPageDotColor{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[CYPageControl class]]) {
        CYPageControl *pageControl = (CYPageControl *)_pageControl;
        pageControl.currentColor = currentPageDotColor;
    }
    
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[CYPageControl class]]) {
        CYPageControl *pageControl = (CYPageControl *)_pageControl;
        pageControl.pageColor = pageDotColor;
    }
}

-(void)setCurrentPageDotImage:(NSString *)currentPageDotImage{
    
    _currentPageDotImage = currentPageDotImage;
    if ([self.pageControl isKindOfClass:[CYPageControl class]]) {
        CYPageControl *pageControl = (CYPageControl *)_pageControl;
        pageControl.currentImageUrl = currentPageDotImage;
    }
}
-(void)setPageDotImage:(NSString *)pageDotImage{
    _pageDotImage = pageDotImage;
    if ([self.pageControl isKindOfClass:[CYPageControl class]]) {
        CYPageControl *pageControl = (CYPageControl *)_pageControl;
        pageControl.pageImageUrl = pageDotImage;
    }
}

//功能设置
-(void)openFunction{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _infiniteLoop = YES;
    _autoScroll = YES;
    _autoScrollTimeInterval = 2.0;
    self.backgroundColor = [UIColor cyanColor];
}
//UI界面
-(void)creatUI{

//    self.contentMode = UIViewContentModeScaleAspectFill;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[CYCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
     CYPageControl *page = [[CYPageControl alloc]initWithFrame:CGRectZero];
    page.currentPage = 0;
    page.userInteractionEnabled = NO;
    [self addSubview:page];
    _pageControl = page;
    
 
}

-(void)buttonAction:(UIButton *)btn{
    
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}


#pragma mark  timer
- (void)automaticScroll
{
 
    if (0 == _totalItemsCount) return;
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
#warning 避免导航栏影响。
    self.viewController.automaticallyAdjustsScrollViewInsets = NO;
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
    _pageControl.frame = CGRectMake(0, self.height -20, self.width, 20);
    if (self.imageNames.count == 1) {
        _pageControl.numberOfPages = 0;
    }else{
      _pageControl.numberOfPages = self.imageNames.count;
    }
   
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NSString *imagePath = self.imagePathsGroup[indexPath.row];

    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] ];
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@""]];
        } else {
            cell.imageView.image = [UIImage imageNamed:imagePath];
        }
    } else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        NSInteger index = indexPath.item ;
        if (indexPath.item + 1== _totalItemsCount) {
            index = 0;
        }
        [self.delegate cycleScrollView:self didSelectItemAtIndex:index];
    }
//    NSLog(@"点击了  %ld",indexPath.row);
}


#pragma mark scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.width * 0.5) / self.mainView.width;
    _pageControl.currentPage = itemIndex;
    if (itemIndex== _totalItemsCount -1) {
        _pageControl.currentPage = 0;
    }
    if (scrollView.contentOffset.x < 0) {
        _mainView.contentOffset = CGPointMake((_imagePathsGroup.count -1) * self.bounds.size.width, 0);

    }
    if (scrollView.contentOffset.x > (_imagePathsGroup.count -1) * self.bounds.size.width) {

      [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        _mainView.contentOffset = CGPointMake(0, 0);

    }

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [_timer invalidate];
        _timer = nil;
    }
}
//scrollViewDidEndDecelerating 手滑动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}
//代码移动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.width * 0.5) / self.mainView.width;
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题

    if (itemIndex +1 == _totalItemsCount) {
        itemIndex = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:itemIndex];
    }
}




@end
