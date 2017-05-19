//
//  QueryModel.m
//  CloudTiger
//
//  Created by cyan on 16/9/12.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryModel.h"

@implementation QueryModel
-(instancetype)initWithShopDict:(NSDictionary *)dict{
    self.headCellArray = [NSMutableArray arrayWithArray:[self ReturnData2:dict[@"list"]]];
    return self ;
}

-(NSArray *)ReturnData2:(NSArray *)array{

    NSMutableArray *arrays= [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < array.count ; index ++) {
        NSDictionary *dic = array[index];
        QueryCellModel *model = [[QueryCellModel alloc] init];
        model.titleKey = dic.allKeys[0];
        model.title = [dic valueForKey:model.titleKey];
        model.cellText = @"";
        [arrays addObject:model];
    }
    
    return arrays;
}
-(NSArray *)ReturnData:(NSArray *)array{
    
    NSMutableArray *arrays= [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        
        QueryCellModel *model = [[QueryCellModel alloc] initWithShopDict:dict];
        
        [arrays addObject:model];
        
    }
    
    return arrays;
}
@end

@implementation QueryCellModel


-(instancetype)initWithShopDict:(NSDictionary *)dict{
    self.title = dict[@"cart_id"];

    return self ;
}


@end