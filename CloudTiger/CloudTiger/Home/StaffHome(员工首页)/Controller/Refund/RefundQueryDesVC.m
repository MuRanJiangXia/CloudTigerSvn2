//
//  RefundQueryDesVC.m
//  CloudTiger
//
//  Created by cyan on 16/10/16.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RefundQueryDesVC.h"
//#import "RefudDesModel.h"
#import "RefunOperationCell.h"
#import "RefundOperationCell2.h"
#import "RefundQueryNewModel.h"
#import "CyanLoadFooterView2.h"

@interface RefundQueryDesVC ()<UITableViewDelegate,UITableViewDataSource,RefundOperationDelegate>{
    NSArray *_titleArr;
    NSArray *_contArr;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation RefundQueryDesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款查询详情";
    

    _titleArr = @[@"序号",@"订单号",@"交易类型",@"交易金额",@"交易币种",@"交易时间",@"退款时间",@"退款金额",@"状态"];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    [self loadData];
    
    /**不网络请求了*/
//    [self postData];
    
}

-(void)loadData{
    
//    if ([self.queryResultModel.Pay_Type isEqualToString:@"102"]) {
//        self.queryResultModel.Pay_Type = @"微信";
//    }else{
//       self.queryResultModel.Pay_Type = @"支付宝";
//        
//    }
    

/*
    if (IsNilOrNull(self.queryResultModel.Time_Start)) {
        
    }else{
        //截取时间戳
        NSString *time = [NSString stringWithFormat:@"%@", self.queryResultModel.CreateTime];
        NSRange range = {6,time.length-2-6};
        NSString *time2 = [time substringWithRange:range];
         self.queryResultModel.CreateTime  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
    }
 */
    _contArr =    [ self.queryResultModel allPropertyNames];
    
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
    
    CyanManager *cyanManger = [CyanManager shareSingleTon];
    
    NSMutableDictionary *paramters = [@{
                                        @"SystemUserSysNo":cyanManger.sysNO,
                                        @"out_trade_no":self.queryResultModel.Out_trade_no
                                        } mutableCopy];
    [paramters setObject:pageDic forKey:@"PagingInfo"];
    
    
    //    [self.paramters setObject:@"2" forKey:@"SystemUserSysNo"];
    
    
    
    //    [self.paramters setObject:@"2016-09-12" forKey:@"Time_Start"];
    //    [self.paramters setObject:@"2016-09-11" forKey:@"Time_end"];
    
    
    //    Pay_Type
    //    [parameter setObject:@"102" forKey:@"Pay_Type"];
    
    //    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    //    NSString *json = [writer stringWithObject:self.paramters];
    
    /**
     订单查询
     退款查询
     退款
     */
    NSString *url = @"";
    url = [BaseUrl stringByAppendingString:QueryRefundOrderUrl];
    
    
    [manager POST:url parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        NSArray *modelArr = responseObject[@"model"];
        if (!modelArr.count) {
            NSLog(@"没有数据");
            [MessageView showMessage:@"没有数据"];
            self.table.hidden = YES;
        }else{
            
            /*
            for (NSDictionary* dic in modelArr) {
                _model  = [[ RefundQueryNewModel alloc]init];
                [_model setValuesForKeysWithDictionary:dic];
                
                if ([_model.Pay_Type isEqualToString:@"102"]) {
                    _model.Pay_Type = @"微信";
                }else{
                    _model.Pay_Type = @"支付宝";
                    
                }
                
                if (IsNilOrNull(_model.Cash_fee_type)) {
                    _model.Cash_fee_type =@"CNY";
                }
                //订单状态 stautes
                NSInteger status  = [dic[@"Status"] integerValue];
                
                
                switch (status) {
                    case -1:
                    {
                        _model.Status  = @"已作废";
                    }
                        break;
                    case 0:{
                        _model.Status  = @"待处理";
                        
                    }
                        break;
                    case 1:{
                        
                        _model.Status  = @"处理中";
                        
                    }
                        break;
                    case 2:
                    {
                        _model.Status  = @"处理完毕";
                        
                    }
                        
                        break;
                }
                if (IsNilOrNull(_model.CreateTime)) {
                    
                }else{
                    //截取时间戳 
                    NSString *time = [NSString stringWithFormat:@"%@",_model.CreateTime];
                    NSRange range = {6,time.length-2-6};
                    NSString *time2 = [time substringWithRange:range];
                    _model.CreateTime  =[CyTools getYearAndMonthAndDayAndHourByTimeIntervalStr:time2];
                }
                _contArr =    [_model allPropertyNames];
            }
            
            [self.table reloadData];
             */
            
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
        [_table registerClass:[RefundOperationCell2 class] forCellReuseIdentifier:@"RefundOperationCell2"];
        
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
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    RefunOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefunOperationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.firstLab.text = _titleArr[indexPath.row];
    
    //设置 可以复制
    cell.contLab.isCopy = YES;
    
    NSString *context  = [self.queryResultModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
    if ([_titleArr[indexPath.row] isEqualToString:@"交易金额"]|| [_titleArr[indexPath.row] isEqualToString:@"退款金额"]) {
        
        NSString *money =  [CyTools  folatByStr:context];
        cell.contLab.text = money ;
        
    }else  if ([_titleArr[indexPath.row] isEqualToString:@"交易类型"]) {
        if ([context isEqualToString:@"102"]) {
            cell.contLab.text = @"微信";
        }else{
            cell.contLab.text = @"支付宝";
            
        }
 
      
    }else{
        cell.contLab.text = [NSString stringWithFormat:@"%@",context];
        
        
    }
    
    return cell;
//
//    if (indexPath.row == _titleArr.count - 1) {
//        RefundOperationCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundOperationCell2" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.refundDesModel = _model;
//        cell.delegete = self;
//        return cell;
//    }else{
//
//        
//    }
    
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
@end
