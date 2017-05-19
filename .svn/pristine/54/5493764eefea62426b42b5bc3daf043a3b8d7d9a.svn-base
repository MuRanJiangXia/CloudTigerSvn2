//
//  PositionViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "PositionViewController.h"
#import "QueryCell.h"
#import "QueryCell2.h"
#import "QueryCell3.h"
#import "QueryNewOrderCell.h"
#import "QueryHeaderView.h"
#import "QueryFooterView.h"
#import "QueryModel.h"
#import "SBJsonWriter.h"
#import "StaffListViewController.h"
#import "ShopListViewController.h"
#import "RefundResultViewController.h"
#import "SYQRCodeViewController.h"
@interface PositionViewController ()<UITableViewDelegate,UITableViewDataSource,QueryCellDelegate,QueryFooterDelegate,QueryNewOrderCellDelegate,QueryCell2Delegate>{
    
    NSArray *_queryArr;
    NSMutableArray *_cellArr;
    CyanManager  *_cyanManager ;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation PositionViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark  员工查询  退款 商户查询  公用了
    _cyanManager  = [CyanManager shareSingleTon];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    if ([_cyanManager.isStaff isEqualToString:@"1"]&&[_cyanManager.customersType isEqualToString:@"1"]) {//退款
        
        [self loadRefunData];
        
        
    }else{
        
           [self loadData];
    }

}
-(void)loadRefunData{
    self.title = @"退款";

    _queryArr  = @[         @{@"list":@[@{@"Out_trade_no":@"订单号"}
                                        ]
                              },
                            @{@"list":@[@{@"Time_Start":@"订单开始时间"},
                                        @{@"Time_end":@"订单结束时间"}
                                        ]}
                            
                            ];
    
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
    
    [self.table reloadData];
    
}

-(void)loadData{
 
    if ([_cyanManager.isStaff isEqualToString:@"1"]) {
        
        self.title = @"商户查询";
        _queryArr  = @[         @{@"list":@[ @{@"Customer":@"商户用户名"},//登录账号
                                             @{@"CustomerName":@"商户名称"}//昵称
                                             
                                             ]
                                  }
                                
                                ];
        
        
        
    }else{//非员工 是员工查询
        self.title = @"员工列表";
        _queryArr  = @[         @{@"list":@[@{@"LoginName":@"登录名"},
                                            @{@"PhoneNumber":@"电话"}
                                            
                                            ]
                                  }
                                
                                ];
        
    }

    
    _cellArr = [NSMutableArray new];
    for (NSInteger index =0 ; index<_queryArr.count; index ++) {
        
        QueryModel *queryModel = [[QueryModel alloc]initWithShopDict:_queryArr[index]];
        [_cellArr addObject:queryModel];
    }
    
    [self.table reloadData];
    
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -44) style:UITableViewStyleGrouped];
        
        [_table registerClass:[QueryCell class] forCellReuseIdentifier:@"QueryCell"];
        [_table registerClass:[QueryCell2 class] forCellReuseIdentifier:@"QueryCell2"];
        [_table registerClass:[QueryCell3 class] forCellReuseIdentifier:@"QueryCell3"];
        
        [_table registerClass:[QueryNewOrderCell class] forCellReuseIdentifier:@"QueryNewOrderCell"];

        
        //
        [_table registerClass:[QueryHeaderView class] forHeaderFooterViewReuseIdentifier:@"QueryHeaderView"];
        [_table registerClass:[QueryFooterView class] forHeaderFooterViewReuseIdentifier:@"QueryFooterView"];
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
        if ([_cyanManager.isStaff isEqualToString:@"1"]&&[_cyanManager.customersType isEqualToString:@"1"]) {//退款
            
            if (indexPath.section == 0) {
                
                QueryNewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryNewOrderCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                QueryModel *queryModel = _cellArr[indexPath.section];
                cell.indexPath = indexPath;
                cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
                cell.delegete = self;
                //        cell.isLockText = _isHaveCustomer;
                return cell;
                
            }
            else{
                QueryCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell2" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                QueryModel *queryModel = _cellArr[indexPath.section];
                cell.indexPath = indexPath;
                cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
                cell.delegete = self;
                return cell;
                
            }
        
        }else{
            QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            QueryModel *queryModel = _cellArr[indexPath.section];
            cell.indexPath = indexPath;
            cell.queryCellmodel = queryModel.headCellArray [indexPath.row];
            cell.delegete = self;
            //        cell.isLockText = YES;
            return cell;
            
        }
    

    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == _cellArr.count -1) {
        QueryFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QueryFooterView"];
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
        return 60;
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
        
//        [self queryAction];
        [self queryRefundAction];

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
-(void)queryAction{
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];
    //
    /*
     LoginName  商户名称
     PhoneNumber  商户用户名
     
     CustomerServiceSysNo  服务商,商户主键
     
     PagingInfo PageNumber（当前页数索引
     PageSize（每页行数
     */
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    for (NSInteger index = 0; index < _cellArr.count; index++) {
        QueryModel *queryModel = _cellArr[index];
        for (NSInteger index2  = 0; index2 <queryModel.headCellArray.count ; index2++) {
            QueryCellModel *cellModel = queryModel.headCellArray [index2];
            [parameter setObject:cellModel.cellText forKey:cellModel.titleKey];
        }
        
    }
    
    CyanManager  *manager = [CyanManager shareSingleTon];
    NSLog(@"sysNO : %@",manager.sysNO);
    
    if ([manager.isStaff isEqualToString:@"1"]) {
        if ([manager.customersType isEqualToString:@"1"]) {//商户下员工 查退款
            if ([_cyanManager.powers indexOfObject:CyanRefund] == NSNotFound) {
                //没有该权限
                [MessageView showMessage:@"该用户没有退款权限"];
                return;
                
            }
            
            
           [self queryRefundAction];
        }else{//服务商员工 查商户
            if ([_cyanManager.powers indexOfObject:CyanShopQuery] == NSNotFound) {
                //没有该权限
                [MessageView showMessage:@"该用户没有商户查询权限"];
                return;
                
            }
        
            ShopListViewController *shopList = [ShopListViewController new];
            shopList.hidesBottomBarWhenPushed = YES;
            shopList.paramters = parameter;
            shopList.shopState = kShopListOfStaff;
            //        shopList.shopState = self.shopState;
            //        shopList.staffSysNo = self.staffSysNo;
            [self.navigationController pushViewController:shopList animated:YES];
        }

        
        
    }else{//商户  服务商 查员工
        if ([_cyanManager.customersType isEqualToString:@"1"]) {//商户的时候判断 是否有 员工列表的权限
            
            if ([_cyanManager.powers indexOfObject:CyanStaffList] == NSNotFound) {
                //没有该权限
                [MessageView showMessage:@"该用户没有员工查询权限"];
                return;
                
            }
            
        }
 
        StaffListViewController *query = [StaffListViewController  new];
        query.hidesBottomBarWhenPushed = YES;
        query.paramters = parameter;
        query.staffState = self.staffState;
        [self.navigationController pushViewController:query animated:YES];
        
    }

    
    
    
}

-(void)queryRefundAction{
    
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];

    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    for (NSInteger index = 0; index < _cellArr.count; index++) {
        QueryModel *queryModel = _cellArr[index];
        for (NSInteger index2  = 0; index2 <queryModel.headCellArray.count ; index2++) {
            QueryCellModel *cellModel = queryModel.headCellArray [index2];
            
            /**
             时间 起始时间拼接  00:00:00 23:59:59
             */
            if ([cellModel.titleKey isEqualToString:@"Time_Start"]) {
                if (cellModel.cellText.length) {//空的时候不拼接
                    [parameter setObject:[NSString stringWithFormat:@"%@ 00:00:00",cellModel.cellText] forKey:cellModel.titleKey];
                }
                
                
            }
            else if ([cellModel.titleKey isEqualToString:@"Time_end"]) {
                if (cellModel.cellText.length) {
                    [parameter setObject:[NSString stringWithFormat:@"%@ 23:59:59",cellModel.cellText] forKey:cellModel.titleKey];
                }
                
                
            }else{
                
                [parameter setObject:cellModel.cellText forKey:cellModel.titleKey];
                
            }
        }
        
    }

    RefundResultViewController *query = [RefundResultViewController  new];
    query.hidesBottomBarWhenPushed = YES;
    query.paramters = parameter;
    query.queryState = kQueryRefund;
    [self.navigationController pushViewController:query animated:YES];
    
}
@end
