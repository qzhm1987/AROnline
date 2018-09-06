//
//  ReportViewController.m
//  ARVideo
//
//  Created by youdian on 2018/8/29.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()


@property (strong, nonatomic)NSMutableArray *selectArray;
@end

@implementation ReportViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden  = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
     self.navigationController.navigationBar.hidden  = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"举报";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getReportTypeList];
    
    
    // Do any additional setup after loading the view.
}

#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"reportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = self.dataList[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
 UIImageView *selectView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"selected")];
    selectView.tag = 30+indexPath.row;
    [cell.contentView addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(25, 18));
    }];
   
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *select = (UIImageView *)[cell.contentView viewWithTag:30+indexPath.row];
    [select removeFromSuperview];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    button.layer.cornerRadius = 5.0f;
    [button setTitle:@"举报" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 38));
    }];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 55.0f;
}
-(void)reportClick:(UIButton *)button{
    HttpManager *manager = [HttpManager requestManager];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString*reportType = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSString *type = [self.rType isEqualToString:@"1"]?@"0":@"1";
   
    
    if (sessionId.length<1) {
        [self alertLogin];
    }else{
        [SVProgressHUD showWithStatus:@"举报中"];
       WS(weakSelf)
        [manager arReportInsertWithSessionAndReportType:reportType contentId:self.contentId type:type success:^(Response *response) {
             [SVProgressHUD dismiss];
            CWTOAST(@"已收到您的举报内容");
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [SVProgressHUD dismiss];
        }];
    }

  
    [self performSelector:@selector(reportSuccess) withObject:nil afterDelay:2.0f];
}

-(void)alertLogin{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录,是否现在登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"现在登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        
        [AppDel goLoginViewController];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)reportSuccess{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
       _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}



-(void)getReportTypeList{
    
    HttpManager *manager = [HttpManager requestManager];
    [manager getArReportTypeWithType:self.rType success:^(Response *response) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
    
    
    
}
-(NSArray *)dataList{
    NSArray *arrayAR = @[@"违法违规",@"色情低俗",@"垃圾广告、卖假冒伪劣产品",@"内容不适合孩子观看",@"未成年不适当行为",@"标题党、封面党、骗点击",@"作品令人反感，我不喜欢",@"盗用作品",@"泄露我的隐私",@"其他"];
    NSArray *arrayComment  = @[@"违法违规",@"色情低俗",@"辱骂我或他人",@"制售假冒伪劣商品"];
    if (!_dataList) {
        _dataList = [self.rType isEqualToString:@"1"]?arrayAR:arrayComment;
    }
    return _dataList;
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
