//
//  ShopQueryDetailVC.m
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffDetailViewController.h"
#import "RefunOperationCell.h"
#import "ShopQueryDetailCell.h"
#import "QueryViewController.h"
#import "ShopQueryViewController.h"
//#import "QueryShopOperationCell.h"
#import "BaseOperationCell.h"
#import "CyanLoadFooterView2.h"

#import "QueryRateViewController.h"
#import "RegisterShopViewController.h"

@interface StaffDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ShopQueryDelegate,OperationDelegate>{
    NSArray *_titleArr;
    NSArray *_contArr;
    CyanManager *_cyManager;
    NSString *_registerTime;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation StaffDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工详情";
    self.view.backgroundColor = [UIColor cyanColor];
    
    /**编号*/
    /**登录名*/
    /**显示名*/
    /**电话*/
    /**邮箱*/
    /**门店ID*/
    /**注册时间*/
    /**操作*/
    
    _titleArr = @[@"编号",@"登录名",@"显示名",@"电话",@"邮箱",@"门店ID",@"注册时间"];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    
    _cyManager = [CyanManager shareSingleTon];
    /**底部返回首页按钮*/
    [self homeBtnView];
    /**
     暂时不再次请求了
     */
    [self loadData];
    
    //    [self postData];
}


-(void)loadData{
    
    _contArr =   [self.queryStaffModel allPropertyNames];
    
    
    if (IsNilOrNull(self.queryStaffModel.InDate) ) {
        _registerTime = @"空";
    }else{
        NSString *time = [NSString stringWithFormat:@"%@",self.queryStaffModel.InDate];
        if (time.length < 6) {
            _registerTime  = @"空";
            
        }else{
            NSRange range = {6,time.length-2-6};
            NSString *time2 = [time substringWithRange:range];
            _registerTime  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
            NSLog(@"time2 : %@,final : %@",time2,self.queryStaffModel.InDate);
        }
        
    }
//    self.queryStaffModel.type = @"商户";
//    self.queryStaffModel.staff = @"当前用户名";
    [self.table reloadData];
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
    
    
    NSNumber *number = @0;
    NSNumber *number2 = @1;
    NSDictionary *pageDic = @{
                              @"PageNumber":number,
                              @"PageSize":number2
                              };
    NSMutableDictionary *paramters = [@{
                                        @"CustomerServiceSysNo":@"1",
                                        @"SysNo":@"1898"
                                        } mutableCopy];
    [paramters setObject:pageDic forKey:@"PagingInfo"];
    
    
    NSString *url = @"";
    url = [BaseUrl stringByAppendingString:StaffQueryUrl];
    
    
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
////                                _model  = [[  alloc]init];
////                                [_model setValuesForKeysWithDictionary:dic];
////                                _contArr =    [_model allPropertyNames];
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
        
        [_table registerClass:[RefunOperationCell class] forCellReuseIdentifier:@"RefunOperationCell"];
        [_table registerClass:[ShopQueryDetailCell class] forCellReuseIdentifier:@"ShopQueryDetailCell"];
        [_table registerClass:[BaseOperationCell class] forCellReuseIdentifier:@"BaseOperationCell"];
        
        /**底部加高 footer*/
        [_table registerClass:[CyanLoadFooterView2 class] forHeaderFooterViewReuseIdentifier:@"CyanLoadFooterView2"];
        
        
        
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
    if ([_cyManager.customersType isEqualToString:@"1"]) {//商户的时候 第一个是查询订单
        return _titleArr.count + 2;

    }
    return _titleArr.count +4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >= _titleArr.count) {
        
        BaseOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOperationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
        if (indexPath.row == _titleArr.count ) {//查询商户
            if ([_cyManager.customersType isEqualToString:@"1"]) {//商户的时候 第一个是查询订单
//                cell.btnTitle = @"订单查询";
//                kOriginalOrder
                 cell.queryOrderState  = kOriginalOrder;
            }else{
                
                    cell.queryOrderState  = kQueryShop;
            }
      
            
        }else if (indexPath.row == _titleArr.count +1){//商户注册
            if ([_cyManager.customersType isEqualToString:@"1"]) {//商户的时候 第二个是员工费率订单查询
//                cell.btnTitle = @"订单查询";
                cell.queryOrderState  = kOrderShopUser;
                
            }else{
                
              cell.queryOrderState  = kRegisterShop;
            }
        
            
        }else if (indexPath.row == _titleArr.count +2){//员工上级费率订单
            cell.queryOrderState  = kTopCustomerUserRate;
            
            
        }else if (indexPath.row == _titleArr.count +3){//商户费率订单
          cell.queryOrderState  = kOrderShop;
        }
        
        return cell;
        
    }else{
        RefunOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefunOperationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.firstLab.text = _titleArr[indexPath.row];
        
        if ([_titleArr[indexPath.row] isEqualToString:@"注册时间"]) {
            cell.contLab.text =   _registerTime;
        }else{
            NSString *showStr = [self.queryStaffModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
            
            if (IsNilOrNull(showStr)) {
              cell.contLab.text = @"";
            }else{
                cell.contLab.text = [NSString stringWithFormat:@"%@",showStr];
 
            }
    
            
        }
    
        return cell;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CyanLoadFooterView2 *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CyanLoadFooterView2"];
    //    footer.delegete = self;
    return footer;
}
////组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

     return 68 + 10;
    
}


/**
 
 服务商查员工 ：  查看商户 商户注册  上级费率订单  商户费率订单
 
 */
#pragma mark OperationDelegate

-(void)jumpOperationBy:(enum QueryOrderState)queryOrderState{
    
    NSLog(@"queryOrderState : %d",queryOrderState);
    switch (queryOrderState) {
            
        case kOriginalOrder:{//订单查询
            QueryViewController *query = [QueryViewController new];
            query.queryOrderState = kOrderShopUser;
            //获取员工
            NSString *sysNo = [NSString stringWithFormat:@"%@",self.queryStaffModel.SysNO];
//            NSLog(@"sysNo : %@ ,LoginName %@",sysNo,self.queryStaffModel.LoginName);
            query.userSysNo = sysNo;
            [self.navigationController pushViewController:query animated:YES];
        }
            break;
  
        case kQueryShop:
        {
//            NSLog(@"商户查询");
            //跳转商户查询  。。。
            ShopQueryViewController *query = [ShopQueryViewController new];
            query.staffSysNo = [NSString stringWithFormat:@"%@",self.queryStaffModel.SysNO] ;
            query.shopState = kShopListOfCustomerUser;
            [self.navigationController pushViewController:query animated:YES];
     
            
        }
        break;
            
        case kRegisterShop:
            {
            NSLog(@"商户注册");
                
                RegisterShopViewController *regist = [RegisterShopViewController new];
                regist.staffSysNo = self.queryStaffModel.SysNO;
                [self.navigationController pushViewController:regist animated:YES];

             }
            break;
            
        case kTopCustomerUserRate:
        {
            NSLog(@"员工上级费率订单");
            
            //上级费率订单
            QueryRateViewController *shop = [QueryRateViewController new];
            shop.hidesBottomBarWhenPushed = YES;
            shop.queryOrderState = kTopCustomerUserRate;
            shop.userSysNo = self.queryStaffModel.SysNO;
            //                shop.userSysNo = self.queryShopModel.SysNo;
            [self.navigationController pushViewController:shop animated:YES];
            
        }
            break;
        case kOrderShop:
        {
            NSLog(@"商户费率订单");
            QueryRateViewController *shop = [QueryRateViewController new];
            shop.hidesBottomBarWhenPushed = YES;
            shop.queryOrderState = kOrderCustomerUser;
            shop.userSysNo = self.queryStaffModel.SysNO;
            //                shop.userSysNo = self.queryShopModel.SysNo;
            [self.navigationController pushViewController:shop animated:YES];
            
        }
        break;
        case kOrderShopUser:
        {
            NSLog(@"商户员工费率订单");
            QueryRateViewController *shop = [QueryRateViewController new];
            shop.hidesBottomBarWhenPushed = YES;
            shop.queryOrderState = kOrderShopUser;
            shop.userSysNo = self.queryStaffModel.SysNO;
            //                shop.userSysNo = self.queryShopModel.SysNo;
            [self.navigationController pushViewController:shop animated:YES];
            
        }
            break;
            
            
  
        default:
            break;
       }
    
}
@end
