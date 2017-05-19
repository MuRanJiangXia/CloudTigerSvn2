//
//  CYCollectionViewCell.h
//  CYCycleScrollView
//
//  Created by liran on 16/6/1.
//  Copyright © 2016年 liran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@property (nonatomic, assign) BOOL hasConfigured;
@end
