//
//  RegisterShopCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RegisterShopCell.h"
@interface RegisterShopCell ()<UITextFieldDelegate>{
    UILabel *titleLab;

}

@end
@implementation RegisterShopCell

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

-(void)setPassWordModel:(PassWordModel *)passWordModel{
    
//    if (_passWordModel != passWordModel) {
//  
//    }
    
    
    _passWordModel = passWordModel;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
#warning 设置不可编辑  属性
    switch (self.indexPath.row) {
        case 0://用户名
        {
            _cellTextField.keyboardType = UIKeyboardTypeNumberPad;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

        }
            break;
            
        case 1://密码
        {
            _cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = YES;
            _cellTextField.userInteractionEnabled = YES;

        }
            break;
            
        case 2://重复密码
        {
            _cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = YES;
            _cellTextField.userInteractionEnabled = YES;

        }
            break;
            
        case 3://门店名称真实姓名
        {
            _cellTextField.keyboardType = UIKeyboardTypeDefault;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

            
        }
            break;
            
            
        case 4://邮箱
        {
            _cellTextField.keyboardType =   UIKeyboardTypeASCIICapable;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

            
        }
            break;
        case 5://联系电话 不可编辑 同用户名
        {
            
            _cellTextField.userInteractionEnabled = NO;
            _cellTextField.textColor = GrayColor;
            _cellTextField.secureTextEntry = NO;
            
        }
            break;
            
        case 6://员工ID 不可编辑
        {
            
            _cellTextField.userInteractionEnabled = NO;
            _cellTextField.textColor = GrayColor;
            _cellTextField.secureTextEntry = NO;

            
        }
            break;
        case 7://费率
        {
            
            _cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

            
        }
            break;
        case 8://邮编
        {
            
            _cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

            
        }
            break;
            
        case 10://详细地址
        {
            
            _cellTextField.keyboardType = UIKeyboardTypeDefault;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

            
        }
            break;
            
            
        case 11://传真
        {
            _cellTextField.keyboardType = UIKeyboardTypeNumberPad;
            _cellTextField.textColor  = [UIColor blackColor];
            _cellTextField.secureTextEntry = NO;
            _cellTextField.userInteractionEnabled = YES;

            
        }
            break;
            
        default:
            break;
    }
    
    titleLab.text = _passWordModel.title;
    _cellTextField.placeholder = _passWordModel.title;
    _cellTextField.text = _passWordModel.cellText;

}

-(void)createUI{
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.6*4, 60)];
    //        titleLab.backgroundColor = [UIColor redColor];
    titleLab.text = @"订单号";
    titleLab.textColor = GrayColor;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLab];
    
    _cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab.right  , 0, MainScreenWidth - 15 -10 -titleLab.right , 60)];
    _cellTextField.placeholder = @"输入。。";
    //    [cellTextField setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
    [_cellTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    //        cellTextField.backgroundColor = [UIColor cyanColor];
    _cellTextField.textColor = [UIColor blackColor];
    _cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cellTextField.delegate = self;
    _cellTextField.textAlignment = NSTextAlignmentRight;
    _cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    // UITextField关闭系统自动联想和首字母大写功能
    [_cellTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_cellTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    
    [self.contentView addSubview:_cellTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom -1, MainScreenWidth, 1)];
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
    if ([self.delegete respondsToSelector:@selector(messWithText:ByIndexPath:)]) {
        [self.delegete messWithText:_cellTextField.text ByIndexPath:self.indexPath];
    }
    return YES;
    
}

@end
