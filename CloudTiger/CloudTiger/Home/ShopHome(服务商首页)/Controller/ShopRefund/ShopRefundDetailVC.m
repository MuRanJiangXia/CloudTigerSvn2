//
//  ShopRefundDetailVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopRefundDetailVC.h"
#import "QueryOrderCell.h"
#import "CyanLoadFooterView2.h"

@interface ShopRefundDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *_titleArr;
    NSArray *_contArr;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation ShopRefundDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款查询详情";
    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    [self loadData];
}

-(void)loadData{
    
//    登录名称	真实姓名	原订单号	商户名称	交易类型	交易金额	退款金额	交易币种	交易时间	退款时间
    
    _titleArr = @[@"登录名称",@"真实姓名",@"原订单号",@"商户名称",@"交易类型",@"交易金额",@"退款金额",@"交易币种",@"交易时间",@"退款时间"];
    _contArr =    [self.shopRefundModel allPropertyNames];
    [self.table reloadData];
    
    
}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[QueryOrderCell class] forCellReuseIdentifier:@"QueryOrderCell"];
        [_table registerClass:[CyanLoadFooterView2 class] forHeaderFooterViewReuseIdentifier:@"CyanLoadFooterView2"];
        
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = PaleColor;
        //去掉头部留白
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        view.backgroundColor = [UIColor redColor];
        _table.tableHeaderView = view;
        //去掉边线
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _table;
}

#pragma mark  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QueryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.firstLab.text = _titleArr[indexPath.row];
    
    NSString *context = [self.shopRefundModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
    
    //设置 可以复制
    cell.contLab.isCopy = YES;
    
    if ([_titleArr[indexPath.row] isEqualToString:@"交易金额"]||[_titleArr[indexPath.row] isEqualToString:@"退款金额"]) {
        
        NSString *money =  [CyTools  folatByStr:context];
        cell.contLab.text = money ;
        
    }else if ([_titleArr[indexPath.row] isEqualToString:@"交易类型"]){
        if ([context isEqualToString:@"102"]) {
            cell.contLab.text =  @"微信";
        }
        else if ([context isEqualToString:@"103"]){
            //        wft_wx aliPay
            cell.contLab.text =  @"支付宝";
        }
        else{
            //
            cell.contLab.text =  @"威富通(微信)";
        }
        
        
    }else{
        cell.contLab.text = [NSString stringWithFormat:@"%@", context];
        
    }
    //    cell.resultModel = self.queryModel;
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


////组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CyanLoadFooterView2 *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CyanLoadFooterView2"];
    return footer;

    
}
////组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
  return 68 + 10;
}

@end
