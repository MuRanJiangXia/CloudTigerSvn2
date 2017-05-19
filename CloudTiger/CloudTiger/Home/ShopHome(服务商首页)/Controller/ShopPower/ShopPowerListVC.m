//
//  ShopPowerListVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopPowerListVC.h"
#import "SBJsonWriter.h"
#import "ShopQueryCell.h"
#import "QueryShopModel.h"
#import "CyanLoadFooterView.h"
#import "ShopPowerDetailVC.h"

@interface ShopPowerListVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_queryResultArr;
    NSInteger _page;
    BOOL _isMove;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation ShopPowerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户权限";
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    self.table.hidden = YES;
    /**底部返回首页按钮*/
    [self homeBtnView];
    
    [self initConfigure];
    [self getUrlAndParameters];
    [self postData];
}
//获取 url 和 参数
-(void)getUrlAndParameters{
    NSNumber *number = [NSNumber numberWithInteger:_page];
    
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
#pragma mark 判断 进入 员工进
    /**
     员工进入（直接进入）   传 CyManager.sysNo
     
     服务商进入 (直接进入)  传 CustomersTop.SysNo
     （通过查询 员工，员工进入） 员工详情获取的 sysno
     */
    NSString *sysNo = [self.paramters objectForKey:@"SystemUserSysNo"];
    
    if (sysNo.length) {//进入前已经获取
        
    }else{
        CyanManager *cyManager = [CyanManager shareSingleTon];
        
        if ([cyManager.isStaff isEqualToString:@"0"]) {
            [self.paramters setObject:cyManager.sysNO forKey:@"CustomersTopSysNo"];
        }else{
            [self.paramters setObject:cyManager.sysNO forKey:@"SystemUserSysNo"];
            
        }
        
    }
    
    [self.paramters setObject:pageDic forKey:@"PagingInfo"];
    
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
#pragma mark ---  加载更多
-(void)loadMoreData{
    _page ++;
    NSNumber *number = [NSNumber numberWithInteger:_page];
    NSNumber *number2 = @20;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    
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
    [self postData];
}
-(void)postData{
    
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];

    
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *json = [writer stringWithObject:self.paramters];
    
    
    NSString *url = @"";
    url = [BaseUrl stringByAppendingString:ShopQueryUrl];
    
    
    [manager POST:url parameters:self.paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        self.table.hidden = NO;
        //底部试图显示出来
        _table.footer.hidden = NO;
        
        [self endRefreshing];
        NSLog(@"responseObject :%@",responseObject);
        NSArray *model = responseObject[@"model"];
        if (!model.count) {
            NSLog(@"没有数据");
            _isMove = YES;
            _table.footer.hidden = YES;
        }else{
            
            if (model.count < 20) {//这个页面已经是最后一页了
                _isMove = YES;
                _table.footer.hidden = YES;
            }
            
            
            for (NSDictionary* dic in model) {
                QueryShopModel  *shopModel = [[ QueryShopModel alloc]init];
                [shopModel setValuesForKeysWithDictionary:dic];
                [_queryResultArr addObject:shopModel];
            }
            
      
        }
              [self.table reloadData];
        NSLog(@"count :%ld",model.count);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissSVP];
        NSLog(@"error :%@",error);
    }];
}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[ShopQueryCell class] forCellReuseIdentifier:@"ShopQueryCell"];
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
    ShopQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopQueryCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.queryModel = _queryResultArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopPowerDetailVC *query = [ShopPowerDetailVC new];
    QueryShopModel *model = _queryResultArr[indexPath.row];
    query.queryShopModel = model;
    [self.navigationController pushViewController:query animated:YES];
    
}

//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}
//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_isMove) {
        CyanLoadFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CyanLoadFooterView"];
        //    footer.delegete = self;
        return footer;
    }
    return nil;
    
}
//组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_isMove) {
        return 118;
    }
    return 0.01;
    
}

@end
