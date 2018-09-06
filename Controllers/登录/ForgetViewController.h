//
//  ForgetViewController.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)(NSString*phone,NSString*password);

@interface ForgetViewController : UIViewController

@property (nonatomic ,copy) returnBlock returnBlock;
@end
