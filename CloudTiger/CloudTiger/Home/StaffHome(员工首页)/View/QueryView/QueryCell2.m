//
//  QueryCell2.m
//  CloudTiger
//
//  Created by cyan on 16/9/13.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "QueryCell2.h"
#import "KSDatePicker.h"

@interface QueryCell2()<UITextFieldDelegate>{
    UILabel *titleLab;
    UILabel *chooseLab;
   
}
@end
@implementation QueryCell2


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
    
    titleLab.text = _queryCellmodel.title;
    if (_queryCellmodel.cellText.length) {
        chooseLab.text = _queryCellmodel.cellText;
  
    }else{
       chooseLab.text = @"选择日期";
    }
}
-(void)createUI{
    
//    CGFloat width =  [CyTools getWidthWithContent:@"订单开始时间" height:60 font:14];
//    NSLog(@"width : %f",width);
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 14.5*6, 60)];
//    titleLab.backgroundColor = [UIColor redColor];
    titleLab.text = @"订单开始时间";
    titleLab.textColor = GrayColor;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14];
//    titleLab.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//    titleLab.adjustsFontForContentSizeCategory = YES;

    [self.contentView addSubview:titleLab];
    
    chooseLab  = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.right, 0, MainScreenWidth - titleLab.right - 15 - 45 , 60)];
//    chooseLab.backgroundColor = [UIColor redColor];
    chooseLab.text = @"2016-09-23";
    chooseLab.textAlignment = NSTextAlignmentRight;
    chooseLab.textColor = [UIColor blackColor];

    [self.contentView addSubview:chooseLab];
    
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    chooseLab.userInteractionEnabled = YES;
    [chooseLab addGestureRecognizer:tap];

    
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanBtn.frame = CGRectMake(MainScreenWidth - 15 -40 , 10, 40, 40);
//    cleanBtn.backgroundColor = [UIColor yellowColor];
    [cleanBtn setBackgroundImage:[UIImage imageNamed:@"clean_time_2"] forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(cleanBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cleanBtn];

    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom, MainScreenWidth, 1)];
    lineView.backgroundColor = PaleColor;
    [self.contentView addSubview:lineView];
    
}

-(void)cleanBtn:(UIButton *)btn{
    NSLog(@"清空时间 ");
    NSString *dateStr  = @"";
    
    if ([self.delegete respondsToSelector:@selector(messWithText2:ByIndexPath:)]) {
        [self.delegete messWithText2:dateStr ByIndexPath:self.indexPath];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tapGest{
    
    NSLog(@"选择时间");
//    379
     KSDatePicker *picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0,CYAdaptationW(300),CYAdaptationH(379))];
    
    //配置中心，详情见KSDatePikcerApperance
    
     picker.appearance.radius = 5;
//    //时间选择
//    picker.appearance.datePickerBackgroundColor  = [UIColor redColor];
//    picker.appearance.maskBackgroundColor = [UIColor greenColor];
    
    //取消按钮
//    picker.appearance.cancelBtnTitleColor = [UIColor cyanColor];
     picker.appearance.cancelBtnBackgroundColor = BlueColor;
    
    //确定按钮
     picker.appearance.commitBtnBackgroundColor = BlueColor;

    //headerview
     picker.appearance.headerBackgroundColor = BlueColor;
    
//    picker.appearance.lineColor = BlueColor;
    
    //设置回调
     picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        
        if (buttonType == KSDatePickerButtonCommit || buttonType==KSDatePickerWeakButtonTag || buttonType==KSDatePickerMonthButtonTag || buttonType==KSDatePickerThreeMonthButtonTag) {
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter stringFromDate:currentDate];
            NSLog(@"dateStr :%@",dateStr);
            if ([self.delegete respondsToSelector:@selector(messWithText2:ByIndexPath:)]) {
                [self.delegete messWithText2:dateStr ByIndexPath:self.indexPath];
            }
//            [btn setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
        }
    };
    // 显示
    [picker show];
}



@end
