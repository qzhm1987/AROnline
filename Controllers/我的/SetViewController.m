//
//  SetViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/25.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "SetViewController.h"
#import "UIImageView+WebCache.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UIImageView *headImage;
@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSettingsUI];
    // Do any additional setup after loading the view.
}


-(void)addSettingsUI{
    WS(weakSelf)
    [self.view addSubview:self.tableView];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.layer.cornerRadius =20.0f;
    [button addTarget: self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view.mas_centerY).offset(160);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 52));
    }];
    
}

-(void)aboutTap:(UITapGestureRecognizer *)gesture{
    DLog(@"about");
    UIViewController *vc = [[NSClassFromString(@"AboutViewController") alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = self.funArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if (indexPath.row==0) {
            UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectZero];
            ARUser *user = [ARUser shareARUser];
            NSString *headUrl =[user.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [head sd_setImageWithURL:[NSURL URLWithString:headUrl]];
            [cell.contentView addSubview:head];
            [head mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(0);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self goViewController:@"UserInfoViewController"];
            break;
        case 1:
            [self goViewController:@"BindingSetVC"];
            break;
        case 2:
            [self goViewController:@"ModifyViewController"];
            break;
        case 3:
            [self goViewController:@"AboutViewController"];
            break;
        case 4:
            [self share];
            break;
            
        default:
            break;
    }
    
    
}

-(void)share{
    WS(weakSelf)
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString *title = @"AR在线";
    NSString* thumbURL = [@"https://arvideo.zhyell.com/arlogo.png" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:@"AR在线制作扫描视频展示快来下载试试吧" thumImage:thumbURL];
    //设置网页地址
    NSString *webShareUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zhyell.ar.online";
    NSString *url =[NSString stringWithFormat:@"%@",webShareUrl];
    
    shareObject.webpageUrl = url;
    // [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        DLog(@"data = %@",data);
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
           
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                DLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                DLog(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                DLog(@"response data is %@",data);
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView =[self headView];
        _tableView.tableFooterView = [[UIView alloc]init];
         self.tableView.scrollEnabled = NO;
    }
    return _tableView;
}
-(NSArray *)funArray{
    if (!_funArray) {
        _funArray = @[@"修改个人资料",@"账号和绑定设置",@"修改密码",@"关于我们",@"推荐AR在线给朋友"];
    }
        return _funArray;
}
-(UIView *)headView{
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 111);
    [self.view addSubview:topImgView];
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
    label.text = @"设置";
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

-(void)loginOut{
    NSLog(@"退出");
    [USER_DEFAULT removeObjectForKey:@"sessionId"];
    [USER_DEFAULT synchronize];
    [AppDel goMainViewController];
}
-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}








-(void)goViewController:(NSString *)viewController{
    UIViewController * vc = [NSClassFromString(viewController) new];
    [self.navigationController pushViewController:vc animated:YES];
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
