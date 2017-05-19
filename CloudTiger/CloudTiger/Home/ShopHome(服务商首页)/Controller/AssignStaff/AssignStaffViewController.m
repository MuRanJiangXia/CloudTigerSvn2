//
//  AssignStaffViewController.m
//  CloudTiger
//
//  Created by cyan on 16/12/2.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "AssignStaffViewController.h"
#import "AssignStaffCell.h"
#import "AssignStaffModel.h"
@interface AssignStaffViewController ()<UITableViewDelegate,UITableViewDataSource,AssignStaffDelegate>{
    
    
    NSArray *_allStaff;
    NSArray *_chooseStaff;
    NSMutableArray *_cellArr;
    
    CyanManager *_cyManager;

}

@property(nonatomic,strong)UITableView *table;

@end

@implementation AssignStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"调拨";
    self.view.backgroundColor = PaleColor;
    [self rightNavBtn];
    [self.view addSubview:self.table];
    _cyManager = [CyanManager shareSingleTon];
    
    [self loadData];
    
}


-(void)rightNavBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 44);
//    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //   btn文字偏右
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    使文字距离做边框保持10个像素的距离。
    //    Btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    
}
-(void)rightNavBtnAction:(UIButton *)btn{
    NSLog(@"保存");
    NSMutableArray *finalArr = [NSMutableArray array];
    for (NSInteger index = 0 ; index < _cellArr.count; index++) {
        
        AssignStaffModel *model = _cellArr[index];
        if (model.isChoose) {
            [finalArr addObject:model];
        }
    }
    if (!finalArr.count) {
        
      [self alterWith:@"没有选择"];
        return;
    }
    if (finalArr.count >= 2) {
        [self alterWith:@"只能选择一个"];
        return;
    }
    
    NSLog(@"finalArr : %@",finalArr);
    AssignStaffModel *model = finalArr[0];
    [self assignStaffPostByStaffSysNo:model.SysNO];
    
    
}

-(void)assignStaffPostByStaffSysNo:(NSString *)staffSysNo{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    AFPropertyListResponseSerializer AFHTTPResponseSerializer AFJSONResponseSerializer
    /**
     这两个 必须设置
     */
    manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSDictionary *parameters = @{
                                 @"CustomerServiceSysNo":_shopSysNo,
                                 @"SystemUserSysNo":staffSysNo,

                                 };
    
    [self showSVPByStatus:@"加载中..."];
    //    查询上级服务商员工
    NSString *url  = [BaseUrl stringByAppendingString:AssignStaffUrl];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@",responseObject);
        [self dismissSVP];
        if ([responseObject isEqualToString:@"true"]) {
            
            [MessageView showMessage:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MessageView showMessage:@"保存失败"];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];

        NSLog(@"error : %@",error);
        [self alterWith:error.userInfo[@"NSLocalizedDescription"]];
        
    }];
    
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        [_table registerClass:[AssignStaffCell class] forCellReuseIdentifier:@"AssignStaffCell"];
//        [_table registerClass:[CyanLoadFooterView class] forHeaderFooterViewReuseIdentifier:@"CyanLoadFooterView"];
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

-(void)loadChooseData{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSDictionary *parameters = @{
                                 @"CustomerServiceSysNo":_shopSysNo,
                                 @"PagingInfo":@{
                                         @"PageNumber":@"0",
                                         @"PageSize":@"10000"
                                         }
                                 
                                 };
    //    查询上级服务商员工
    NSString *url  =[BaseUrl stringByAppendingString:ShopQueryTopStaffUrl]; ;

//    NSString *url  = @"http://iosapi.yunlaohu.cn/";
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        
//        NSLog(@"responseObject :%@",responseObject);
        NSArray *modelArr = responseObject[@"model"];
//        NSLog(@"modelArr : %@",modelArr);
        _chooseStaff = modelArr;
        
        //谓词
        //    @"NOT (SELF IN %@)"
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",_chooseStaff];
        
        NSArray * filter = [_allStaff filteredArrayUsingPredicate:filterPredicate];
        
        
//        NSLog(@"filter : %@",filter);
        _cellArr = [NSMutableArray array];
  
        for (NSDictionary* dic in _allStaff) {
            AssignStaffModel   *model  = [[AssignStaffModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_cellArr addObject:model];
            
        }
        /**在所有的数据中 把已经选择的修改 isChoose*/
        for (NSInteger index = 0; index < filter.count; index++) {
            
            NSDictionary *dic = filter[index];
            NSInteger chooseIndex =  [_allStaff indexOfObject:dic];
            AssignStaffModel   *model = _cellArr[chooseIndex];
            model.isChoose = YES;
        }
        [self.table reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self alterWith:@"获取调拨员工失败"];
        [self dismissSVP];
        NSLog(@"error :%@",error);
        
    }];
    
}
-(void)loadData{
    
     [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSDictionary *parameters = @{
                                 @"CustomerServiceSysNo":_cyManager.sysNO,
                                 @"PagingInfo":@{
                                         @"PageNumber":@"0",
                                         @"PageSize":@"10000"
                                         }
                                 
                                 };

    
    //查询服务商所有员工
    NSString *url  =[BaseUrl stringByAppendingString:StaffQueryUrl]; ;
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"responseObject :%@",responseObject);
        NSArray *modelArr = responseObject[@"model"];
        
        NSLog(@"modelArr : %@",modelArr);
        _allStaff = modelArr;
        
        [self loadChooseData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        NSLog(@"error :%@",error);
        
    }];
    
    
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssignStaffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignStaffCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.assignStaffModel = _cellArr[indexPath.row];
    cell.indexPath  = indexPath;
    cell.delegate =self;
    return cell;
    
}
//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
//组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark AssignStaffDelegate
-(void)switchAction:(BOOL)isSelected byIndex:(NSIndexPath *)indexPath{
    
    for (NSInteger index = 0 ; index < _cellArr.count; index++) {
        AssignStaffModel *model = _cellArr[index];
        //把之前选中的取消 选中
        if (model.isChoose) {
            model.isChoose = NO;
            NSIndexPath  *indexPathPre = [NSIndexPath indexPathForRow:index inSection:0];
            [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathPre,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    AssignStaffModel   *model = _cellArr[indexPath.row];
    model.isChoose = isSelected;
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [self.table reloadData];
}
@end
