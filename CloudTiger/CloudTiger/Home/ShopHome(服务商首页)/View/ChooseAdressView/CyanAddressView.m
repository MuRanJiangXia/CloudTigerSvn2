//
//  CyanAddressView.m
//  CloudTiger
//
//  Created by cyan on 16/12/8.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanAddressView.h"
@interface CyanAddressView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSArray *proArr;
    NSArray *cityArr;
    NSArray *countyArr;
    
    
    
}

@property (nonatomic, strong)UITextField *textTF;

@property (nonatomic, strong)UIPickerView *pickView;

@property(nonatomic,strong)  UIActivityIndicatorView *active;

/**当前地址dic*/
@property(nonatomic,strong)NSDictionary *chooseDic;
/**上级地址id*/
@property(nonatomic,strong)NSString *topId;



@property (nonatomic, strong)void(^block)(NSDictionary * pro,NSDictionary * city ,NSDictionary * county);

@end

@implementation CyanAddressView


/**
 chooseID  上一级id currentDic 已选择的地址dic
 */
+(instancetype)showWith:(UITextField*)textF ByChooseId:(NSString *)chooseID WithCurrentDic:(NSDictionary *)currentDic Complete:(void(^)(NSDictionary * pro,NSDictionary * city ,NSDictionary * county))complete{
    
    
    CyanAddressView * view = [[CyanAddressView alloc]init];
    
    view.frame = CGRectMake(0, MainScreenHeight*0.7, MainScreenWidth, MainScreenHeight*0.3);
    
    view.backgroundColor = [UIColor whiteColor];
    
    view.block = complete;
    
    view.textTF=(UITextField*)textF;
    
    view.chooseDic = currentDic;
    view.topId = chooseID;
    [view creatUI];
    
    return view;
}



-(void)creatUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    view.backgroundColor = BlueColor;
    [self addSubview:view];
    
    
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth -100)/2.0, 0,100, 40)];
//    label.backgroundColor = [UIColor redColor];
    label.text = @"选择地址";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [self addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"refund_dimss_btn"] forState:UIControlStateNormal];
    //    [button setTitle:@"x" forState:UIControlStateNormal];
    //    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(self.width - 60 , 0,60 , 40) ;
//    sureBtn.backgroundColor = [UIColor purpleColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    
    
    ///选择 器
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, 216-40)];
    _pickView.delegate=self;
    _pickView.dataSource=self;
    _pickView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:_pickView];
    
    
    //加载等待
    
    _active = [[UIActivityIndicatorView alloc]init];
    _active.frame = _pickView.frame;
    _active.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //    active.backgroundColor = [UIColor blueColor];
    
    [self addSubview:_active];
    
    [_active startAnimating];
    
    
    [self loadAdressData];
    
}

-(void)sureAction:(UIButton *)btn{
    
    [self.textTF resignFirstResponder];
    
    NSDictionary *dic1 = [NSDictionary new] ;
    NSDictionary *dic2 = [NSDictionary new] ;
    NSDictionary *dic3 = [NSDictionary new] ;
    
    NSInteger selectProvince = [self.pickView selectedRowInComponent:0];
    if (!proArr.count) {
        NSLog(@"没有获取到数据");
        return;
    }
    
    if (proArr.count) {
        
        dic1 = proArr[selectProvince];
    }
    
    if (proArr.count) {
        dic2 = proArr[0];
    }
    
    if (proArr.count) {
        dic3 = proArr[0];
    }
    
    self.block(dic1,dic2,dic3);
    
//    NSLog(@"确定");
    
}

-(void)cancleAction:(UIButton *)btn{
    
    [self.textTF resignFirstResponder];
    
    
}


-(void)loadAdressData{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    //设置请求头 压缩
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setTimeoutInterval:15];
    
    if (!self.topId.length) {
        NSLog(@"未设置id");
        return;
    }
    NSDictionary *parameters = @{
                                 @"Parent_id":self.topId
                                 };
    
    
    //加载中
    _pickView.hidden = YES;
    [_active startAnimating];
    

    [manager POST:[BaseUrl stringByAppendingString:AddresChooseAreaUrl] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //加载中
        _pickView.hidden = NO;
        [_active stopAnimating];
        
//        NSLog(@"responseObject  : %@",responseObject);
        
        proArr = responseObject;
        [_pickView reloadAllComponents];
        
        //已经选中了
        if (self.chooseDic.count) {
            /**
             选取选中的地址
             */
            NSInteger proIndex = [self.chooseDic[@"SysNo"] integerValue] ;
            //谓词查找选择中的想
            NSString  *preStr = [NSString stringWithFormat:@"SysNo == %ld",proIndex];
            
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:preStr];
            NSArray * filter = [responseObject filteredArrayUsingPredicate:filterPredicate];
            if (filter.count) {
                NSInteger chooseIndex = [responseObject indexOfObject:filter[0]];
                NSLog(@"选中了%ld",chooseIndex);
                
                [_pickView selectRow:chooseIndex inComponent:0 animated:NO];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [_active stopAnimating];
        NSLog(@"error  : %@",error);
    }];
    
}


#pragma mark UIPickerViewDataSource


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    return proArr.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
//    NSLog(@"component==%ld---row==%ld",component,row);
    
    if (!view) {
        view = [[UIView alloc] init];
    }
    
    float weigh;
    
    
    weigh = MainScreenWidth;
    // 20  //16
    UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weigh, 40)];
    text.textAlignment=1;
    [view addSubview:text];
    text.font=[UIFont systemFontOfSize:18];
    NSDictionary * dic = proArr[row];
    text.text= dic[@"AddressName"];
    
    
    return view;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 40.0;
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    
    
//    NSLog(@"选中刷新：component==%ld---row==%ld",component,row);
    
}
@end
