//
//  ShopQueryDetailVC.m
//  CloudTiger
//
//  Created by cyan on 16/9/20.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ShopQueryDetailVC.h"
//#import "RefunOperationCell.h"
#import "ShopQueryDetailCell2.h"
#import "ShopQueryDetailCell.h"
#import "QueryViewController.h"
#import "CyanLoadFooterView2.h"

#import "AssignStaffViewController.h"
#import "QueryRateViewController.h"
#import "BaseOperationCell.h"

#import "ChangeTopRateView.h"

@interface ShopQueryDetailVC ()<UITableViewDelegate,UITableViewDataSource,OperationDelegate,ChangeTopRateViewDelegate>{
    NSArray *_titleArr;
    NSArray *_contArr;
    CyanManager *_cyManager;
    
    NSString *_registerTime;
}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)ChangeTopRateView *changeTopRateView;

@end

@implementation ShopQueryDetailVC

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
    _titleArr = @[@"商户号",@"商户名称",@"用户名",@"联系电话",@"商户类型",@"注册时间",@"电子邮箱",@"传真",@"联系地址",@"上级员工",@"商户费率",@"上级费率"];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    
    [self loadData];
    

}


-(void)loadData{
    
    _contArr =   [self.queryShopModel allPropertyNames];
    
    if (IsNilOrNull(self.queryShopModel.RegisterTime) ) {
      _registerTime = @"空";
    }
    else{
        NSString *time = [NSString stringWithFormat:@"%@",self.queryShopModel.RegisterTime];
        
        NSLog(@"time : %@",time);
        if (time.length < 6) {
           _registerTime  = @"空";

        }else{
            NSRange range = {6,time.length-2-6};
            NSString *time2 = [time substringWithRange:range];
            
            _registerTime  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
            
            NSLog(@"time2 : %@,final : %@",time2,self.queryShopModel.RegisterTime);
        }
   
        
    }

    self.queryShopModel.type = @"商户";
    
    if ([_cyManager.isStaff isEqualToString:@"1"]) {//服务商员工 进入的时候 直接用自己的用户名
        /**
         9.29 当前用户名
         */
        self.queryShopModel.staff = _cyManager.displayName;
    }else{//服务商 查询员工 - 查询商户 获取 商户上级用户名
        
        //查询上级员工
        [self postGetStaffId];
    }
    
    [self.table reloadData];
}
//修改 上级费率 post
-(void)changeRatePostByRate:(NSString *)rate{
    
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
                                 @"SysNo":self.queryShopModel.SysNo,
                                 @"UserRate":rate,
                                 
                                 };
    
    //    @"http://iosapi.yunlaohu.cn/IPP3Customers/IPP3CustomerUserRateUpdate"
    //    SysNo
    //    UserRate
    //    查询上级服务商员工
    NSString *url  = [BaseUrl stringByAppendingString:ChangeRateCustomerUserUrl];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@",responseObject);
        
        if ([responseObject isEqualToString:@"true"]) {
            [self alterWith:@"保存成功"];
        }else{
            [self alterWith:@"保存失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@",error);
        IsNilOrNull(error.userInfo[@"NSLocalizedDescription"])?  [self alterWith:@"网络错误"]:  [self alterWith:error.userInfo[@"NSLocalizedDescription"]];
        
    }];
    
}
//商户查询上级 id
-(void)postGetStaffId{
    
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSMutableDictionary *paramters = [@{
                                        @"CustomerServiceSysNo":self.queryShopModel.SysNo
                                        } mutableCopy];
    
    
   NSString *url = [BaseUrl stringByAppendingString:ShopTopGradeUrl] ;
    
    
    [manager POST:url parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *model = responseObject[@"model"];
        if (model.count) {
            NSDictionary *dic =model[0];
            NSString *SystemUserSysNo  = dic[@"SystemUserSysNo"];
            [self postGetStaffNameBy:SystemUserSysNo];

  
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        NSLog(@"error : %@",error);
    }];
}
/**
   获取员工名
 */
-(void)postGetStaffNameBy:(NSString *)staffID{
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSMutableDictionary *paramters = [@{
                                        @"SysNo":staffID
                                        } mutableCopy];

    

    NSString *url = @"";
    //员工查询
    url = [BaseUrl stringByAppendingString:StaffPersonUrl];
    
    
    [manager POST:url parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        NSArray *modelArr = responseObject[@"model"];
        if (!modelArr.count) {
            NSLog(@"没有数据");
            
        }else{
            
            NSDictionary *staffDic = modelArr[0];
            
            self.queryShopModel.staff = staffDic[@"DisplayName"];
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
-(void)creatgoodsView{
    
    self.changeTopRateView = [[ChangeTopRateView alloc]initWithFrame:CGRectMake(0,MainScreenHeight  , MainScreenWidth, MainScreenHeight -20)];
    //    _goodsView.backgroundColor = [UIColor greenColor];
    [[UIApplication sharedApplication].keyWindow addSubview: self.changeTopRateView ];
    
    self.changeTopRateView.changeRateDelegate = self;
    [self.changeTopRateView bgViewTop];

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
    
    if ([_cyManager.isStaff isEqualToString:@"1"]) {//服务商员工
      return _titleArr.count +4;
    }
    
    if (self.shopState == kShopListOfCustomerUser) {//服务商-员工列表-商户查询
        return _titleArr.count + 4;
    }
    return _titleArr.count +3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_cyManager.isStaff isEqualToString:@"1"]) {//服务商员工
    
        
     if (indexPath.row >= _titleArr.count) {
        
         
         BaseOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOperationCell" forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.delegete = self;
            if (indexPath.row == _titleArr.count) {//查看订单
                cell.queryOrderState = kOriginalOrder;
                
            }else if (indexPath.row == _titleArr.count +1) {//商户费率订单
                cell.queryOrderState = kOrderShop;

            }else if (indexPath.row == _titleArr.count +2) {//服务商员工 上级费率订单
                
                cell.queryOrderState = kTopShopRate;
            }
            else if (indexPath.row == _titleArr.count +3) {//修改上级费率
                cell.queryOrderState = kChangeRate;
            }
        
            return cell;
        }else{
            
            ShopQueryDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopQueryDetailCell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstLab.text = _titleArr[indexPath.row];
            cell.contLab.isCopy = YES;
            if (  [_titleArr[indexPath.row] isEqualToString:@"注册时间"]) {
                cell.contLab.text = _registerTime;
            }else{
                NSString *showStr = [self.queryShopModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
                
                
                if (IsNilOrNull(showStr)) {
                    cell.contLab.text = @"";
                }else{
                    cell.contLab.text = [NSString stringWithFormat:@"%@",showStr];
                    
                }
        
            }
            return cell;
            
        }
    }else{//服务商
        if (indexPath.row >= _titleArr.count) {
            
         
            
            BaseOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOperationCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegete = self;
            
            
            if (self.shopState == kShopListOfCustomerUser) {//服务商-员工列表-商户查询
                
                if (indexPath.row == _titleArr.count) {//查看订单
                    cell.queryOrderState = kOriginalOrder;
                }else if (indexPath.row == _titleArr.count +1) {//商户费率订单
                    cell.queryOrderState = kOrderShop;
                    
                }else if (indexPath.row == _titleArr.count +2) {//上级费率订单
                    cell.queryOrderState = kTopShopRate;
                }
                else if(indexPath.row == _titleArr.count +3) {//调拨
                    cell.queryOrderState = kAssignStaff;
                }
                
                
                
            }else{
                if (indexPath.row == _titleArr.count) {//查看订单
                    cell.queryOrderState = kOriginalOrder;
                }else if (indexPath.row == _titleArr.count +1) {//商户费率订单
                    cell.queryOrderState = kOrderShop;
                    
                }else if(indexPath.row == _titleArr.count +2) {//调拨
                    cell.queryOrderState = kAssignStaff;
                }
                
            }
      
            
             return cell;
         }
        else{
            ShopQueryDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopQueryDetailCell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstLab.text = _titleArr[indexPath.row];
            cell.contLab.isCopy = YES;
            
            if (  [_titleArr[indexPath.row] isEqualToString:@"注册时间"]) {
                cell.contLab.text = _registerTime;
            }else{
                NSString *showStr = [self.queryShopModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
                
                if (IsNilOrNull(showStr)) {
                     cell.contLab.text = @"";
                }else{
                    cell.contLab.text = [NSString stringWithFormat:@"%@",showStr];
   
                }
            }
          
       
            return cell;
            
        }
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}
////组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CyanLoadFooterView2 *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CyanLoadFooterView2"];
    //    footer.delegete = self;
    return footer;
    
}
////组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 68 +10;
    
}

#pragma mark OperationDelegate

-(void)jumpOperationBy:(enum QueryOrderState)queryOrderState{
    
    switch (queryOrderState) {
        case kOriginalOrder:
        {
#pragma mark 判断是服务商 还是 服务商员工
            //把 Customer 锁死
            //    self.queryShopModel.Customer
            QueryViewController *query = [QueryViewController new];
            CyanManager *cyManager = [CyanManager shareSingleTon];
            if ([cyManager.isStaff isEqualToString:@"1"]) {//员工
                query.queryOrderState = kOrderCustomerUser;
            }else{
                query.queryOrderState = kOrderCustomer;
                
                
            }
            query.customer = self.queryShopModel.Customer;
            
            [self.navigationController pushViewController:query animated:YES];
            
        }
            break;
            
        case kOrderShop:
        {
            
            
            QueryRateViewController *shop = [QueryRateViewController new];
            shop.queryOrderState = kOrderShop;
            shop.userSysNo = self.queryShopModel.SysNo;
            [self.navigationController pushViewController:shop animated:YES];
        }
            break;
            
        case kAssignStaff:
        {
            
            AssignStaffViewController *assign = [AssignStaffViewController new];
            assign.shopSysNo = self.queryShopModel.SysNo;
            [self.navigationController pushViewController:assign animated:YES];
        }
            break;
            
        case kTopShopRate:
        {
            
            QueryRateViewController *shop = [QueryRateViewController new];
            shop.queryOrderState = kTopShopRate;
//            shop.userSysNo = self.queryShopModel.SysNo;
            shop.userSysNo = self.staffSysNo;
            shop.customer = self.queryShopModel.Customer;
            [self.navigationController pushViewController:shop animated:YES];
        }
            break;
            
        case kChangeRate:
        {
            
        NSLog(@"修改上级费率");
            
            [self creatgoodsView];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark ChangeTopRateViewDelegate

-(void)changeTopRate:(NSArray *)changeRateArr{

    NSLog(@"refundArr : %@",changeRateArr);
    NSString *rate = changeRateArr[0];
    
    if ( [CyTools isNeedPointBy:rate]) {
         [self changeRatePostByRate:rate];
    }else{
        
        [self alterWith:@"输入费率不正确"];
    }
   
  

}



@end
