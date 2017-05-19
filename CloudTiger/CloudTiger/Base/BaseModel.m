//
//  BaseModel.m
//  CloudTiger
//
//  Created by cyan on 16/9/14.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel


///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    
    objc_property_t  * propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}
//
//BeautifulGirlModel *beautifulGirl = [BeautifulGirlModel modelWithDictionary:data];
//
//[beautifulGirl displayCurrentModleProperty];
#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL) creatGetterWithPropertyName: (NSString *) propertyName{
    
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}

//获取
- (id) displayCurrentModlePropertyBy:(NSString *)propertyName{
    
    //接收返回的值
    NSObject *__unsafe_unretained returnValue = nil;
    //获取get方法
    SEL getSel = [self creatGetterWithPropertyName:propertyName];
    
    if ([self respondsToSelector:getSel]) {
        
        //获得类和方法的签名
        NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
        
        //从签名获得调用对象
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        //设置target
        [invocation setTarget:self];
        
        //设置selector
        [invocation setSelector:getSel];
        
        //调用
        [invocation invoke];
        
        //接收返回值
        [invocation getReturnValue:&returnValue];

        
    }

    return returnValue;
    
}
@end
