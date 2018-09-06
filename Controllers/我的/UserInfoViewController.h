//
//  UserInfoViewController.h
//  ARVideo
//
//  Created by youdian on 2018/7/17.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_DatePickerView.h"

@interface UserInfoViewController : UIViewController<PW_DatePickerViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *funArray;
@property (nonatomic,strong) PW_DatePickerView *PWpickerView;


@end
