//
//  ChartViewController.h
//  ARVideo
//
//  Created by youdian on 2018/8/14.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataList;
@end
