//
//  StaffHomeTopView.h
//  CloudTiger
//
//  Created by cyan on 16/9/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseHeaderDelegate <NSObject>
-(void)chooseIndex:(NSInteger )index;

-(void)jumpMine;
@end
@interface StaffHomeTopView : UICollectionReusableView
@property(nonatomic,weak)id<ChooseHeaderDelegate>delegete;
@property(nonatomic,copy)NSString *isShopStaff;

@property(nonatomic,strong)NSArray *powerArr;



@end
