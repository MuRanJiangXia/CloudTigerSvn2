//
//  LoginChooseView.m
//  CloudTiger
//
//  Created by cyan on 16/9/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "LoginChooseView.h"
#define BaseTag 20160906

@interface LoginChooseView()<UIScrollViewDelegate,UITextFieldDelegate>{
    NSInteger _btnTag;
    UIView *chooseView;


}
@end
@implementation LoginChooseView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}


-(void)setLoginChooseDelegete:(id<LoginChooseDelegate>)loginChooseDelegete{
    
    _loginChooseDelegete = loginChooseDelegete;
    
    NSArray *textArr = @[@"",@""];
    if ([self.loginChooseDelegete respondsToSelector:@selector(chooseTag:Text:)]) {
        [self.loginChooseDelegete chooseTag:_btnTag Text:textArr];
    }
}

-(void)createChooseScroll{
    _chooseScroll  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, chooseView.bottom, MainScreenWidth, 110)];
    _chooseScroll.backgroundColor = [UIColor yellowColor];
    _chooseScroll.showsHorizontalScrollIndicator = NO;
    _chooseScroll.delegate =self;
    _chooseScroll.pagingEnabled = YES;
    _chooseScroll.bounces = NO;
    [self addSubview:_chooseScroll];
    
    _chooseScroll.contentSize = CGSizeMake(MainScreenWidth *2, 110);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    view.backgroundColor = [UIColor blueColor];
    [_chooseScroll addSubview:view];
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth , 100)];
    view2.backgroundColor = [UIColor brownColor];
    [_chooseScroll addSubview:view2];
    
    NSArray *textArr = @[@"账号",@"密码"];
    NSArray *textLeftArr = @[@"login_person",@"login_password"];
    for (NSInteger   j = 1; j <= 2; j ++) {
        for (NSInteger index = 0; index < textArr.count; index ++) {
            UITextField *textField  = [[UITextField alloc]initWithFrame:CGRectMake(0, 55 *index +0, MainScreenWidth, 55)];
            textField.placeholder = textArr[index];
            textField.backgroundColor = [UIColor whiteColor];
            textField.tag  = BaseTag + index + 10 * j;
            textField.delegate = self;
       
            if (index == 1) {
                
                textField.returnKeyType = UIReturnKeyJoin;
                textField.secureTextEntry = YES;
            
            }else{
                textField.returnKeyType = UIReturnKeyNext;

            }
            if (j == 1) {
                [view addSubview:textField];

            }else{
                [view2 addSubview:textField];
 
            }
            //关闭联想功能
            //        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            //关闭 首字母大写
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField setValue:GrayColor forKeyPath:@"_placeholderLabel.textColor"];
            [textField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
            
            textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (55.0 -20)/2, 20, 20)];
            //        imageView.backgroundColor = [UIColor yellowColor];
            imageView.image = [UIImage imageNamed:textLeftArr[index]];
            [textField addSubview:imageView];
            
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, textField.bottom -1, MainScreenWidth, 1)];
            lineView.backgroundColor = PaleColor;
            [textField addSubview:lineView];
        }
    }

    
}

-(void)createUI{
    
    
    chooseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, MainScreenWidth, 55)];
    chooseView.backgroundColor = BlueColor;
    [self addSubview:chooseView];
    
    
    NSArray *arr = @[@"服务商/商户",@"员工"];
    CGFloat width = MainScreenWidth /2;
    for (NSInteger index = 0; index < arr.count; index ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width *index,0 , width , 56);
        //        button.backgroundColor = [UIColor clearColor];
        
    
        [button setBackgroundImage:[CyTools imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
        [button setBackgroundImage:[CyTools imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//        [button setBackgroundImage:[CyTools imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        button.adjustsImageWhenHighlighted =NO;
         
         
        
 
        
        [button setTitle:arr[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        UIControlStateDisabled UIControlStateSelected
        [button setTitleColor:UIColorFromRGB(0x01A9EF, 1) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.tag  = index + BaseTag;
        
        [button addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [chooseView addSubview:button];
        
        if (index == 0) {//默认选中第一个
            _btnTag = BaseTag + index;
//            button.selected = YES;
            button.enabled = NO;

            [self loadBtnBy:button];
          
        }
        
    }
    [self createChooseScroll];
    
}
-(void)chooseAction:(UIButton *)btn{
    //    NSLog(@"tag :%ld",btn.tag);
  
//    if (btn.tag == _btnTag) {
//        NSLog(@"点击一个了");
//        return;
//    }
//    btn.selected = YES;
     btn.enabled = NO;
    if (_btnTag!= 0) {
        if (_btnTag != btn.tag) {
            UIButton *preBtn =   [self viewWithTag:_btnTag];
//            preBtn.selected = !preBtn.selected;
            preBtn.enabled = !preBtn.enabled;
            [self loadBtnBy:preBtn];
        }
    }
    _btnTag = btn.tag;
    
    [self loadBtnBy:btn];
    [_chooseScroll setContentOffset:CGPointMake((btn.tag -BaseTag)*MainScreenWidth, _chooseScroll.contentOffset.y) animated:YES];
  
    
}

-(void)loadBtnBy:(UIButton *)btn{
//    btn.selected
//    NSLog(@"btn.tag : %ld",btn.tag);
    if (!btn.enabled) {
        for (CALayer *layer in  btn.layer.sublayers) {
            if ([layer isKindOfClass:[CAShapeLayer class]]) {
                [layer removeFromSuperlayer];
                //                return;
            }
        }
        btn.layer.masksToBounds = YES;
        CGSize size = CGSizeMake(10, 10);
        UIRectCorner corner;
        if (btn.tag - BaseTag == 0) {
            corner  = UIRectCornerTopRight;
        }else{
            corner   = UIRectCornerTopLeft;
        }
        CALayer *layer = [CyTools viewWithBounds:btn.bounds ByCorners:corner ByCornerRadii:size drawByColor:[UIColor clearColor]];
        CALayer *mask =  [CyTools viewWithBounds2:btn.bounds ByCorners:corner ByCornerRadii:size];
        
        [btn.layer addSublayer:layer];
        btn.layer.mask = mask;
        
    }else{
        for (CALayer *layer in  btn.layer.sublayers) {
            
            if ([layer isKindOfClass:[CAShapeLayer class]]) {
                [layer removeFromSuperlayer];
                
            }
        }
        
        
    }
    
}


#pragma mark scrollViewDelegate

//scrollViewDidEndDecelerating 手滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"scrollViewDidEndDecelerating");
    _chooseScroll.hidden = NO;
    [self scrollby:scrollView];
    
}
//代码移动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    NSLog(@"scrollViewDidEndScrollingAnimation");
    _chooseScroll.hidden = NO;
    
    [self scrollby:scrollView];
    
}
/**
 * 滑动到指定位置,改变button选中效果
 */
-(void)scrollby:(UIScrollView *)scrollView{
    NSInteger row =  (scrollView.contentOffset.x+MainScreenWidth/2.f)/MainScreenWidth;
    //上一个btn
    UIButton *button =   [self viewWithTag:_btnTag];
//    button.selected = NO;
    button.enabled = YES;
    [self loadBtnBy:button];

    //当前选中btn
    _btnTag = row + BaseTag;
    UIButton *button1 =   [self viewWithTag:_btnTag];
//    button1.selected = YES;
    button1.enabled = NO;
    [self loadBtnBy:button1];
    NSLog(@"_btnTag :%ld",_btnTag);
  
    UITextField *text = (UITextField *)[_chooseScroll viewWithTag:BaseTag + 0+ 10 * (row + 1)];
    UITextField *text2 = (UITextField *)[_chooseScroll viewWithTag:BaseTag + 1+ 10 * (row + 1)];


    NSArray *textArr = @[text.text,text2.text];
    if ([self.loginChooseDelegete respondsToSelector:@selector(chooseTag:Text:)]) {
        [self.loginChooseDelegete chooseTag:_btnTag Text:textArr];
    }
}

#pragma mark UITextFieldDelegate

/**
 * 密码输入完点击done直接执行登录
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    _chooseScroll.
     [_chooseScroll endEditing:YES];
    
    NSLog(@"点击了return");
    NSLog(@"textField.tag :%ld",textField.tag);
    if (textField.tag == 20160916) {
        UITextField *text2 = (UITextField *)[_chooseScroll viewWithTag:20160917];
        [text2 becomeFirstResponder];
    }
    if (textField.tag == 20160926) {
        UITextField *text2 = (UITextField *)[_chooseScroll viewWithTag:20160927];
        [text2 becomeFirstResponder];
    }
    if (textField.tag ==20160917 || textField.tag == 20160927) {//点击密码 登录
        if ([self.loginChooseDelegete respondsToSelector:@selector(joinActionBy:)]) {
            [self.loginChooseDelegete joinActionBy:_btnTag];
        }
    }
    

    return YES;
}




//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    UITextField *perText = (UITextField *)[chooseScroll viewWithTag:BaseTag + 0+ 10 * (_btnTag -BaseTag + 1)];
//    UITextField *passwordText = (UITextField *)[chooseScroll viewWithTag:BaseTag + 1+ 10 * (_btnTag -BaseTag + 1)];
//    NSArray *textArr = @[perText.text,passwordText.text];
//    if ([self.loginChooseDelegete respondsToSelector:@selector(chooseTag:Text:)]) {
//        [self.loginChooseDelegete chooseTag:_btnTag Text:textArr];
//    }
//    
//    return YES;
// 
//    
//}

@end
