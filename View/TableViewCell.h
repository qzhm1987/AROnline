//
//  TableViewCell.h
//  ARVideo
//
//  Created by youdian on 2018/7/30.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic)UIImageView *headImgView;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *dateLabel;
@property (strong, nonatomic)UILabel *contentLabel;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic)UIImageView *zanView;
@end

@interface ChartDataCell : UITableViewCell

@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UILabel *cityLabel;
@property (strong, nonatomic)UILabel *deviceLabel;
@end

@interface PayTableViewCell : UITableViewCell

@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic)UILabel *valueLabel;
@end
