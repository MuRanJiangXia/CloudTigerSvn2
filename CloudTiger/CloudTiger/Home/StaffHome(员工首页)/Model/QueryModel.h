//
//  QueryModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryModel : NSObject

@property (nonatomic, assign)NSInteger section;
//
//@property(nonatomic,copy)NSString *title;
//@property(nonatomic,copy)NSString *cellText;
@property (nonatomic, strong) NSMutableArray *headCellArray;

-(instancetype)initWithShopDict:(NSDictionary *)dict;

@end
@interface QueryCellModel : NSObject

@property (nonatomic, copy) NSDictionary *cellPriceDict;
@property(nonatomic,copy)NSString *titleKey;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *cellText;


-(instancetype)initWithShopDict:(NSDictionary *)dict;
//-(instancetype)initWithShopArr:(NSArray *)arr;

@end