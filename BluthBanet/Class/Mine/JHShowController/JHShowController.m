//
//  JHShowController.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/12.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHShowController.h"
#import "JHLineChart.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
#define MaxBattery 80
@interface JHShowController ()<JHLineChartDelegate>
@property (nonatomic, strong) NSArray *battery;

@property (nonatomic, strong) UIView *barreryView;
@property (nonatomic, strong) UIImageView *batteryOutSide;
@property (nonatomic, strong) UIImageView *batteryInSide;

@property (nonatomic, strong) UILabel *electricityCountLB;

@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) JHLineChart *lineChart;

@property (nonatomic, strong) UILabel *LastTimeTitle;
@property (nonatomic, strong) UILabel *LastTimeLB;
@property (nonatomic, strong) UIImageView *tiemIV;
//@property (nonatomic, strong) UILabel *nextTimeTitle;
//@property (nonatomic, strong) UILabel *nextTimeLB;


@end

@implementation JHShowController

// batteryOutSide batteryInSide
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = colorf4f4f4;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    self.battery = [df objectForKey:@"locationTime"];
    
    
    if (self.battery.count > 0) {
        [self showFirstQuardrant];
        [self setupUI];
    }
    
}

- (void)setupUI{
    _barreryView = [[UIView alloc] init];
    [self.view addSubview:_barreryView];
    [_barreryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 100;
        make.height.offset = 60;
        make.centerX.offset = 0;
        make.bottom.equalTo(_lineChart.mas_top).offset = -20;
//        make.top.offset = 30;
    }];
    
    _batteryOutSide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"batteryOutSide"]];
    [_barreryView addSubview:_batteryOutSide];
    [_batteryOutSide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset = 0;
    }];
    
    UIView *insideView = [[UIView alloc]init];
    [_batteryOutSide addSubview:insideView];
    insideView.clipsToBounds = YES;
    [insideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 8;
        make.centerY.offset = 2;
        make.height.offset = 20;
        make.width.offset = MaxBattery;
    }];
    
    _batteryInSide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"batteryInSide"]];
    _batteryInSide.layer.masksToBounds = YES;
    [insideView addSubview:_batteryInSide];
    [_batteryInSide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 20;
        make.right.equalTo(insideView.mas_left).offset = 0;
        make.width.offset = MaxBattery;
        make.centerY.offset = 0;
    }];
    
    _electricityCountLB = [[UILabel alloc] init];
    _electricityCountLB.textAlignment = NSTextAlignmentCenter;
    _electricityCountLB.font = font(30);
    _electricityCountLB.textColor = [UIColor greenColor];
    [_batteryOutSide addSubview:_electricityCountLB];
    [_electricityCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_batteryInSide.mas_centerY).offset = 0;
        make.centerX.offset = 0;
        make.height.offset = 15;
        make.width.offset = 100;
    }];
    


    
    _LastTimeLB = [[UILabel alloc] init];
    _LastTimeLB.font = font(30);
    _LastTimeLB.textAlignment = NSTextAlignmentCenter;
    _LastTimeLB.textColor = [UIColor blackColor];
    [self.view addSubview:_LastTimeLB];
    [_LastTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 200;
        make.height.offset = 15;
        make.bottom.equalTo(_barreryView.mas_top).offset = -30;
        make.centerX.offset = 0;
    }];
    
    _tiemIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeClock"]];
    [self.view addSubview:_tiemIV];
    [_tiemIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 40;
        make.centerY.equalTo(_LastTimeLB.mas_centerY).offset = 0;
        make.right.equalTo(_LastTimeLB.mas_left).offset = -24;
    }];
    
    
    _timeLB = [[UILabel alloc] init];
    _timeLB.font = font(30);
    _timeLB.textAlignment = NSTextAlignmentCenter;
    _timeLB.textColor = [UIColor blackColor];
    [self.view addSubview:_timeLB];
    [_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 200;
        make.centerX.offset = 0;
        make.bottom.equalTo(_LastTimeLB.mas_top).offset = -30;
        make.height.offset  = 14;
    }];
    
    

}

- (void)setBatteryCount:(NSInteger)count{

    _electricityCountLB.text = [NSString stringWithFormat:@"%ld%%", (long)count];
    CGFloat scale = count*75/100;
    [UIView animateWithDuration:.5 animations:^{
        _batteryInSide.transform = CGAffineTransformMakeTranslation(scale, 0);
    }];
}


//第一象限折线图
- (void)showFirstQuardrant{


        _lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, SSize.height/3 - 30, k_MainBoundsWidth, 300) andLineChartType:JHChartLineValueNotForEveryX];
        _lineChart.buttonDelegate = self;
        NSMutableArray *timeArr = [NSMutableArray array];
        NSMutableArray *electricArr = [NSMutableArray array] ;
        for (NSDictionary *dic in _battery) {
            [timeArr addObject:dic.allKeys.firstObject];
            [electricArr addObject:dic.allValues.firstObject];
        }
        
        /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < timeArr.count; i++) {
            [arr addObject:[NSString stringWithFormat:@"%d", i + 1]];
        }
        _lineChart.xLineDataArr = arr;
        
        /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
        _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
        
        /* 数据源 */
        _lineChart.valueArr = @[electricArr];
        
        /* 值折线的折线颜色 默认暗黑色*/
        _lineChart.valueLineColorArr =@[[UIColor purpleColor], [UIColor brownColor]];
        
        /* 值点的颜色 默认橘黄色*/
        _lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
        
        /* X和Y轴的颜色 默认暗黑色 */
        _lineChart.xAndYLineColor = [UIColor greenColor];
        
        /* XY轴的刻度颜色 m */
        
        _lineChart.xAndYNumberColor = [UIColor blueColor];
        
        /* 坐标点的虚线颜色 */
        _lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
        [self.view addSubview:_lineChart];
        [_lineChart showAnimation];

    
}

- (NSString *)getCurrentTimeWithTimeString:(NSString *)timeString{
    
    
    
    NSDateFormatter *f = [NSDateFormatter new];
    //设置格式Mon Aug 15 15:36:17 +0800 2016
    
    f.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [f dateFromString:timeString];
    
    NSDate *date2 = [NSDate new];
    
    NSTimeInterval timeInterval1 = [date1 timeIntervalSince1970];
    NSTimeInterval timeInterval2 = [date2 timeIntervalSince1970];
    NSInteger timeInterval = timeInterval2 - timeInterval1;

        if (timeInterval<60) {
            return @"刚刚";
        }else if (timeInterval>=60&&timeInterval<3600){
            return [NSString stringWithFormat:@"%ld分钟前",timeInterval/60];
        }else if (timeInterval>=3600&&timeInterval<3600*24){
            return [NSString stringWithFormat:@"%ld小时前",timeInterval/3600];
        }else{
            f.dateFormat = @"MM月dd日 HH:mm";

            return timeString;
        }
    
}

#pragma mark - JHLineChartDelegate
-(void)didSelectedButtonIndex:(NSInteger)index{
    NSDictionary *dic = _battery[index];
    NSInteger count = [dic.allValues.firstObject intValue];
    _timeLB.text = dic.allKeys.firstObject;

    _LastTimeLB.text = [self getCurrentTimeWithTimeString:dic.allKeys.firstObject];
//    if (_battery.count >=2 && index > 0) {
//        NSDictionary *lastDic = _battery[index-1];
//        NSString *str = lastDic.allKeys.firstObject;
//        NSLog(@"%@", str);
//
//        
//    }
//
//    if (_battery.count >= 2 && index<_battery.count-1) {
//        NSDictionary *nextDic = _battery[index-1];
//        NSString *str = nextDic.allKeys.firstObject;
//        NSLog(@"%@", str);
//
//        _nextTimeLB.text = [self getCurrentTimeWithTimeString:str];
//    }
    
    [self setBatteryCount:count];
}



@end
