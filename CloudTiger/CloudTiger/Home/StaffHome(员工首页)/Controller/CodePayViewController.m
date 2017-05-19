//
//  CodePayViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/23.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CodePayViewController.h"
#import "SYQRCodeViewController.h"
#import "CodePostViewController.h"
@interface CodePayViewController ()<UITextFieldDelegate>{
    
    UIImageView *codeImageV ;
    UITextField *moneyText;
    NSInteger _btnTag;
    BOOL isHaveDian ;
    
    UILabel *_moneyLab;

}

@end

@implementation CodePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智能扫码";
    self.view.backgroundColor = PaleColor;
    [self createUI];

}
/**
 重写返回方法，收键盘
 */
-(void)backAction{
    [super backAction];
    [moneyText resignFirstResponder];
    
    
}
-(void)createUI{
    
    //    750/290
    UIImageView *topBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, MainScreenWidth,  145)];
//        topBgView.backgroundColor = [UIColor yellowColor];
    topBgView.image = [UIImage imageNamed:@"code_wx_bg"];
    [self.view addSubview:topBgView];
    
    topBgView.userInteractionEnabled = YES;
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 50)];
    //    label.backgroundColor = [UIColor redColor];
    label.text = @"￥";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:14];
//    [topBgView addSubview:label];
    
    moneyText = [[UITextField alloc]initWithFrame:CGRectMake(15, 37.5/2.0, MainScreenWidth -30, 50)];
    moneyText.placeholder = @"输入金额";
//    moneyText.font = [UIFont systemFontOfSize:50];
//    moneyText.font = [UIFont systemFontOfSize:50 weight:1];
        moneyText.font = [UIFont boldSystemFontOfSize:50];

//    moneyText.backgroundColor = [UIColor cyanColor];
    //    UIKeyboardTypeNumberPad UIKeyboardTypeNumbersAndPunctuation
    moneyText.keyboardType = UIKeyboardTypeDecimalPad;
    moneyText.delegate = self;
    moneyText.textAlignment = NSTextAlignmentCenter;
    [topBgView addSubview:moneyText];
    
    [moneyText addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    //label超出不显示
    moneyText.clipsToBounds = YES;
    
    /**
     监听textfield 的text变化，加上 ￥
     */
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 20, 30)];
    //    _moneyLab.backgroundColor = [UIColor redColor];
    _moneyLab.text = @"￥";
    _moneyLab.textColor = [UIColor blackColor];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    //    _moneyLab.center = moneyText.center;
    _moneyLab.font = [UIFont systemFontOfSize:14];
    _moneyLab.hidden = YES;
    [moneyText addSubview:_moneyLab];


    
    //    230/230
    //二维码btn
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((MainScreenWidth - 115)/2.0, 0, 115, 115);
    //    button.backgroundColor = [UIColor purpleColor];
    [button setBackgroundImage:[UIImage imageNamed:@"scan_code_n"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"code_s"] forState:UIControlStateNormal];

    [button addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = CGPointMake(button.center.x, topBgView.bottom);
}

#pragma mark TextField ChangeValue
-(void)changeValue:(UITextField *)textField{
    NSLog(@"textField.text :%@",textField.text);
    if (!textField.text.length) {
        _moneyLab.hidden = YES;
    }else{
        _moneyLab.hidden = NO;
//        [self reloadMoneyLocation:textField];
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {//有小数点
            NSLog(@"没有小数点");
            /**
             判断一下 ，可能是复制粘贴过来的 。。。
             */
            if (textField.text.length > 6) {
                NSString *changeStr = textField.text;
                textField.text = [changeStr substringToIndex:6];
            }
            
        }else{
            
            //判断小数点的位数
            NSRange ran = [textField.text rangeOfString:@"."];
            NSLog(@"textField.text :%@",textField.text);
            
            if (textField.text.length - ran.location >2) {
                NSMutableString *muteString = [[NSMutableString alloc]initWithFormat:@"%@",textField.text];
                //                49543  49.54
                //           123.456  --> 123.45
                [muteString deleteCharactersInRange:NSMakeRange(ran.location + 3,textField.text.length - ran.location - 3)];
                
                NSLog(@"muteString :%@",muteString);
                textField.text = [muteString copy];
                
                
            }
        }
        //刷新￥ 位置
              [self reloadMoneyLocation:textField];
        
    }


    
}
/**
 刷新 ￥ 标识的位置
 */
-(void)reloadMoneyLocation:(UITextField *)textF{
    
    CGSize textSize = [moneyText.text sizeWithAttributes:@{NSFontAttributeName:moneyText.font}] ;
    NSLog(@"width : %f,height :%f",textSize.width,textSize.height);
    CGFloat  with =     (  textF.frame.size.width  - textSize.width)/2.0 -20 ;
    _moneyLab.left = with;
}

-(void)codeAction:(UIButton *)btn{
    
    NSLog(@"扫描二维码");
    [moneyText resignFirstResponder];
    
//    
//    if (moneyText.text.length == 0) {
//        NSLog(@"输入金额为 0");
//
//        return;
//    }
//    
//    if ([moneyText.text isEqualToString:@"0"] || [moneyText.text isEqualToString:@"0."]||[moneyText.text isEqualToString:@"0.0"]||[moneyText.text isEqualToString:@"0.00"]) {
//        
//        NSLog(@"输入金额为 0");
//        return;
//    }
    
    
    if (!moneyText.text.length) {
        
        //        [self showSVPErrorStatus:@"输入为空"];
        [MessageView showMessage:@"输入为空"];
        return;
    }
    if ([moneyText.text floatValue] <= 0.0) {
        NSString *money =   [CyTools interByStr:moneyText.text];
        //金额格式化显示
        moneyText.text =[CyTools folatByStr:money];
        [self changeValue:moneyText];
        [MessageView showMessage:@"输入金额不能为0元"];
        
        return;
    }
    NSString *money =   [CyTools interByStr:moneyText.text];
    //金额格式化显示
    moneyText.text =[CyTools folatByStr:money];
    [self changeValue:moneyText];
    
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    
    
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        NSLog(@"扫码成功 %@",qrString);
        CodePostViewController *codePost = [CodePostViewController new];
        codePost.hidesBottomBarWhenPushed  = YES;
        codePost.codeStr = qrString;
        codePost.moneyStr = moneyText.text;
        
        [self.navigationController pushViewController:codePost animated:YES];
        
   
        [aqrvc dismissViewControllerAnimated:YES completion:nil];

      

        
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        NSLog(@"扫码失败");
        [aqrvc dismissViewControllerAnimated:YES completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        
        NSLog(@"扫码取消");
        
        [aqrvc dismissViewControllerAnimated:YES completion:nil];
        
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    if (textField.text.length) {
        if (![textField.text containsString:@"."]) {
            textField.text = [NSString stringWithFormat:@"%@.00",textField.text];
            _moneyLab.hidden = NO;
            CGSize textSize = [moneyText.text sizeWithAttributes:@{NSFontAttributeName:moneyText.font}] ;
            NSLog(@"width : %f,height :%f",textSize.width,textSize.height);
            CGFloat  with =     (  textField.frame.size.width  - textSize.width)/2.0 -20 ;
            _moneyLab.left = with;
        }
     
        
    }
    
//       [self changeValue:textField];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    
    [textField resignFirstResponder];
    return YES;
}
/**
 12 3456.00
 
 */
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
    //    [self alterWith:errorString];
    //
    //    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeErrorView2) userInfo:nil repeats:NO];
    [self showSVPErrorStatus:errorString];
    [self performSelector:@selector(playDiss) withObject:nil afterDelay:1];
    [moneyText resignFirstResponder];
}

-(void)playDiss{
    [self dismissSVP];
}


@end
