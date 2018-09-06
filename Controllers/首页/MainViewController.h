//
//  MainViewController.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic)UIButton *welBtn;
@property (strong, nonatomic)HttpManager *manager;
@property (strong, nonatomic)NSMutableArray *banerArray;

@end
