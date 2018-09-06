//
//  ARMakeViewController.h
//  ARVideo
//
//  Created by youdian on 2018/7/12.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ARMakeViewController : UIViewController

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *dataList;

@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic ,copy) NSString *longitude;
@property (nonatomic ,copy) NSString *latitude;
@property (nonatomic,assign)BOOL isDown;
@end
