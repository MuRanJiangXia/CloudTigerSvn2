//
//  ShopRefundListVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopRefundListVC.h"
#import "SBJsonWriter.h"
#import "ShopRefundListCell.h"
#import "ShopRefundModel.h"

#import "ShopRefundDetailVC.h"
#import "CyanLoadFooterView.h"

@interface ShopRefundListVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_queryResultArr;
    NSInteger _page;
    NSString *_postUrl;
    BOOL _isMove;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation ShopRefundListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款查询";
    [self.view addSubview:self.table];
    self.table.hidden = YES;
    /**底部返回首页按钮*/
    [self homeBtnView];
    [self initConfigure];
    [self getUrlAndParameters];
    //退款 用 RefudDesModel.h model
    [self postData];
    
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

-(void)getUrlAndParameters{
    NSNumber *number = [NSNumber numberWithInteger:_page];
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    [self.paramters setObject:pageDic forKey:@"PagingInfo"];

    NSString *url = @"";

    CyanManager *cyManager = [CyanManager shareSingleTon];
    url = [BaseUrl stringByAppendingString:RefundShopUrl];
    
    
    if ([cyManager.customersType isEqualToString:@"0"]) {//服务商
        [self.paramters setObject:cyManager.sysNO forKey:@"CustomersTopSysNo"];

    }else{//商户
        [self.paramters setObject:cyManager.sysNO forKey:@"CustomerSysNo"];

    }
//    cyManager.sysNO
    /**
     保存一下
     */
    _postUrl = url;
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
    
    
    
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *json = [writer stringWithObject:self.paramters];
    
    [manager POST:_postUrl parameters:self.paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        self.table.hidden = NO;
        [self endRefreshing];
        NSLog(@"responseObject :%@",responseObject);
        NSArray *modelArr = responseObject[@"model"];
        if (!modelArr.count) {
            NSLog(@"没有数据");
            if (_page == 0) {//第一次请求，没有数据提示 查无数据
                [MessageView showMessage:@"查无数据"];
                
            }
            _isMove = YES;
            _table.footer.hidden = YES;
            //            _table.footer.state = MJRefreshFooterStateNoMoreData;
        }else{
            
            if (modelArr.count < 20) {
                _isMove = YES;
                _table.footer.hidden = YES;
            }
            
            //            _queryResultArr  =[ NSMutableArray new];
            for (NSDictionary* dic in modelArr) {
                
                ShopRefundModel *model = [[ ShopRefundModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.Cash_fee_type =@"CNY";
                [_queryResultArr addObject:model];
            }
        
        }
        
        /**最后做刷新*/
        [self.table reloadData];
        NSLog(@"count :%ld",modelArr.count);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissSVP];
        IsNilOrNull(error.userInfo[@"NSLocalizedDescription"])?  [self alterWith:@"网络错误"]:  [self alterWith:error.userInfo[@"NSLocalizedDescription"]];
        NSLog(@"error :%@",error);
    }];
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[ShopRefundListCell class] forCellReuseIdentifier:@"ShopRefundListCell"];
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

#pragma  mark UITableViewDataSource
//组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _queryResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopRefundListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopRefundListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.shopRefundModel = _queryResultArr[indexPath.row];
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了。。");
    
    ShopRefundDetailVC *query = [ShopRefundDetailVC new];
    ShopRefundModel *model = _queryResultArr[indexPath.row];
    query.shopRefundModel = model;
    [self.navigationController pushViewController:query animated:YES];
}


//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 ;
    
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
