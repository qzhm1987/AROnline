//
//  AppDelegate.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <UMCommon/UMCommon.h>
#import <UShareUI/UShareUI.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic)NSInteger selectIndex;
@property (nonatomic ,copy) NSString *city;



-(void)setWindowRootViewController;
-(void)goLoginViewController;
-(void)goMainViewController;
-(BOOL)isIphoneX;
@end
// 新加跳转链接到在这里注册
// annidy

typedef enum : NSUInteger {
    Help_美女直播,
    Help_录屏直播,
    Help_超级播放器,
    Help_视频录制,
    Help_特效编辑,
    Help_视频拼接,
    Help_图片转场,
    Help_视频上传,
    Help_双人音视频,
    Help_多人音视频,
    Help_rtmp推流,
    Help_直播播放器,
    Help_点播播放器,
    Help_webrtc,
} HelpTitle;

#define  HelpBtnUI(NAME) \
UIButton *helpbtn = [UIButton buttonWithType:UIButtonTypeCustom]; \
helpbtn.tag = Help_##NAME; \
[helpbtn setFrame:CGRectMake(0, 0, 60, 25)]; \
[helpbtn setBackgroundImage:[UIImage imageNamed:@"help_small"] forState:UIControlStateNormal]; \
[helpbtn addTarget:[[UIApplication sharedApplication] delegate] action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside]; \
[helpbtn sizeToFit]; \
UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:helpbtn]; \
self.navigationItem.rightBarButtonItems = @[rightItem];


