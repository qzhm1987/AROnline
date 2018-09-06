//
//  IntroViewController.h
//  ARVideo
//
//  Created by youdian on 2018/7/18.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^introBlock)(NSString *introduce);
@interface IntroViewController : UIViewController

@property (nonatomic ,copy)introBlock introBlock;

@end
