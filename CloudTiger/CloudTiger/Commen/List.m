//
//  List.m
//  EBangNet
//
//  Created by SZH on 15/11/25.
//  Copyright © 2015年 kang. All rights reserved.
//

#import "List.h"

#import "Reachability.h"


@implementation List

+ (void)setObject:(id)objc forKey:(NSString *)key {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (IsNilOrNull(objc)) {
        return;
    }else if([objc isKindOfClass:[NSArray class]]||[objc isKindOfClass:[NSMutableArray class]]){
    

        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:(NSArray*)objc];
        
        for ( int i=0; i<[array count]; i++) {
            
            if ([array[i] isKindOfClass:[NSDictionary class]]) {
                
                [array replaceObjectAtIndex:i withObject:[List check:array[i]]];
            }
        }
        
        [user setObject:array forKey:key];
    }else if ([objc isKindOfClass:[NSDictionary class]]||[objc isKindOfClass:[NSMutableDictionary class]]){
        
        [user setObject:[List check:objc] forKey:key];
        
    }else{
        
         [user setObject:objc forKey:key];
        
    }
        
    
        
    
    
    
    
}

+ (id)objectForKey:(NSString *)key {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    id objc = [user objectForKey:key];

    return objc;
}

+ (void)removeObjectForKey:(NSString *)key {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
}

+(NSDictionary*)check:(NSDictionary *)dic{
    
    NSArray * array = [dic allKeys];
    
    NSMutableDictionary * mut = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    for (NSString * key in array) {
        
        if ([dic[key] isKindOfClass:[NSNull class]]) {
            
        
            [mut setObject:@"" forKey:key];
        }
    }
    
    return (NSDictionary*)mut;
    
    
    
}


/**
 *  网络连接状态
 *
 *  @return 返回网络连接状态
 */
+(BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络连接");
            isExistenceNetwork=NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            
            NSLog(@"用的流量");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"使用WiFi网络");
            break;
    }
    
    return isExistenceNetwork;
}

@end
