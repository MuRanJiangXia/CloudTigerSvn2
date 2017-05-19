//
//  PersonViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/28.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonCell.h"
#import "PassWordModel.h"
#import "StaffPersonModel.h"
#import "RegisterShopCell2.h"
#import "PersonFooter.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,PassWordCellDelegate,RegisterShopAddressDelegate,PersonFooterDelegate>{
    
    NSArray *_mineArr;
    NSMutableArray *_cellArr;
    StaffPersonModel *_staffPersonModel;
    CyanManager *_cyanManager;
    
    BOOL _isChooseAllAddress;//是否全部选择了省市地区
    
    NSString *_showAddress;//显示的地址省市区


}

@property(nonatomic,strong)UITableView *table;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号信息";
    self.view.backgroundColor = PaleColor;
    _cyanManager = [CyanManager shareSingleTon];
    [self.view addSubview:self.table];
    self.table.hidden = YES;
    [self loadData];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, MainScreenHeight - 50 -64 , MainScreenWidth - 30, 40);
    button.backgroundColor = BlueColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changePassWord:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;

    
    
}
//修改资料
-(void)changePassWord:(UIButton *)btn{
    /**
     必须 把键盘收起来不然，， 会少穿字段
     */
    [_table endEditing:YES];
    if (!_isChooseAllAddress) {
        [MessageView showMessage:@"地区没有选择完毕"];
        NSLog(@"地区没有选择完毕");
        return;
    }
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    PassWordModel *passModel =  _cellArr[2];
    NSString *phone = passModel.cellText;
    
    if ( ![CyTools checkPhoneNumberBy:phone]) {
        [MessageView showMessage:@"联系电话填写不正确"];
        NSLog(@"联系电话填写不正确");
        return;
    }
    
    PassWordModel *passModel3 =  _cellArr[3];
    NSString *disName = passModel3.cellText;
    
    if (!disName.length) {
        [MessageView showMessage:@"真实姓名填写不正确"];
        return;
    }
    if ([CyTools isContainChinese:disName]) {
        [MessageView showMessage:@"真实姓名填写不正确"];
        return;

    }
    

    PassWordModel *passModel4 =  _cellArr[4];
    NSString *email = passModel4.cellText;
    if (![CyTools isValidateEmail:email]) {
        [MessageView showMessage:@"邮箱填写不正确"];

        NSLog(@"邮箱填写不正确");
        return;
    }
    
//
    PassWordModel *passModel5 =  _cellArr[5];
    NSString *store = passModel5.cellText;
    
    if (store.length) {
        if ([_cyanManager.isStaff isEqualToString:@"1"]) {//商户员工是门店id 商户是传真
            
            if (![ CyTools validateNumberOnly:store]) {
                NSLog(@"1111");
                [MessageView showMessage:@"门店ID填写不正确"];
                return;
            }
        }
     
    }
   
    //
    PassWordModel *passModel7 =  _cellArr[7];
    NSString *address = passModel7.cellText;
    
    if (!address.length) {
        [MessageView showMessage:@"详细地址为空"];

        return;
        
    }
  
    PassWordModel *passModel8 =  _cellArr[8];
    NSString *rate = passModel8.cellText;

    if (! [CyTools isNeedPointBy:rate]) {
        [MessageView showMessage:@"费率填写不正确"];
        
        return;
        
    }
    
    for (NSInteger index = 2; index < _cellArr.count; index++) {//联系电话，真实姓名，邮箱地址，门店id
        PassWordModel *passModel =  _cellArr[index];
        
        [parameter setObject:passModel.cellText forKey:passModel.titleKey];
        
        if (index == 7) {//地址
            NSString *address = [_showAddress  stringByAppendingFormat:@"-%@",passModel.cellText];
            [parameter setObject:address forKey:passModel.titleKey];
        }
    }

    [parameter setObject:_cyanManager.sysNO forKey:@"SysNo"];
    
    NSLog(@"确定修改 parameter：%@",parameter);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSString *url = @"";
    if ([_cyanManager.isStaff isEqualToString:@"1"]) {
        url = [BaseUrl stringByAppendingString:PersonlStaffUrl];
 
    }else{
        
        url = [BaseUrl stringByAppendingString:PersonlShopUrl];

    }
    
    [self showSVPByStatus:@"加载中..."];
    
    [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject : %@",responseObject);
        NSInteger  Code = [responseObject[@"Code"]integerValue];
        NSString *Description  = responseObject[@"Description"];
        
        if (Code == 0) {
            NSLog(@"修改成功");
            [MessageView showMessage:@"修改账号信息成功"];

            [self performSelector:@selector(backTop) withObject:nil afterDelay:.5];
#warning 这里要改一下 
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //保存一下
            /**
             NSString *shopName     = [defaults objectForKey:@"shopName"];
             NSString *shopSysNo       = [defaults objectForKey:@"shopSysNo"];
             NSString *phoneNumber = [defaults objectForKey:@"phoneNumber"];
             NSString *email  = [defaults objectForKey:@"email"];
             NSString *storeID  = [defaults objectForKey:@"storeID"];
             
             manager.shopName = shopName;
             manager.shopSysNo = shopSysNo;
             manager.phoneNumber = phoneNumber;
             manager.email = email;
             manager.storeID =storeID;
             
             
             [defaults setObject:loginName forKey:@"loginName"];
             [defaults setObject:displayName forKey:@"displayName"];
             //                [defaults setObject:passWord forKey:@"passWord"];
             [defaults setObject:customersType forKey:@"customersType"];
             
             */
            CyanManager *manager = [CyanManager shareSingleTon];

            [defaults setObject:disName forKey:@"displayName"];
            [defaults setObject:phone forKey:@"phoneNumber"];
            [defaults setObject:email forKey:@"email"];
            if ([manager.isStaff isEqualToString:@"1"]) {//员工是storeid
                [defaults setObject:store forKey:@"storeID"];
  
            }else{//商户 是 传真
                [defaults setObject:store forKey:@"fax"];
                
            }
           [defaults synchronize];
            manager.displayName = disName;
            manager.phoneNumber = phone;
            manager.email = email;
            manager.storeID = store;
            
        }else{
            
            [MessageView showMessage:Description];
 
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissSVP];
        [MessageView showMessage:@"修改失败"];

        NSLog(@"error :%@",error);
    }];

    
}
-(void)backTop{
    
    [self backAction];
}
//网络请求数据
-(void)loadData{
    CyanManager *cyanManager  = [CyanManager shareSingleTon];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    NSString *url = @"";
    
    if ([_cyanManager.isStaff isEqualToString:@"1"]) {//商户员工
        url = [BaseUrl stringByAppendingString:StaffPersonUrl];
 
    }else{//商户
        url = [BaseUrl stringByAppendingString:ShopQueryUrl];

        
    }
    
    NSDictionary *parameters =@{
                                @"SysNo":cyanManager.sysNO
                                };
    [self showSVPByStatus:@"加载中..."];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];
        NSLog(@"responseObject :%@",responseObject);
        
        self.table.hidden = NO;
        
#warning  商户新增
        
        /**
         主键 SysNo
         商户费率 Rate
         门店名称   CustomerName
         
         邮箱  Email
         
         省ID|市ID|区ID    DwellAddressID
         省市区-详细地址  DwellAddress
         传真  Fax
         */
        NSArray *model =  responseObject[@"model"];
        if (model.count) {
            NSDictionary *dic = model[0];
            _staffPersonModel = [[StaffPersonModel alloc]init];
            [_staffPersonModel setValuesForKeysWithDictionary:dic];
            if ([_cyanManager.isStaff isEqualToString:@"0"]) {//商户
                _staffPersonModel.DisplayName = dic[@"CustomerName"];
                _staffPersonModel.PhoneNumber = dic[@"Phone"];
            }
            
            
        }
        
        [self reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@",error);
        [self dismissSVP];
        [MessageView  showMessage:@"获取失败"];
    }];
    

}
//更新一下tableview
-(void)reloadData{
  
    NSString *identity = @"";
    
    /**
     DepartmentName  部门
     DisplayName  显示名称
     Email  邮箱
     PhoneNumber 电话
     SysNo 主键
     Alipay_store_id 门店ID
     */
    if ([_cyanManager.isStaff isEqualToString:@"1"]) {
        identity = @"商户员工";
        _mineArr  = @[  @{@"name":@"用户名"},
                        @{@"o_pass":@"用户身份"},
                        @{@"PhoneNumber":@"联系电话"},
                        @{@"DisplayName":@"真实姓名"},
                        @{@"Email":@"邮箱地址"},
                        @{@"Alipay_store_id":@"门店ID"},
                        @{@"DwellAddressID":@"省|市|区"},
                        @{@"DwellAddress":@"详细地址"},
                        @{@"Rate":@"员工费率"},
                        
                        ];
        
    }else{
        
#warning  商户新增
        
        /**
         主键 SysNo
         商户费率 Rate
         门店名称   CustomerName
         
         邮箱  Email
         
         省ID|市ID|区ID    DwellAddressID
         省市区-详细地址  DwellAddress
         传真  Fax
         */
        
        identity = @"商户";
        _mineArr  = @[  @{@"name":@"用户名"},
                        @{@"o_pass":@"用户身份"},
                        @{@"Phone":@"联系电话"},
                        @{@"CustomerName":@"真实姓名"},
                        @{@"Email":@"邮箱地址"},
                        @{@"Fax":@"传真"},
                        @{@"DwellAddressID":@"省|市|区"},
                        @{@"DwellAddress":@"详细地址"},
                        @{@"Rate":@"商户费率"},
                        
                        ];
        
    }
    
    _cellArr = [NSMutableArray new];
    for (NSInteger index = 0; index < _mineArr.count; index++) {
        NSDictionary *dic = _mineArr[index];
        
        PassWordModel *passModel = [[PassWordModel alloc]init];
        passModel.titleKey = dic.allKeys[0];
        passModel.title = [dic valueForKey:passModel.titleKey];
        
        switch (index) {
            case 0:
            {
                passModel.cellText = _cyanManager.loginName;
            }
                break;
            case 1:
            {
                passModel.cellText = identity;
            }
                break;
            case 2:
            {    if (IsNilOrNull(_staffPersonModel.PhoneNumber)) {
                passModel.cellText = @"";
                 }else{
                 passModel.cellText =[NSString stringWithFormat:@"%@",_staffPersonModel.   PhoneNumber] ;
                 }
            }
                break;
            case 3:
            {
                if (IsNilOrNull(_staffPersonModel.DisplayName)) {
                passModel.cellText = @"";
                }else{
                passModel.cellText =[NSString stringWithFormat:@"%@",_staffPersonModel.DisplayName];
                }
            }
                break;
            case 4:
            {
                if (IsNilOrNull(_staffPersonModel.Email)) {
                    passModel.cellText = @"";
                }else{
                passModel.cellText = [NSString stringWithFormat:@"%@",_staffPersonModel.Email];
                }
            }
                break;
            case 5:
            {
                
                if ([_cyanManager.isStaff isEqualToString:@"0"]) {
                    if (IsNilOrNull(_staffPersonModel.Alipay_store_id)) {
                        passModel.cellText = @"";
                    }else{
                        passModel.cellText = [NSString stringWithFormat:@"%@",_staffPersonModel.Alipay_store_id];
                    }
                }else{
                    if (IsNilOrNull(_staffPersonModel.Fax)) {
                        passModel.cellText = @"";
                    }else{
                        passModel.cellText = [NSString stringWithFormat:@"%@",_staffPersonModel.Fax];
                    }
                    
                }
                
          
        
            }
                break;
                
                
            case 6://地址
            {
                
                if (IsNilOrNull(_staffPersonModel.DwellAddressID)) {
                    passModel.cellText = @"";
                }else{
                    passModel.cellText = [NSString stringWithFormat:@"%@",_staffPersonModel.DwellAddressID];
                }
                
                //判断地区是否全部选择完毕
                NSArray *arr = [_staffPersonModel.DwellAddressID componentsSeparatedByString:@"|"];
                NSString *countyId = arr[arr.count -1];
                if (countyId.length) {
                    NSLog(@"地区全部选择完毕");
                    _isChooseAllAddress = YES;
                }else{
                    _isChooseAllAddress = NO;
                    NSLog(@"地区没有选全");
                    
                }
            }
                break;
                
            case 7://详细地址
            {
                
                if (IsNilOrNull(_staffPersonModel.DwellAddress)) {
                    passModel.cellText = @"";
                }else{
                    
                    //—  分割符号，前面是省区市区 后边是 详细地址
                  NSArray *arr = [_staffPersonModel.DwellAddress componentsSeparatedByString:@"-"];
                    if (arr.count ==2) {
                        
                        _showAddress = arr[0];
                        _staffPersonModel.DwellAddress = arr[1];
                    }
                    
                    passModel.cellText = [NSString stringWithFormat:@"%@",_staffPersonModel.DwellAddress];
                }
                
        
            }
                break;
                
            case 8://费率
            {
                
                if (IsNilOrNull(_staffPersonModel.Rate)) {
                    passModel.cellText = @"";
                }else{
                    passModel.cellText = [NSString stringWithFormat:@"%@",_staffPersonModel.Rate];
                }
                
            }
                break;
                
            default:
                break;
        }
        [_cellArr addObject:passModel];
    }
    
    
    [self.table reloadData];
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[PersonCell class] forCellReuseIdentifier:@"PersonCell"];
        [_table registerClass:[RegisterShopCell2 class] forCellReuseIdentifier:@"RegisterShopCell2"];
        [_table registerClass:[PersonFooter class] forHeaderFooterViewReuseIdentifier:@"PersonFooter"];
        
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
    if (indexPath.row == 6) {
        
        RegisterShopCell2  *cell =  [tableView dequeueReusableCellWithIdentifier:@"RegisterShopCell2" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        //        cell.passWordModel = _cellArr[indexPath.row];
        
        cell.addressID = _staffPersonModel.DwellAddressID;
        cell.delegete = self;
        return cell;
    }else{
        
        PersonCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.passWordModel = _cellArr[indexPath.row];
        cell.delegete = self;
        return cell;
    }

    
}

//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    PersonFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonFooter"];
    
    footer.delegate = self;
    return footer;
    
}


//组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    
    return 50 + 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return  60 *3;
    }
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

#pragma mark  PersonFooterDelegate
-(void)changePerson:(UIButton *)btn{
    
    [self changePassWord:btn];
}


#pragma mark PassWordCellDelegate

-(void)messWithText:(NSString *)text ByIndexPath:(NSIndexPath *)indexPath{
    PassWordModel *passModel =   _cellArr[indexPath.row];
    passModel.cellText = text;
    [self.table reloadData];
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
    
//    NSLog(@"addressArr : %@ ,addressID : %@",addressArr,addressID);
}



@end
