//
//  TableViewCell.m
//  ARVideo
//
//  Created by youdian on 2018/7/30.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    WS(weakSelf)
    if (self) {
        _headImgView  = [[UIImageView alloc]init];
        _headImgView.layer.cornerRadius = 20.0f;
        _headImgView.clipsToBounds = YES;
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(weakSelf).offset(10);
            make.left.equalTo(weakSelf).offset(15);
        }];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headImgView).offset(0);
            make.left.equalTo(weakSelf.headImgView.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(160, 25));
        }];
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor lightGrayColor];
       _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel);
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(120, 25));
        }];
      _contentLabel = [UILabel new];
       _contentLabel.font = [UIFont systemFontOfSize:15.0f];
       _contentLabel.textColor = [UIColor darkGrayColor];
       _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _contentLabel];
        [ _contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel);
            make.top.equalTo(weakSelf.dateLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(280, 25));
        }];
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:15.0f];
        _countLabel.textColor = [UIColor darkGrayColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:  _countLabel];
        [  _countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(0);
            make.bottom.equalTo(weakSelf).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        _zanView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"点赞")];
        _zanView.userInteractionEnabled = YES;
        [self addSubview:_zanView];
        [_zanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).offset(-5);
            make.right.equalTo(weakSelf.countLabel.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
       
        
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ChartDataCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    WS(weakSelf)
    if (self) {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_timeLabel];
        _cityLabel = [UILabel new];
        _cityLabel.textColor = [UIColor darkGrayColor];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_cityLabel];
        
        _deviceLabel = [UILabel new];
         _deviceLabel.textColor = [UIColor darkGrayColor];
        _deviceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_deviceLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(30);
            make.top.bottom.equalTo(weakSelf);
            make.width.mas_equalTo(80);
        }];
        [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.bottom.equalTo(weakSelf);
            make.width.mas_equalTo(80);
        }];
        [_deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-30);
            make.top.bottom.equalTo(weakSelf);
            make.width.mas_equalTo(80);
        }];
        
        
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

@implementation PayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    WS(weakSelf)
    if (self) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"AR视频";
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(25);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        _countLabel = [UILabel new];
        _countLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel.mas_right).offset(10);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        _valueLabel = [UILabel new];
        [self addSubview:_valueLabel];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-25);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
    }
    return self;
}

@end





