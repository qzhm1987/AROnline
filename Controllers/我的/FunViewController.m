//
//  FunViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/22.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "FunViewController.h"
#import "UIImageView+WebCache.h"
#import "ARDetailViewController.h"

@interface FunViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)UICollectionView *collectionView;
@end

@implementation FunViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden  = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    switch (_funType) {
        case makeType:
            self.navigationItem.title = @"我的制作";
            [self getMakeDataList];
            break;
        case shareType:
            self.navigationItem.title = @"我的分享";
            [self getShareDataList];
            break;
        case zanType:
            self.navigationItem.title = @"我赞过的";
            [self getZanDataList];
            break;
        default:
            break;
    }
    WS(weakSelf)
    [self addFunTopUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"typeCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(110*PIX+10);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
       
    }];
    // Do any additional setup after loading the view.
}

-(void)addFunTopUI{
    WS(weakSelf)
    UIImageView *nav = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    nav.userInteractionEnabled = YES;
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(110*PIX);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @[@"我的制作",@"我的分享",@"我赞过的"][_funType];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(nav).offset(34);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [self.view addSubview:back];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:backTap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(34);
        make.left.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UICollection DataSource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"typeCell" forIndexPath:indexPath];
    ARModel *ar = self.dataList[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",ar.counts];
    [cell.ARImgView sd_setImageWithURL:[NSURL URLWithString:ar.imageUrl]];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:ar.image]];
    if (self.funType==makeType) {
         cell.deleImg.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteTap:)];
        [cell.deleImg addGestureRecognizer:tap];
    }
   
    cell.nameLabel.text = ar.name;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"index =%ld",indexPath.row);
    ARModel *ar = self.dataList[indexPath.row];
    ARDetailViewController *detail = [ARDetailViewController new];
    detail.ar = ar;
    [self.navigationController pushViewController:detail animated:YES];
    
    
    
}
-(void)deleteTap:(UITapGestureRecognizer *)gesture{
    CollectionViewCell *cell =(CollectionViewCell *) [gesture.view superview];
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    ARModel *ar = self.dataList[indexPath.row];
    WS(weakSelf)
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除AR作品" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *easyArId = [NSString stringWithFormat:@"%ld",ar.id];
        [self.dataList removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
        [weakSelf deleteArRequestWithArId:easyArId];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
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
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero   collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
      //  _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

-(void)deleteArRequestWithArId:(NSString *)arId{
    HttpManager *manager = [HttpManager requestManager];
    [manager deleteARWithSessionIdAndARId:arId success:^(Response *response) {
        WTOAST(response.msg.desc);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}
-(void)getMakeDataList {
    WS(weakSelf)
     HttpManager *manager = [HttpManager requestManager];
    _dataList = [NSMutableArray arrayWithCapacity:0];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getHaveMakeWithSession:sessionId success:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.dataList = response.data.listAR;
            [weakSelf.collectionView reloadData];
        }
        WTOAST(response.msg.desc);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getShareDataList{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    _dataList = [NSMutableArray arrayWithCapacity:0];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getShareWithSession:sessionId success:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.dataList = response.data.listAR;
            [weakSelf.collectionView reloadData];
        }
        WTOAST(response.msg.desc);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getZanDataList{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    _dataList = [NSMutableArray arrayWithCapacity:0];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    [manager getMyGiveWithSession:sessionId success:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.dataList = response.data.listAR;
            [weakSelf.collectionView reloadData];
        }
        WTOAST(response.msg.desc);
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
