//
//  ChangeTopRateCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ChangeTopRateCell.h"
@interface ChangeTopRateCell()<UITextFieldDelegate>{
    
    UILabel *_titlLab;
}

@end
@implementation ChangeTopRateCell

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


-(void)setShowPlaceholder:(NSString *)showPlaceholder{
    
    if (_showPlaceholder != showPlaceholder) {
        _showPlaceholder = showPlaceholder;
        
        _password.placeholder = _showPlaceholder;
        _titlLab.text = _showPlaceholder;
    }
}

-(void)createUI{
    _titlLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 56, 50)];
    //    label.backgroundColor = [UIColor redColor];
    _titlLab.text = @"密码";
    _titlLab.textColor = GrayColor;
    _titlLab.textAlignment = NSTextAlignmentLeft;
    _titlLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titlLab];
    
    _password= [[UITextField alloc]initWithFrame:CGRectMake(_titlLab.right +10, 0,MainScreenWidth -  _titlLab.right -10 -15, 50)];
    _password.placeholder = @"密码";
    _password.textAlignment = NSTextAlignmentRight;
    _password.delegate = self;
//    _password.secureTextEntry = YES;
    _password.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_password];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _titlLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
    
}
@end
