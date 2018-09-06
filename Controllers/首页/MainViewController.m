//
//  MainViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "MainViewController.h"
#import "WaterWaveView.h"
#import "DCCycleScrollView.h"
#import "FunctionViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ARDetailViewController.h"


#import "QBImagePickerController.h"
#import "VideoLoadingController.h"
#import "UIImage+GIF.h"

#import "ViewController.h"
#import "VideoRecordViewController.h"

@import TXLiteAVSDK_UGC;
#define  tabBarHeight self.tabBarController.tabBar.frame.size.height
@interface MainViewController ()<DCCycleScrollViewDelegate,AMapSearchDelegate,QBImagePickerControllerDelegate>
{
    VideoConfigure *_videoConfig;
}
@property (strong, nonatomic)AMapSearchAPI *search;
@property (strong, nonatomic)UILabel *cityLabel;
@property (strong, nonatomic)UILabel *tLabel;
@property (strong, nonatomic)UILabel *wLabel;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (strong, nonatomic) DCCycleScrollView *banner;

@property (nonatomic) QBImagePickerMediaType mediaType;
@property (strong, nonatomic) QBImagePickerController* imagePicker;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self quickLogin];
    [self addMainUI];
    [self startLocation];
    [self requestBanner];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:@"refreshInfo" object:nil];
   
    // Do any additional setup after loading the view.
}
-(void)refreshInfo:(NSNotification *)notification{
    [self getUserInfoWithSessionId];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)quickLogin{
    WS(weakSelf)
    NSString *session = [USER_DEFAULT objectForKey:@"sessionId"];
    DLog(@"session = %@",session);
    if (session.length>0) {
        [self.manager quickLoginWithSession:session success:^(Response *response) {
            WTOAST(response.msg.desc);
            if (response.msg.status!=0) {
                [AppDel goLoginViewController];
            }else{
                DLog(@"无操作");
                [weakSelf getUserInfoWithSessionId];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
   
}
-(void)requestBanner{
     WS(weakSelf)
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    _banerArray = [NSMutableArray arrayWithCapacity:0];
    [self.manager postBannerssuccess:^(Response *response) {
        weakSelf.banerArray = response.data.listAR;
            for (ARModel *ar in response.data.listAR) {
                [imageArr addObject:ar.imageUrl];
            }
        weakSelf.banner.imgArr = imageArr;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
    }];
}
-(void)addMainUI{
    WS(weakSelf)
    CGFloat height = [AppDel isIphoneX]?170:150;
    WaterWaveView *backImgView = [[WaterWaveView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    [self.view addSubview:backImgView];
    _cityLabel = [[UILabel alloc]init];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    _cityLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.view addSubview:_cityLabel];
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView).offset(35);
        make.centerX.equalTo(backImgView);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    UIImageView *line = [UIImageView new];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cityLabel.mas_bottom);
        make.left.right.equalTo(weakSelf.cityLabel);
        make.height.mas_equalTo(1);
    }];
    _tLabel = [UILabel new];
    _tLabel.textAlignment = NSTextAlignmentLeft;
    _tLabel.font = [UIFont systemFontOfSize:23.0f];
    _tLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_tLabel];
    [_tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
   _wLabel = [UILabel new];
    _wLabel.textAlignment = NSTextAlignmentRight;
   _wLabel.font = [UIFont systemFontOfSize:23.0f];
    _wLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_wLabel];
    [_wLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line);
        make.top.equalTo(line);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    _banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, height+60, SCREEN_WIDTH, 160*PIX) shouldInfiniteLoop:YES imageGroups:nil];
   // _banner.pageControl.currentPageIndicatorTintColor = THEME_COLOR;
    _banner.autoScrollTimeInterval = 3;
    _banner.autoScroll = YES;
    _banner.isZoom = YES;
    _banner.itemSpace = 0;
    _banner.imgCornerRadius = 8.0f;
    _banner.itemWidth = SCREEN_WIDTH-100;
    _banner.delegate = self;
    [self.view addSubview:_banner];
    
    UIImageView *gif_imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:gif_imgView];
    gif_imgView.backgroundColor = [UIColor clearColor];
    NSString *str = [[NSBundle mainBundle]pathForResource:@"main_gif" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:str];
    gif_imgView.image = [UIImage sd_animatedGIFWithData:data];
    
    [gif_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.banner.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 230*PIX));
    }];
    
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
       // button.backgroundColor = [UIColor redColor];
        button.tag = 10+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat maxY =CGRectGetMaxY(self.banner.frame)+20;
        CGRect rect ;
        if (i==0) {
           rect = CGRectMake(10, maxY,210*PIX , 85*PIX);
        }
       else if (i==1) {
            rect =CGRectMake(210*PIX+20, maxY, 155*PIX, 210*PIX);
        }
       else if (i==2){
           rect = CGRectMake(10, maxY+100, 110*PIX, 100*PIX);
       }else{
           rect = CGRectMake(110*PIX+20, maxY+100, 90*PIX, 100*PIX);
       }
        button.frame = rect;
        [self.view addSubview:button];
    }
    
    
    /*
    UIImageView *cityImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backCity")];
    [self.view addSubview:cityImgView];
    [cityImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0-tabBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(180*PIX);
    }];
    UIImageView *startView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"open1")];
    [self.view addSubview:startView];
    UITapGestureRecognizer *startTap   = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(start:)];
    [startView addGestureRecognizer:startTap];
    startView.userInteractionEnabled  = YES;
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cityImgView.mas_top).offset(40);
        make.centerX.equalTo(cityImgView);
        make.size.mas_equalTo(CGSizeMake(150*PIX, 150*PIX));
    }];
    */
}


-(void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 10:
            
            [self scanQRAndAR];
            break;
        case 11:
            
            [self videoRecoder];
            break;
        case 12:
            [self editVideo];
            break;
        case 13:
            [self imagesVideo];
            break;
            
        default:
            break;
    }
}
-(void)scanQRAndAR{
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)videoRecoder{
    //初始化video
    _videoConfig = [[VideoConfigure alloc] init];
    _videoConfig.videoRatio = VIDEO_ASPECT_RATIO_9_16;
    _videoConfig.bps = 6500;
    _videoConfig.fps = 30;
    _videoConfig.gop = 3;
    VideoRecordViewController *vc = [[VideoRecordViewController alloc] initWithConfigure:_videoConfig];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)editVideo{
    _imagePicker = [[QBImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.allowsMultipleSelection = NO;
    _imagePicker.showsNumberOfSelectedAssets = NO;
    _imagePicker.mediaType = QBImagePickerMediaTypeVideo;
    _mediaType = _imagePicker.mediaType;
    [self.navigationController pushViewController:_imagePicker animated:YES];
}
-(void)imagesVideo{
    _imagePicker = [[QBImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.allowsMultipleSelection = YES;
    _imagePicker.minimumNumberOfSelection = 3;
    _imagePicker.showsNumberOfSelectedAssets = YES;
    _imagePicker.mediaType = QBImagePickerMediaTypeImage;
    _mediaType = _imagePicker.mediaType;
      [self.navigationController pushViewController:_imagePicker animated:YES];
}



#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    [self.navigationController popViewControllerAnimated:YES];
    
    VideoLoadingController *loadvc = [[VideoLoadingController alloc] init];
     loadvc.composeMode = ComposeMode_Edit;
    
   /*
    if ([cellInfo.title isEqualToString:@"特效编辑"] || [cellInfo.title isEqualToString:@"图片转场"]) {
        loadvc.composeMode = ComposeMode_Edit;
    } else if ([cellInfo.title isEqualToString:@"视频拼接"]) {
        loadvc.composeMode = ComposeMode_Join;
    } else if ([cellInfo.title isEqualToString:@"视频上传"]) {
        loadvc.composeMode = ComposeMode_Upload;
    }
    else return;
    */
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loadvc];
    [self presentViewController:nav animated:YES completion:nil];
    [loadvc exportAssetList:assets assetType:_mediaType == QBImagePickerMediaTypeImage ? AssetType_Image : AssetType_Video];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"imagePicker Canceled.");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)startLocation{
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =20;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 10;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
            }
        }
        
        NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        [USER_DEFAULT setObject:lat forKey:@"lat"];
        [USER_DEFAULT setObject:lng forKey:@"lng"];
        [USER_DEFAULT synchronize];
       
        if (regeocode){
            DLog(@"regeocode = %@",regeocode);
            AppDel.city = regeocode.city;
            [self requestWeatherDataWithCityCode:regeocode.adcode];
        }else{
            AppDel.city = @"石家庄市";
            [self requestWeatherDataWithCityCode:@"130102"];
        }
        
    }];
}

-(void)requestWeatherDataWithCityCode:(NSString *)adCode{
    DLog(@"adcode = %@",adCode);
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = adCode;
    request.type = AMapWeatherTypeLive;
    [self.search AMapWeatherSearch:request];
}

-(void)start:(UITapGestureRecognizer *)gesture{
    QBImagePickerController* imagePicker = [[QBImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.showsNumberOfSelectedAssets = YES;
    imagePicker.maximumNumberOfSelection = 10;
    imagePicker.mediaType = QBImagePickerMediaTypeVideo;
    _mediaType = QBImagePickerMediaTypeVideo;
    
    /*
    //特效编辑
    imagePicker.allowsMultipleSelection = NO;
    imagePicker.showsNumberOfSelectedAssets = NO;
    imagePicker.mediaType = QBImagePickerMediaTypeVideo;
    _mediaType = imagePicker.mediaType;
    */
    /*
     图片转场
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.minimumNumberOfSelection = 3;
    imagePicker.showsNumberOfSelectedAssets = YES;
    imagePicker.mediaType = QBImagePickerMediaTypeImage;
    _mediaType = imagePicker.mediaType;
    */
    [self.navigationController pushViewController:imagePicker animated:YES];
    
/*
    FunctionViewController *fun = [[FunctionViewController alloc]init];
    [self.navigationController pushViewController:fun animated:YES];
 */
}


//点击图片代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"index = %ld",index);
    ARModel *ar = self.banerArray[index];
    ARDetailViewController *detail = [ARDetailViewController new];
    detail.ar = ar;
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
    AMapLocalWeatherLive *live = response.lives[0];
    _cityLabel.text = live.city;
    _tLabel.text = [NSString stringWithFormat:@"%@℃",live.temperature];
    _wLabel.text = live.weather;
    
}
-(void)getUserInfoWithSessionId{
    
    HttpManager *manager = [HttpManager requestManager];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getAdminInfoWithSessionId:sessionId success:^(Response *response) {
        if (response.msg.status==0) {
            NSDictionary *dict = response.data.admin;
            ARUser *user = [ARUser shareARUser];
            [user yy_modelSetWithJSON:dict];
            
//            [weakSelf.head sd_setImageWithURL:[NSURL URLWithString:user.image]];
//            weakSelf.nameLabel.text = user.username;
//            weakSelf.countLabel.text = [NSString stringWithFormat:@"使用次数：%@次",user.useCount];
//            weakSelf.shareLabel.text = [NSString stringWithFormat:@"分享：%@次",user.share];
//            weakSelf.zanLabel.text = [NSString stringWithFormat:@"赞过的:%@次",user.give];
//            weakSelf.zhiLabel.text = [NSString stringWithFormat:@"制作:%@个",user.makeCount];
        }else{
             WTOAST(response.msg.desc);
        }
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(HttpManager *)manager{
    if (!_manager) {
        _manager = [HttpManager requestManager];
    }
    return _manager;
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
