//
//  CyTools.h
//  GuanJiaLaiLeApp
//
//  Created by liran on 16/5/31.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CyTools : NSObject


/**
 *  根据宽度求高度 
 */

+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;

/**
 * 根据高度度求宽度
 */

+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;

/** view所在的VC */
+(UIViewController *)viewControllerBy:(UIView *)currentView;
/**根据时间戳比较*/
+(NSDateComponents *)compare:(NSTimeInterval)interval1 With:(NSTimeInterval)interval2;


/**Sublayer*/
+(CALayer *)viewWithBounds:(CGRect )bounds ByCorners:(UIRectCorner )corners ByCornerRadii:(CGSize)cornerRadii drawByColor:(UIColor *)color;
/**Sublayer*/

+(CALayer *)viewWithBounds:(CGRect )bounds ByCorners:(UIRectCorner )corners ByCornerRadii:(CGSize)cornerRadii;
/**layer.mask*/
+(CALayer *)viewWithBounds2:(CGRect )bounds ByCorners:(UIRectCorner) corners ByCornerRadii:(CGSize)cornerRadii;

/**检查手机号*/
+(BOOL )checkPhoneNumberBy:(NSString *)mobile;
/**检查邮箱*/
+(BOOL)isValidateEmail:(NSString *)email;
/**检查密码*/
+ (BOOL) validatePassword:(NSString *)passWord;
/**只允许输入数字*/
+ (BOOL) validateNumberOnly:(NSString *)passWord;

/**大于0 小于1  小数点后面有三位*/
+(BOOL)isNeedPointBy:(NSString *)inputStr;
/**是否纯中文*/
+(BOOL) isContainChinese:(NSString *)inputStr;

/**数组排序*/
+(NSArray *)allReturnWith:(NSArray *)arr;

/**根据颜色返回一个图片*/
+(UIImage *)imageWithColor:(UIColor *)color;
/**数组中所有数比较一个数得到超过数最大的数*/
+(NSString *  )compareOne:(CGFloat )index WithArr:(NSArray *)arr;
/**升序排列数组*/
+(NSArray *)orderByAscWith:(NSArray *)arr;
/**根据数组取得对应values*/
+(NSArray *)orderByAscWithDic:(NSDictionary *)dic By:(NSArray *)keyArr;


/**key，value对换（前提value不能为空，value唯一性）*/
+(NSDictionary *)exchangeKeyValueBy:(NSDictionary *)dic;

/**时间戳*/
+(NSInteger)getTimeToShowWithStartTime:(NSString *)start_time EndTime:(NSString *)end_time;
/**根据时间戳 获取小时：分钟*/
+(NSString *)getHourAndSecondByTimeInterval:(NSTimeInterval )interval;

/**根据时间戳 获取 年-月-日 */
+(NSString *)getYearAndMonthAndDayByTimeInterval:(NSTimeInterval )interval;
/**根据时间戳字符串 获取 年-月-日*/
+(NSString *)getYearAndMonthAndDayByTimeIntervalStr:(NSString *)interval;

/**根据时间戳 获取 年-月-日 时分秒*/
+(NSString *)getYearAndMonthAndDayAndHourByTimeInterval:(NSTimeInterval )interval;
/**根据时间戳字符串 获取 年-月-日 时分秒*/
+(NSString *)getYearAndMonthAndDayAndHourByTimeIntervalStr:(NSString *)interval;

/**
 2016-09-24 10:11:23 --> yyyy-MM-dd
 */
+(NSString *)getYearAndMonthByYear:(NSString *)time;

/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     目标数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(float)price afterPoint:(NSInteger)position;

/**
 0.01 -->  1
 */
+(NSString *)interByStr:(NSString *)input;
/**
 1 -->  0.01
 */
+(NSString *)folatByStr:(NSString *)input;

/**double --> str*/
+(NSString *)strByDoubleValue:(id )doubleValue;


/**123456789 --> 123,456,789 */
+(NSString *)countNumAndChangeformat:(NSString *)num;



/**登出*/
+(void)loginException;
/**登录成功*/
+(void)loginSuccess;
/**登录失败*/
+(void)loginFail;
/**获取登录是否完全成功*/
+(BOOL)isLoginSuccess;


@end
