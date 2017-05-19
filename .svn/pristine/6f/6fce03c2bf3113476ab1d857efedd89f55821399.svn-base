    //
//  StaffPowerDetailVC.m
//  CloudTiger
//
//  Created by cyan on 16/12/7.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StaffPowerDetailVC.h"
#import "RefunOperationCell.h"
#import "BaseOperationCell.h"
#import "CyanLoadFooterView2.h"
#import "StaffPowerOperationVC.h"

@interface StaffPowerDetailVC ()<UITableViewDelegate,UITableViewDataSource,OperationDelegate>{
    NSArray *_titleArr;
    NSArray *_contArr;
    CyanManager *_cyManager;
    NSString *_registerTime;
    
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation StaffPowerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工详情";
    self.view.backgroundColor = PaleColor;
//登录名	真实姓名	电话	邮箱 
    _titleArr = @[@"登录名",@"真实姓名",@"电话",@"邮箱"];
    self.view.backgroundColor = PaleColor;
    [self.view addSubview:self.table];
    
    _cyManager = [CyanManager shareSingleTon];
    /**底部返回首页按钮*/
    [self homeBtnView];
    /**
     暂时不再次请求了
     */
    [self loadData];
    
}

-(void)loadData{
    NSMutableArray *mutabArr = [NSMutableArray new];
    _contArr =    [self.queryStaffModel allPropertyNames];
    for (NSInteger index = 1; index < _contArr.count; index ++ ) {//不显示编号
        
         [mutabArr addObject:_contArr[index]];
    }
    _contArr = [mutabArr copy];
    
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
        }
    }
    //    self.queryStaffModel.type = @"商户";
    //    self.queryStaffModel.staff = @"当前用户名";
    [self.table reloadData];
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight -64) style:UITableViewStyleGrouped];
        
        [_table registerClass:[RefunOperationCell class] forCellReuseIdentifier:@"RefunOperationCell"];
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

    return _titleArr.count +1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >= _titleArr.count) {
        
        BaseOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOperationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
        cell.queryOrderState = kChangeStaffPower;
        return cell;
        
    }else{
        RefunOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefunOperationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.firstLab.text = _titleArr[indexPath.row];
        NSString *showStr =  [self.queryStaffModel displayCurrentModlePropertyBy:_contArr[indexPath.row]];
        if ([_titleArr[indexPath.row] isEqualToString:@"注册时间"]) {
            cell.contLab.text = _registerTime;
        }else{
            cell.contLab.text = [NSString stringWithFormat:@"%@",showStr];

            
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

#pragma mark OperationDelegate 

-(void)jumpOperationBy:(enum QueryOrderState)queryOrderState{
    
    NSLog(@"权限配置");
    StaffPowerOperationVC *staffOperation = [StaffPowerOperationVC new];
    staffOperation.userSysNo = self.queryStaffModel.SysNO;
    
    [self.navigationController pushViewController:staffOperation animated:YES];
    
}

@end
