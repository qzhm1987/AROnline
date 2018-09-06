//
//  SearchResultVC.m
//  ARVideo
//
//  Created by youdian on 2018/8/17.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "SearchResultVC.h"
#import "ARDetailViewController.h"
#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface SearchResultVC ()

@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addMainSearchUI];
    [self getSearchResults];
    
    // Do any additional setup after loading the view.
}

-(void)addMainSearchUI{
    WS(weakSelf)
    [weakSelf.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(-20);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-20);
    }];
    UIImageView *nav = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    nav.userInteractionEnabled = YES;
    [_collectionView addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.collectionView);
        make.height.mas_equalTo(110);
    }];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [nav addSubview:back];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:backTap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(35);
        make.left.equalTo(weakSelf.view).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label =[UILabel new];
    label.text = @"搜索结果";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [nav addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nav).offset(20);
        make.centerX.equalTo(weakSelf.collectionView);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
}


#pragma mark UICollection DataSource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
    
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"search_list" forIndexPath:indexPath];
    ARModel *ar = self.dataList[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",ar.counts];
    [cell.ARImgView sd_setImageWithURL:[NSURL URLWithString:ar.image_url]];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:ar.image]];
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

#pragma mark GET
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(110+20, 10, 0, 10);
        CGFloat itemWidth = (SCREEN_WIDTH-30)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth+30);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero   collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
         [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"search_list"];
    }
    return _collectionView;
}

-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSearchResults{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    [manager searchResultListWithKeywords:self.keywords page:@0 limit:@15 type:self.type success:^(Response *response) {
        if (response.msg.status ==0) {
            weakSelf.dataList = response.data.resultList;
            [weakSelf.collectionView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
