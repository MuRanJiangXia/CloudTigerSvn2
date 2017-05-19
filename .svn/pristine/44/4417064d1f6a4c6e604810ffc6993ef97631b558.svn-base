//
//  StaffSumDetailViewController.m
//  CloudTiger
//
//  Created by cyan on 16/12/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffSumDetailViewController.h"
#import "QueryOrderCell.h"

@interface StaffSumDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *_titleArr;
    NSArray *_contArr;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation StaffSumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"服务商员工汇总详情";
    
    self.view.backgroundColor = PaleColor;
    
    [self.view addSubview:self.table];
    
    /**底部返回首页按钮*/
    [self homeBtnView];
    
    [self loadData];

}

-(void)loadData{
    //    /**订单号*/
    //    @property(nonatomic,copy)NSString *Out_trade_no;
    //    /**金额*/
    //    @property(nonatomic,copy)NSString *Total_fee;
    //    /**支付类型*/
    //    @property(nonatomic,copy)NSString *Pay_Type;
    //    /**交易时间*/
    //    @property(nonatomic,copy)NSString *Time_Start;
    //    ///**订单状态*/
    //    //@property(nonatomic,copy)NSString *Status;
    
    //员工登陆名	真实姓名	电话	 交易金额	 退款金额 实际金额

    _titleArr = @[@"员工登陆名",@"真实姓名",@"电话",@"交易金额",@"退款金额",@"实际金额"];
    _contArr =    [self.staffSumModel allPropertyNames];
    
    
    
    
    [self.table reloadData];
    
    
}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStylePlain];
        
        [_table registerClass:[QueryOrderCell class] forCellReuseIdentifier:@"QueryOrderCell"];
        
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
    
    NSString *context = [self.staffSumModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
    
    //设置 可以复制
    cell.contLab.isCopy = YES;
//    退款金额 实际金额
    if ([_titleArr[indexPath.row] isEqualToString:@"交易金额"]||[_titleArr[indexPath.row] isEqualToString:@"退款金额"]||[_titleArr[indexPath.row] isEqualToString:@"实际金额"]) {
        
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
        
        
    }
    
    else{
        cell.contLab.text = [NSString stringWithFormat:@"%@",context];
        
        
    }
    
    
    //    cell.resultModel = self.queryModel;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

@end
