//
//  ShopPowerOperarionVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopPowerOperarionVC.h"
#import "ShopPowerShowCell.h"
#import "ShopPowerModel.h"

@interface ShopPowerOperarionVC ()<UITableViewDelegate,UITableViewDataSource,AssignStaffDelegate>{
    
    
    NSArray *_allStaff;
    NSArray *_chooseStaff;
    NSMutableArray *_cellArr;
    
    CyanManager *_cyManager;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation ShopPowerOperarionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户权限分配";
    self.view.backgroundColor = PaleColor;

    [self rightNavBtn];
    [self.view addSubview:self.table];
    _cyManager = [CyanManager shareSingleTon];
    
    [self getAllPower];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)rightNavBtnAction:(UIButton *)btn{
    
    NSLog(@"保存");
    [self showSVPByStatus:@"加载中..."];
    if (_chooseStaff.count) {
        //先清空所有权限
        [self deleteShopPower];
    }else{
        
        [self addShopPowerPost];
    }
    //插入选择的权限
}

-(void)addShopPowerPost{
#warning CustomerServiceSysNo 从上一个页面获取
#warning  SystemRoleSysNo 权限 id
    NSMutableArray *finalArr = [NSMutableArray array];
    for (NSInteger index = 0 ; index < _cellArr.count; index++) {
        
        ShopPowerModel  *model = _cellArr[index];
        if (model.isChoose) {
            
            NSDictionary *parameters = @{
                                         @"CustomerServiceSysNo":_shopSysNo,
                                         @"SystemRoleSysNo":model.SysNo,
                                         @"InUser":_cyManager.sysNO,
                                         @"EditUser":_cyManager.sysNO
                                         
                                         };
            
            [finalArr addObject:parameters];
        }
    }
    //全部为空的时候不在请求了
    if (!finalArr.count) {
        [self dismissSVP];
        
        [self.navigationController popViewControllerAnimated:YES];
        [MessageView showMessage:@"保存成功"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];

    /**
        [{"SysNo":0,
          "SystemRoleSysNo":12,
          "CustomerServiceSysNo":1,
          "InUser":1,"EditUser":1 },
     
           {"SysNo":0,
           "SystemRoleSysNo":13,
           "CustomerServiceSysNo":1,
           "InUser":1, 
           "EditUser":1 }]
     
     */
//    31 大学 ——交易订单
    //    添加商户权限
    NSString *url  =[BaseUrl stringByAppendingString:ShopAddPowerUrl];
    
    [manager POST:url parameters:finalArr progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
//        NSLog(@"responseObject : %@",responseObject);
        NSInteger code = [responseObject[@"Code"] integerValue];
        if (code == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [MessageView showMessage:@"保存成功"];
        }else{
            [self alterWith:@"保存失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        [self alterWith:@"保存失败"];
        NSLog(@"error : %@",error);

    }];
    
}
-(void)deleteShopPower{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    

#warning 从上一个页面获取
    NSDictionary *parameters = @{
                                 @"CustomerServiceSysNo":_shopSysNo
                                 
                                 };
    
    //    该商户权限
    NSString *url  =[BaseUrl stringByAppendingString:ShopDeletePowerUrl];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject : %@",responseObject);
        NSInteger code = [responseObject[@"Code"] integerValue];
        if (code == 0) {
         NSLog(@"删除成功");
         [self addShopPowerPost];
        }else{
            NSLog(@"删除失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        NSLog(@"error : %@",error);

    }];
    
}

-(void)getShopChoosePower{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
#warning 从上一个页面获取
    NSDictionary *parameters = @{
                                 @"CustomerServiceSysNo":_shopSysNo
                                 
                                 };
    
    //    该商户权限
    NSString *url  =[BaseUrl stringByAppendingString:ShopHavePowerUrl];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        _chooseStaff = responseObject;
        //谓词
        NSString *preStr = @"";
        
        for (NSInteger index = 0; index < _chooseStaff.count ; index ++) {
            NSDictionary *dic  = _chooseStaff[index];
            NSString *sysNo = dic[@"SystemRoleSysNo"];
            if (index == _chooseStaff.count -1) {
                preStr = [preStr stringByAppendingFormat:@"SysNo == %ld",[sysNo integerValue]];
                
            }else{
                preStr = [preStr stringByAppendingFormat:@"SysNo == %ld ||",[sysNo integerValue]];
                
            }
            
        }
        
        NSLog(@"preArr :%@",preStr);
        _cellArr = [NSMutableArray array];
        for (NSDictionary* dic in _allStaff) {
            ShopPowerModel   *model  = [[ShopPowerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_cellArr addObject:model];
            
        }
        
        if (preStr.length) {//有数据的时候
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:preStr];
            NSArray * filter = [_allStaff filteredArrayUsingPredicate:filterPredicate];
            /**在所有的数据中 把已经选择的修改 isChoose*/
            for (NSInteger index = 0; index < filter.count; index++) {
                
                NSDictionary *dic = filter[index];
                NSInteger chooseIndex =  [_allStaff indexOfObject:dic];
                ShopPowerModel   *model = _cellArr[chooseIndex];
                model.isChoose = YES;
            }
        }
  
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        NSLog(@"error :%@",error);
        
    }];
    
}
//获取所有权限
-(void)getAllPower{
    
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    
    NSString *url = @"";
    url = [BaseUrl stringByAppendingString:ShopPowerAllUrl];
    NSDictionary *pageDic = @{
                              @"PageNumber":@"0",
                              @"PageSize":@"10000"
                              };
    NSMutableDictionary *paraters = [NSMutableDictionary dictionary];
    
    [paraters setObject:pageDic forKey:@"PagingInfo"];
    
    [manager POST:url parameters:paraters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *modelArr = responseObject[@"model"];
        _allStaff = modelArr;
        [self getShopChoosePower];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        NSLog(@"error ； %@",error);

    }];
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        [_table registerClass:[ShopPowerShowCell class] forCellReuseIdentifier:@"ShopPowerShowCell"];
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopPowerShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopPowerShowCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shopPowerModel = _cellArr[indexPath.row];
    cell.indexPath  = indexPath;
    cell.delegate =self;
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
#pragma mark AssignStaffDelegate
-(void)switchAction:(BOOL)isSelected byIndex:(NSIndexPath *)indexPath{
    ShopPowerModel   *model = _cellArr[indexPath.row];
    model.isChoose = isSelected;
    [self.table reloadData];
}
@end
