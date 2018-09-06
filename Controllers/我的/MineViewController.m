//
//  MineViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/14.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "MineViewController.h"
#import "CollectionViewCell.h"
#import "FunViewController.h"
#import "SetViewController.h"
#import "VipViewController.h"
#import "ChartViewController.h"
#import "UIImageView+WebCache.h"

#define Head_R 30.0f
@interface MineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)UIImageView *topImgView;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSArray *funArray;
@property (strong, nonatomic)NSArray *ImgArray;
@property (strong, nonatomic)UIImageView *headImage;

@property (strong, nonatomic)UILabel *remind;
@property (strong, nonatomic)  UILabel *perWeek;
@property (strong, nonatomic)UILabel *perMonth;
@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
     [self addFounctionView];
    [self addMineUI];
    [self getUserInfoWithSessionId];
    [self getAdminData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHead:) name:@"changeHead" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:@"refreshInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adminData:) name:@"newData" object:nil];
    // Do any additional setup after loading the view.
}

-(void)refreshInfo:(NSNotification *)notification{
    [self getUserInfoWithSessionId];
}
-(void)changeHead:(NSNotification *)notification{
    ARUser *user= [ARUser shareARUser];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:user.image]];
}
-(void)adminData:(NSNotification *)notification{
    
    [self getAdminData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)addMineUI{
    WS(weakSelf)
    ARUser *user = [ARUser shareARUser];
    _topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"BlueBack")];
    _topImgView.userInteractionEnabled = YES;
    [self.collectionView addSubview:_topImgView];
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.collectionView);
        make.height.mas_equalTo(210*PIX);
    }];
    UIImageView *head = [UIImageView new];
    head.layer.cornerRadius = Head_R;
    [head sd_setImageWithURL:[NSURL URLWithString:user.image]];
    head.clipsToBounds = YES;
    [_topImgView addSubview:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImgView).offset(20);
        make.centerY.equalTo(weakSelf.topImgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(Head_R*2, Head_R*2));
    }];
    _headImage = head;
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = user.username;
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = [UIColor whiteColor];
    [_topImgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(20);
        make.top.equalTo(head);
        make.size.mas_equalTo(CGSizeMake(165, 30));
    }];
    UILabel *phone = [UILabel new];
    phone.textColor = [UIColor whiteColor];
    phone.font = [UIFont systemFontOfSize:14.0f];
    phone.text =user.telphone;
    [_topImgView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 25));
    }];
    UIImageView *setImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"set")];
    setImgView.userInteractionEnabled = YES;
    [_topImgView addSubview:setImgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setTap:)];
    [setImgView addGestureRecognizer:tap];
    
    [setImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(60);
        make.top.equalTo(nameLabel).offset(-20);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [self dataView];
   
}
-(void)dataView{
    WS(weakSelf)
    ARUser *user = [ARUser shareARUser];
    UIImageView *data = [[UIImageView alloc]init];
    data.backgroundColor = [UIColor whiteColor];
     data.image = IMAGE_NAME(@"data");
    data.userInteractionEnabled = YES;
    data.layer.cornerRadius = 15.0f;
    data.clipsToBounds = YES;
    [self.collectionView addSubview:data];
    [self.collectionView bringSubviewToFront:data];
    [data mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.collectionView);
        make.centerY.equalTo(weakSelf.topImgView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 233/2.0f));
    }];
    UILabel *dataM = [UILabel new];
    dataM.text = @"数据管理";
    dataM.textColor = [UIColor darkGrayColor];
    dataM.font = [UIFont systemFontOfSize:16.0f];
    [data addSubview:dataM];
    [dataM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(data).offset(15);
        make.top.equalTo(data).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
  
    UILabel *count_R = [UILabel new];
   count_R.textColor =  [UIColor darkGrayColor];
    count_R.font = [UIFont systemFontOfSize:14.0f];
   count_R.text  = @"剩余次数";
    [data addSubview:count_R];
   
    [count_R mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dataM).offset(-8);
        make.top.equalTo(dataM.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    UILabel *rcount = [UILabel new];
    rcount.textAlignment = NSTextAlignmentCenter;
   rcount .font = [UIFont systemFontOfSize:14.0f];
    rcount .text  = [NSString stringWithFormat:@"%ld",user.counts];
    [data addSubview:rcount ];
     _remind = rcount;
    [rcount  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(count_R).offset(0);
        make.top.equalTo(count_R.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    UILabel *count_P = [UILabel new];
    count_P.font = [UIFont systemFontOfSize:14.0f];
    count_P.textColor = [UIColor darkGrayColor];
    count_P.text  = @"最近30天使用次数";
    [data addSubview:count_P];

    [count_P mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(count_R.mas_right).offset(10);
        make.top.equalTo(dataM.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 25));
    }];
    UILabel *pcount = [UILabel new];
    pcount.font = [UIFont systemFontOfSize:16.0f];
    pcount.text  =user.makeCount;
    [data addSubview:pcount];
        _perMonth = pcount;
    [pcount mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(count_P).offset(0);
        make.top.equalTo(count_P.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(35, 20));
    }];
    
    UILabel *count_W = [UILabel new];
    count_W.textColor = [UIColor darkGrayColor];
    count_W.font = [UIFont systemFontOfSize:14.0f];
    count_W.text  = @"最近一周";
    [data addSubview:count_W];
    
    [count_W mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(count_P.mas_right).offset(15);
        make.top.equalTo(count_P).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    UILabel *mcount = [UILabel new];
    mcount.font = [UIFont systemFontOfSize:16.0f];
    mcount.text  = user.useCount;
    [data addSubview:mcount];
    _perWeek = mcount;
    [mcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(count_W).offset(0);
        make.top.equalTo(count_W.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(35, 20));
    }];
    
    UILabel *more = [UILabel new];
    more.text = @"更多";
    more.hidden = YES;
    more.userInteractionEnabled = YES;
    more.textColor =  [UIColor darkGrayColor];
    more.font = [UIFont systemFontOfSize:14.0f];
    [data addSubview:more];
    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreTap:)];
    [more addGestureRecognizer:moreTap];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dataM);
        make.right.equalTo(data).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 25));
    }];
}


-(void)addFounctionView{
    WS(weakSelf)
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[FCollectionViewCell class] forCellWithReuseIdentifier:@"funCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(-20);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.bottom.equalTo(weakSelf.view);
       // make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 320*PIX));
    }];
}

//设置

-(void)setTap:(UITapGestureRecognizer *)gesture{
    DLog(@"set");
    SetViewController *set = [SetViewController new];
    [self.navigationController pushViewController:set animated:YES];
}
-(void)moreTap:(UITapGestureRecognizer *)gesture{
    DLog(@"more");
    ChartViewController *chart = [ChartViewController new];
    [self.navigationController pushViewController:chart animated:YES];
    
}



#pragma mark UICollection DataSource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"funCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *imgName = self.ImgArray[indexPath.row];
    cell.funImgView.image = IMAGE_NAME(imgName);
    cell.funLabel.text = self.funArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<3) {
        FunViewController *fun = [FunViewController new];
        fun.funType = indexPath.row;
        [self.navigationController pushViewController:fun animated:YES];
    }else{
        CWTOAST(@"iOS暂不支持VIP充值");
//        VipViewController *vip = [VipViewController new];
//        [self.navigationController pushViewController:vip animated:YES];
    }
    
    
    
}


-(void)getUserInfoWithSessionId{
    HttpManager *manager = [HttpManager requestManager];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getAdminInfoWithSessionId:sessionId success:^(Response *response) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getAdminData{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    [manager getAdminDataWithSessionIdSuccess:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.remind.text = [NSString stringWithFormat:@"%ld",response.data.restNumber];
            weakSelf.perMonth.text  =[NSString stringWithFormat:@"%ld",response.data.monthNumber];
            weakSelf.perWeek.text  =[NSString stringWithFormat:@"%ld",response.data.weekendNumber];
        }else{
            WTOAST(response.msg.desc);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}






#pragma mark GET

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 2.0f;
        flowLayout.minimumInteritemSpacing = 2.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(210*PIX+70, 15, 0, 15);
        CGFloat itemWidth = (SCREEN_WIDTH-30-2)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,160*PIX);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero   collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.layer.cornerRadius = 15.0f;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _collectionView;
}


-(NSArray *)funArray{
    if (!_funArray) {
        _funArray = @[@"我的制作",@"我的分享",@"我赞过的",@"VIP充值"];
    }
    return _funArray;
}
-(NSArray *)ImgArray{
    if (!_ImgArray) {
        _ImgArray = @[@"make",@"share",@"zan",@"Vip"];
    }
    return _ImgArray;
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
