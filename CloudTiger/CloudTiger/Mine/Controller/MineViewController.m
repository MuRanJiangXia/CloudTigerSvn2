//
//  MineViewController.m
//  CloudTiger
//
//  Created by cyan on 16/9/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MineCell.h"
#import "ChangePassWordViewController.h"
#import "PersonViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CyanManager *_cyanManager;

    NSArray *_mineArr;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation MineViewController

/**首页不能侧滑返回*/
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    self.title = @"我的";
    self.view.backgroundColor = PaleColor;
    _cyanManager = [CyanManager shareSingleTon];
    if ([_cyanManager.customersType isEqualToString:@"1"]) {//商户员工 ||商户
         _mineArr = @[@"修改密码",@"账户信息"];
        
    }else{//其他
         _mineArr = @[@"修改密码"];
    }
  
    [self.view addSubview:self.table];
  
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, MainScreenHeight - 64 - 49 -70, MainScreenWidth -30, 50);
//    button.backgroundColor = UIColorFromRGB(0xd9534f, 1);
    [button setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0xd9534f, 1) ] forState:UIControlStateNormal];
        [button setBackgroundImage:[CyTools imageWithColor:UIColorFromRGB(0xe17572, 1) ] forState:UIControlStateHighlighted];
    [button setTitle:@"退出账号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
//    button.layer.borderColor = [UIColor blueColor].CGColor;
//    button.layer.borderWidth = 1;
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStylePlain];
        
        [_table registerClass:[MineCell class] forCellReuseIdentifier:@"MineCell"];
        
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mineArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = _mineArr[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChangePassWordViewController *change = [ChangePassWordViewController new];
        change.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:change animated:YES];
    }else{
        
        PersonViewController *person = [PersonViewController new];
        person.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:person animated:YES];
    }
    
    
}
@end
