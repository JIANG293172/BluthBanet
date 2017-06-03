//
//  JHLineChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHLineChart.h"
//#define kXandYSpaceForSuperView 20.0

@interface JHLineChart ()<CAAnimationDelegate>

@property (assign, nonatomic)   CGFloat  xLength;
@property (assign , nonatomic)  CGFloat  yLength;
@property (assign , nonatomic)  CGFloat  perXLen ;
@property (assign , nonatomic)  CGFloat  perYlen ;
@property (assign , nonatomic)  CGFloat  perValue ;
@property (nonatomic,strong)    NSMutableArray * drawDataArr;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (assign , nonatomic) BOOL  isEndAnimation ;
@property (nonatomic,strong) NSMutableArray * layerArr;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *seletedBtn;
@end

@implementation JHLineChart

/**
 *  重写初始化方法
 *
 *  @param frame         frame
 *  @param lineChartType 折线图类型
 *
 *  @return 自定义折线图
 */
-(instancetype)initWithFrame:(CGRect)frame andLineChartType:(JHLineChartType)lineChartType{
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.3];
        _lineWidth = 0.5;
        self.contentInsets = UIEdgeInsetsMake(10, 20, 10, 10);
        _yLineDataArr  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xLineDataArr  = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xAndYLineColor = [UIColor darkGrayColor];
        _pointNumberColorArr = @[[UIColor redColor]];
        _positionLineColorArr = @[[UIColor darkGrayColor]];
        _pointColorArr = @[[UIColor orangeColor]];
        _xAndYNumberColor = [UIColor darkGrayColor];
        _valueLineColorArr = @[[UIColor redColor]];
        _layerArr = [NSMutableArray array];
        [self configChartXAndYLength];
        [self configChartOrigin];
        [self configPerXAndPerY];
        
        _buttons = [NSMutableArray array];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
}
    return self;
    
}

-(void)setXLineDataArr:(NSArray *)xLineDataArr{
    _xLineDataArr = xLineDataArr;
    self.contentSize = CGSizeMake(SSize.width*_xLineDataArr.count/10, 300);
    
    if (SSize.width*_xLineDataArr.count/10<SSize.width) {
        _xLength = CGRectGetWidth(self.frame);
    }else{
        _xLength = SSize.width*_xLineDataArr.count/10;
    }
    
    _yLength = CGRectGetHeight(self.frame)-self.contentInsets.top-self.contentInsets.bottom;
}

/**
 *  清除图标内容
 */
-(void)clear{
    
    _valueArr = nil;
    _drawDataArr = nil;
    
    for (CALayer *layer in _layerArr) {
        
        [layer removeFromSuperlayer];
    }
    [self showAnimation];
    
}

/**
 *  获取每个X或y轴刻度间距
 */
- (void)configPerXAndPerY{

//    _perXLen = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
    
    _perXLen = (SSize.width)/10;
    _perYlen = (_yLength)/_yLineDataArr.count;

}


/**
 *  获取X与Y轴的长度
 */
- (void)configChartXAndYLength{

}


/**
 *  重写ValueArr的setter方法 赋值时改变Y轴刻度大小
 *
 */
-(void)setValueArr:(NSArray *)valueArr{
    
    _valueArr = valueArr;
    
    [self updateYScale];
    
}

/**
 *  更新Y轴的刻度大小
 */
- (void)updateYScale{
    
    if (_valueArr.count) {
        
        NSInteger max=0;
        
        for (NSArray *arr in _valueArr) {
            for (NSString * numer  in arr) {
                NSInteger i = [numer integerValue];
                if (i>=max) {
                    max = i;
                }
                
            }
            
        }
        
        
        if (max%5==0) {
            max = max;
        }else
            max = (max/5+1)*5;
        _yLineDataArr = nil;
        NSMutableArray *arr = [NSMutableArray array];
        if (max<=5) {
            for (NSInteger i = 0; i<5; i++) {
                
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                
            }
        }
        
        if (max<=10&&max>5) {
            
            
            for (NSInteger i = 0; i<5; i++) {
                
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                
            }
            
        }else if(max>10){
            
            for (NSInteger i = 0; i<max/5; i++) {
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                
                
            }
            
        }
        
        _yLineDataArr = [arr copy];
        
        [self setNeedsDisplay];
        
        
    }
    
}


/**
 *  构建折线图原点
 */
- (void)configChartOrigin{
    
    self.chartOrigin = CGPointMake(self.contentInsets.left, self.frame.size.height-self.contentInsets.bottom);
    
}


/* 绘制x与y轴 */
- (void)drawXAndYLineWithContext:(CGContextRef)context{

    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:_xAndYLineColor];
    if (_xLineDataArr.count>0) {
        CGFloat xPace = (SSize.width)/10;
        
        for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
            CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
            CGFloat len = [self getTextWithWhenDrawWithText:_xLineDataArr[i]];
            [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
            
//            [self ddrawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:7.0];
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%@",_xLineDataArr[i]];
            label.font = font(14);
            label.frame = CGRectMake(p.x-len/2, p.y+2, 20, 7);
            label.textColor = _xAndYNumberColor;
            [self addSubview:label];
        }
        
    }
    
    if (_yLineDataArr.count>0) {
        CGFloat yPace = (_yLength)/(_yLineDataArr.count);
        for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
            CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
            CGFloat len = [self getTextWithWhenDrawWithText:_yLineDataArr[i]];
            [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:7.0];
        }
    }
    
}

- (void)ddrawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{
    
    
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];
    
    [color setFill];
    
    CGContextDrawPath(context, kCGPathFill);
    
}

/**
 *  动画展示路径
 */
-(void)showAnimation{
    [self configPerXAndPerY];
    [self configValueDataArray];
    [self drawAnimation];
}


- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawXAndYLineWithContext:context];
    
    
    if (!_isEndAnimation) {
        return;
    }
    
    if (_drawDataArr.count) {
        [self drawPositionLineWithContext:context];
    }
    
}


/**
 *  装换值数组为点数组
 */
- (void)configValueDataArray{
    _drawDataArr = [NSMutableArray array];
    
    if (_valueArr.count==0) {
        return;
    }

    
    _perValue = _perYlen/[[_yLineDataArr firstObject] floatValue];
    
    for (NSArray *valueArr in _valueArr) {
        NSMutableArray *dataMArr = [NSMutableArray array];
        for (NSInteger i = 0; i<valueArr.count; i++) {
            
            CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
            NSValue *value = [NSValue valueWithCGPoint:p];
            [dataMArr addObject:value];
        }
        [_drawDataArr addObject:[dataMArr copy]];
        
    }
    

}


//执行动画
- (void)drawAnimation{
    
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = [CAShapeLayer layer];
    if (_drawDataArr.count==0) {
        return;
    }
    
    //第一、UIBezierPath绘制线段
    [self configPerXAndPerY];
 
    
    for (NSInteger i = 0;i<_drawDataArr.count;i++) {
        
        NSArray *dataArr = _drawDataArr[i];
        
        [self drawPathWithDataArr:dataArr andIndex:i];
        
    }
    

    
}


- (void)drawPathWithDataArr:(NSArray *)dataArr andIndex:(NSInteger )colorIndex{
    
    UIBezierPath *firstPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
    for (NSInteger i = 0; i<dataArr.count; i++) {
        
        NSValue *value = dataArr[i];
        
        CGPoint p = value.CGPointValue;
        

        
        if (i==0) {
            [firstPath moveToPoint:p];
            
        }else{
            [firstPath addLineToPoint:p];
        }
        
        
        [firstPath moveToPoint:p];
    }
    
    
    //第二、UIBezierPath和CAShapeLayer关联
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    
    //    _shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    
    
    shapeLayer.path = firstPath.CGPath;
    
    
    UIColor *color = (_valueLineColorArr.count==_drawDataArr.count?(_valueLineColorArr[colorIndex]):([UIColor orangeColor]));
    
    shapeLayer.strokeColor = color.CGColor;
    
    shapeLayer.lineWidth = (_animationPathWidth<=0?2:_animationPathWidth);
    
    //第三，动画
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    
    ani.fromValue = @0;
    
    ani.toValue = @1;
    
    ani.duration = 0;
    
    ani.delegate = self;
    
    [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self.layer addSublayer:shapeLayer];
    [_layerArr addObject:shapeLayer];
}

/**
 *  设置点的引导虚线
 *
 *  @param context 图形面板上下文
 */
- (void)drawPositionLineWithContext:(CGContextRef)context{
    
    if (_drawDataArr.count==0) {
        return;
    }
    
    for (NSInteger m = 0;m<_valueArr.count;m++) {
        NSArray *arr = _drawDataArr[m];
        
        for (NSInteger i = 0 ;i<arr.count;i++ ) {
            
            CGPoint p = [arr[i] CGPointValue];
            UIColor *positionLineColor;
            if (_positionLineColorArr.count == _valueArr.count) {
                positionLineColor = _positionLineColorArr[m];
            }else
                positionLineColor = [UIColor orangeColor];

            
//            [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x, p.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
//            [self drawLineWithContext:context andStarPoint:P_M(p.x, self.chartOrigin.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            
            if (p.y!=0) {
                UIColor *pointNumberColor = (_pointNumberColorArr.count == _valueArr.count?(_pointNumberColorArr[m]):([UIColor orangeColor]));
                
                UILabel *label = [[UILabel alloc] init];
                label.text = [NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]];
                label.font = font(14);
                label.frame = CGRectMake(p.x, p.y, 50, 7);
                label.textColor = pointNumberColor;
                [self addSubview:label];
                
//                [self drawText:[NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]] andContext:context atPoint:p WithColor:pointNumberColor andFontSize:7.0];

                
            }
            
            
        }
    }
    
     _isEndAnimation = NO;
    
    
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        
        
     
//        [self drawPoint];
        [self drawButtonPoint];

        
    }
    
}

- (void)drawButtonPoint{
    
    for (NSInteger m = 0;m<_drawDataArr.count;m++) {
        
        NSArray *arr = _drawDataArr[m];
        for (NSInteger i = 0; i<arr.count; i++) {
            
            
            NSValue *value = arr[i];
            
            CGPoint p = value.CGPointValue;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            //            [button setBackgroundImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
            //            [button setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateSelected];
            button.frame = CGRectMake(p.x - 20, p.y-20, 40, 40);
            [button addTarget:self action:@selector(seletedBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:button];
            [self addSubview:button];
            
            UIBezierPath *pBezier = [UIBezierPath bezierPath];
            
            [pBezier moveToPoint:p];
            //            [pBezier addArcWithCenter:p radius:13 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *pLayer = [CAShapeLayer layer];
            pLayer.frame = CGRectMake(0, 0, 5, 5);
            pLayer.position = p;
            pLayer.path = pBezier.CGPath;
            
            UIColor *color = _pointColorArr.count==_drawDataArr.count?(_pointColorArr[m]):([UIColor orangeColor]);
            
            pLayer.fillColor = color.CGColor;
            
            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            
            ani.fromValue = @0;
            
            ani.toValue = @1;
            
            ani.duration = 0;
            
            
            [pLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
            
            [self.layer addSublayer:pLayer];
            [_layerArr addObject:pLayer];
            
            
            
        }
        _isEndAnimation = YES;
        
        [self setNeedsDisplay];
    }

}


- (void)seletedBtn:(UIButton *)btn{
    _seletedBtn.selected = NO;
    btn.selected = YES;
    _seletedBtn = btn;
    [self.buttonDelegate didSelectedButtonIndex:btn.tag];
}

/**
 *  绘制值的点
 */
- (void)drawPoint{
//    return;
    for (NSInteger m = 0;m<_drawDataArr.count;m++) {
        
        NSArray *arr = _drawDataArr[m];
        for (NSInteger i = 0; i<arr.count; i++) {
            
            NSValue *value = arr[i];
            
            CGPoint p = value.CGPointValue;
            
            
//            UIBezierPath *pBezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 5, 5)];
            UIBezierPath *pBezier = [UIBezierPath bezierPath];

            [pBezier moveToPoint:p];
            //            [pBezier addArcWithCenter:p radius:13 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *pLayer = [CAShapeLayer layer];
            pLayer.frame = CGRectMake(0, 0, 5, 5);
            pLayer.position = p;
            pLayer.path = pBezier.CGPath;
            
            UIColor *color = _pointColorArr.count==_drawDataArr.count?(_pointColorArr[m]):([UIColor orangeColor]);
            
            pLayer.fillColor = color.CGColor;
            
            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            
            ani.fromValue = @0;
            
            ani.toValue = @1;
            
            ani.duration = 0;
            
            
            [pLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
            
            [self.layer addSublayer:pLayer];
            [_layerArr addObject:pLayer];
            
            
        }
        _isEndAnimation = YES;
        
        [self setNeedsDisplay];
    }
}


@end
