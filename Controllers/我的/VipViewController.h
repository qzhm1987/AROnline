//
//  VipViewController.h
//  ARVideo
//
//  Created by youdian on 2018/6/28.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataList;
@end
