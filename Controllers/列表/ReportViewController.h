//
//  ReportViewController.h
//  ARVideo
//
//  Created by youdian on 2018/8/29.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,copy) NSString *rType;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *dataList;
@property (nonatomic ,copy) NSString *contentId;
@end
