//
//  SearchResultVC.h
//  ARVideo
//
//  Created by youdian on 2018/8/17.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)HotSearch *search;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *dataList;
@property (nonatomic ,copy) NSString *keywords;
@property (nonatomic ,copy) NSString *type;
@end
