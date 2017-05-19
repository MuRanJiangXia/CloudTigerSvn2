//
//  StaffHomeViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffHomeViewController.h"
#import "StaffHomeCell.h"
#import "StaffHomeCell2.h"
#import "StaffHomeTopView.h"
#import "StaffHomeFooterView.h"
#import "StaffModel.h"
#import "QueryViewController.h"
#import "QueryWXOrderViewController.h"
#import "QueryAliOrderViewController.h"
#import "RefundViewController.h"
#import "RefundQueryViewController.h"
#import "CodeViewController.h"
#import "ShopQueryViewController.h"
#import "LoginViewController.h"
#import "SYQRCodeViewController.h"
#import "CodePostViewController.h"
#import "CodePayViewController.h"
#import "StaffCodeViewController.h"
#import "QueryRateViewController.h"
#import "SBJSON.h"

@interface StaffHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ChooseHeaderDelegate>{
    
    NSMutableArray *_staffCellArr;
    CyanManager *_cyanManager;
    NSIndexPath *_chooseIndexPath;
    
    NSArray *_powerArr;
}
@property(nonatomic,strong)UICollectionView *staffCollection;

@end

@implementation StaffHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    _cyanManager  = [CyanManager shareSingleTon];
    BOOL isLogin =  [CyTools isLoginSuccess];
    if (isLogin) {//完全登录成功
//
     
    }else{
#pragma 第一次登陆获取权限(测试用)
        [self showSVPByStatus:@"加载中..."];
//        [self loadStaffPower];
    }
 
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PaleColor;
    _cyanManager = [CyanManager shareSingleTon];
    
    NSLog(@"员工首页");
    [self.view addSubview:self.staffCollection];
    [self loadData];
    
    BOOL isLogin =  [CyTools isLoginSuccess];
    if (isLogin) {
        
        /**
         判断 权限是否为空
         如果是空 就加载
         如果不是空 就加载
         */
        
        NSArray *fiter = (NSArray *)[List objectForKey:UserPowers] ;
       
        if (fiter.count) {
            NSArray *arr ;
            if ([_cyanManager.customersType isEqualToString:@"0"]) {//0代表服务商员工
                arr = @[CyanTopRateOrder,CyanRateOrder,CyanOrderQuery,CyanShopQuery];
                
            }else{
                arr = @[CyanWXOrderQuery,CyanAliOrderQuery,CyanRefund,CyanRefundQuery,CyanPayCode,CyanRateOrder,CyanCount,CyanAliScanPay,CyanWXScanPay,CyanPayCode,CyanOrderQuery];
                
            }
           [self  reloagUI:fiter By:arr];
        }else{
            [self showSVPByStatus:@"加载中..."];
            [self loadStaffPower];
        }

    }
    

   
}

/**
服务商员工
 
 上级费率订单查询       "/OrderFund/orderfund?Top=1"
 费率订单查询          "/OrderFund/orderfund"
 
 交易订单查询          "/Order/order_search"
 商户查询             "/Business/business"
 
 */

/**
 微信订单平台查询    "/Order/platform_order_search"
 支付宝订单平台查询   "/Order/order_search_alipay"
 退款     "/Refund/refund"
 退款查询   "/RefundSearch/refund_search"
 "员工二维码"  "/Qrcode/index"
 费率订单查询   "/OrderFund/orderfund"
 统计  “count/cyan”  //没有 假的数据
 
 支付宝扫码支付   "/Pay/scan_code_payment_Alipay"
 微信扫码支付    "/Pay/scan_code_payment"
 支付二维码  "/Wxpay/native"
 交易订单查询  "/Order/order_search"
 */

/**获取员工权限*/
-(void)loadStaffPower{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *json = [writer stringWithObject:self.paramters];
    
    NSDictionary *parameters = @{
                                 @"SystemUserSysNo":_cyanManager.sysNO
                                 
                                 };
    
    //    该员工权限
    NSString *url  =[BaseUrl stringByAppendingString:StaffHavePowerUrl]; ;
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissSVP];

        
        NSLog(@"responseObject : %@",responseObject);
        NSMutableArray *powerArr = [NSMutableArray array];
        NSArray *modelArr = responseObject;
        for (NSInteger index = 0; index < modelArr.count; index ++) {
            
            NSDictionary *dic = modelArr[index];
            NSString *URL = dic[@"URL"];
            [powerArr addObject:URL];
        }
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",powerArr];
        NSArray *arr2;
        if ([_cyanManager.customersType isEqualToString:@"0"]) {//0代表服务商员工
            //        上级费率订单查  费率订单查询 交易订单查询  商户查询
            //            arr2 = @[@"/OrderFund/orderfund?Top=1",@"/OrderFund/orderfund",@"/Order/order_search",@"/Business/business"];
            
            arr2 = @[CyanTopRateOrder,CyanRateOrder,CyanOrderQuery,CyanShopQuery];
            
        }else{
            //微信订单平台查询  支付宝订单平台查询 退款  退款查询  "支付二维码"   费率订单查询  统计
            //支付宝扫码支付 微信扫码支付 支付二维码   交易订单查询
            //            arr2 = @[@"/Order/platform_order_search",@"/Order/order_search_alipay",@"/Refund/refund",@"/RefundSearch/refund_search",@"/Wxpay/native",@"/OrderFund/orderfund",@"count/cyan",@"/Pay/scan_code_payment_Alipay",@"/Pay/scan_code_payment",@"/Wxpay/native",@"/Order/order_search"];
            arr2 = @[CyanWXOrderQuery,CyanAliOrderQuery,CyanRefund,CyanRefundQuery,CyanPayCode,CyanRateOrder,CyanCount,CyanAliScanPay,CyanWXScanPay,CyanPayCode,CyanOrderQuery];
            
        }
        //filter 是最终获取的权限
        NSArray * filter = [arr2 filteredArrayUsingPredicate:filterPredicate];
        [self  reloagUI:filter By:arr2];
        
        /**
         2017,5,3  保存权限不在每次将要初始化的时候加载了
         */
        //保存本地
        [List  setObject:filter forKey:UserPowers];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@",error);
#pragma mark 需要跳转登录页
        [self dismissSVP];
        
        [MessageView showMessage:@"获取员工权限失败"];
        [self performSelector:@selector(loginOut) withObject:nil afterDelay:1];
    }];
    
}

/**
 根据权限刷新 UI

 @param filter 当前用户拥有的权限
 @param arr2 所有权限
 */
-(void)reloagUI:(NSArray *)filter By:(NSArray *)arr2{
    
    
    NSLog(@"filter : %@",filter);
    
    //        filter = @[@"/OrderFund/orderfund?Top=1"];
    _cyanManager.powers = filter;
    //商户下员工 获取一下  扫码权限
    if ([_cyanManager.customersType isEqualToString:@"1"]) {
        NSInteger powerIndex = [filter indexOfObject:CyanAliScanPay ];
        NSInteger powerIndex2 = [filter indexOfObject:CyanWXScanPay];
        
        if (powerIndex == NSNotFound&& powerIndex2 == NSNotFound) {
            _cyanManager.payState = kNoPay;
        }else{
            if (powerIndex == NSNotFound) {
                _cyanManager.payState = kWXPay;
                
            }else if (powerIndex2 == NSNotFound){
                
                _cyanManager.payState = kAliPay;
                
            }else{
                _cyanManager.payState = kAllPay;
                
                
            }
            
        }
        
        
    }
    
    [List removeObjectForKey:@"payState"];
    
    
    
  NSArray *arr =   [List objectForKey:@"UserPowers"];

  NSLog(@"arr : %@",arr);
    
//    [List removeObjectForKey:UserPowers];
//    [List removeObjectForKey:@"payState"];

    
    for (NSInteger index = 0; index < _staffCellArr.count ; index ++) {
        NSString *power = arr2[index];
        NSInteger powerIndex = [filter indexOfObject:power];
        if (powerIndex != NSNotFound) {
            StaffModel *staffModel = _staffCellArr[index];
            staffModel.isHave = YES;
        }
        
    }
    //测试 权限为空
    //        filter = @[@"/Business/business"];
    _powerArr = filter;
    
    
    [self.staffCollection reloadData];
}


-(void)loginOut{
    LoginViewController *login = [LoginViewController new];
    UIWindow* window =  [UIApplication sharedApplication].keyWindow;
    window.rootViewController = login;
    
    /**
     tabbar  需要从新刷新
     */
    CyanManager  *cyManager = [CyanManager shareSingleTon];
    cyManager.isLoadTabar = YES;
    [CyTools loginException];

}

-(void)loadData{
    
    NSLog(@"customersType : %@",_cyanManager.customersType);
    if ([_cyanManager.customersType isEqualToString:@"0"]) {//服务商下员工
        NSArray *orderDisabledArr = @[@"top_rate_query_d",@"rate_query_d"];
        NSArray *orderArr = @[@"top_rate_query_n",@"rate_query_n"];
        NSArray *orderSelectedArr = @[@"top_rate_query_n",@"rate_query_n"];
        NSArray *titleArr = @[@"上级费率订单",@"费率订单"];
        _staffCellArr = [NSMutableArray new];
        for (NSInteger index = 0; index < titleArr.count; index ++) {
            StaffModel *model = [[StaffModel alloc]init];
            model.btnNormal = orderArr[index];
            model.btnSelected = orderSelectedArr[index];
            model.btnDisabled = orderDisabledArr[index];
            model.title = titleArr[index];
            [_staffCellArr addObject:model];
        }
        
        [self.staffCollection reloadData];
        
    }else if ([_cyanManager.customersType isEqualToString:@"1"]) {//商户下员工
        NSArray *orderDisabledArr = @[@"staff_wx_disabled",@"staff_alipay_disabled",@"staff_remoney_disabled",@"staff_refund_disabled",@"staff_pay_code_d",@"rate_query_d",@"staff_count_disabled"];

        //top_rate_query_n rate_query_n
        NSArray *orderArr = @[@"staff_wx_normal",@"staff_alipay_normal",@"staff_remoney_normal",@"staff_refund_normal",@"staff_pay_code_n",@"rate_query_n",@"staff_count_normal"];
        NSArray *orderSelectedArr = @[@"staff_wx_selected",@"staff_alipay_selected",@"staff_remoney_selected",@"staff_refund_selected",@"staff_pay_code_n",@"rate_query_n",@"staff_count_selected"];
        NSArray *titleArr = @[@"微信订单",@"支付宝订单",@"退款",@"退款查询",@"支付二维码",@"费率订单",@"统计"];
        _staffCellArr = [NSMutableArray new];
        for (NSInteger index = 0; index < titleArr.count; index ++) {
            StaffModel *model = [[StaffModel alloc]init];
            model.btnDisabled = orderDisabledArr[index];
            model.btnNormal = orderArr[index];
            model.btnSelected = orderSelectedArr[index];
            model.title = titleArr[index];
            [_staffCellArr addObject:model];
        }
        
        [self.staffCollection reloadData];
    }

}
#pragma mark -- collection
-(UICollectionView *)staffCollection{
    
    if (!_staffCollection) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing=0;
        layout.minimumLineSpacing=0;
        _staffCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -49)  collectionViewLayout:layout];
        _staffCollection.delegate=self;
        _staffCollection.dataSource=self;
        _staffCollection.showsVerticalScrollIndicator=NO;
        _staffCollection.showsHorizontalScrollIndicator=NO;
        _staffCollection.backgroundColor=PaleColor;
#pragma mark -- 注册单元格
        [_staffCollection registerClass:[StaffHomeCell class] forCellWithReuseIdentifier:@"StaffHomeCell"];
        [_staffCollection registerClass:[StaffHomeCell2 class] forCellWithReuseIdentifier:@"StaffHomeCell2"];

#pragma mark -- 注册头部视图
        [_staffCollection registerClass:[StaffHomeTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StaffHomeTopView"];
        
#pragma mark -- 注册尾视图
        [_staffCollection registerClass:[StaffHomeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"StaffHomeFooterView"];
    }
    return _staffCollection;
}


#pragma mark UICollectionViewDataSource
//分组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;//推荐
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _staffCellArr.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    StaffHomeCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StaffHomeCell" forIndexPath:indexPath];
    cell.model  = _staffCellArr[indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    //        cell.selectedBackgroundView.backgroundColor = [UIColor yellowColor];
    return cell;
  
    
}

//组头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        StaffHomeTopView * top = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StaffHomeTopView" forIndexPath:indexPath];
        top.delegete = self;
        top.isShopStaff  = _cyanManager.customersType;
        top.powerArr = _powerArr;
        return top;
    }else{
        
        /**
         9.29 去掉 轮播尾视图
         
         */
//        StaffHomeFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"StaffHomeFooterView" forIndexPath:indexPath];
//        
//        return footer;
        UICollectionReusableView *view = [[UICollectionReusableView alloc]init];
        return view;
        
    }
    
}
//每组里item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(MainScreenWidth /4.0, MainScreenWidth /4.0);
    
}
//头
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(MainScreenWidth, 280);
}
//尾
//每个section的footer
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
//    return CGSizeMake(MainScreenWidth,100);
    return CGSizeMake(0,0);

}
//
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StaffModel *model = _staffCellArr[indexPath.row];
    
    if (!model.isHave) {
//        [self alterWith:@"没有该权限"];
        NSLog(@"没有该权限");

        return;
    }
    
    if ([_cyanManager.customersType isEqualToString:@"0"]) {//服务商
        switch (indexPath.row) {
            case 0:
            {
                //上级费率订单
                QueryRateViewController *shop = [QueryRateViewController new];
                shop.hidesBottomBarWhenPushed = YES;
                shop.queryOrderState = kTopCustomerUserRate;
                [self.navigationController pushViewController:shop animated:YES];
                
                NSLog(@"上级费率");
            }
                break;
                
            case 1:
            {
                NSLog(@"费率");
                
                QueryRateViewController *shop = [QueryRateViewController new];
                shop.queryOrderState = kOrderCustomerUser;
                shop.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:shop animated:YES];
                
                
            }
                break;
            default:
                break;
        }
        
        
    }else{
        
        switch (indexPath.row) {//商户
            case 0:
            {
                QueryWXOrderViewController *query = [QueryWXOrderViewController new];
                query.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:query animated:YES];
            }
                break;
                
            case 1:
            {
                QueryAliOrderViewController *query = [QueryAliOrderViewController new];
                query.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:query animated:YES];
            }
                break;
            case 2:
            {    RefundViewController *refund = [RefundViewController new];
                refund.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:refund animated:YES];
            }
                break;
            case 3:
            {
                RefundQueryViewController *refund = [RefundQueryViewController new];
                refund.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:refund animated:YES];
            }
                break;
            case 4:
            {
                StaffCodeViewController *staff  = [StaffCodeViewController new];
                staff.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:staff animated:YES];
                
            }
                break;
            case 5:
            {
                QueryRateViewController *shop = [QueryRateViewController new];
                shop.queryOrderState = kOrderShopUser;
                shop.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:shop animated:YES];
            }
                break;
                
                
            default:
                break;
        }
 
    }

    

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

//    
}
/*
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_cyanManager.customersType isEqualToString:@"0"]) {
        return YES;
    }else{
        StaffHomeCell  *cell = (StaffHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor yellowColor];
        return YES;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{

    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_cyanManager.customersType isEqualToString:@"0"]) {
        return;
    }
    StaffHomeCell  *cell = (StaffHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
}
 */

#pragma mark  ChooseHeaderDelegate
-(void)chooseIndex:(NSInteger)index{
    
    //            kOrderShop   = 0,//商户订单查询
    //            kOrderShopUser        =  10,//商户员工订单查询
    //            kOrderCustomer   = 20 ,//服务商订单查询
    //            kOrderCustomerUser = 30//服务商员工订单查询
    if ([_cyanManager.customersType isEqualToString:@"0"]) {//服务商员工
        switch (index) {
            case 0:
            {
                NSLog(@"订单查询");
                QueryViewController *query =[QueryViewController new];
                query.hidesBottomBarWhenPushed = YES;
                query.queryOrderState = kOrderCustomerUser;
                [self.navigationController pushViewController:query animated:YES];
            }
                break;
            case 1:
            {
                NSLog(@"商户查询");
                ShopQueryViewController *code = [ShopQueryViewController new];
                code.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:code animated:YES];
            }
                break;
       
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
            {
                NSLog(@"智能扫码");
                CodePayViewController *codePay = [CodePayViewController new];
                codePay.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:codePay animated:YES];
                
         
            }
                break;
            case 1:
            {
                NSLog(@"二维码");
                CodeViewController *code = [CodeViewController new];
                code.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:code animated:YES];
            }
                break;
            case 2:
            {
                NSLog(@"订单查询");
                QueryViewController *query =[QueryViewController new];
                query.hidesBottomBarWhenPushed = YES;
                query.queryOrderState = kOrderShopUser;
                [self.navigationController pushViewController:query animated:YES];
                
            }
                break;
            default:
                break;
        }
    }

}

-(void)jumpMine{
    NSLog(@"跳转mine");
    TabBarViewController *tabVC=[TabBarViewController share];
    tabVC.selectedIndex = 3;
}
@end
