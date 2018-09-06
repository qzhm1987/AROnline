//
//  AppDelegate.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeVC.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "MakeARViewController.h"
#import "ARMakeViewController.h"
#import "ListViewController.h"

#import "MLBasePageViewController.h"
#import "NewListViewController.h"
#import "HotListViewController.h"
#import "CityListViewController.h"

#import "MineViewController.h"
#import <easyar/engine.oc.h>
NSString * key = @"AeFvykCZyxCvfDcUbWrCBaTQcfCmCijmTJhMReTyePfJO6n32c2mSTMh0GYs5l1XE4tNRvmQtaiayy04mnzrrJae5N7ow77SttaBtmNl0v5NgJ3aRenk9s7etBdl1CwE0aQ7ZXamIfb7jUsjeMWuVVLtswEPG9A62XmI31A0sbSzu1uuId0shsBtwPxi8yE3CsIjl8WF";
NSString * cloud_server_address = @"6296c09052012b394de6c002d7b81508.cn1.crs.easyar.com:8080";
NSString * cloud_key = @"a1d3c25006629cf8e3bbabd0c64003dd";
NSString * cloud_secret = @"kYSRElAeH4ceubOnGnBiMqyrHYUgspVHZqBcibifXD10ldVjwhU1RGRwebMjGsry7ItPyreLGBQfG5ZB6IzSKspVmhOeLGQ3ZkB08G7BPE9gSnZyLQiscnHiEOiBS5I8";

static NSString *const GaodeKey = @"a075c3e216d4ef9e861e779494ef98ce";


@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@import TXLiteAVSDK_UGC;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
     [self configureEasyAR];
    NSString *channel;
#ifdef DEBUG
    channel = @"Debug";
#else
    channel = @"App Store";
#endif
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:@"5b4c2e3ca40fa3710900016e" channel:channel];
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *welcome = [USER_DEFAULT objectForKey:@"welcome"];
    if (IsStrEmpty(welcome)) {
        WelcomeVC *welcome = [WelcomeVC new];
        self.window.rootViewController = welcome;
    }else{
       [self setWindowRootViewController];
    }
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [AMapServices sharedServices].apiKey = GaodeKey;
    [self configureUSharePlatforms];
    [self configutreTXVideo];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


-(void)configureEasyAR{
#if TARGET_IPHONE_SIMULATOR
#endif
#if TARGET_OS_IPHONE
#endif
    
    //初始化AR
    if (![easyar_Engine initialize:key]) {
        NSLog(@"Initialization Failed.");
    }
    
    
}
-(void)setWindowRootViewController{
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    if (sessionId) {
        [self goMainViewController];
    }else{
         [self goMainViewController];
         // [self goLoginViewController];
    }
  
}
-(void)goLoginViewController{
    LoginViewController *login = [LoginViewController new];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = loginNav;
}
-(void)goMainViewController{
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.delegate = self;
    MainViewController *main  = [MainViewController new];
    UINavigationController *mainNav =[[UINavigationController alloc]initWithRootViewController:main];
   MLBasePageViewController*list = [ MLBasePageViewController new];
    NewListViewController *new = [NewListViewController new];
    HotListViewController *hot = [HotListViewController new];
    CityListViewController *city = [CityListViewController new];
    list.VCArray = @[new,hot,city];
    list.sectionTitles = @[@"最新",@"热门",@"同城"];
    UINavigationController *listNav = [[UINavigationController alloc]initWithRootViewController:list];
    ARMakeViewController *make_ar =[ ARMakeViewController new];
    UINavigationController *makeNav = [[UINavigationController alloc]initWithRootViewController:make_ar];
    MineViewController *mine = [MineViewController new];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mine];
    mainNav.tabBarItem.title = @"首页";
    listNav.tabBarItem.title = @"列表";
    makeNav.tabBarItem.title = @"AR制作";
    mineNav.tabBarItem.title = @"我的";
    mainNav.tabBarItem.image = IMAGE_NAME(@"Main_gray");
    mainNav.tabBarItem.selectedImage = [IMAGE_NAME(@"Main_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    listNav.tabBarItem.image = IMAGE_NAME(@"List_gray");
    listNav.tabBarItem.selectedImage = [IMAGE_NAME(@"List_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   makeNav.tabBarItem.image = [IMAGE_NAME(@"AR_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    makeNav.tabBarItem.selectedImage = [IMAGE_NAME(@"AR_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.image = IMAGE_NAME(@"Mine_gray");
    mineNav.tabBarItem.selectedImage = [IMAGE_NAME(@"Mine_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBar.viewControllers = @[mainNav,listNav,makeNav,mineNav];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:THEME_COLOR];
    [[UINavigationBar appearance]  setTranslucent:NO];
    [[UINavigationBar appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.window.rootViewController = tabBar;
}

-(BOOL)isIphoneX {
    float width= [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    return (width==375.0f&height==812.0f);
}


-(void)configureUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa08f5eb09bfe34d9" appSecret:@"1f100000a78c6542e01a408d7d6b98e5" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1107420047" appSecret:nil redirectURL:nil];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatFavorite)]];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        DLog(@"回调回调");
        // 其他如支付等SDK的回调
    }
    return result;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    DLog(@"index = %ld",tabBarController.selectedIndex);
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    if (tabBarController.selectedIndex>1&&sessionId.length<1) {
        [tabBarController setSelectedIndex:AppDel.selectIndex];
        [self alertLogin];
    }
    
    if (tabBarController.selectedIndex==0||tabBarController.selectedIndex==1) {
        AppDel.selectIndex = tabBarController.selectedIndex;
    }
}

-(void)alertLogin{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录,是否现在登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"现在登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        
        [self goLoginViewController];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)configutreTXVideo{
    NSString *url = @"http://license.vod2.myqcloud.com/license/v1/35f259eb63c58cdc88dc09b02914bbf5/TXUgcSDK.licence";
    NSString *key = @"3bc7bba172507eb5e62da437cb417cd5";
    [TXUGCBase setLicenceURL:url key:key];
    
    [TXLiveBase setConsoleEnabled:YES];
    [TXLiveBase setLogLevel:LOGLEVEL_DEBUG];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
     [[NSNotificationCenter defaultCenter]postNotificationName:@"appBecomeActive" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
