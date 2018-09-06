//
//  NewListViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/21.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "NewListViewController.h"
#import "ARDetailViewController.h"


@interface NewListViewController ()

@property (nonatomic,assign)NSInteger   index;
@end

@implementation NewListViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    _pageNum = 1;
    _isDown = YES;
    [self.view addSubview:self.collectionView];
    WS(weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-0);
    }];
    
    [self startLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refresh" object:nil];
   
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)refreshData:(NSNotification *)notification{
    DLog(@"刷新");
    [self startLocation];
}
#pragma mark UICollection DataSource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    DLog(@"Count = %ld",self.dataList.count);
    return self.dataList.count;
    
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"AR_list" forIndexPath:indexPath];
    ARModel *ar = self.dataList[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",ar.counts];
     NSString *urlString = [ar.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.ARImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:ar.image]];
    cell.nameLabel.text = ar.name;
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
        self.index = indexPath.row;
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
#pragma mark GET
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        CGFloat itemWidth = (SCREEN_WIDTH-30)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth+30);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero   collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       // _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"AR_list"];
        WS(weakSelf)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->_pageNum = 1;
            weakSelf.isDown = YES;
            [weakSelf getARListWithLatitudeAndLongitude];
        }];
        _collectionView.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.isDown = NO;
            self->_pageNum++;
            [weakSelf getARListWithLatitudeAndLongitude];
            
        }];
        
        _collectionView.mj_footer = footer;
        
       
    }
    
    return _collectionView;
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
                CWTOAST(@"定位失败");
                return;
            }
        }
        NSLog(@"location:%@", location);
         self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
         self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        [USER_DEFAULT setObject:self.latitude forKey:@"lat"];
        [USER_DEFAULT setObject:self.longitude forKey:@"lng"];
        [USER_DEFAULT synchronize];
        [self getARListWithLatitudeAndLongitude];
        //        if (regeocode){
        //            self.city = [regeocode.city substringToIndex:regeocode.city.length-1];
        //           // [self getARList];
        //        }
        
    }];
}
-(void)getARListWithLatitudeAndLongitude{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    //    AR列表
   
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageNum];
    [manager getARListWithCity:self.latitude longitude:self.longitude page:page limit:@"10" orderType:@"1" success:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.isDown? weakSelf.dataList = [NSMutableArray arrayWithCapacity:0]:@"";
            [weakSelf.dataList addObjectsFromArray:response.data.listAR];
            [weakSelf.collectionView reloadData];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    } faiure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

-(void)requestDislikeWithArId:(NSString *)easyArId{
    HttpManager *manager = [HttpManager requestManager];
    [manager dislikeArWithSessionIdAndEasyArId:easyArId success:^(Response *response) {
        if (response.msg.status==0) {
            CWTOAST(@"减少展示此类型作品");
        }else{
           CWTOAST(response.msg.desc);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
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
