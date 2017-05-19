//
//  RefundDesView.m
//  CloudTiger
//
//  Created by cyan on 16/9/18.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RefundDesView.h"
#import "RefundDesCell.h"
#import "RefundDesCell2.h"
#import "RefundDesCell3.h"
#import "IQKeyboardManager.h"
@interface RefundDesView()<UITableViewDelegate,UITableViewDataSource>{
    
    UIView *view1;//头部
    UIView *bgView;
    UIControl *alphaView;
    UITableView *table;
    NSInteger _chooseNum;//记录一下 num
    int _keyHeight;
}
@property(nonatomic,copy)NSArray *allKeys;
@property(nonatomic,strong)NSArray *allValues;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *priceLabel;
@property(nonatomic,strong) UILabel *ypriceLabel;
@property(nonatomic,strong) UIImageView *imageV;
@end
@implementation RefundDesView

-(void)dealloc{
    
    
    NSLog(@"退款底部视图销毁额");
}

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [IQKeyboardManager sharedManager].enable = NO;
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [self createUI];
    }
    return self;
}

//-(void)dealloc{
//    
//    NSLog(@"RetainCount :%ld", CFGetRetainCount((__bridge CFTypeRef)(self))) ;
//}

-(void)setRefunDesModel:(RefudDesModel *)refunDesModel{
    
    _refunDesModel = refunDesModel;
    
    [self reloadView];
}

-(void)reloadView{
    
    [table reloadData];

}
-(void)createUI{
    
#pragma 081411
    alphaView = [[UIControl alloc]initWithFrame:CGRectMake(0, -20, MainScreenWidth, MainScreenHeight)];
//    [alphaView addTarget:self action:@selector(tapBack) forControlEvents:UIControlEventTouchUpInside];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [self addSubview:alphaView];
    
    //    bgView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height -425, MainScreenWidth, 425)];
    //    bgView.backgroundColor = [UIColor cyanColor];
    //    bgView.alpha = 1;
    //    [self  addSubview:bgView];
#pragma 081411 修改高度
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height, MainScreenWidth, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 1;
    [self  addSubview:bgView];
    
    
    
    //tableview 260
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, MainScreenWidth,150 ) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor whiteColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.scrollEnabled = NO;
//    
    [table registerClass:[RefundDesCell class] forCellReuseIdentifier:@"RefundDesCell"];
    [table registerClass:[RefundDesCell2 class] forCellReuseIdentifier:@"RefundDesCell2"];
    [table registerClass:[RefundDesCell3 class] forCellReuseIdentifier:@"RefundDesCell3"];
    
    
    [bgView addSubview:table];
    
    
    //头
    view1= [[UIView alloc]initWithFrame:CGRectMake(0, table.top -50, MainScreenWidth, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [bgView  addSubview:view1];
    
  
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth  , 50)];
    _titleLabel.text = @"退款详情";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = UIColorFromRGB(0x333333, 1);
    [view1 addSubview:_titleLabel];

    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.frame = CGRectMake(0, 0 , 40, 40);
//    [buttonCancel setTitle:@"x" forState:UIControlStateNormal];
//    [buttonCancel setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
//    buttonCancel.backgroundColor = [UIColor cyanColor];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"refund_dimss_btn"] forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:buttonCancel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom - 1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [view1 addSubview:lineView];
    
    
    //确定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, bgView.height  -45, MainScreenWidth, 45);
    //    button.backgroundColor = UIColorFromRGB(0xA243E9, 1);
    button.tag = 2016704;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundImage:[ CyTools imageWithColor:BlueColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[ CyTools imageWithColor:PaleColor] forState:UIControlStateDisabled];
//    button.enabled = NO;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
}

#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        RefundDesCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDesCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contLab.text = self.refunDesModel.Out_trade_no;
        return cell;
        
    }else if (indexPath.row == 1){
        RefundDesCell2  *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDesCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.refundableAmount = self.refunDesModel.fee;
        return cell;
        
    }else{
        RefundDesCell3  *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDesCell3" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }

    
}
//14 + 10 +24 +25 =73 //1排的时候   + 8 + 24 = 32（每增加一排）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    return 50;
}
#pragma mark  buttonaAction
-(void)cancelAction:(UIButton *)btn{
    NSLog(@"取消");
    
    [self bgViewDown];
    
}

-(void)sureAction:(UIButton *)btn{

//    {
//        "out_trade_no": "133268090120160914145907812",
//        "refund_fee": "1",
//        "total_fee": "1",
//        "SOSysNo": "12399",
//        "YwMch_id2": 2
//    }
    NSLog(@"确定");
    
    [self bgViewDown];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1  inSection:0];
    RefundDesCell2 *cell2 = [table cellForRowAtIndexPath:indexPath];
    
    
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2  inSection:0];
    RefundDesCell3 *cell3 = [table cellForRowAtIndexPath:indexPath3];
    
    NSString *pasword = cell3.password.text;
    NSString *money =  cell2.moneyTextField.text;
   
    NSArray *arr = @[money,pasword];
    if ([self.refundDesViewDelegate respondsToSelector:@selector(refundDesView:)]) {
        [self.refundDesViewDelegate refundDesView:arr];
        
    }
  
}

#pragma mark 动画 滑出 滑入
-(void)bgViewTop{
#pragma 081411
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.height);
    self.transform = transform;
    [UIView animateWithDuration:0.3 animations:^{
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.alpha = 0.3;
        bgView.center = CGPointMake(bgView.center.x, bgView.center.y-300);
        
    }];
    
    //如果单次 只改变一次 如果连续 在以前基础上再次进行移位
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.height);
    //    [UIView animateWithDuration:.3 animations:^{
    //
    //        self.transform = transform;
    //
    //
    //    } completion:^(BOOL finished) {
    //
    //
    //    }];
}
/**
 *  SKU页面从底部滑出
 */
-(void)bgViewDown{
    
    
    [IQKeyboardManager sharedManager].enable = YES;
#pragma 081411
    [UIView animateWithDuration:0.2 animations:^{
        alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        bgView.center = CGPointMake(bgView.center.x, bgView.center.y+300);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeTranslation(0, self.height);
        [self removeFromSuperview];
        
    }];
    
    
    //    alphaView.hidden = YES;
    //如果单次 只改变一次 如果连续 在以前基础上再次进行移位
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.height);
    //    [UIView animateWithDuration:.5 animations:^{
    //       self.transform = transform;
    //    } completion:^(BOOL finished) {
    //        self.hidden = YES; 直接移除不隐藏
    //        [self removeFromSuperview];
    //    }];
    
    
}


#pragma mark - 键盘 
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    NSLog(@"center.y :%f",bgView.center.y);
    if (_keyHeight > 0) {
        
        if (_keyHeight != height) {
            [UIView animateWithDuration:0.3 animations:^{
                NSLog(@"改变了");
                bgView.center = CGPointMake(bgView.center.x, bgView.center.y+ _keyHeight -height);
                
            }];
        }
        
    
    }else{
        
      
            [UIView animateWithDuration:0.3 animations:^{
                bgView.center = CGPointMake(bgView.center.x, bgView.center.y-height);
                
            }];
        
   
        NSLog(@"center.y :%f",bgView.center.y);

    }
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.height);
     _keyHeight = height;
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.height);
    //    self.transform = transform;
    [UIView animateWithDuration:0.3 animations:^{
        //        alphaView.backgroundColor = [UIColor blackColor];
        //        alphaView.alpha = 0.3;
        bgView.center = CGPointMake(bgView.center.x, bgView.center.y+height);
        
    }];
    _keyHeight = 0;
}


@end
