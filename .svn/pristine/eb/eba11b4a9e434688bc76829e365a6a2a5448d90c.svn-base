//
//  RefundDesCell2.m
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RefundDesCell2.h"
@interface RefundDesCell2()<UITextFieldDelegate>{
    
    UILabel *tipLab;
    BOOL isHaveDian ;

}
@end
@implementation RefundDesCell2

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
        
    }
    return self;
}

-(void)setRefundableAmount:(NSString *)refundableAmount{
    _refundableAmount = refundableAmount;
    
    [self relaodView];
    
}

-(void)relaodView{
    /**
     11.25  修改了 显示； 默认进来 _moneyTextField.text 是可退金额 tipLab.text  显示为空
     */
    _moneyTextField.text = [CyTools folatByStr:_refundableAmount];
    
    tipLab.text = @"(可退0.00元)";
    
    
//    tipLab.text = [NSString stringWithFormat:@"(可退%@元)", [CyTools folatByStr:_refundableAmount]];
    
}

-(void)createUI{

    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 56, 50)];
//    label.backgroundColor = [UIColor redColor];
    label.text = @"退款金额";
    label.textColor = GrayColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13.5];
    [self.contentView addSubview:label];
    
     _moneyTextField= [[UITextField alloc]initWithFrame:CGRectMake(label.right +10, 0,MainScreenWidth -  label.right -10 -15, 30)];
    _moneyTextField.placeholder = @"退款金额";
//    _moneyTextField.backgroundColor = [UIColor cyanColor];
    _moneyTextField.delegate = self;
    _moneyTextField.textAlignment = NSTextAlignmentRight;
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;



    [self.contentView addSubview:_moneyTextField];
    
    
    [_moneyTextField addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    
    tipLab  = [[UILabel alloc]initWithFrame:CGRectMake(_moneyTextField.left, _moneyTextField.bottom,_moneyTextField.width , 20)];
//    tipLab.backgroundColor = [UIColor redColor];
    
    tipLab.text = @"(可退0.001元)";
    tipLab.textColor = UIColorFromRGB(0xff5c11, 1);
    tipLab.textAlignment = NSTextAlignmentRight;
    tipLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:tipLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}
-(void)changeValue:(UITextField *)textField{
    [self reloadTipLab];
    
}

-(void)reloadTipLab{
    //输入
    NSInteger money = [[CyTools interByStr:_moneyTextField.text] integerValue];
    //可退金额
    NSInteger refundAmount = [_refundableAmount integerValue];
    NSLog(@"money : %ld",money);
    if (refundAmount < money) {
        
       tipLab.text = @"金额错误";
    }else{
        
        NSString *showMonet = [NSString stringWithFormat:@"%ld",refundAmount -money];
        tipLab.text = [NSString stringWithFormat:@"(可退%@元)", [CyTools folatByStr:showMonet]];
    }
    


    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    /**
     有无小数点  -> 无小数点 6 位
     
     ->  有小数点 -> 小数点后两位可以输入
     
     */
    
    if ([string isEqualToString:@""]) {//清空不处理
        return YES;
    }
    
    unichar single = [string characterAtIndex:0];//当前输入的字符
    
    if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
        
    }else{
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {//无小数点
        
        
        if (textField.text.length >= 6) {
            
            if ([string isEqualToString:@"."]) {
                
                
                return YES;
            }
            if ([string isEqualToString:@""]) {
                return YES;
            }
            
            return NO;
        }
        
        
    }else{//有小数点
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        
        
        if (textField.text.length >= 3 + 6) {
            NSLog(@"没有小数点 不能输入超过 10 0000 ");
            return NO;
        }
        
        //判断小数点的位数
        NSRange ran = [textField.text rangeOfString:@"."];
        
        NSLog(@"ran.location : %ld,range.location : %ld",ran.location,range.location);
        
        
        
        if (range.location > ran.location) {//小数点后边输入
            //有小数点 不能输入超过 10 0000 ；
            
            if (textField.text.length - ran.location == 3) {
                return NO;
            }
            
            return YES;
            
        }else{//小数点前边输入
            
            if (textField.text.length >= 3 + 6) {
                NSLog(@"没有小数点 不能输入超过 10 0000 ");
                return NO;
            }
            
            return YES;
            
        }
        
    }
    
    
    return YES;

}


- (void)showError:(NSString *)errorString
{
    [SVProgressHUD showErrorWithStatus:errorString];
    [SVProgressHUD dismissWithDelay:.5];
    
}




@end
