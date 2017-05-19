//
//  StaffModel.h
//  CloudTiger
//
//  Created by cyan on 16/9/9.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject
@property(nonatomic,copy)NSString *btnNormal;
@property(nonatomic,copy)NSString *btnSelected;
@property(nonatomic,copy)NSString *btnDisabled;
@property(nonatomic,copy)NSString *title;

/**是否有这个权限功能*/
@property(nonatomic,assign)BOOL isHave;
@end
