//
//  HotListViewController.h
//  ARVideo
//
//  Created by youdian on 2018/7/21.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ARDetailViewController.h"

@interface HotListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *dataList;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic ,copy) NSString *longitude;
@property (nonatomic ,copy) NSString *latitude;
@property (nonatomic,assign)BOOL isDown;
@end
