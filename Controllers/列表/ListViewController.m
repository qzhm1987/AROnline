//
//  ListViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ListViewController.h"
#import "UIImageView+WebCache.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ListViewController ()<DCCycleScrollViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIImageView *line ;
}
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *shareLabel;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic) UILabel *zanLabel;
@property (strong, nonatomic)UILabel *zhiLabel;
@property (strong, nonatomic)UIImageView *head;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic ,copy) NSString *city;
@end

@implementation ListViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTop];
    [self startLocation];
   
    // Do any additional setup after loading the view.
}


-(void)addTop{
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 111);
    [self.view addSubview:topImgView];
    
    QTextField *searchTF = [[QTextField alloc]init];
    searchTF.layer.cornerRadius = 19.0f;
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
     CGFloat width = SCREEN_WIDTH/3.0f;
    WS(weakSelf)
    for (int i=0  ; i<3; i++) {
       
        UILabel *label = [UILabel new];
        label.tag = 30+i;
        label.userInteractionEnabled =YES;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @[@"最新",@"热门",@"同城"][i];
        [self.view addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [label addGestureRecognizer:tap];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(i*width);
            make.top.equalTo(topImgView.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(width, 30));
        }];
    }
    
    line = [UIImageView new];
    line.backgroundColor = THEME_COLOR;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(10+30);
        make.left.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(width, 2));
    }];
    
    
    
    
    
}

-(void)tapClick:(UITapGestureRecognizer *)gesture{
    UILabel *label = (UILabel *)gesture.view;
    
    [UIView animateWithDuration:1.0f animations:^{
        [self->line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label);
        }];
    }];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label);
    }];
}
-(void)addListUI{
    WS(weakSelf)
    
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _baseScrollView.showsHorizontalScrollIndicator= NO;
    _baseScrollView.showsVerticalScrollIndicator= NO;
    _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_baseScrollView];

    
    
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"listHead")];
    topImgView.userInteractionEnabled = YES;
    [self.baseScrollView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.baseScrollView);
        make.centerX.equalTo(weakSelf.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 477/2.0f*PIX));
    }];
    
    UIImageView *circle = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"start")];
    [weakSelf.baseScrollView addSubview:circle];
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
    _head.image = IMAGE_NAME(@"head");
    _head.layer.cornerRadius = 45.0f*PIX;
    _head.clipsToBounds = YES;
    [topImgView addSubview:_head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImgView).offset(20);
        make.top.equalTo(searchImgView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(90*PIX, 90*PIX));
    }];
    _nameLabel = [self addLabelUIWithText:@"" font:20.0f];
    [topImgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.head.mas_right).offset(20);
        make.top.equalTo(weakSelf.head).offset(-5);
        make.size.mas_equalTo(CGSizeMake(75, 30));
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
    scanLabel.text = @"浏览历史";
    scanLabel.textColor = [UIColor darkGrayColor];
    scanLabel.font = [UIFont systemFontOfSize:14.0f];
    [weakSelf.baseScrollView addSubview:scanLabel];
    [scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.baseScrollView).offset(15);
        make.top.equalTo(topImgView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
 
    NSArray *imageArr = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"];
    _historyScroll=[[UIScrollView alloc]initWithFrame:CGRectZero];
    _historyScroll.contentSize=CGSizeMake(115*imageArr.count+20,100);
     _historyScroll.backgroundColor=[UIColor whiteColor];
     _historyScroll.delegate = self;
     _historyScroll.pagingEnabled = YES;
     _historyScroll.bounces = YES;
     _historyScroll.showsHorizontalScrollIndicator= NO;
     _historyScroll.showsVerticalScrollIndicator= NO;
    [weakSelf.baseScrollView addSubview:_historyScroll];
    [_historyScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanLabel.mas_bottom).offset(5);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(110);
    }];
    
    
    for (int i = 0; i<imageArr.count; i++) {
        NSString *imgName =imageArr[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(imgName)];
        imgView.layer.cornerRadius = 8.0f;
        imgView.clipsToBounds = YES;
        imgView.frame = CGRectMake(115*i+10, 0, 110, 100);
        [ _historyScroll addSubview:imgView];
    }

    UILabel *hotLabel = [[UILabel alloc]init];
    hotLabel.text = @"推荐";
    hotLabel.tag  =30;
    hotLabel.textColor = [UIColor darkGrayColor];
    hotLabel.font = [UIFont systemFontOfSize:14.0f];
    [weakSelf.baseScrollView addSubview:hotLabel];
    [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scanLabel);
        make.top.equalTo(weakSelf.historyScroll.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [weakSelf.baseScrollView addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( hotLabel.mas_bottom).offset(5);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(150);
    }];
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"AR_list"];
    
  
}

-(void)makeARTap:(UITapGestureRecognizer *)gesture{
    self.tabBarController.selectedIndex = 2;
}
-(void)searchTap:(UITapGestureRecognizer *)gesture{
    DLog(@"searchTap");
}

//点击图片代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"index = %ld",index);
}

-(UILabel *)addLabelUIWithText:(NSString *)text font:(CGFloat)font{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.font =[UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
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
    [cell.ARImgView sd_setImageWithURL:[NSURL URLWithString:ar.imageUrl]];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:ar.image]];
    cell.nameLabel.text = ar.name;
    return cell;
}

#pragma mark GET
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        CGFloat itemWidth = (SCREEN_WIDTH-30)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero   collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }

    return _collectionView;
}



-(void)getUserInfoWithSessionId{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getAdminInfoWithSessionId:sessionId success:^(Response *response) {
        if (response.msg.status==0) {
            [weakSelf.head sd_setImageWithURL:[NSURL URLWithString:response.data.image]];
            weakSelf.nameLabel.text = response.data.username;
            weakSelf.countLabel.text = [NSString stringWithFormat:@"使用次数：%@次",response.data.useCount];
            weakSelf.shareLabel.text = [NSString stringWithFormat:@"分享：%@次",response.data.share];
            weakSelf.zanLabel.text = [NSString stringWithFormat:@"赞过的:%@次",response.data.give];
            weakSelf.zhiLabel.text = [NSString stringWithFormat:@"制作:%@个",response.data.makeCount];
        }
        WTOAST(response.msg.desc);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getARListWithLat:(NSString *)lat longitude:(NSString *)lng{
    WS(weakSelf)
     HttpManager *manager = [HttpManager requestManager];
    //    AR列表
    _dataList = [NSMutableArray arrayWithCapacity:0];
    [manager getARListWithCity:lat longitude:lng page:@"1" limit:@"20" orderType:@"1" success:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.dataList=response.data.listAR;
            [weakSelf.collectionView reloadData];
            NSInteger row =(weakSelf.dataList.count+1)/2;
            weakSelf.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+150*(row-1)-49);
            [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(155*row);
            }];
        }

    } faiure:^(NSURLSessionDataTask *task, NSError *error) {

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
        NSLog(@"location:%@", location);
        NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        [USER_DEFAULT setObject:lat forKey:@"lat"];
        [USER_DEFAULT setObject:lng forKey:@"lng"];
        [USER_DEFAULT synchronize];
        [self getARListWithLat:lat longitude:lng];
        
//        if (regeocode){
//            self.city = [regeocode.city substringToIndex:regeocode.city.length-1];
//           // [self getARList];
//        }
        
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
