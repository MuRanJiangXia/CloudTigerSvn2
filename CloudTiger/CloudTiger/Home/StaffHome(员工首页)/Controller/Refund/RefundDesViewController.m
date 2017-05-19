//
//  RefundDesViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RefundDesViewController.h"
#import "RefudDesModel.h"
#import "RefunOperationCell.h"
#import "RefundOperationCell2.h"
#import "CyanLoadFooterView2.h"

@interface RefundDesViewController ()<UITableViewDelegate,UITableViewDataSource,RefundOperationDelegate>{
    NSArray *_titleArr;
    NSArray *_contArr;
    RefudDesModel *_model;
    NSString *_state;//刷新状态
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation RefundDesViewController


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    if ([self.delegete respondsToSelector:@selector(tableReloadBy:andIndexPath:)]) {
        [self.delegete tableReloadBy:_state andIndexPath:_indexPath];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    
    /**订单号*/
    /**支付类型*/
    /**金额*/
   ///**交易币种*/
    /**交易时间*/
    /**已退金额*/
    /**可退金额*/
    /**退款笔数*/
    /**是否可退款*/
    _titleArr = @[@"序号",@"订单号",@"交易类型",@"订单金额",@"交易币种",@"交易时间",@"已退金额",@"可退金额",@"退款笔数",@"退款操作"];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    self.table.hidden = YES;
    /**底部返回首页按钮*/
    [self homeBtnView];
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
    url = [BaseUrl stringByAppendingString:QureyRefundUrl];
    
    
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
         

            for (NSDictionary* dic in modelArr) {
                 _model  = [[ RefudDesModel alloc]init];
                [_model setValuesForKeysWithDictionary:dic];
                
//                if ([_model.Pay_Type isEqualToString:@"102"]) {
//                    _model.Pay_Type = @"微信";
//                }else{
//                    _model.Pay_Type = @"支付宝";
//
//                }
//                
                if (IsNilOrNull(_model.fee_type)) {
                    _model.fee_type =@"CNY";
                }
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval dis = [date timeIntervalSince1970];
                NSString *time = [CyTools getYearAndMonthAndDayByTimeInterval:dis];
                NSString *time2 = [CyTools  getYearAndMonthByYear:_model.Time_Start];
                NSInteger refunMoney = [_model.fee integerValue];
                NSString *refundstate = @"";
                if ([time2  isEqualToString:time]) {
                    //                refundBtn.backgroundColor = UIColorFromRGB(0x26a005, 1);
                    
//                    refundBtn.enabled = YES;
                    //可退金额小于  总金额 为部分退款 ；可退金额 ==  总金额  为退款
                    NSInteger totalMoney = [_model.Cash_fee integerValue];
                  
                    if (refunMoney == totalMoney) {
                          refundstate  = @"退款";
                        
                    }else if(refunMoney ==  0){
                        refundstate  = @"退款完成";
                        
                    }else{
                        refundstate  = @"部分退款";
                    }
                    
                    
                }else{
                    //                不可退款
                    refundstate  = @" 不可退款";
        
                    
                }
                
                _state = refundstate;
                
                _contArr =    [_model allPropertyNames];
                self.table.hidden = NO;
                
            }
    
            [self.table reloadData];
        }
        NSLog(@"count :%ld",modelArr.count);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.table.hidden = YES;

        [self dismissSVP];
//        Code=-1001 "请求超时。"
        if (error.code ==  -1009) {
          
            NSLog(@"没有网络了");
        
            [self.navigationController popViewControllerAnimated:YES];

        }
    IsNilOrNull(error.userInfo[@"NSLocalizedDescription"])?   [MessageView showMessage:@"网络错误"]:   [MessageView showMessage:error.userInfo[@"NSLocalizedDescription"]];
        NSLog(@"error :%@",error);
    }];
}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[RefunOperationCell class] forCellReuseIdentifier:@"RefunOperationCell"];
        [_table registerClass:[RefundOperationCell2 class] forCellReuseIdentifier:@"RefundOperationCell2"];
//
        [_table registerClass:[CyanLoadFooterView2 class]  forHeaderFooterViewReuseIdentifier:@"CyanLoadFooterView2"];

        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = PaleColor;
//        _table.backgroundColor = [UIColor redColor];

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
        
    if (indexPath.row == _titleArr.count - 1) {
        RefundOperationCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundOperationCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.refundDesModel = _model;
        cell.delegete = self;
        return cell;
    }else{
        RefunOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefunOperationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.firstLab.text = _titleArr[indexPath.row];
        
        //设置 可以复制
        cell.contLab.isCopy = YES;
        
      
        NSString *context  = [_model displayCurrentModlePropertyBy:_contArr[indexPath.row]];
        if ([_titleArr[indexPath.row] isEqualToString:@"交易类型"]) {
            if ([context isEqualToString:@"102"]) {
              context = @"微信";
            }else{
             context = @"支付宝";

            }
        }
        if ([_titleArr[indexPath.row] isEqualToString:@"订单金额"] ||[_titleArr[indexPath.row] isEqualToString:@"已退金额"] || [_titleArr[indexPath.row] isEqualToString:@"可退金额"]) {
            
           NSString *money =  [CyTools  folatByStr:context];
            cell.contLab.text = money ;
 
        }else{
            cell.contLab.text = [NSString stringWithFormat:@"%@",context];

            
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
    //    footer.delegete = self;
    return footer;
    
}
////组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
 return 68 +10;
    
}
#pragma mark RefundOperationDelegate
-(void)tableReloadBy:(BOOL)isSuccess{
    
    if (isSuccess) {
        NSLog(@"退款成功");
        /**
         11.29 修改了延时时间（退款操作后，用户可能直接返回了）
         */

        [self performSelector:@selector(postData) withObject:nil afterDelay:.1];
        
    }else{
        NSLog(@"退款失败");
  
        
    }
}
@end
