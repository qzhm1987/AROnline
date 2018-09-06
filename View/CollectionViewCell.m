//
//  CollectionViewCell.m
//  ARVideo
//
//  Created by youdian on 2018/6/20.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf)
       
       _ARImgView = [[UIImageView alloc]init];
        _ARImgView.layer.cornerRadius = 8.0f;
        _ARImgView.clipsToBounds = YES;
       _ARImgView.layer.masksToBounds = YES;
        _ARImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview: _ARImgView];
        [_ARImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(0);
            make.left.right.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-45);
        }];
        _headImgView  = [UIImageView new];
        _headImgView.layer.cornerRadius = 18;
        _headImgView.clipsToBounds = YES;
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.ARImgView).offset(18);
            make.top.equalTo(weakSelf.ARImgView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.headImgView.mas_right).offset(8);
            make.centerY.equalTo(weakSelf.headImgView);
            make.size.mas_equalTo(CGSizeMake(150, 30));
        }];
        
        _deleImg = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"删除")];
        _deleImg.hidden = YES;
        _deleImg.userInteractionEnabled = YES;
        [self addSubview:_deleImg];
        [_deleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf.nameLabel);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        
        _heartImg = [[UIImageView alloc]init];
        _heartImg.image = IMAGE_NAME(@"heart");
        [self addSubview:_heartImg];
        [_heartImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(0);
            make.left.equalTo(weakSelf).offset(5);
            make.size.mas_equalTo(CGSizeMake(25*PIX, 25*PIX));
        }];
    
        _countLabel= [UILabel new];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:14.0f];
        _countLabel.textColor = [UIColor whiteColor];
        [self addSubview: _countLabel];
        [ _countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.heartImg);
            make.top.equalTo(weakSelf.heartImg.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
    }
    self.layer.cornerRadius = 8.0f;
    self.clipsToBounds = YES;
    return self;
}

@end


@implementation FCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf)
        
        _funImgView = [[UIImageView alloc]init];
        _funImgView.layer.cornerRadius = 5.0f;
        _funImgView.clipsToBounds = YES;
        [self addSubview:_funImgView];
        [_funImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(55*PIX, 55*PIX));
        }];
        _funLabel = [UILabel new];
        _funLabel.font = [UIFont systemFontOfSize:15.0f];
        _funLabel.textColor = [UIColor lightGrayColor];
        _funLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_funLabel];
        [_funLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.funImgView.mas_bottom);
            make.centerX.equalTo(weakSelf.funImgView);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
        
        
    }
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    return self;
}
@end



@implementation ARCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf)
        _ARImageView = [[UIImageView alloc]init];
         _ARImageView.layer.cornerRadius = 5.0f;
        // _ARImageView.clipsToBounds = YES;
        _ARImageView.layer.masksToBounds = YES;
    _ARImageView.contentMode =  UIViewContentModeScaleAspectFill;
        [self addSubview:  _ARImageView];
        [ _ARImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(0);
            make.left.right.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(0);
        }];
        _heartImg = [[UIImageView alloc]init];
        _heartImg.image = IMAGE_NAME(@"heart");
        [self addSubview:_heartImg];
        [_heartImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(0);
            make.left.equalTo(weakSelf).offset(5);
            make.size.mas_equalTo(CGSizeMake(25*PIX, 25*PIX));
        }];
        
        _countLabel= [UILabel new];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:14.0f];
        _countLabel.textColor = [UIColor whiteColor];
        [self addSubview: _countLabel];
        [ _countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.heartImg);
            make.top.equalTo(weakSelf.heartImg.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
    }
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    return self;
}

@end



