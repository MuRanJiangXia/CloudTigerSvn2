//
//  ChangePassWordViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/28.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "PassWordCell.h"
#import "PassWordModel.h"
@interface ChangePassWordViewController ()<UITableViewDelegate,UITableViewDataSource,PassWordCellDelegate>{
    CyanManager *_cyanManager;
    NSArray *_mineArr;
    NSMutableArray *_cellArr;

}
@property(nonatomic,strong)UITableView *table;

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = PaleColor;
    
    [self.view addSubview:self.table];
    _cyanManager = [CyanManager shareSingleTon];
    [self loadData];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, MainScreenHeight - 50 -64 , MainScreenWidth - 30, 40);
    button.backgroundColor = BlueColor;
    [button setTitle:@"修改密码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changePassWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
//    button.layer.borderColor = [UIColor blueColor].CGColor;
//    button.layer.borderWidth = 1;
    
    
}
/**
 重写返回方法，收键盘
 */
-(void)backAction{
    [super backAction];
//    [moneyText resignFirstResponder];
    [_table endEditing:YES];

    
}

-(void)changePassWord:(UIButton *)btn{
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];
    
    NSLog(@"修改密码");
    PassWordModel *oldPassModel =  _cellArr[1];
    PassWordModel *passModel =  _cellArr[2];
    PassWordModel *passModel2 =  _cellArr[3];

    NSString *oldPassWord = oldPassModel.cellText;
    
    NSString *newPassWord = passModel.cellText;
    NSString *rePassWord = passModel2.cellText;
    
    if (oldPassWord.length == 0) {
        [MessageView showMessage:@"原密码为空"];
        return;
    }
    if (newPassWord.length == 0) {
        [MessageView showMessage:@"新密码为空"];
        return;
    }
    
    if (rePassWord.length == 0) {
        [MessageView showMessage:@"重复密码为空"];
        return;
    }
    if (![newPassWord isEqualToString:rePassWord]) {
        [MessageView showMessage:@"重复密码与新密码不同"];
        NSLog(@"重复密码填写bu正确");
        return;
  
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    for (NSInteger index = 0; index < _cellArr.count; index++) {
        if (index == 1 || index == 2) {//只获取原密码和新密码
            PassWordModel *passModel =  _cellArr[index];
            [parameter setObject:passModel.cellText forKey:passModel.titleKey];
        }

        
    }
    
    [parameter setObject:_cyanManager.sysNO forKey:@"SysNo"];
    //服务商
    //
    /*
     SysNo 主键
     OldPassWord 老密码
     NewPassWord 新密码
     */
    //员工
    
    //
    /*
     SysNo 主键
     OldPassWord 老密码
     Password 新密码
     edituser 编辑人
     */
    NSLog(@"parameter : %@ \n ",parameter);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSString *url = @"";
    if ([_cyanManager.isStaff isEqualToString:@"0"]) {//商户
        url = [BaseUrl stringByAppendingString:ChangePassWordShopUrl];

    }else{
        url = [BaseUrl stringByAppendingString:ChangePassWordStaffUrl];

    }
    [self showSVPByStatus:@"加载中..."];
  [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
      ;
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      [self dismissSVP];
      NSLog(@"responseObject :%@",responseObject);
      NSInteger Code = [responseObject[@"Code"] integerValue];
      NSString *Description = responseObject[@"Description"];
      if (Code == 0) {
          [MessageView showMessage:@"修改密码成功"];
          [self performSelector:@selector(backTop) withObject:nil afterDelay:.5];
      }else{
          NSLog(@"%@",Description);
          [MessageView showMessage:Description];

      }
      
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      NSLog(@"error : %@",error);
      [self dismissSVP];

  }];

}


-(void)backTop{
    
    [self backAction];
}
-(void)loadData{
 
    NSString *name =   _cyanManager.loginName;
    if ([_cyanManager.isStaff isEqualToString:@"0"]) {//商户
        _mineArr  = @[  @{@"name":@"用户名"},
                        @{@"OldPassWord":@"原密码"},
                        @{@"NewPassWord":@"新密码"},
                        @{@"more_pass":@"重复密码"}
                        
                        ];
        
    }else{
        _mineArr  = @[  @{@"name":@"用户名"},
                        @{@"OldPassWord":@"原密码"},
                        @{@"Password":@"新密码"},
                        @{@"more_pass":@"重复密码"}
                        ];
        
    }

    
    _cellArr = [NSMutableArray new];
    for (NSInteger index = 0; index < _mineArr.count; index++) {
        NSDictionary *dic = _mineArr[index];
        
        PassWordModel *passModel = [[PassWordModel alloc]init];
        passModel.titleKey = dic.allKeys[0];
        passModel.title = [dic valueForKey:passModel.titleKey];
        if (index == 0) {
            passModel.cellText = name;
        }else{
            passModel.cellText = @"";

            
        }
        [_cellArr addObject:passModel];
    }

    
    [self.table reloadData];
}
#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStylePlain];
        
        [_table registerClass:[PassWordCell class] forCellReuseIdentifier:@"PassWordCell"];
        
        _table.delegate = self;
        _table.dataSource = self;
        //
        _table.backgroundColor =   PaleColor;
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
    return _mineArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PassWordCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"PassWordCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.passWordModel = _cellArr[indexPath.row];
    cell.delegete = self;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        ChangePassWordViewController *change = [ChangePassWordViewController new];
//        change.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:change animated:YES];
//    }else{
//        
//        PersonViewController *person = [PersonViewController new];
//        person.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:person animated:YES];
//    }
//    
//    
//}



#pragma mark PassWordCellDelegate
-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath{
    PassWordModel *passModel =   _cellArr[indexPath.row];
    passModel.cellText = text;
    [self.table reloadData];
    NSLog(@"text :%@ section :%ld",text,indexPath.row);
    
}

@end
