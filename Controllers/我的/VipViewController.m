//
//  VipViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/28.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "VipViewController.h"
#import "TableViewCell.h"

@interface VipViewController ()

@end

@implementation VipViewController

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


#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld次",60+60*indexPath.row];
    cell.valueLabel.text = [NSString stringWithFormat:@"%ld元",6+6*indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)headView{
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 110);
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
    label.text = @"Vip";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    return topImgView;
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
        [_tableView registerClass:[PayTableViewCell class] forCellReuseIdentifier:@"payCell"];
       
    }
    return _tableView;
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
