//
//  HttpManager.h
//  ARVideo
//
//  Created by youdian on 2018/6/14.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARUser.h"

typedef void(^successBlock)(id responobject);
typedef void(^responseBlock)(Response *response);
typedef void(^failBlock)(NSURLSessionDataTask *  task,NSError * error);

@interface HttpManager : NSObject
/**
 获取网络请求管理类
 *
 @return 网络管理类Manager
 */
+(HttpManager *)requestManager;
/**
 二次封装AFNetWorkng
 * @ param path API接口
 * @ param parameters 参数
 * @ success 成功Block
 * @ fail 失败回调
 @ return
 */
+(void)postDataWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters success:(successBlock)success fail:(failBlock)fail;


/**
 二次封装AFNetWorking GET
 @ param
 @ return
 */
+(void)getDataWithUr:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success fail:(failBlock)fail;

/**
 获取短信验证码
 @ param path 请求路径
 @ param telphone 手机号码
 @ param code 图片验证码
 @ param type 注册忘记密码等类型
 @ return
 */
-(void)getSMSCodeWithPhone:(NSString *)telphone code:(NSString *)code type:(NSString *)type success:(responseBlock)response failure:(failBlock)fail;
/**
 用户注册
 @ param path 请求路径
 @ param telphone 手机号
 @ param password 密码
 @ param smsCode 短信验证码
 @ return
 */
-(void)registerUserWithPhone:(NSString *)telphone password:(NSString *)password code:(NSString *)smsCode success:(responseBlock)response failure:(failBlock)fail;

/**
 用户登录
 @ param path 路径
 @ param telphone 手机号
 @param password 密码
 @ return
 */
-(void)loginWithPhone:(NSString *)telphone password:(NSString *)password success:(responseBlock)response failure:(failBlock)fail;

/**
 快速登录
 @ param path 路径 login/quick 快速登录      user/register退出
 @ param sessionId 登录标识
 @ return
 */

-(void)quickLoginWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail;
/**
 退出登录接口
 @ param
 @ return
 */
-(void)loginOutWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail;
/**
 修改密码
 @ param path 路径
 @ param oldPwd 旧密码
 @ param newPwd 新密码
 @ return
 */
-(void)modifyPasswordWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(responseBlock)response failure:(failBlock)fail;

/**
 忘记密码
 @ param path 忘记密码
 @ param telphone 手机号
 @ param password 密码
 @ param smsCode 短信验证码
 @ return
 */
-(void)forgetPasswordWithPhone:(NSString *)telphone password:(NSString *)password code:(NSString *)smsCode success:(responseBlock)response failure:(failBlock)fail;

/**
 添加搜索记录接口
 @ param keywords 关键字
 @ return
 */
-(void)addSearchRecordWIthKey:(NSString *)keywords success:(responseBlock)response failure:(failBlock)fail;

/**
 搜索结果
 @ param
 @ return
 */
-(void)searchResultListWithKeywords:(NSString *)keywords page:(NSNumber *)page limit:(NSNumber *)limit type:(NSString *)type success:(responseBlock)response failure:(failBlock)fail;

/**
 添加点赞或分享
 @ param
 @ return
 */
-(void)addShareOrZanWithSession:(NSString *)sessionId type:(NSString *)type identifier:(NSInteger )ArId success:(responseBlock)response failure:(failBlock)fail;

/**
 AR列表
 @ param
 @ return
 */
-(void)getARListWithCity:(NSString *)lat longitude:(NSString *)lng  page:(NSString *)page limit:(NSString *)limit orderType:(NSString *)order success:(responseBlock)response faiure:(failBlock)fail;

/**
扫描成功
 @ param
 @ return
 */
-(void)scanCountWithSession:(NSString *)sessionId  video:(NSString *)videoUrl phone:(NSString *)phoneType city:(NSString *)address success:(responseBlock)response failure:(failBlock)fail;

/**
 首页轮播图
 @ param
 @ return
 */
-(void)postBannerssuccess:(responseBlock)response failure:(failBlock)fail;
/**
 评论接口
 @ param
 @ return
 */
-(void)arCommentWithSessionIdAndContent:(NSString *)content arid:(NSNumber *)easyArid commentId:(NSNumber *)commendId success:(responseBlock)response failure:(failBlock)fail;

/**
 获取AR评论
 @ param
 @ return
 */
-(void)arCommentWithARId:(NSNumber *)easyArId success:(responseBlock)response failure:(failBlock)fail;

/**
 点赞评论
 @ param
 @ return
 */
-(void)arCommentGiveWithSessionIdAndCommentId:(NSNumber *)commentId success:(responseBlock)response failure:(failBlock)fail;
/**
 删除AR
 @ param easyArId
 @ return
 */
-(void)deleteARWithSessionIdAndARId:(NSString *)easyArId success:(responseBlock)response failure:(failBlock)fail;


/**
 修改个人信息
 @ param username 用户名
 @ param infomation 介绍
 @param birthday 生日
 @param sex 性别
 @ return
 */
-(void)updateInfoWithSessionIdAndName:(NSString *)username info:(NSString *)infomation birth:(NSString *)birthday sex:(NSString *)sex success:(responseBlock)response failure:(failBlock)fail;

/**
 QQ登录绑定 微信登录绑定
 path login/qqBinding login/wechatBinding
 @ param
 @ return
 */
-(void)qqLoginBindingWithSessionAndOpenId:(NSString *)qqOpenId phone:(NSString *)telphone pwd:(NSString *)password success:(responseBlock)response failure:(failBlock)fail;
/**
 微信登录绑定
 @ param
 @ return
 */
-(void)weChatLoginBindingWithSessionAndOpenId:(NSString *)wechatOpenId phone:(NSString *)telphone pwd:(NSString *)password success:(responseBlock)response failure:(failBlock)fail;

/**
 QQ登录
 @ param
 @ return
 */
-(void)qqLoginWithOpenId:(NSString *)qqOpenId success:(responseBlock)response failure:(failBlock)fail;

/**
 微信登录
 @ param
 @ return
 */
-(void)weChatLoginWithOpenId:(NSString *)wechatOpenId success:(responseBlock)response failure:(failBlock)fail;

/**
 QQ绑定注册
 @ param
 @ return
 */
-(void)qqRegisterWithPhone:(NSString *)telphone pwd:(NSString *)password sms:(NSString *)smsCode openId:(NSString *)qqOpenId success:(responseBlock)response failure:(failBlock)fail;
/**
 微信注册绑定
 @ param
 @ return
 */
-(void)wechatRegisterWithPhone:(NSString *)telphone pwd:(NSString *)password sms:(NSString *)smsCode openId:(NSString *)wechatOpenId success:(responseBlock)response failure:(failBlock)fail;


/**
 QQ注销绑定 微信注销绑定
 @ param
 @ return
 */
-(void)qqOrWeChatCancelWithSessionPath:(NSString *)path success:(responseBlock)response failure:(failBlock)fail;

/**
 折线图
 @ param
 @ return
 */

-(void)getScanCountWithARId:(NSString *)ArId success:(responseBlock)response failure:(failBlock)fail;


/**
 AR详情
 @ param
 @ return
 */
-(void)arDetailWithSessionIdAndEasyArId:(NSInteger)arid success:(responseBlock)response failure:(failBlock)fail;

/**
 reportTypeId 举报内容类型
 contentId 作品或评论ID
 @ param
 @ return
 */

-(void)arReportInsertWithSessionAndReportType:(NSString *)reportTypeId contentId:(NSString *)contentId type:(NSString *)type success:(responseBlock)response failure:(failBlock)fail;
/**
 拉黑屏蔽
 @ param
 @ return
 easyArId
 */
-(void)dislikeArWithSessionIdAndEasyArId:(NSString *)easyArId success:(responseBlock)response failure:(failBlock)fail;


#pragma mark GET

/**
 个人信息接口 Get
 @ param path 路径 admin/getInfo
 @ param sessionId 登录标识
 @ return
 */
-(void)getAdminInfoWithSessionId:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail;



/**
 点赞过的
 @ param
 @ return
 */
-(void)getMyGiveWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail;
/**
 分享过的
 @ param
 @ return
 */
-(void)getShareWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail;

/**
 我制作过的
 @ param
 @ return
 */
-(void)getHaveMakeWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail;

/**
 热搜历史
 @ param
 @ return
 */
-(void)getWebSearchWithType:(NSString *)type success:(responseBlock)response failure:(failBlock)fail;
/**
 历史搜索接口
 @ param
 @ return
 */
-(void)getMySearchWithSessionIdAndType:(NSString *)type success:(responseBlock)response failure:(failBlock)fail;
/**
 点赞评论
 @ param
 @ return
 */
-(void)getARCommentGiveWithSessionAndCommentId:(NSString*)commentId success:(responseBlock)response failure:(failBlock)fail;
/**
 消费详细
 @ param
 @ return
 */
-(void)getScancountDetailWithARId:(NSString *)easyArId success:(responseBlock)response failure:(failBlock)fail;
/**
 数据管理数据
 @ param
 @ return
 */
-(void)getAdminDataWithSessionIdSuccess:(responseBlock)response failure:(failBlock)fail;

/**
 获取评论类型
 @ param
 @ return
 */

-(void)getArReportTypeWithType:(NSString *)type success:(responseBlock)response failure:(failBlock)fail;

@end
