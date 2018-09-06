//
//  RegisterViewController.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TypeBinding){
    QQType,
    WechatType
};

@interface RegisterViewController : UIViewController


@property (nonatomic ,copy) NSString *unionid;
@property (nonatomic ,copy) NSString *type;
@property (strong, nonatomic)UIButton *selectBtn;
@property (nonatomic,assign)BOOL isSelected;
@end
