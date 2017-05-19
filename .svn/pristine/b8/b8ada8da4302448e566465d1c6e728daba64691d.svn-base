//
//  QueryViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/9.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryViewController.h"
#import "QueryCell.h"
#import "QueryCell2.h"
#import "QueryCell3.h"
#import "QueryHeaderView.h"
//#import "QueryFooterView.h"
#import "QueryFooterView2.h"
#import "QueryModel.h"
#import "SBJsonWriter.h"
#import "QueryResultViewController.h"
#import "SummaryViewController.h"
#import "QueryNewOrderCell.h"
#import "SYQRCodeViewController.h"

@interface QueryViewController ()<UITableViewDelegate,UITableViewDataSource,QueryCellDelegate,QueryCell2Delegate,QueryCell3Delegate,QuerySumFooterDelegate,QueryNewOrderCellDelegate>{
    
    NSArray *_queryArr;
    NSMutableArray *_cellArr;
    BOOL _isHaveCustomer;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation QueryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单查询";
    self.view.backgroundColor = PaleColor;
//    [self.view setExclusiveTouch:NO];
//    self.view.isMultipleTouchEnabled = NO;

    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    [self loadData];
    
}

-(void)loadData{
    
    NSLog(@"queryOrderState : %d",self.queryOrderState);
    
    /**
      2017.2.27  商户 查询 商户用户名，商户名称 改为员工登录名（LoginName）和真实姓名（DisplayName）
     */
    if (self.queryOrderState == kOrderShop) {
        _queryArr  = @[         @{@"list":@[@{@"Out_trade_no":@"订单号"}
                                            ]
                                  },
                                @{@"list":@[@{@"Time_Start":@"订单开始时间"},
                                            @{@"Time_end":@"订单结束时间"}
                                            ]},
                                @{@"list":@[@{@"LoginName":@"员工登录名"},
                                            @{@"DisplayName":@"真实姓名"}
                                            ]},
                                @{@"list":@[@{@"Pay_Type":@"交易类型"}
                                            ]}
                                
                                ];
    }else{
        _queryArr  = @[         @{@"list":@[@{@"Out_trade_no":@"订单号"}
                                            ]
                                  },
                                @{@"list":@[@{@"Time_Start":@"订单开始时间"},
                                            @{@"Time_end":@"订单结束时间"}
                                            ]},
                                @{@"list":@[@{@"CustomerName":@"商户名称"},
                                            @{@"Customer":@"商户用户名"}
                                            ]},
                                @{@"list":@[@{@"Pay_Type":@"交易类型"}
                                            ]}
                                
                                ];
        
    }

    
    _cellArr = [NSMutableArray new];
    for (NSInteger index =0 ; index<_queryArr.count; index ++) {
      
        QueryModel *queryModel = [[QueryModel alloc]initWithShopDict:_queryArr[index]];
        [_cellArr addObject:queryModel];
    }
    /**
     给个默认时间  。。。
     */
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval dis = [date timeIntervalSince1970];
    NSString *time = [CyTools getYearAndMonthAndDayByTimeInterval:dis];
    
    QueryModel *queryModel =   _cellArr[1];
    for (QueryCellModel *cellModel in queryModel.headCellArray) {
        cellModel.cellText = time;
    }
    if (self.customer.length) {//设置了customer 卡死customer
        QueryModel *queryModel2 =   _cellArr[2];
        QueryCellModel *cellModel  =  queryModel2.headCellArray[1];
        cellModel.cellText = self.customer;
        _isHaveCustomer = YES;
    }
    
    
    [self.table reloadData];

}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[QueryCell class] forCellReuseIdentifier:@"QueryCell"];
        [_table registerClass:[QueryCell2 class] forCellReuseIdentifier:@"QueryCell2"];
        [_table registerClass:[QueryCell3 class] forCellReuseIdentifier:@"QueryCell3"];
        [_table registerClass:[QueryNewOrderCell class] forCellReuseIdentifier:@"QueryNewOrderCell"];


//
        [_table registerClass:[QueryHeaderView class] forHeaderFooterViewReuseIdentifier:@"QueryHeaderView"];
        [_table registerClass:[QueryFooterView2 class] forHeaderFooterViewReuseIdentifier:@"QueryFooterView2"];
//        [_table registerClass:[SubOrderHeaderView class] forHeaderFooterViewReuseIdentifier:@"SubOrderHeaderView"];
        
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = PaleColor;
        //去掉头部留白
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        view.backgroundColor = [UIColor redColor];
        _table.tableHeaderView = view;
        //去掉边线
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.showsVerticalScrollIndicator = YES;
//        _table.showsHorizontalScrollIndicator = YES;
    }
    return _table;
}


#pragma  mark UITableViewDataSource
//组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cellArr.count;
}
//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    QueryModel *queryModel = _cellArr[section];
    return queryModel.headCellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        QueryNewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryNewOrderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QueryModel *queryModel = _cellArr[indexPath.section];
        cell.indexPath = indexPath;
        cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
        cell.delegete = self;
        cell.isLockText = _isHaveCustomer;
        return cell;
    }else if (indexPath.section == 1) {
        QueryCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QueryModel *queryModel = _cellArr[indexPath.section];
        cell.indexPath = indexPath;
        cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
        cell.delegete = self;
        return cell;
    }else if (indexPath.section == _cellArr.count -1) {
        QueryCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell3" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QueryModel *queryModel = _cellArr[indexPath.section];
        cell.indexPath = indexPath;
        cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
        cell.delegete = self;
        return cell;
    }
    else{
        
        QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QueryModel *queryModel = _cellArr[indexPath.section];
        cell.indexPath = indexPath;
        cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
        cell.delegete = self;
        cell.isLockText = _isHaveCustomer;
        return cell;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}

//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == _cellArr.count -1) {
        QueryFooterView2 *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QueryFooterView2"];
        footer.delegete = self;
        return footer;
    }else{
        
        return nil;
    }

    
}

//组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    QueryHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QueryHeaderView"];
    return header;
    
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}
//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 10;
    
}
//组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == _cellArr.count -1) {
//        68 +10
     return 60 + 50 +30 + 68 +10;
    }else{
        
          return 0.0001;
    }
}

#pragma mark QueryNewOrderCellDelegate

-(void)codePost:(NSString *)code{
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    
    
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        NSLog(@"扫码成功");

        NSLog(@"qrString :%@",qrString);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self messWithText:qrString ByIndexPath:indexPath];
        
        [self queryAction];
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
#pragma mark QueryCellDelegate
//订单号 和其他输入 的公用这个 方法了
-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath{
    QueryModel *queryModel =   _cellArr[indexPath.section];
    QueryCellModel *cellModel = queryModel.headCellArray[indexPath.row];
    cellModel.cellText = text;
    [self.table reloadData];
    NSLog(@"text :%@ section :%ld",text,indexPath.section);
    
}
-(void)messWithText2:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath{
    QueryModel *queryModel =   _cellArr[indexPath.section];
    QueryCellModel *cellModel = queryModel.headCellArray[indexPath.row];
    cellModel.cellText = text;
    [self.table reloadData];
    NSLog(@"text :%@ section :%ld",text,indexPath.section);
    
}
-(void)messWithText3:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath{
    QueryModel *queryModel =   _cellArr[indexPath.section];
    QueryCellModel *cellModel = queryModel.headCellArray[indexPath.row];
    cellModel.cellText = text;
    [self.table reloadData];
    NSLog(@"text :%@ section :%ld",text,indexPath.section);
    
}
#pragma mark QueryFooterDelegate
//订单查询
-(void)queryAction{
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];
//    Out_trade_no 订单号
    NSMutableDictionary *parameter = [self getParameter];
    
//    [self showSVP];
    QueryResultViewController *query = [QueryResultViewController  new];
    query.paramters = parameter;
    query.queryState = kQueryOrder;
    query.queryOrderState = self.queryOrderState;
    query.userSysNo = self.userSysNo;
    [self.navigationController pushViewController:query animated:YES];
    

    
}

//汇总
-(void)sumAction{
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];
    //    Out_trade_no 订单号
    NSMutableDictionary *parameter = [self getParameter];
    SummaryViewController *sum =[ SummaryViewController new];
    sum.queryOrderState = self.queryOrderState;
    sum.paramters = parameter;
    sum.userSysNo = self.userSysNo;

    [self.navigationController pushViewController:sum animated:YES];

    
    
}


-(NSMutableDictionary *)getParameter{
    /*
     CustomerName  商户名称
     Customer   商户用户名
     
     Pay_Type 102 :微信； 103 ：支付宝
     Time_end  交易结束时间
     Time_Start  交易开始时间
     
     PagingInfo PageNumber（当前页数索引
     PageSize（每页行数
     */
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    for (NSInteger index = 0; index < _cellArr.count; index++) {
        QueryModel *queryModel = _cellArr[index];
        for (NSInteger index2  = 0; index2 <queryModel.headCellArray.count ; index2++) {
            QueryCellModel *cellModel = queryModel.headCellArray [index2];
            
            /**
             时间 起始时间拼接  00:00:00 23:59:59
             */
            if ([cellModel.titleKey isEqualToString:@"Time_Start"]&& cellModel.cellText.length){
                
                [parameter setObject:[NSString stringWithFormat:@"%@ 00:00:00",cellModel.cellText] forKey:cellModel.titleKey];
                
                
            }else if ([cellModel.titleKey isEqualToString:@"Time_end"]&& cellModel.cellText.length) {
                [parameter setObject:[NSString stringWithFormat:@"%@ 23:59:59",cellModel.cellText] forKey:cellModel.titleKey];
                
            }else{
                
                [parameter setObject:cellModel.cellText forKey:cellModel.titleKey];
                
            }
        }
        
    }
    NSString *cellText = [parameter objectForKey:@"Pay_Type"];
    
    if ([cellText isEqualToString:@"全部"] ||cellText.length == 0 ) {
        NSLog(@"全部");
        [parameter setObject:@"" forKey:@"Pay_Type"];
        
    }else if ([cellText isEqualToString:@"支付宝"]){
        NSLog(@"支付宝");
        [parameter setObject:@"103" forKey:@"Pay_Type"];
        
    }else{
        [parameter setObject:@"102" forKey:@"Pay_Type"];
        
        NSLog(@"微信");
        
    }
    return parameter;
}


@end
