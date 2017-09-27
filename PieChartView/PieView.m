//
//  PieView.m
//  PieChart
//
//  Created by 王树军(金融壹账通客户端研发团队) on 27/09/2017.
//  Copyright © 2017 wsj_2012. All rights reserved.
//

#import "PieView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define OUTR ((kScreenWidth)/4)
#define INR  ((kScreenWidth/4)-26)
#define PIECENTERX kScreenWidth/2
#define PIECENTERY 150
#define PIECENTER CGPointMake(kScreenWidth/2, frame.size.height/2)
#define LABELTAG 121

@interface PieView()

@property (nonatomic, strong) NSArray *percentArr;//百分比分段
@property (nonatomic, strong) NSMutableArray *angleArr;//对应的弧度
@property (nonatomic, strong) NSMutableArray *midAngleArr;//每个弧度分段的中心点位置
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *subTitleArr;

@end

@implementation PieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)initSubviews {
    
    for (int i = 0; i < self.percentArr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-100, -100, 100, 100)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = [NSString stringWithFormat:@"%@\n%@",self.titleArr[i],self.subTitleArr[i]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.tag = LABELTAG+i;
        [self addSubview:label];
    }
}

- (void)initArr {
    self.angleArr = [[NSMutableArray alloc] initWithCapacity:self.percentArr.count];
    self.midAngleArr = [[NSMutableArray alloc] initWithCapacity:self.percentArr.count];
    float sumAngle = 0.0;
    //通过百分比转换成弧度
    for (int i = 0; i < self.percentArr.count; i++) {
        CGFloat angle = [self.percentArr[i] floatValue]*2*M_PI;
        CGFloat midAngle = sumAngle + angle/2.0;
        [self.midAngleArr addObject:[NSNumber numberWithFloat:midAngle]];
        sumAngle += angle;
        [self.angleArr addObject:[NSNumber numberWithFloat:sumAngle]];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //绘制外圆填充绿色
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextAddArc(context, kScreenWidth/2, 150, OUTR, 0, 2*M_PI, 0);
    CGContextFillPath(context);
    
    //绘制外圆设置颜色为白色
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddArc(context, PIECENTERX, PIECENTERY, OUTR, 0, 2*M_PI, 0);
    CGContextStrokePath(context);
    
    //绘制内圆填充色为橙色
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextAddArc(context, PIECENTERX, PIECENTERY, INR, 0, 2*M_PI, 0);
    CGContextFillPath(context);
    
    //绘制内圆颜色为白色
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, PIECENTERX, PIECENTERY, INR, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
    
    for (int i = 0; i < self.angleArr.count; i++) {
        
        //根据弧度算内分割的线的起始点
        CGFloat angle = [self.angleArr[i] floatValue];
        CGPoint inPoint = CGPointMake(PIECENTERX+INR*cos(angle), PIECENTERY+INR*sin(angle));
        CGPoint outPoint = CGPointMake(PIECENTERX+OUTR*cos(angle), PIECENTERY+OUTR*sin(angle));
        
        //连接起始点
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, inPoint.x, inPoint.y);
        CGContextAddLineToPoint(context, outPoint.x, outPoint.y);
        CGContextStrokePath(context);
        
        //算每个分段弧度的中心点位置
        CGFloat midAngel = [self.midAngleArr[i] floatValue];
        CGPoint midPoint = CGPointMake(PIECENTERX+(INR+OUTR)/2.0*cos(midAngel), PIECENTERY+(INR+OUTR)/2.0*sin(midAngel));
        
        //        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        //        CGContextAddArc(context, midPoint.x, midPoint.y, 3, 0, 2*M_PI, 0);
        //        CGContextFillPath(context);
        
        //每个分段延伸出去的折点
        CGPoint breakPoint = CGPointMake(PIECENTERX+(OUTR+(OUTR-INR)/2.0)*cos(midAngel), PIECENTERY+(OUTR+(OUTR-INR)/2.0)*sin(midAngel));
        //        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        //        CGContextAddArc(context, breakPoint.x, breakPoint.y, 3, 0, 2*M_PI, 0);
        //        CGContextFillPath(context);
        
        //结束点的位置，确定说明文本的放置位置
        CGPoint endPoint;
        if (breakPoint.x<PIECENTERX) {
            endPoint = CGPointMake(43, breakPoint.y);
        }else {
            endPoint = CGPointMake(kScreenWidth-43, breakPoint.y);
        }
        
        //结束点画圈，填充白色
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, endPoint.x, endPoint.y, 3, 0, 2*M_PI, 0);
        CGContextFillPath(context);
        
        //将中心点、折点、结束点连接起来
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, midPoint.x, midPoint.y);
        CGContextAddLineToPoint(context, breakPoint.x, breakPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
        
        //        CGContextSetLineWidth(context, 2.0f);
        //        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        //        CGContextMoveToPoint(context, midPoint.x, midPoint.y);
        //        CGContextSetLineCap(context, kCGLineCapRound);
        //        CGContextAddLineToPoint(context, breakPoint.x, breakPoint.y);
        //        CGContextStrokePath(context);
        
        //调整说明控件的中心位置
        UILabel *label = (UILabel *)[self viewWithTag:LABELTAG+i];
        label.center = CGPointMake(endPoint.x, endPoint.y+30);
        
    }
}

#pragma mark - publick method

- (void)prepareWithPercentArr:(NSArray *)percentArr
                     titleArr:(NSArray *)titleArr
                  subTitleArr:(NSArray *)subTitleArr
{
    self.percentArr = percentArr;
    self.titleArr = titleArr;
    self.subTitleArr = subTitleArr;
    [self initArr];
    [self initSubviews];
    [self setNeedsDisplay];
}


@end
