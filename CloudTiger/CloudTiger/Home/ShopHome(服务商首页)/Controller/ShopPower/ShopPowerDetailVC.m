//
//  ShopPowerDetailVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopPowerDetailVC.h"
#import "ShopQueryDetailCell2.h"
#import "ShopQueryDetailCell.h"
#import "CyanLoadFooterView2.h"
#import "BaseOperationCell.h"
#import "ShopPowerOperarionVC.h"

@interface ShopPowerDetailVC ()<UITableViewDelegate,UITableViewDataSource,OperationDelegate>{
    NSArray *_titleArr;
    NSArray *_contArr;
    CyanManager *_cyManager;
    NSString *_registerTime;
}
@property(nonatomic,strong)UITableView *table;

@end
@interface ShopPowerDetailVC ()

@end
@implementation ShopPowerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _cyManager = [CyanManager shareSingleTon];
    self.title = @"商户详情";
    self.view.backgroundColor = [UIColor cyanColor];
#warning  服务商 ，服务商下员工 查看商户详情，显示不相同
    /**商户号*/
    /**用户名*/
    /**用户名称*/
    ///**联系电话*/
    /**商户类型*/
    /**注册时间*/
    /**电子邮箱*/
    /**传真*/
    /**联系地址*/
    /**上级员工*/
    /**操作*/
    //    商户号	商户用户名 商户名称 	联系电话	地址	商户类型	注册时间
    _titleArr = @[@"商户号",@"商户名称",@"用户名",@"联系电话",@"商户类型",@"注册时间",@"联系地址"];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    
    [self loadData];
    
    //    [self postData];
}


-(void)loadData{
    NSMutableArray *mutabArr = [NSMutableArray new];
    _contArr =    [self.queryShopModel allPropertyNames];
    for (NSInteger index = 0; index < _contArr.count; index ++ ) {
        if (index == 6 ||index == 7) {//电子邮箱 ，传真不读
            
        }else{
            [mutabArr addObject:_contArr[index]];
        }
        
    }
    _contArr = [mutabArr copy];
    
    if (IsNilOrNull(self.queryShopModel.RegisterTime) ) {
        _registerTime = @"空";
    }
    else{
        NSString *time = [NSString stringWithFormat:@"%@",self.queryShopModel.RegisterTime];
        if (time.length < 6) {
            _registerTime  = @"空";
            
        }else{
            NSRange range = {6,time.length-2-6};
            NSString *time2 = [time substringWithRange:range];
            _registerTime  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
        }
    }
    self.queryShopModel.type = @"商户";
    [self.table reloadData];
}

/**
 没有请求网络
 */
-(void)postData{
    
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    
    NSNumber *number = @0;
    NSNumber *number2 = @1;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    
    NSMutableDictionary *paramters = [@{
                                        @"SystemUserSysNo":_cyManager.sysNO,
                                        @"SysNo":@"1633"
                                        } mutableCopy];
    [paramters setObject:pageDic forKey:@"PagingInfo"];
    
    
    NSString *url = @"";
    url = [BaseUrl stringByAppendingString:ShopQueryUrl];
    
    
    [manager POST:url parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        NSArray *modelArr = responseObject[@"model"];
        if (!modelArr.count) {
            NSLog(@"没有数据");
            
        }else{
            //            for (NSDictionary* dic in modelArr) {
            ////                _model  = [[ RefudDesModel alloc]init];
            ////                [_model setValuesForKeysWithDictionary:dic];
            ////                _contArr =    [_model allPropertyNames];
            //            }
            
            [self.table reloadData];
        }
        NSLog(@"count :%ld",modelArr.count);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissSVP];
        
        NSLog(@"error :%@",error);
    }];
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[ShopQueryDetailCell2 class] forCellReuseIdentifier:@"ShopQueryDetailCell2"];
        [_table registerClass:[ShopQueryDetailCell class] forCellReuseIdentifier:@"ShopQueryDetailCell"];
        
        [_table registerClass:[BaseOperationCell class] forCellReuseIdentifier:@"BaseOperationCell"];
        
        [_table registerClass:[CyanLoadFooterView2 class]  forHeaderFooterViewReuseIdentifier:@"CyanLoadFooterView2"];
        
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
    

    return _titleArr.count +1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= _titleArr.count) {
        BaseOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOperationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
        cell.queryOrderState = kChangeShopPower;
        return cell;
    }else{
        
        ShopQueryDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopQueryDetailCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.firstLab.text = _titleArr[indexPath.row];
        cell.contLab.isCopy = YES;
        if ([_titleArr[indexPath.row] isEqualToString:@"注册时间"]) {
            cell.contLab.text =  _registerTime;
        }else{
            NSString *showStr =  [self.queryShopModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
            if (IsNilOrNull(showStr)) {
                cell.contLab.text = _titleArr[indexPath.row];
            }else{
                cell.contLab.text = [NSString stringWithFormat:@"%@",showStr] ;
            }
        }
 
        return cell;
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
////组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CyanLoadFooterView2 *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CyanLoadFooterView2"];
    return footer;
    
}
////组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 68 +10;
}

#pragma mark OperationDelegate
-(void)jumpOperationBy:(enum QueryOrderState)queryOrderState{
    NSLog(@"权限分配");
    ShopPowerOperarionVC *operation = [ShopPowerOperarionVC new];
    operation.shopSysNo = self.queryShopModel.SysNo;
    [self.navigationController pushViewController:operation animated:YES];
}




@end
