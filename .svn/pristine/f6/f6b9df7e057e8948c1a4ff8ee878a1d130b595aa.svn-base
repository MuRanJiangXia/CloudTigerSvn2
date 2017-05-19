//
//  BaseOperationCell.m
//  CloudTiger
//
//  Created by cyan on 16/12/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "BaseOperationCell.h"

@implementation BaseOperationCell{
    
    UILabel *showLab;
}


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


-(void)setQueryOrderState:(enum QueryOrderState)queryOrderState{
    
    if (_queryOrderState != queryOrderState) {
        _queryOrderState = queryOrderState;
        
        switch (self.queryOrderState) {
                
                //               kOriginalOrder
                
            case kOriginalOrder://上一版本 订单查询
            {
                
                [_operationBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 86 -15 , 10,86, 30);
                
                
            }
                break;
            case kOrderShop://商户费率
            {
                [_operationBtn setTitle:@"商户费率订单" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
                
            }
              break;

                
            case kQueryShop://商户查询
            {
                
                [_operationBtn setTitle:@"查看商户" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 86 -15 , 10,86, 30);
                
            }
                break;
            case kOrderCustomerUser://服务商员工费率
            {
                [_operationBtn setTitle:@"费率订单查询" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
                
            }
                break;
                
            case   kOrderShopUser://商户员工费率
            {
                [_operationBtn setTitle:@"员工费率订单" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
                
            }
                break;
                
                
            case kTopCustomerUserRate://服务商上级员工费率查询
            {
                [_operationBtn setTitle:@"上级费率订单" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
                
            }
            break;
            case kTopShopRate://商户费率
            {
                
                [_operationBtn setTitle:@"上级费率订单" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
                
            }
                break;
                
            case kRegisterShop://商户注册
            {
                [_operationBtn setTitle:@"商户注册" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 86 -15 , 10,86, 30);
                
            }
                break;
                
            case kAssignStaff://服务商调拨员工
            {
                [_operationBtn setTitle:@"调拨" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 50 -15 , 10,50, 30);
                
            }
                break;
            case kChangeShopPower://商户权限修改
            {
                [_operationBtn setTitle:@"权限分配" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 86 -15 , 10,86, 30);
                
            }
                break;
                
            case kChangeStaffPower://员工权限修改
            {
                [_operationBtn setTitle:@"权限分配" forState:UIControlStateNormal];
                _operationBtn.frame = CGRectMake(MainScreenWidth - 86 -15 , 10,86, 30);
                
            }
                break;
                
                
            default:
                break;
        }
    }
    showLab.text =  _operationBtn.titleLabel.text;

    //      _queryOrderState = queryOrderState;
    
    
    
}

-(void)createUI{
    
    
    showLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.5 *6, 50)];
    //    label.backgroundColor = [UIColor redColor];
    showLab.text = @"操作";
    showLab.textColor = GrayColor;
    showLab.textAlignment = NSTextAlignmentLeft;
    showLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:showLab];
    
    
    //    NSLog(@"queryOrderState : %d",self.queryOrderState);
    //18 字体大小默认 左右间距 7
    _operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _operationBtn.frame = CGRectMake(MainScreenWidth - 122 -15 , 10,122, 30);
    _operationBtn.backgroundColor = BlueColor;
    [_operationBtn setTitle:@"修改上级费率" forState:UIControlStateNormal];
    [_operationBtn addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_operationBtn];
    
    //    NSLog(@"%@",button.titleLabel.font);
    
    _operationBtn.layer.cornerRadius = 5;
    _operationBtn.layer.masksToBounds = YES;
    //    button.layer.borderColor = [UIColor blueColor].CGColor;
    //    button.layer.borderWidth = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, showLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}


-(void)refundAction:(UIButton *)btn{
    if ([self.delegete respondsToSelector:@selector(jumpOperationBy:)]) {
        [self.delegete jumpOperationBy:self.queryOrderState];
    }
    
}


@end
