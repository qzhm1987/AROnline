//
//  FunViewController.h
//  ARVideo
//
//  Created by youdian on 2018/6/22.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"


typedef NS_ENUM(NSInteger, funType) {
    makeType,
    shareType,
    zanType,
};

@interface FunViewController : UIViewController

@property (assign, nonatomic)funType funType;
@property (strong, nonatomic)NSMutableArray *dataList;
@end
