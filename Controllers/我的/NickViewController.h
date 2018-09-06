//
//  NickViewController.h
//  ARVideo
//
//  Created by youdian on 2018/7/19.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^nameBlock)(NSString *nickName);
@interface NickViewController : UIViewController
@property (nonatomic ,copy)nameBlock nameBlock;
@property (strong, nonatomic)UITextField *nameTextField;
@end
