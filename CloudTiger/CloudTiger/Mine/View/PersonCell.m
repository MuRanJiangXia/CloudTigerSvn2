//
//  PersonCell.m
//  CloudTiger
//
//  Created by cyan on 16/10/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "PersonCell.h"
@interface PersonCell ()<UITextFieldDelegate>{
    UILabel *titleLab;
    UITextField *cellTextField;
    CyanManager *_cyanManager;

}
@end


@implementation PersonCell


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
    
    if (_passWordModel != passWordModel) {
        _passWordModel = passWordModel;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _cyanManager = [CyanManager shareSingleTon];
    switch (self.indexPath.row) {//用户名、用户身份 ，不可编辑
        case 0:
        {
            
            cellTextField.userInteractionEnabled = NO;
            cellTextField.textColor = GrayColor;
            cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
            
        case 1:
        {
            cellTextField.userInteractionEnabled = NO;
            cellTextField.textColor = GrayColor;
            cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
            
        case 2://联系电话
        {
            cellTextField.keyboardType = UIKeyboardTypeNumberPad;
            cellTextField.userInteractionEnabled = NO;
            cellTextField.textColor = GrayColor;
        }
            break;
            
        case 3://真实姓名
        {
            cellTextField.keyboardType = UIKeyboardTypeDefault;
            cellTextField.userInteractionEnabled = YES;
            cellTextField.textColor = [UIColor blackColor];
        }
            break;
            
        case 4://邮箱
        {
            cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
            cellTextField.userInteractionEnabled = YES;
            cellTextField.textColor = [UIColor blackColor];
        }
            break;
            
        case 5://名店 id
        {
            cellTextField.keyboardType = UIKeyboardTypeNumberPad;
            cellTextField.userInteractionEnabled = YES;
            cellTextField.textColor = [UIColor blackColor];
        }
            break;
            
        case 6://省市区
        {
            cellTextField.keyboardType = UIKeyboardTypeNumberPad;
            cellTextField.userInteractionEnabled = YES;
            cellTextField.textColor = [UIColor blackColor];
        }
            break;
            
        case 7://详细地址
        {
            cellTextField.keyboardType = UIKeyboardTypeDefault;
            cellTextField.userInteractionEnabled = YES;
            cellTextField.textColor = [UIColor blackColor];
        }
            break;
            
        case 8://费率
        {
            cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
            cellTextField.userInteractionEnabled = YES;
    
            /** 2017.3.7  商户费率不可修改*/
            if ([_cyanManager.isStaff  isEqualToString:@"1"]) {
                cellTextField.userInteractionEnabled = YES;
                cellTextField.textColor = [UIColor blackColor];
            }else{
                cellTextField.userInteractionEnabled = NO;
                cellTextField.textColor = GrayColor;
                
            }
         

        }
            break;
            
        default:
            break;
    }

    titleLab.text = _passWordModel.title;
    cellTextField.text = _passWordModel.cellText;
    cellTextField.placeholder = _passWordModel.title;

    //
    //    CGFloat width =   [CyTools getWidthWithContent:titleLab.text height:60 font:14];
    //    titleLab.width = width;
    //    cellTextField.frame =CGRectMake(titleLab.right + 10 , 0,MainScreenWidth - titleLab.right -15 -10 , 60);
}

-(void)createUI{
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.6 *4, 60)];
//        titleLab.backgroundColor = [UIColor redColor];
    titleLab.text = @"订单号";
    titleLab.textColor = GrayColor;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLab];
    
    cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab.right  , 0, MainScreenWidth - 15 -10 -titleLab.right , 60)];
    cellTextField.placeholder = @"输入。。";
    //    [cellTextField setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
    [cellTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    //        cellTextField.backgroundColor = [UIColor cyanColor];
    cellTextField.textColor = [UIColor blackColor];
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.delegate = self;
    cellTextField.textAlignment = NSTextAlignmentRight;

    [self.contentView addSubview:cellTextField];
    
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
        [self.delegete messWithText:cellTextField.text ByIndexPath:self.indexPath];
    }
    return YES;
    
}

@end
