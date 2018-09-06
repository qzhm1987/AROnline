//
//  CollectionViewCell.h
//  ARVideo
//
//  Created by youdian on 2018/6/20.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *ARImgView;
@property (strong, nonatomic)UIImageView *heartImg;
@property (strong, nonatomic)UIImageView *headImgView;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic)UIImageView *deleImg;
@end

@interface FCollectionViewCell : UICollectionViewCell  //功能cell

@property (strong, nonatomic)UIImageView *funImgView;//功能图
@property (strong, nonatomic)UILabel *funLabel; //功能标签
@end

@interface ARCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *ARImageView;
@property (strong, nonatomic)UIImageView *heartImg;
@property (strong, nonatomic)UILabel *countLabel;
@end






