//
//  ShopRateDetailVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryRateDetailVC.h"
#import "QueryOrderCell.h"
@interface QueryRateDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titleArr;
    NSArray *_contArr;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation QueryRateDetailVC

-(void)dealloc{
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易费率订单详情";
    
//    NSLog(@"SysNo : %@",self.queryModel.SysNo);
    
    self.view.backgroundColor = PaleColor;
    
    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    
    [self loadData];
}
-(void)loadData{
    
    CyanManager *cyanManager  = [CyanManager shareSingleTon];
    _titleArr = @[@"序号",@"商户名称",@"登陆名",@"真实姓名",@"订单号",@"交易金额",@"员工费率",@"返佣",@"交易类型",@"交易币种",@"交易时间"];
    _contArr =    [self.queryModel allPropertyNames];
    NSMutableArray *mutabArr = [NSMutableArray array];
    //序号	商户名称	订单号	交易金额	商户费率	返佣	 支付类型	 交易币种	交易时间
    
    
    if ([cyanManager.customersType isEqualToString:@"0"]) {
        if (self.queryOrderState == kTopCustomerUserRate||self.queryOrderState == kTopShopRate) {
        _titleArr = @[@"序号",@"商户名称",@"订单号",@"交易金额",@"上级费率",@"返佣",@"交易类型",@"交易币种",@"交易时间"];
            
        }else{
            
            _titleArr = @[@"序号",@"商户名称",@"订单号",@"交易金额",@"商户费率",@"返佣",@"交易类型",@"交易币种",@"交易时间"];
            
        }
        
        for (NSInteger index = 0; index < _contArr.count; index ++ ) {
            if (index == 2||index ==3) {//没有 @"登陆名",@"真实姓名"
                
            }else{
                [mutabArr addObject:_contArr[index]];
            }
            
        }
        _contArr = [mutabArr copy];
        
    }else{
        
        if ([cyanManager.isStaff isEqualToString:@"1"]) {//
        _titleArr = @[@"序号",@"商户名称",@"订单号",@"交易金额",@"员工费率",@"交易类型",@"交易币种",@"交易时间"];
            for (NSInteger index = 0; index < _contArr.count; index ++ ) {
                if (index == 2||index ==3||index == 7) {//没有 @"登陆名",@"真实姓名" @“返佣”
                    
                }else{
                    [mutabArr addObject:_contArr[index]];
                }
                
            }
            _contArr = [mutabArr copy];
            
        }else{
            
            if (self.queryOrderState == kOrderShopUser ) {
                
            _titleArr = @[@"序号",@"商户名称",@"登陆名",@"真实姓名",@"订单号",@"交易金额",@"员工费率",@"交易类型",@"交易币种",@"交易时间"];
            }else{
                
            _titleArr = @[@"序号",@"商户名称",@"登陆名",@"真实姓名",@"订单号",@"交易金额",@"商户费率",@"交易类型",@"交易币种",@"交易时间"];
            }
            
            for (NSInteger index = 0; index < _contArr.count; index ++ ) {
                if (index == 7) {//没有  @“返佣”
                    
                }else{
                    [mutabArr addObject:_contArr[index]];
                }
                
            }
            _contArr = [mutabArr copy];
            
            
        }
        
    }
    
    
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
    
    NSString *context = [self.queryModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
    
    //设置 可以复制
    cell.contLab.isCopy = YES;
   
    if ([_titleArr[indexPath.row] isEqualToString:@"交易金额"]||[_titleArr[indexPath.row] isEqualToString:@"返佣"]) {
        
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
        cell.contLab.text = [NSString stringWithFormat:@"%@",context] ;
        
        
    }
    
    
    //    cell.resultModel = self.queryModel;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


@end
