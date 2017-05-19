//
//  CyTools.m
//  GuanJiaLaiLeApp
//
//  Created by liran on 16/5/31.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import "CyTools.h"

@implementation CyTools


//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
    
    
}


//根据高度求宽度  content 计算的内容  Height 计算的高度 font字体大小

+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(999, height)
                            options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    
                       return rect.size.width;
    
    
}


-(void)imageByUrl:(NSString *)imageURL{
    
//    NSURL* URL = nil;
//    if([imageURL isKindOfClass:[NSURL class]]){
//        URL = imageURL;
//    }
//    if([imageURL isKindOfClass:[NSString class]]){
//        URL = [NSURL URLWithString:imageURL];
//    }
//    if(URL == nil)
////        return CGSizeZero;                // url不正确返回CGSizeZero
//    
//    
////    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
//    NSString *pathExtendsion = [URL.pathExtension lowercaseString];
//    
//    
////    CGSize size = CGSizeZero;
//    if([pathExtendsion isEqualToString:@"png"]){
////        size =  [self getPNGImageSizeWithRequest:request];
//    }
//    else if([pathExtendsion isEqual:@"gif"])
//    {
////        size =  [self getGIFImageSizeWithRequest:request];
//    }
//    else{
////        size = [self getJPGImageSizeWithRequest:request];
//    }
}

/** view所在的VC */
+(UIViewController *)viewControllerBy:(UIView *)currentView{
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = currentView.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

+(NSDateComponents *)compare:(NSTimeInterval)interval1 With:(NSTimeInterval)interval2{
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval1];
    
    //时间戳 1465377090.95  1465377355.06
    NSDate *date2  = [NSDate dateWithTimeIntervalSince1970:interval2];
    //日历对象
    NSCalendar *calender = [ NSCalendar currentCalendar];
    //枚举代表想获取那些差值
    NSCalendarUnit unit =NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期之间的差值
    NSDateComponents *cmpss = [calender components:unit fromDate:date toDate:date2 options:0];

    return cmpss;
    
}
+(CALayer *)viewWithBounds:(CGRect )bounds ByCorners:(UIRectCorner )corners ByCornerRadii:(CGSize)cornerRadii drawByColor:(UIColor *)color{
    
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *borderLayer3 =  [[CAShapeLayer alloc]init];
    borderLayer3.frame = bounds;
    borderLayer3.path = maskPath3.CGPath;
    if (!color) {
        borderLayer3.strokeColor = [UIColor colorWithRed:228.0 / 255 green:228.0 / 255 blue:228.0 / 255 alpha:1].CGColor;
    }else{
        borderLayer3.strokeColor = color.CGColor;

    }
    borderLayer3.fillColor = [UIColor clearColor ].CGColor;
    
    
    return borderLayer3;}

/**Sublayer*/
+(CALayer *)viewWithBounds:(CGRect )bounds ByCorners:(UIRectCorner )corners ByCornerRadii:(CGSize)cornerRadii{
    
    
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *borderLayer3 =  [[CAShapeLayer alloc]init];
    borderLayer3.frame = bounds;
    borderLayer3.path = maskPath3.CGPath;
    
    
    borderLayer3.strokeColor = [UIColor colorWithRed:228.0 / 255 green:228.0 / 255 blue:228.0 / 255 alpha:1].CGColor;
    borderLayer3.fillColor = [UIColor clearColor ].CGColor;
    
    
    return borderLayer3;
}
/**layer.mask*/
+(CALayer *)viewWithBounds2:(CGRect )bounds ByCorners:(UIRectCorner) corners ByCornerRadii:(CGSize)cornerRadii{
    
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer3 = [CAShapeLayer layer];
    
    maskLayer3.frame = bounds;
    
    maskLayer3.path = maskPath3.CGPath;
    
    return maskLayer3;
}


/**检查手机号*/
+(BOOL )checkPhoneNumberBy:(NSString *)mobile{
    
    
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        
      return YES;
    }else{
    
      return NO;
    }
 
    
}
//验证邮箱
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//密码
//    1：密码长度为6位或6位以上
//    2：密码字符只允许“数字，大小写字母，下划线
+ (BOOL) validatePassword:(NSString *)passWord
{
//        NSString *passWordRegex =@"^[a-zA-Z0-9~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]{6,20}+$";
    NSString *passWordRegex = @"^[a-zA-Z0-9_]{6,200}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

+ (BOOL) validateNumberOnly:(NSString *)passWord
{
    
    NSString *passWordRegex = @"^[0-9]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

/**大于0 小于1  小数点后面有三位*/
+(BOOL)isNeedPointBy:(NSString *)inputStr{
    if (![inputStr containsString:@"."]) {//没有小数点 直接 不对
        
        return NO;
    }
    
    NSLog(@"包含");
    
    NSRange ran = [inputStr rangeOfString:@"."];
    //小数点后边
    NSString *pointStr = [inputStr substringFromIndex:ran.location+1];
    //小数点前边
    NSString *pointStr2 = [inputStr substringToIndex:ran.location];
    
    if (pointStr2.length == 0 || pointStr2.length > 1) {
        NSLog(@"小数点前面 为空  或者超过了两位数");
        return NO;
    }
    NSLog(@"pointStr2  : %@",pointStr2);
    
    
    NSDecimalNumber*discount1 = [NSDecimalNumber decimalNumberWithString:inputStr];
    
    NSDecimalNumber*discount2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    NSDecimalNumber*discount3 = [NSDecimalNumber decimalNumberWithString:@"1"];
    
    
    NSComparisonResult result = [discount1 compare:discount2];
    
    NSComparisonResult result2 = [discount1 compare:discount3];
    
    if (result ==NSOrderedDescending && result2 == NSOrderedAscending ) {
        NSLog(@"大于 0  小于  1");
        //判断小数点的位数
        
        if ([pointStr containsString:@"."]) {
            NSLog(@"多了小数点");
            return NO;
        }
        if (pointStr.length >4) {
            NSLog(@"超过四位小数了");
            
            return NO;
        }
        
        NSLog(@"ran.location : %ld ,pointStr ：%@ ",ran.location,pointStr);
        
        
    }else{
        
        return NO;
    }
    
    
    return YES;
}



/**是否纯中文*/
+(BOOL) isContainChinese:(NSString *)inputStr{
    
    //    只能输入汉字：^[\u4e00-\u9fa5]{0,}$
    //    不能输入汉字：^[^\u4e00-\u9fa5]{0,}$
    NSString *passWordRegex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    //为0 的时候 包含中文
    BOOL isSure =  [passWordPredicate evaluateWithObject:inputStr];
    NSLog(@"isSure : %d",isSure);
    
    return !isSure;
}

/**数组排序*/
+(NSArray *)allReturnWith:(NSArray *)arr{
    
    
    NSMutableArray *arr1 = [arr mutableCopy];
    for (NSInteger index = 0; index < arr1.count; index ++) {
        NSString *str = [arr1 objectAtIndex:index];
        if ([str isEqualToString:@"综合"]) {
            [arr1 exchangeObjectAtIndex:0 withObjectAtIndex:index];
        }

        if ([str isEqualToString:@"comprehensive"]) {
            [arr1 exchangeObjectAtIndex:0 withObjectAtIndex:index];
        }
        
    }
    
    return arr1;
}
/**根据颜色返回一个图片*/
+(UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 3;
    CGFloat imageH = 3;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
+(NSString * )compareOne:(CGFloat )index WithArr:(NSArray *)arr{
    NSMutableArray *countArr = [NSMutableArray new];
    for (NSString *numbr in arr) {
        NSInteger count =  index - [numbr integerValue];
        if (count >=0) {
            [countArr addObject:numbr];
        }
        
    }
    
    NSArray *arr3 = [countArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger: [obj1 integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger: [obj2 integerValue]];
        
        return [number1  compare:number2];
    }];
    
    NSString *compare = arr3.lastObject ;
    return compare;
}


/**升序排列数组*/
+(NSArray *)orderByAscWith:(NSArray *)arr{
    
    NSArray *arr3 = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger: [obj1 integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger: [obj2 integerValue]];
        
        return [number1  compare:number2];
    }];
//    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
//    
//    NSArray *sortDescriptors = @[firstDescriptor];
//    
//    NSArray *sortedArray = [arr sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return arr3;
}
/**根据数组取得对应values*/
+(NSArray *)orderByAscWithDic:(NSDictionary *)dic By:(NSArray *)keyArr{
    
    NSMutableArray *values = [NSMutableArray new];
    for (NSInteger index = 0; index < dic.count ; index ++) {
        NSString *key = keyArr[index];
        id value = [dic objectForKey:key];
        [values addObject:value];
    }
    
    return [values copy];
}
/**key，value对换（前提value不能为空，value唯一性）*/
+(NSDictionary *)exchangeKeyValueBy:(NSDictionary *)dic{
     NSDictionary *dic2 = [[NSDictionary alloc]initWithObjects:dic.allKeys forKeys:dic.allValues];
    
    return dic2;
}

+(NSInteger)getTimeToShowWithStartTime:(NSString *)start_time EndTime:(NSString *)end_time{
    
    NSString*strend=end_time;//时间戳
    
    NSTimeInterval time=[strend doubleValue]+28800;//因为时差问题要加8小时
    NSDate*EndDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    
    NSString*strstart=start_time;//时间戳
    
    NSTimeInterval time1=[strstart doubleValue]+28800;
    NSDate *StartDate=[NSDate dateWithTimeIntervalSince1970:time1];
    
    
    NSTimeInterval timeInterval=[StartDate timeIntervalSinceDate:EndDate];
    
    NSInteger hour=fabs(timeInterval)/3600;
    
    return hour;
}
+(NSString *)getHourAndSecondByTimeInterval:(NSTimeInterval )interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    yyyy-MM-dd HH:mm:ss:SSS
    formatter.dateFormat = @"HH:mm";
    NSString *time = [formatter stringFromDate:date];
    return time;
}
+(NSString *)getYearAndMonthAndDayByTimeIntervalStr:(NSString *)interval{

    NSTimeInterval interval2 =[interval doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval2];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    yyyy-MM-dd HH:mm:ss:SSS
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:date];
    return time;
}
+(NSString *)getYearAndMonthAndDayByTimeInterval:(NSTimeInterval )interval{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    yyyy-MM-dd HH:mm:ss:SSS
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:date];
    return time;
}
/**根据时间戳 获取 年-月-日 时分秒*/
+(NSString *)getYearAndMonthAndDayAndHourByTimeInterval:(NSTimeInterval )interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    yyyy-MM-dd HH:mm:ss:SSS
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formatter stringFromDate:date];
    return time;
    
}
/**根据时间戳字符串 获取 年-月-日 时分秒*/
+(NSString *)getYearAndMonthAndDayAndHourByTimeIntervalStr:(NSString *)interval{
    NSTimeInterval interval2 =[interval doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval2];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    yyyy-MM-dd HH:mm:ss:SSS
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formatter stringFromDate:date];
    return time;
    
}
/**
 2016-09-24 10:11:23 --> yyyy-MM-dd
 */
+(NSString *)getYearAndMonthByYear:(NSString *)time{
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [form dateFromString:time];
    form.dateFormat = @"yyyy-MM-dd";
    NSString *str = [form stringFromDate:date];
    
    return str;
}

/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     目标数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(float)price afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


/**
  0.01 -->  1
 */
+(NSString *)interByStr:(NSString *)input{
    
    if (input.length == 0) {
        return @"0";
    }
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:input];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    NSInteger index = [product integerValue];
    NSString *outStr = [NSString stringWithFormat:@"%ld",index];

//    NSLog(@"outStr :%@",outStr);
    return outStr;
}
/**
 1 -->  0.01
 */

+(NSString *)folatByStr:(NSString *)input{
    if (IsNilOrNull(input)) {
        return @"0.00";
    }
    NSString *input2 = [NSString stringWithFormat:@"%@",input];
    if (input2.length == 0) {
        return @"0.00";
    }
    
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:input2];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
    
    NSString *outStr = [NSString stringWithFormat:@"%.2f",[product doubleValue]];
    
//    NSLog(@"price :%@",price);
    return outStr;
}
/**double --> str*/

+(NSString *)strByDoubleValue:(id )doubleValue{
    double rate = [doubleValue doubleValue];
    NSString *d2Str       = [NSString stringWithFormat:@"%lf", rate];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:d2Str];
    NSString *strD2       = [num1 stringValue];
    return strD2;
}

/**123456789 --> 123,456,789 */

+(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"，," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}


//登出
+(void)loginException{
    NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
    //登出
    NSDictionary *isFirstDic = @{@"isFirst":@NO};//测试 为NO
    [isFirstDic writeToFile:isFirstFilePath atomically:YES];
    
    [[CyanManager shareSingleTon]cleanUserInfo];
    
}

+(BOOL)isLoginSuccess{
    
    NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:isFirstFilePath];
    
    BOOL isFirst = [dic[@"isFirst"] boolValue];//第一次是no
    return isFirst;
}
+(void)loginSuccess{
    
    NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
    //登录成功
    NSDictionary *isFirstDic = @{@"isFirst":@YES};//测试 为NO
    [isFirstDic writeToFile:isFirstFilePath atomically:YES];
}


+(void)loginFail{
    
    NSString  *isFirstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/first.plist"];
    //登录失败
    NSDictionary *isFirstDic = @{@"isFirst":@NO};//测试 为NO
    [isFirstDic writeToFile:isFirstFilePath atomically:YES];
}


@end
