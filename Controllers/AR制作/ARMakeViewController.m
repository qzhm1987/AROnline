//
//  ARMakeViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/12.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ARMakeViewController.h"
#import "MakeARViewController.h"
#import "QTextField.h"
#import "UIImageView+WebCache.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import "ARDetailViewController.h"
#import "SearchViewController.h"



@interface ARMakeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *shareLabel;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic) UILabel *zanLabel;
@property (strong, nonatomic)UILabel *zhiLabel;
@property (strong, nonatomic)UIImageView *head;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic ,copy) NSString *city;
@end

@implementation ARMakeViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isDown = YES;
    _pageNum = 1;
    [self makeARUI];
    [self getUserInfoWithSessionId];
    [self startLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refresh" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHead:) name:@"changeHead" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:@"refreshInfo" object:nil];
    // Do any additional setup after loading the view.
}

-(void)refreshInfo:(NSNotification *)notification{
    [self getUserInfoWithSessionId];
}
-(void)refreshData:(NSNotification *)notification{
    DLog(@"刷新");
    [self startLocation];
}
-(void)changeHead:(NSNotification *)notification{
    ARUser *user= [ARUser shareARUser];
    [_head sd_setImageWithURL:[NSURL URLWithString:user.image]];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)makeARUI{
    WS(weakSelf)
    [weakSelf.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(-20);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-20);
    }];
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"listHead")];
    topImgView.userInteractionEnabled = YES;
    [_collectionView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView);
        make.centerX.equalTo(weakSelf.collectionView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 477/2.0f*PIX));
    }];
    UIImageView *circle = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"startMake")];
    [self.collectionView addSubview:circle];
    circle.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeARTap:)];
    [circle addGestureRecognizer:tap];
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topImgView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(223/2.0f*PIX, 223/2.0f*PIX));
        make.right.equalTo(topImgView.mas_right).offset(-15*PIX);
    }];
    QTextField *searchTF = [[QTextField alloc]init];
    searchTF.layer.cornerRadius = 19.0f;
    searchTF.delegate = self;
    searchTF.placeholder = @"请输入您要搜索的内容";
    searchTF.backgroundColor = [UIColor lightTextColor];
    [topImgView addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView);
        make.top.equalTo(topImgView).offset(44);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 38));
    }];
    UIImageView *searchImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"search")];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTap:)];
    searchImgView.userInteractionEnabled = YES;
    [searchImgView addGestureRecognizer:searchTap];
    [topImgView addSubview:searchImgView];
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchTF).offset(-15);
        make.centerY.equalTo(searchTF);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    _head = [[UIImageView alloc]initWithFrame:CGRectZero];
   // _head.image = IMAGE_NAME(@"head");
    _head.layer.cornerRadius = 40.0f;
    _head.clipsToBounds = YES;
    [topImgView addSubview:_head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImgView).offset(20);
        make.top.equalTo(searchImgView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    _nameLabel = [self addLabelUIWithText:@"" font:15.0f];
    [topImgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.head.mas_right).offset(20);
        make.top.equalTo(weakSelf.head).offset(-5);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    _countLabel = [self addLabelUIWithText:@"" font:14.0f];
    [topImgView addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel);
        make.size.mas_equalTo(CGSizeMake(100, 22));
    }];
    _shareLabel = [self addLabelUIWithText:@"" font:14.0f];
    [topImgView addSubview:_shareLabel];
    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.countLabel);
        make.top.equalTo(weakSelf.countLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 22));
    }];
    _zanLabel = [self addLabelUIWithText:nil font:14.0f];
    [topImgView addSubview:_zanLabel];
    [_zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.countLabel.mas_right).offset(30);
        make.top.equalTo(weakSelf.countLabel);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    
    _zhiLabel = [self addLabelUIWithText:nil font:14.0f];
    [topImgView addSubview:_zhiLabel];
    [_zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.countLabel.mas_right).offset(30);
        make.top.equalTo(weakSelf.shareLabel);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    UILabel *scanLabel = [[UILabel alloc]init];
    scanLabel.text = @"热门推荐";
    scanLabel.textColor = [UIColor darkGrayColor];
    scanLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.collectionView addSubview:scanLabel];
    [scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.collectionView).offset(15);
        make.top.equalTo(topImgView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];

}


-(UILabel *)addLabelUIWithText:(NSString *)text font:(CGFloat)font{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.font =[UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
-(void)makeARTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController pushViewController:[MakeARViewController new] animated:YES];
}
-(void)searchTap:(UITapGestureRecognizer *)gesture{
    DLog(@"searchTap");
}


#pragma mark UICollection DataSource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    DLog(@"Count = %ld",self.dataList.count);
    return self.dataList.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ARCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"AR_Case" forIndexPath:indexPath];
    ARModel *ar = self.dataList[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",ar.counts];
    NSString *urlString = [ar.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.ARImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [cell addGestureRecognizer:longPressRecognizer];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"index =%ld",indexPath.row);
    ARModel *ar = self.dataList[indexPath.row];
    ARDetailViewController *detail = [ARDetailViewController new];
    detail.ar = ar;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CollectionViewCell *cell = (CollectionViewCell *)gesture.view;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        DLog(@"index = %ld",indexPath.row);
          [self alertDislikeWithIndexPath:indexPath];
    }else {
        NSLog(@"long pressTap state :end");
    }
    
}


-(void)alertDislikeWithIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"不感兴趣" message:@"你是否减少展示此类作品" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
       
        ARModel *ar = self.dataList[indexPath.row];
        [weakSelf requestDislikeWithArId:[NSString stringWithFormat:@"%ld",ar.id]];
        [weakSelf.dataList removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



-(void)requestDislikeWithArId:(NSString *)easyArId{
    HttpManager *manager = [HttpManager requestManager];
    [manager dislikeArWithSessionIdAndEasyArId:easyArId success:^(Response *response) {
        if (response.msg.status==0) {
            CWTOAST(@"已减少展示此类型作品");
        }else{
            CWTOAST(response.msg.desc);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
-(void)getUserInfoWithSessionId{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getAdminInfoWithSessionId:sessionId success:^(Response *response) {
        if (response.msg.status==0) {
            NSDictionary *dict = response.data.admin;
            ARUser *user = [ARUser shareARUser];
            [user yy_modelSetWithJSON:dict];
            
            [weakSelf.head sd_setImageWithURL:[NSURL URLWithString:user.image]];
            weakSelf.nameLabel.text = user.username;
            weakSelf.countLabel.text = [NSString stringWithFormat:@"使用次数:%@次",user.useCount];
            weakSelf.shareLabel.text = [NSString stringWithFormat:@"分享:%@次",user.share];
            weakSelf.zanLabel.text = [NSString stringWithFormat:@"赞过的:%@次",user.give];
            weakSelf.zhiLabel.text = [NSString stringWithFormat:@"制作:%@个",user.makeCount];
        }else{
            WTOAST(response.msg.desc);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getARListWithLatitudeAndLongitude{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    //    AR列表
    NSString *page = [NSString stringWithFormat:@"%ld",_pageNum];
    [manager getARListWithCity:self.latitude longitude:self.longitude page:page limit:@"20" orderType:@"2" success:^(Response *response) {
        if (response.msg.status==0) {
              weakSelf.isDown? weakSelf.dataList = [NSMutableArray arrayWithCapacity:0]:@"";
            weakSelf.dataList=response.data.listAR;
            [weakSelf.collectionView reloadData];
        }else{
            WTOAST(response.msg.desc);
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    } faiure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}


-(void)startLocation{
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =20;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 10;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        [USER_DEFAULT setObject:lat forKey:@"lat"];
        [USER_DEFAULT setObject:lng forKey:@"lng"];
        [USER_DEFAULT synchronize];
        self.latitude = lat;
        self.longitude = lng;
        [self getARListWithLatitudeAndLongitude];
    }];
}


#pragma mark GET
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(477/2.0f*PIX+70, 10, 0, 10);
        CGFloat itemWidth = (SCREEN_WIDTH-30)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero   collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //_collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
         [_collectionView registerClass:[ARCollectionViewCell class] forCellWithReuseIdentifier:@"AR_Case"];
        
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->_pageNum = 1;
            weakSelf.isDown = YES;
            [weakSelf getARListWithLatitudeAndLongitude];
        }];
        _collectionView.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self->_pageNum++;
            weakSelf.isDown = NO;
            [weakSelf getARListWithLatitudeAndLongitude];
        }];
         _collectionView.mj_footer = footer;
    }
    
    return _collectionView;
}

#pragma mark Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    SearchViewController *search = [SearchViewController new];
    [self.navigationController pushViewController:search animated:YES];
    //     NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    //    PYSearchViewController *pySearch = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"作品搜索"];
    //
    //    [self.navigationController pushViewController:pySearch animated:YES];
    //
    
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
