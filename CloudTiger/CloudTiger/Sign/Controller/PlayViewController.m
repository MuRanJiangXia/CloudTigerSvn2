//
//  PlayViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"play";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    //内存泄露测试 
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    
    [arr1 addObject:arr2];
    [arr2 addObject:arr1];
    
    
    /**
     abcd efgh 'ijkl mnop qrsd uvwx yz
ABCD abcd efgh 'ijk lmno pqrs duvw xyz
     
     4 * 6 +2
     4 * 6 +2 +1
     如果 数据 变化  把请求多的  不插入数据（多一条 少插入一条 ，多两条少插入两条）
     COUNT 相减 取余数 余数为0 算页数 页数+N
               余数 不为零 页数+N 不插入数据（多一条 少插入一条 ，多两条少插入两条）
     */
    
    
    /**
     
     3edc 2wsx 1qaz 4rfv 5tgb // 6yhn 7ujm 8ik, 9ol. 0p;/
     
     
     1圈子 2我是想 3得出 4染发 5淘宝
     1圈子  2我是想 3得出 4染发 5淘宝
     
     6因 7居民 8靠， 9哦了 0跑；、
     
     
     */
    
    
    NSArray *arr = @[@"2",@"3"];
    
    
    if ([arr isKindOfClass:[NSArray class]]) {
        
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
