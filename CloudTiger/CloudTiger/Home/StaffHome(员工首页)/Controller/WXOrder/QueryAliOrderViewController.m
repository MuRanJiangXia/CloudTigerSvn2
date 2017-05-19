//
//  QueryAliOrderViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/14.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryAliOrderViewController.h"
#import "QueryAliModel.h"
#import "SBJSON.h"
#import "WXOrderCell.h"
#import "SYQRCodeViewController.h"

@interface QueryAliOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UIButton *queryBtn;
    QueryAliModel *_AliModel;
    UIView *resultView;
    UITextField *_orderTextField;
    NSArray *_titleArr;
    NSArray *_contextArr;

}
@property(nonatomic,strong)UITableView *table;

@end

@implementation QueryAliOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"支付宝订单";
    
    self.view.backgroundColor = PaleColor;
    [self createUI];
    
    [self.view addSubview:self.table];
    self.table.hidden = YES;
    _titleArr = @[@"订单号",@"交易类型",@"交易金额",@"交易币种",@"交易时间",@"交易状态"];

}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, queryBtn.bottom + 10, MainScreenWidth, MainScreenHeight - 64 - queryBtn.bottom -10 ) style:UITableViewStylePlain];
        
        [_table registerClass:[WXOrderCell class] forCellReuseIdentifier:@"WXOrderCell"];
        
        
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
    
    WXOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.firstLab.text = _titleArr[indexPath.row];
    NSString *context = [_AliModel displayCurrentModlePropertyBy:_contextArr[indexPath.row]];
    
    cell.contLab.text = [NSString stringWithFormat:@"%@",context];
//    if ([_titleArr[indexPath.row] isEqualToString:@"交易金额"]) {
//        
//        NSString *money =  [CyTools  folatByStr:context];
//        cell.contLab.text = money ;
//        
//    }else{
//        cell.contLab.text = context;
//        
//        
//    }
    return cell;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
-(void)createUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, MainScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.5 * 3, 60)];
//    label.backgroundColor = [UIColor yellowColor];
    label.text = @"订单号";
    label.textColor = GrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    _orderTextField  = [[UITextField alloc]initWithFrame:CGRectMake(label.right + 10, label.top, MainScreenWidth - label.right-10 -15-60 -5 , 60)];
//    _orderTextField.backgroundColor = [UIColor cyanColor];
    _orderTextField.placeholder = @"订单号";
    _orderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _orderTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _orderTextField.textAlignment= NSTextAlignmentRight;
    _orderTextField.delegate = self;
    [view addSubview:_orderTextField];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(MainScreenWidth - 15 -40 , 10, 40, 40);
//        button.backgroundColor = [UIColor redColor];
    
    [button setBackgroundImage:[UIImage imageNamed:@"code_order_btn"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    queryBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    queryBtn.frame = CGRectMake(15, view.bottom + 10, MainScreenWidth -30, 40);
    queryBtn.backgroundColor = BlueColor;
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(WXOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    
    queryBtn.layer.cornerRadius = 5;
    queryBtn.layer.masksToBounds = YES;

    
    
    
    
}
#pragma mark codeAction

-(void)codeAction:(UIButton *)btn{
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    
    
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        NSLog(@"扫码成功");
        
        NSLog(@"qrString :%@",qrString);
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        _orderTextField.text = qrString;
        
        [self postWX];
        [aqrvc dismissViewControllerAnimated:YES completion:nil];
        
        
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        NSLog(@"扫码失败");
        [aqrvc dismissViewControllerAnimated:YES completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        
        NSLog(@"扫码取消");
        
        [aqrvc dismissViewControllerAnimated:YES completion:nil];
        
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
    
}

-(void)WXOrderAction:(UIButton *)btn{
    [self postWX];
    
}

-(void)postWX{
    [_orderTextField resignFirstResponder];
    if (!_orderTextField.text.length) {
        [self alterWith:@"输入为空"];
        return;
    }
    [self showSVPByStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    CyanManager *cyManager = [CyanManager shareSingleTon];
    NSString *sysNo = cyManager.sysNO;
    
    NSString *orderNum = _orderTextField.text ;
    //  @"133268090120160913141427457"
    NSDictionary *parameters = @{
                                 @"systemUserSysNo":sysNo,
                                 @"out_trade_no":orderNum
                                 
                                 };
    
    NSString *url = [BaseUrl stringByAppendingString:QueryAliOrderUrl];
    
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    
//    NSString *json = [writer stringWithObject:parameters];
    //    20160909150725011992698 支付宝
    //    133268090120160913141427457 微信
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress :%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        NSInteger code = [responseObject[@"Code"] integerValue];
        if (code == 0) {
            NSDictionary *data = responseObject[@"Data"];
        
            
            NSString *wxStr = data[@"WxPayData"];
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            NSDictionary *jsonObjects = [jsonParser objectWithString:wxStr];
            NSDictionary *m_values = jsonObjects[@"alipay_trade_query_response"];
            if (NotNilAndNull(m_values)) {
                _table.hidden = NO;
                
                _AliModel = [[QueryAliModel alloc]init];
                [_AliModel setValuesForKeysWithDictionary:m_values];
                NSLog(@"out_trade_no :%@",_AliModel.trade_no);
                _AliModel.pay_Type = @"支付宝";
                _AliModel.fee_type = @"CNY";
                NSLog(@"total_amount : %@",_AliModel.total_amount);
//                _AliModel.fee_type = @"人民币";
                NSArray *statusArr = @[@"WAIT_BUYER_PAY",@"TRADE_CLOSED",@"TRADE_SUCCESS",@"TRADE_FINISHED"];
                NSInteger index = [statusArr indexOfObject:_AliModel.trade_status];
                NSLog(@"index :%ld",index);
                switch (index) {
                    case 0:
                        _AliModel.trade_status = @"交易创建，等待买家付款";
                        break;
                    case 1:
                        _AliModel.trade_status = @"未付款交易超时关闭，或支付完成后全额退款";
                        break;
                    case 2:
                        _AliModel.trade_status = @"交易支付成功";
                        break;
                    case 3:
                        _AliModel.trade_status = @"交易结束，不可退款";
                        break;
                        
                    default:
                        break;
                        
                }

                _contextArr  = [_AliModel allPropertyNames];
                
                [self.table reloadData];
                
                
            }else{
                _table.hidden = YES;

                
                NSLog(@"m_values is NUll");
                
            }
            
            
            
        }else {
            [MessageView showMessage:@"查无数据"];

            NSLog(@"请求失败");
            _table.hidden = YES;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissSVP];
        _table.hidden = YES;

        
        NSLog(@"error :%@",error);
    }];
    
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
@end
