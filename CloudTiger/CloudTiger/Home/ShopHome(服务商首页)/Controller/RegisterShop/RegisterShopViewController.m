//
//  RegisterShopViewController.m
//  CloudTiger
//
//  Created by cyan on 16/12/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RegisterShopViewController.h"
#import "PassWordModel.h"
//#import "PassWordCell.h"
#import "RegisterShopCell.h"
#import "RegisterShopCell2.h"
#import "RegisterShopFooter.h"
#import "RegisterShopCell3.h"


@interface RegisterShopViewController ()<UITableViewDelegate,UITableViewDataSource,RegisterShopDelegate,RegisterShopFooterDelegate,RegisterShopAddressDelegate>{
    NSArray *_mineArr;
    NSMutableArray *_cellArr;
    CyanManager *_cyanManager;

    
    BOOL _isChooseAllAddress;//是否全部选择了省市地区
    NSString *_showAddress;//显示的 地址

}
@property(nonatomic,strong)UITableView *table;

@end

@implementation RegisterShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户注册";
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.table];
    /**底部返回首页按钮*/
    [self homeBtnView];
    [self loadData];
    
}
-(void)loadData{
    
    /**
     用户名   Customer （用户名只能 是手机号，同联系电话）
     密码           Pwd
     门店名称   CustomerName
     
     邮箱  Email
     联系电话  Phone（不可编辑 同用户名）
     
     用户ID   SystemUserSysNo
     费率    Rate （默认 0.006）
     邮编  DwellZip
     
     
     省ID|市ID|区ID    DwellAddressID
     省市区-详细地址  DwellAddress
     传真  Fax
     
     商户类型,（0服务商1商户）（传 1） CustomersType
     传 1  Vip_CustomerType
     */
    _mineArr  = @[  @{@"Customer":@"用户名"},//（用户名只能 是手机号，同联系电话）
                    @{@"Pwd":@"密码"},
                    @{@"RePwd":@"重复密码"},//不需要传本地判断
                    @{@"CustomerName":@"门店名称"},
                    @{@"Email":@"邮箱"},
                    @{@"Phone":@"联系电话"},//（不可编辑 同用户名）
                    @{@"SystemUserSysNo":@"员工ID"},
                    @{@"Rate":@"商户费率"},//（默认 0.006）
                    @{@"DwellZip":@"邮编"},
                    @{@"DwellAddressID":@"省|市|区"},
                    @{@"DwellAddress":@"详细地址"},
                    @{@"Fax":@"传真"},
                    @{@"bank":@"中信银行"}//不传（备用）

                    ];
    
    _cellArr = [NSMutableArray new];
    for (NSInteger index = 0; index < _mineArr.count; index++) {
        NSDictionary *dic = _mineArr[index];
        
        PassWordModel *passModel = [[PassWordModel alloc]init];
        passModel.titleKey = dic.allKeys[0];
        passModel.title = [dic valueForKey:passModel.titleKey];
        if (index == 6) {
            passModel.cellText = [NSString stringWithFormat:@"%@",self.staffSysNo] ;
//            passModel.cellText = @"123456";

            
        }else if (index == 7) {
            passModel.cellText = @"0.006";
        }
        else{
            passModel.cellText = @"";
  
        }
        [_cellArr addObject:passModel];
    }
    
    
    [self.table reloadData];
}

-(void)registerShopPostBy:(NSDictionary *)postDic{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    if (!postDic.count) {
        NSLog(@"字典是空");
        return;
    }
    
    NSString *url = [BaseUrl stringByAppendingString:RegisterShopUrl];
    [self showSVPByStatus:@"加载中..."];
    [manager POST:url parameters:postDic progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject : %@",responseObject);
        
        [self dismissSVP];
        NSInteger Code = [responseObject[@"Code"] integerValue];
        
        if (Code == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [MessageView showMessage:@"注册成功"];
            
        }else{
            
            [self alterWith:@"注册失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        [self alterWith:@"注册失败"];
        NSLog(@"error : %@",error);

    }];
    
}


#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[RegisterShopCell class] forCellReuseIdentifier:@"RegisterShopCell"];
        [_table registerClass:[RegisterShopCell2 class] forCellReuseIdentifier:@"RegisterShopCell2"];
        [_table registerClass:[RegisterShopCell3 class] forCellReuseIdentifier:@"RegisterShopCell3"];

        
        [_table registerClass:[RegisterShopFooter class] forHeaderFooterViewReuseIdentifier:@"RegisterShopFooter"];
        
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
    
    if (indexPath.row == 9) {
        RegisterShopCell2  *cell =  [tableView dequeueReusableCellWithIdentifier:@"RegisterShopCell2" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.delegete = self;
        return cell;
    }else if (indexPath.row == _mineArr.count -1){
        
        RegisterShopCell3  *cell =  [tableView dequeueReusableCellWithIdentifier:@"RegisterShopCell3" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.indexPath = indexPath;
//        cell.delegete = self;
        return cell;
        
    }
    else{
        RegisterShopCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"RegisterShopCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;

        cell.passWordModel = _cellArr[indexPath.row];
        cell.delegete = self;
        cell.isEdite = YES;

 
        
        return cell; 
        
    }

}

//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    RegisterShopFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RegisterShopFooter"];
    footer.delegete = self;
    return footer;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {//地址
        return 180;
    }
    return 60;
}


//组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 60  + 68 +10;
}


#pragma mark RegisterShopDelegate

-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath{
    
    PassWordModel *passModel =   _cellArr[indexPath.row];
    passModel.cellText = text;
    
    if (indexPath.row == 0) {
        PassWordModel *passModel2 =   _cellArr[5];
        passModel2.cellText = text;
        //一个cell刷新
        NSIndexPath *indexPa =[NSIndexPath indexPathForRow:5 inSection:0];
        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPa,nil] withRowAnimation:UITableViewRowAnimationNone];

    }
//    [self.table reloadData];
    NSLog(@"text :%@ section :%ld",text,indexPath.row);
    
}

#pragma mark RegisterShopAddressDelegate
-(void)messWithAdress:(NSArray *)addressArr ByIndexPath:(NSIndexPath *)indexPath{
    //数组 有三个  ：省，市，区
    /**
     AddressName 名字， SysNo 地址id
     {
     AddressName = "\U5bc6\U4e91\U53bf";
     "Parent_id" = 35;
     Priority = 422;
     SysNo = 422;
     }
     */
    NSString *addressID = @"";
    for (NSInteger index = 0; index < addressArr.count; index ++) {
        NSDictionary *dic = addressArr[index];
        NSString *SysNo = dic[@"SysNo"];
        
        if (index == addressArr.count-1) {
          addressID =   [addressID stringByAppendingFormat:@"%@",SysNo];

        }else{
          addressID =   [addressID stringByAppendingFormat:@"%@|",SysNo];

        }
    }
    PassWordModel *passModel =   _cellArr[indexPath.row];
    passModel.cellText = addressID;
    
    //判断地区是否全部选择完毕
    NSArray *arr = [addressID componentsSeparatedByString:@"|"];
    NSString *countyId = arr[arr.count -1];
    if (countyId.length) {
        NSLog(@"地区全部选择完毕");
        //全部选择完毕 把中文地址取出来
        NSString *addressShow = @"";
        
        for (NSInteger index = 0;index < addressArr.count; index ++) {
            NSDictionary *dic = addressArr[index];
            
            NSString *porStr = dic[@"AddressName"];
            addressShow =   [addressShow stringByAppendingFormat:@"%@",porStr];
        }
        _showAddress = addressShow;
        
        _isChooseAllAddress = YES;
    }else{
        _isChooseAllAddress = NO;
        NSLog(@"地区没有选全");

    }
    
    NSLog(@"addressArr : %@ ,addressID : %@",addressArr,addressID);
}

#pragma mark RegisterShopFooterDelegate
-(void)registerSureAction{
    
    NSLog(@"确定，，，");
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];
    if (!_isChooseAllAddress) {
        [MessageView showMessage:@"地区没有选择完毕"];
        NSLog(@"地区没有选择完毕");
        return;
    }
    PassWordModel *userModel =   _cellArr[0];
    PassWordModel *passModel =   _cellArr[1];
    PassWordModel *passModel2 =   _cellArr[2];
    PassWordModel *passModel3 =   _cellArr[3];
    PassWordModel *passModel4 =   _cellArr[4];

    PassWordModel *passModel10 =   _cellArr[10];//详细地址

    if (![CyTools checkPhoneNumberBy:userModel.cellText]) {
        [MessageView showMessage:@"用户名非手机号"];

        return;
    }
    if (!passModel.cellText.length) {
        [MessageView showMessage:@"密码为空"];

        return;
    }
    if (![passModel.cellText isEqualToString:passModel2.cellText]) {
        NSLog(@"密码与重复密码不相同");
        
        [MessageView showMessage:@"密码与重复密码不相同"];
        return;
    }

    if (!passModel3.cellText.length) {
        [MessageView showMessage:@"名店名称不能为空"];
        return;
    }
   
    if (! [CyTools isValidateEmail:passModel4.cellText]) {
        [MessageView showMessage:@"邮箱填写不正确"];
        return;
    }
    if (!passModel10.cellText.length) {
        [MessageView showMessage:@"详细地址不能为空"];
        return;
    }
    
    NSLog(@"cellText : %@",passModel.cellText);
//    RePwd  bank
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    for (NSInteger index = 0; index < _cellArr.count; index++) {
        
        PassWordModel *passModel =  _cellArr[index];
        if ([passModel.titleKey isEqualToString:@"RePwd"]||[passModel.titleKey isEqualToString:@"bank"]) {
            NSLog(@"重复密码，银行不传");
     
        } else if ([passModel.titleKey isEqualToString:@"DwellAddress"]){
            
            NSString *address = [_showAddress  stringByAppendingFormat:@"-%@",passModel.cellText];
            [parameter setObject:address forKey:passModel.titleKey];
        }
        else{
            [parameter setObject:passModel.cellText forKey:passModel.titleKey];

        }

    }
    
    /**
     用户名   Customer （用户名只能 是手机号，同联系电话）
     密码           Pwd
     门店名称   CustomerName
     
     邮箱  Email
     联系电话  Phone（不可编辑 同用户名）
     
     用户ID   SystemUserSysNo
     费率    Rate （默认 0.006）
     邮编  DwellZip
     
     
     省ID|市ID|区ID    DwellAddressID
     省市区-详细地址  DwellAddress
     传真  Fax
     
     商户类型,（0服务商1商户）（传 1） CustomersType
     传 1  Vip_CustomerType
     */
    
    [parameter setObject:self.staffSysNo forKey:@"SystemUserSysNo"];
    [parameter setObject:@"1" forKey:@"CustomersType"];
    [parameter setObject:@"1" forKey:@"Vip_CustomerType"];

    
    [self registerShopPostBy:parameter];
    NSLog(@"parameter : %@",parameter);
    
}

@end
