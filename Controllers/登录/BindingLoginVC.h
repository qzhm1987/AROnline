//
//  BindingLoginVC.h
//  ARVideo
//
//  Created by youdian on 2018/8/15.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTextField.h"

@interface BindingLoginVC : UIViewController

@property (strong, nonatomic)QTextField *oPwdTextField;
@property (strong, nonatomic)QTextField *nPwdTextField;
@property (strong, nonatomic)QTextField *rPwdTextField;

@property (strong, nonatomic)QTextField *phoneTextField;
@property (nonatomic ,copy) NSString *unionid;
@property (nonatomic ,copy) NSString *type;
@end
