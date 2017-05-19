//
//  QueryCell3.m
//  CloudTiger
//
//  Created by cyan on 16/9/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryCell3.h"
#import "DPPopUpMenu.h"

@interface QueryCell3()<UITextFieldDelegate,DPPopUpMenuDelegate>{
    UILabel *titleLab;
    UIButton *chooseBtn;
}
@end
@implementation QueryCell3

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
        
    }
    return self;
}

-(void)setQueryCellmodel:(QueryCellModel *)queryCellmodel{
    
    if (_queryCellmodel != queryCellmodel) {
        _queryCellmodel = queryCellmodel;
        
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    if (self.queryCellmodel.cellText.length) {
        [chooseBtn setTitle:self.queryCellmodel.cellText forState:UIControlStateNormal];
 
    }else{
        [chooseBtn setTitle:@"全部" forState:UIControlStateNormal];
  

    }
}
-(void)createUI{
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 6 *14, 60)];
//    titleLab.backgroundColor = [UIColor redColor];
    titleLab.text = @"交易类型";
    titleLab.textColor = GrayColor;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLab];
    

    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth - 15 -40 , 10, 40, 40)];
//    imageView.backgroundColor = [UIColor yellowColor];
    imageView.image = [UIImage imageNamed:@"type_choose"];
    [self.contentView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    chooseBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(MainScreenWidth - 100 - 15  , 0,100 , 60);
//    chooseBtn.backgroundColor = [UIColor purpleColor];
    [chooseBtn setTitle:@"全部" forState:UIControlStateNormal];
    [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    
    [chooseBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chooseBtn];
    
    
    //   btn文字偏左
    chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    使文字距离做边框保持10个像素的距离。
    chooseBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 30);
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom -1, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
 

}


-(void)chooseType:(UIButton *)btn{
    
    NSLog(@"选择交易类型");
    
    DPPopUpMenu *men=[[DPPopUpMenu alloc]initWithFrame:CGRectMake(0, 0, CYAdaptationW(270), CYAdaptationH(176))];
    men.titleText=@"交易类型";
    men.delegate=self;
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"name",@"0",@"typeID", nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"支付宝",@"name",@"102",@"typeID", nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"name",@"103",@"typeID", nil];

//    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"支付宝",@"name",@"13",@"typeID", nil];
//    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"卡券",@"name",@"16",@"typeID", nil];
//    NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"刷卡",@"name",@"03",@"typeID", nil];
//    NSDictionary *dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@"钱包",@"name",@"15",@"typeID", nil];
//    NSDictionary *dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"name",@"12",@"typeID", nil];
    men.dataArray = [NSArray arrayWithObjects:dic1,dic2,dic3, nil];
    [men show];
}

- (void)DPPopUpMenuCellDidClick:(DPPopUpMenu *)popUpMeunView withDic:(NSDictionary *)dic{
    
    NSLog(@"name : %@",[dic objectForKey:@"name"]);
    if ([self.delegete respondsToSelector:@selector(messWithText3:ByIndexPath:)]) {
        [self.delegete messWithText3:[dic objectForKey:@"name"] ByIndexPath: self.indexPath];
    }
}
@end
