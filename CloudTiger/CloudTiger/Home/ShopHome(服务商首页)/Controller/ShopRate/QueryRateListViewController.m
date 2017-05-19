//
//  ShopRateListViewController.m
//  CloudTiger
//
//  Created by cyan on 16/12/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryRateListViewController.h"
#import "QueryRateListCell.h"
#import "QueryRefundNewCell.h"
#import "CyanLoadFooterView.h"
#import "QueryRateListCell.h"
#import "ShopRateModel.h"
#import "QueryRateDetailVC.h"


@interface QueryRateListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_queryResultArr;

    NSInteger _page;
    NSString *_url;
    BOOL _isMove;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation QueryRateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易费率订单查询";
    [self.view addSubview:self.table];
    self.table.hidden = YES;

    /**底部返回首页按钮*/
    [self homeBtnView];
    
    [self initConfigure];
    [self getUrlAndParameters];
    [self postData];

}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[QueryRateListCell class] forCellReuseIdentifier:@"QueryRateListCell"];
        [_table registerClass:[QueryRefundNewCell class] forCellReuseIdentifier:@"QueryRefundNewCell"];
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
    _queryResultArr = [NSMutableArray new];
}

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
    _queryResultArr = [NSMutableArray new];
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
-(void)getUrlAndParameters{
    
    NSNumber *number = [NSNumber numberWithInteger:_page];
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    //    NSDictionary *pageDic = [NSDictionary new];
    
    
    [self.paramters setObject:pageDic forKey:@"PagingInfo"];
    /**
     enum QueryOrderState{
     kOrderShop   = 0,//商户订单查询
     kOrderShopUser        =  10,//商户员工订单查询
     kOrderCustomer   = 20 ,//服务商订单查询
     kOrderCustomerUser = 30//服务商员工订单查询
     
     */
    
    CyanManager *cyManager = [CyanManager shareSingleTon];
    switch (self.queryOrderState ) {//没有服务商
        case kOrderShop:
        {
            
            if (IsNilOrNull(self.userSysNo)) {//商户首页直接进入
                   [self.paramters setObject:cyManager.sysNO forKey:@"CustomerSysNo"];
            }else{
                   [self.paramters setObject:self.userSysNo forKey:@"CustomerSysNo"];
            }

           _url  = [BaseUrl stringByAppendingString:ShopRateQueryUrl];
        }
        break;
            
        case kOrderShopUser:
        {
            
            if (IsNilOrNull(self.userSysNo)) {//商户员工直接进入
                [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserSysNo"];

            }else{
                [self.paramters setObject:self.userSysNo forKey:@"SystemUserSysNo"];

                
            }
             _url  = [BaseUrl stringByAppendingString:ShopStaffRateQueryUrl];

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
            _url = [BaseUrl stringByAppendingString:QueryRateCustomerUserUrl];
        }
            break;
            
            
        case kTopCustomerUserRate: //上级费率
        {
            
//            UserRate = "0.012"; 上级费率
//            "UserRate_fee" = 0; 上级费率 返佣
            
            
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
            
    
            _url = [BaseUrl stringByAppendingString:QueryRateCustomerUserUrl];
        }
            break;
            
        case kTopShopRate: //商户 上级费率
        {
            //            UserRate = "0.012"; 上级费率
            //            "UserRate_fee" = 0; 上级费率 返佣
        
            if ([cyManager.isStaff isEqualToString:@"1"]) {//服务商员工直接进入
                //员工主键
                [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserTopSysNo"];
                //服务商主键
                [self.paramters setObject:cyManager.shopSysNo forKey:@"CustomersTopSysNo"];
                
                _url = [BaseUrl stringByAppendingString:QueryRateCustomerUserUrl];

                
            }else{
                
            
                if (IsNilOrNull(self.userSysNo)) {//商户首页直接进入
                    [self.paramters setObject:cyManager.sysNO forKey:@"CustomerSysNo"];
                     _url  = [BaseUrl stringByAppendingString:ShopRateQueryUrl];
                    
                }else{
                    //员工主键
                    [self.paramters setObject:self.userSysNo forKey:@"SystemUserTopSysNo"];
                    //服务商主键
                    [self.paramters setObject:cyManager.sysNO forKey:@"CustomersTopSysNo"];
                    
                    _url = [BaseUrl stringByAppendingString:QueryRateCustomerUserUrl];

                    
                }
                
       
                
          
                
            }
            
      
        }
            break;
            
            
        default:
            break;
    }
    

 
    
    
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
    
    
    [manager POST:_url parameters:self.paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        
        _table.footer.hidden = NO;
        self.table.hidden = NO;
        [self endRefreshing];
        
        NSLog(@"responseObject :%@",responseObject);
        NSArray *model = responseObject[@"model"];
//        _queryResultArr = [NSMutableArray array];
        
        
        if (!model.count) {
            NSLog(@"没有数据");
            if (_page == 0) {//第一次请求，没有数据提示 查无数据
                [MessageView showMessage:@"查无数据"];
                
            }
            _isMove = YES;
            _table.footer.hidden = YES;
        

        }else{
            if (model.count < 20) {
                _isMove = YES;
                _table.footer.hidden = YES;
            }
//            DisplayName LoginName
            for (NSDictionary* dic in model) {
                ShopRateModel *rateModel = [[ ShopRateModel alloc]init];
                [rateModel setValuesForKeysWithDictionary:dic];
                 rateModel.Cash_fee_type = @"CNY";
                if (self.queryOrderState == kTopCustomerUserRate || self.queryOrderState == kTopShopRate) {//取上级费率 ，上级返佣
                    
            
                    rateModel.Rate = dic[@"UserRate"];
                    rateModel.Rate_fee = dic[@"UserRate_fee"];
                }
                rateModel.Rate=  [CyTools strByDoubleValue:rateModel.Rate];
                
                [_queryResultArr addObject:rateModel];
            }
            
            
        }
        /** 最后刷新页面 */
        [self.table reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];

        NSLog(@"error :%@",error);

    }];
    
 
}
#pragma mark UITableViewDataSource
//组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _queryResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QueryRateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryRateListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.resultModel = _queryResultArr[indexPath.row];
    return cell;
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了。。");
    QueryRateDetailVC *query = [QueryRateDetailVC new];
    ShopRateModel *model = _queryResultArr[indexPath.row];
    query.queryModel = model;
    query.queryOrderState = self.queryOrderState;
    [self.navigationController pushViewController:query animated:YES];
    
    
}


//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}

@end
