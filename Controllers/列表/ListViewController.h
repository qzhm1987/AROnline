//
//  ListViewController.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTextField.h"//搜索框
#import "DCCycleScrollView.h"
#import <SDCycleScrollView.h>
#import "CollectionViewCell.h"


@interface ListViewController : UIViewController

@property (strong, nonatomic)UIScrollView *baseScrollView;
@property (strong, nonatomic)UIScrollView *historyScroll;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *dataList;
@end
