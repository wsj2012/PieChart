//
//  ViewController.m
//  PieChart
//
//  Created by 王树军(金融壹账通客户端研发团队) on 27/09/2017.
//  Copyright © 2017 wsj_2012. All rights reserved.
//

#import "ViewController.h"
#import "PieView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *percentArr = @[@0.3,@0.3,@0.1,@0.3];
    NSArray *titleArr = @[@"现金类",@"固定收益类",@"股票类", @"基金类"];
    NSArray *subTitleArr = @[@"30%",@"30%",@"10%", @"30%"];
    PieView *pieView = [[PieView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    [pieView prepareWithPercentArr:percentArr titleArr:titleArr subTitleArr:subTitleArr];
    [self.view addSubview:pieView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
