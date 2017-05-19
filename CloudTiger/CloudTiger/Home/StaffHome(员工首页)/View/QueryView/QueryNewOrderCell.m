//
//  QueryNewOrderCell.m
//  CloudTiger
//
//  Created by cyan on 16/10/15.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryNewOrderCell.h"
@interface QueryNewOrderCell()<UITextFieldDelegate>{
    UILabel *titleLab;
    UITextField *cellTextField;
}

@end
@implementation QueryNewOrderCell

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
-(void)setQueryCellmodel:(QueryCellModel *)queryCellmodel{
    
    if (_queryCellmodel != queryCellmodel) {
        _queryCellmodel = queryCellmodel;
        [self setNeedsLayout];
        
        
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
#warning 加个判断 锁死不能 修改text
    if (   [_queryCellmodel.titleKey isEqualToString:@"Customer"]) {
        
        /**
         9.29 修改颜色  锁死颜色为灰色
         */
        if (self.isLockText) {
            cellTextField.userInteractionEnabled = NO;
            cellTextField.textColor = GrayColor;
        }else{
            cellTextField.userInteractionEnabled = YES;
            cellTextField.textColor = [UIColor blackColor];
            
        }
        
    }else{
        //         cellTextField.text = _queryCellmodel.cellText;
    }
    cellTextField.text = _queryCellmodel.cellText;
    cellTextField.placeholder = _queryCellmodel.title;
    titleLab.text = _queryCellmodel.title;
//    CGFloat width =   [CyTools getWidthWithContent:titleLab.text height:60 font:14];
//    titleLab.width = width;
//    cellTextField.frame =CGRectMake(titleLab.right + 10 , 0,MainScreenWidth - titleLab.right -15 -10 , 60);
    
}


-(void)createUI{
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 45, 60)];
    //    titleLab.backgroundColor = [UIColor redColor];
    titleLab.text = @"订单号";
    titleLab.textColor = GrayColor;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLab];
    
    cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab.right  , 0, MainScreenWidth - 15 - titleLab.right -60 -5, 60)];
    cellTextField.placeholder = @"输入。。";
    //    [cellTextField setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
    [cellTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//        cellTextField.backgroundColor = [UIColor cyanColor];
    cellTextField.textColor = [UIColor blackColor];
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.delegate = self;
    cellTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:cellTextField];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(MainScreenWidth - 15 -40 , 10, 40, 40);
//    button.backgroundColor = [UIColor redColor];
    
    [button setBackgroundImage:[UIImage imageNamed:@"code_order_btn"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
    
}

-(void)codeAction:(UIButton *)btn{
    
    NSLog(@"扫码");
    if ([self.delegete respondsToSelector:@selector(codePost:)]) {
        [self.delegete codePost:@""];
    }
    
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
