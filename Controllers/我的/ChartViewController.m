//
//  ChartViewController.m
//  ARVideo
//
//  Created by youdian on 2018/8/14.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ChartViewController.h"
#import "TableViewCell.h"
#import <PNChart.h>


@interface ChartViewController ()
{
    PNLineChart * lineChart;
}
@end

@implementation ChartViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden  = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf)
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(-20);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    
    
    
    
    // Do any additional setup after loading the view.
}




-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChartDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell" forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.timeLabel.text = @"时间";
        cell.cityLabel.text = @"地区";
        cell.deviceLabel.text = @"设备";
    }else{
        cell.timeLabel.text = @"2018/8/14";
        cell.cityLabel.text = @"石家庄";
        cell.deviceLabel.text = @"iOS";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50.0f;
        _tableView.tableHeaderView = [self headView];
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerClass:[ChartDataCell class] forCellReuseIdentifier:@"dataCell"];
    }
    return _tableView;
}

-(UIView *)headView{
    UIView *view  = [UIView new];
    view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 400);
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
    [view addSubview:topImgView];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [topImgView addSubview:back];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:tap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(30);
        make.left.equalTo(topImgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label =[UILabel new];
    label.text = @"数据管理";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    UILabel *label1 = [UILabel new];
    label1.text = @"使用次数数据图";
    label1.textColor = [UIColor darkGrayColor];
    label1.frame = CGRectMake(30,130 ,150, 30);
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:label1];
    
     lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 200)];
    [lineChart setXLabels:@[@" 1",@" 2",@"3",@"4",@"5",@"6",@"7"]];
    [lineChart setYLabels:@[@"10",@"20",@"30",@"40",@"50",@"60"]];
    NSArray * dataArray = @[@5, @8, @33, @22, @55,@40,@15,@43];
    PNLineChartData *data = [PNLineChartData new];
    data.color = PNFreshGreen;
    data.itemCount = lineChart.xLabels.count;
    data.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.showSmoothLines = YES;
    lineChart.showYGridLines = YES;
    lineChart.showCoordinateAxis = YES;
    lineChart.chartData = @[data];
    [lineChart strokeChart];
    [view addSubview:lineChart];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"使用次数数据表";
    label2.textColor = [UIColor darkGrayColor];
    label2.frame = CGRectMake(30,370 ,150, 30);
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:label2];
    
    
    
    
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
