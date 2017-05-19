//
//  CyanAddressView.h
//  CloudTiger
//
//  Created by cyan on 16/12/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CyanAddressView : UIView
/**
 chooseID  上一级id currentDic 已选择的地址dic
 */
+(instancetype)showWith:(UITextField*)textF ByChooseId:(NSString *)chooseID WithCurrentDic:(NSDictionary *)currentDic Complete:(void(^)(NSDictionary * pro,NSDictionary * city ,NSDictionary * county))complete;
@end
