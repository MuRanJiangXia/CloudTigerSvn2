//
//  RateSummaryViewController.m
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RateSummaryViewController.h"
#import "StaffRateSumModel.h"
#import "StaffRateSumListCell.h"
#import "CyanLoadFooterView.h"
#import "RateSummaryDetailVC.h"

@interface RateSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
    NSString *_postUrl;
    NSMutableArray *_cellArr;
    
    BOOL _isMove;

}
@property(nonatomic,strong)UITableView *table;

@end

@implementation RateSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"费率汇总";
    [self.view addSubview:self.table];
    
    self.table.hidden = YES;
    
    /**底部返回首页按钮*/
    [self homeBtnView];
    [self initConfigure];
    
    [self getUrlAndParameters];
    [self postData];
//    NSLog(@"queryOrderState : %d,  paramters:%@",self.queryOrderState,self.paramters);
}

-(void)postData{
    
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    
    
//    
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *json = [writer stringWithObject:self.paramters];
    
    [manager POST:_postUrl parameters:self.paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        _table.footer.hidden = NO;
        self.table.hidden = NO;
        [self endRefreshing];
        
        NSLog(@"responseObject : %@",responseObject);
        
        NSArray *modelArr = responseObject[@"model"];
        
        
        if (!modelArr.count) {
            NSLog(@"没有数据");
            if (_page == 0) {//第一次请求，没有数据提示 查无数据
                [MessageView showMessage:@"查无数据"];
                
            }
            _isMove = YES;
            _table.footer.hidden = YES;
            [self.table reloadData];

        }else{
            if (modelArr.count < 20) {
                _isMove = YES;
                _table.footer.hidden = YES;
            }
            
            for (NSDictionary* dic in modelArr) {
                StaffRateSumModel   *model  = [[StaffRateSumModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                if (IsNilOrNull(model.CustomerName)) {
                if (self.queryOrderState == kOrderShop|| self.queryOrderState == kOrderShopUser||self.queryOrderState == kTopShopRate) {
                        model.CustomerName = dic[@"DisplayName"];
                    }
                }
              
                if (self.queryOrderState == kTopCustomerUserRate ||self.queryOrderState ==kTopShopRate) {//取上级费率 ，上级返佣
                    
                    model.Rate = dic[@"UserRate"];
                    model.Rate_fee = dic[@"UserRate_fee"];
                }
                model.Rate=  [CyTools strByDoubleValue:model.Rate];

                [_cellArr addObject:model];
                
            }
            [self.table reloadData];
            
        }
        
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        
        NSLog(@"error : %@",error);
    }];
    
    
    
}

-(void)getUrlAndParameters{
    
    CyanManager *cyManager = [CyanManager shareSingleTon];
    
    
    NSNumber *number = [NSNumber numberWithInteger:0];
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    [self.paramters setObject:pageDic forKey:@"PagingInfo"];
    /**
     enum QueryOrderState{
     kOrderShop   = 0,//商户订单查询
     kOrderShopUser        =  10,//商户员工订单查询
     kOrderCustomer   = 20 ,//服务商订单查询
     kOrderCustomerUser = 30//服务商员工订单查询
     
     */
    switch (self.queryOrderState ) {//没有服务商
        case kOrderShop:
        {
            
            if (IsNilOrNull(self.userSysNo)) {//商户首页直接进入
                [self.paramters setObject:cyManager.sysNO forKey:@"CustomerSysNo"];
            }else{
                [self.paramters setObject:self.userSysNo forKey:@"CustomerSysNo"];
            }
            
            _postUrl  = [BaseUrl stringByAppendingString:ShopRateSummaryUrl];
        }
            break;
            
        case kOrderShopUser:
        {
            
            if (IsNilOrNull(self.userSysNo)) {//商户员工直接进入
                [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserSysNo"];
                
            }else{
                [self.paramters setObject:self.userSysNo forKey:@"SystemUserSysNo"];
            }
            _postUrl  = [BaseUrl stringByAppendingString:ShopStaffRateSummaryUrl];
            
        }
            break;
            
        case kOrderCustomerUser:
        {
            
            if ([cyManager.isStaff isEqualToString:@"0"]) {//服务商查询 员工 - 查询上级费率
                //服务商主键
                [self.paramters setObject:cyManager.sysNO forKey:@"CustomersTopSysNo"];
                //员工主键
                [self.paramters setObject:self.userSysNo forKey:@"SystemUserTopSysNo"];
                
            }else{
                
                //服务商主键
                [self.paramters setObject:cyManager.shopSysNo forKey:@"CustomersTopSysNo"];
                //员工主键
                [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserTopSysNo"];
            }
            _postUrl = [BaseUrl stringByAppendingString:CustomerUserRateSummaryUrl];
        }
            break;
        case kTopCustomerUserRate://服务商员工 上级费率汇总
        {
            
            if ([cyManager.isStaff isEqualToString:@"0"]) {//服务商查询 员工 - 查询上级费率
                
                //服务商主键
                [self.paramters setObject:cyManager.sysNO forKey:@"CustomersTopSysNo"];
                //员工主键
                [self.paramters setObject:self.userSysNo forKey:@"SystemUserTopSysNo"];
                
            }else{
                
                //服务商主键
                [self.paramters setObject:cyManager.shopSysNo forKey:@"CustomersTopSysNo"];
                //员工主键
                [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserTopSysNo"];
            }
            
            
            _postUrl = [BaseUrl stringByAppendingString:CustomerUserRateSummaryUrl];
        }
            break;
        case kTopShopRate://商户上级费率汇总
        {
            
            if ([cyManager.isStaff isEqualToString:@"1"]) {//服务商员工直接进入
                //员工主键
                [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserTopSysNo"];
                //服务商主键
                [self.paramters setObject:cyManager.shopSysNo forKey:@"CustomersTopSysNo"];
                _postUrl = [BaseUrl stringByAppendingString:CustomerUserRateSummaryUrl];

            }else{//服务商  查员工 查商户 进入
                
                
                if (IsNilOrNull(self.userSysNo)) {//商户首页直接进入
                    [self.paramters setObject:cyManager.sysNO forKey:@"CustomerSysNo"];
                    _postUrl  = [BaseUrl stringByAppendingString:ShopRateSummaryUrl];

                }else{
                    //员工主键
                    [self.paramters setObject:self.userSysNo forKey:@"SystemUserTopSysNo"];
                    //服务商主键
                    [self.paramters setObject:cyManager.sysNO forKey:@"CustomersTopSysNo"];
                    _postUrl = [BaseUrl stringByAppendingString:CustomerUserRateSummaryUrl];

                }
                
   
                
            }
    
        }
            break;
            
            
        default:
            break;
    }

    
    _cellArr  =[ NSMutableArray new];
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        [_table registerClass:[StaffRateSumListCell class] forCellReuseIdentifier:@"StaffRateSumListCell"];
        [_table registerClass:[CyanLoadFooterView class] forHeaderFooterViewReuseIdentifier:@"CyanLoadFooterView"];
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

-(void)initConfigure{
    [self.table  addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.footer  setTitle:@"加载更多" forState:MJRefreshFooterStateIdle];
    [self.table.footer  setTitle:@"暂无更多数据" forState:MJRefreshFooterStateNoMoreData];
    
    
    [self.table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reloadDATA)];
    [self.table.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    _page = 0;
    _cellArr = [NSMutableArray new];
}
#pragma mark ---  加载更多
-(void)loadMoreData{
    _page ++;
    NSNumber *number = [NSNumber numberWithInteger:_page];
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    //    NSDictionary *pageDic = [NSDictionary new];
    
    
    [self.paramters setObject:pageDic forKey:@"PagingInfo"];
    
    //    if (_page >5) {
    //
    //        _table.footer.state = MJRefreshFooterStateNoMoreData;
    //
    //
    //        return;
    //    }
    //
    
    
    [self postData];
    
}
-(void)endRefreshing{
    
    [self.table.footer endRefreshing];
    [self.table.header endRefreshing];
}

/**
 下拉头刷新
 */
-(void)reloadDATA{
    _page = 0;
    _cellArr = [NSMutableArray new];
    _isMove = NO;
    _table.footer.hidden = YES;
    [self.table reloadData];
    
    NSNumber *number = [NSNumber numberWithInteger:0];
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    
    
    
    [self.paramters setObject:pageDic forKey:@"PagingInfo"];
    NSLog(@"下拉刷新");
    //    [self endRefreshing];
    
    [self postData];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StaffRateSumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaffRateSumListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.querySumModel = _cellArr[indexPath.row];
    //    staff_list
    cell.imageV.image = [UIImage imageNamed:@"staff_list"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RateSummaryDetailVC *sumDetail = [[RateSummaryDetailVC alloc]init];
    StaffRateSumModel  *model = _cellArr[indexPath.row];
    sumDetail.queryOrderState = self.queryOrderState;
    sumDetail.queryModel = model;
    [self.navigationController pushViewController:sumDetail animated:YES];
}
////组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        if (_isMove) {
            CyanLoadFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CyanLoadFooterView"];
            //    footer.delegete = self;
            return footer;
        }
    return nil;
    
}
////组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
        if (_isMove) {
            return 118;
        }
    return 0.01;
    
}


@end
