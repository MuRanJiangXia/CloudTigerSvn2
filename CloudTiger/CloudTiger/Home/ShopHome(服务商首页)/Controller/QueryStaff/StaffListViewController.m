//
//  StaffListViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffListViewController.h"
#import "StaffListCell.h"
#import "QueryStaffModel.h"

#import "StaffDetailViewController.h"
#import "StaffCodeViewController.h"
#import "CyanLoadFooterView.h"
#import "StaffPowerDetailVC.h"

@interface StaffListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_queryResultArr;
    NSInteger _page;
    BOOL _isMove;

}
@property(nonatomic,strong)UITableView *table;

@end

@implementation StaffListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    员工列表
    self.title = @"员工查询";

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
    //    NSDictionary *pageDic = [NSDictionary new];
    CyanManager *cyManager  =[CyanManager shareSingleTon];

    [self.paramters setObject:cyManager.sysNO forKey:@"CustomerServiceSysNo"];
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
    //    NSDictionary *pageDic = [NSDictionary new];
    
    
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
    
    //    Pay_Type
    //    [parameter setObject:@"102" forKey:@"Pay_Type"];
    
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *json = [writer stringWithObject:self.paramters];

    NSString *url = [BaseUrl stringByAppendingString:StaffQueryUrl];

    
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
                QueryStaffModel *staffModel = [[ QueryStaffModel alloc]init];
                [staffModel setValuesForKeysWithDictionary:dic];
                [_queryResultArr addObject:staffModel];
            }
            
       
        }
        /**最后做刷新*/
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
        
        [_table registerClass:[StaffListCell class] forCellReuseIdentifier:@"StaffListCell"];
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
    StaffListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaffListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.queryStaffModel = _queryResultArr[indexPath.row];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了。。");
    if (self.staffState == kStaffCode) {//跳转到员工二维码
        StaffCodeViewController *staffCode  = [StaffCodeViewController new];
        [self.navigationController pushViewController:staffCode animated:YES];

    }else if (self.staffState == kStaffPower){//跳转到员工权限配置——服务商
        
        StaffPowerDetailVC *staffPower = [StaffPowerDetailVC new];
        staffPower.queryStaffModel = _queryResultArr[indexPath.row];
        [self.navigationController pushViewController:staffPower animated:YES];
    }
    else{//跳转到员工详情
        StaffDetailViewController *staffDetail = [StaffDetailViewController new];
        staffDetail.queryStaffModel = _queryResultArr[indexPath.row];
        [self.navigationController pushViewController:staffDetail animated:YES];
    }

    
}


//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
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
