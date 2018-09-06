//
//  HttpManager.m
//  ARVideo
//
//  Created by youdian on 2018/6/14.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "HttpManager.h"
static HttpManager *manager = nil;
@implementation HttpManager


+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        if (!manager) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}
+(HttpManager *)requestManager{
    return [[self alloc]init];
}
//请求总接口 POST

+(void)postDataWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters success:(successBlock)success fail:(failBlock)fail {

    [SVProgressHUD show];
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
   // NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [SVProgressHUD dismiss];
           success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [SVProgressHUD dismiss];
        WTOAST(@"网络连接错误");
        fail( task, error);
    }];
}
+(void)getDataWithUr:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success fail:(failBlock)fail{
     [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [SVProgressHUD dismiss];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        WTOAST(@"网络连接错误");
        fail( task, error);
    }];
    
}
//获取短信验证码
-(void)getSMSCodeWithPhone:(NSString *)telphone code:(NSString *)code type:(NSString *)type success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"register/validate";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(telphone,type,code);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}

//用户注册
-(void)registerUserWithPhone:(NSString *)telphone password:(NSString *)password code:(NSString *)smsCode success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"register/register";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *dataDict = NSDictionaryOfVariableBindings(telphone,password,smsCode);
    NSString *datas = [NSString dictionaryToJson:dataDict];
    NSString *type = @"ios";
    NSDictionary *parameters = NSDictionaryOfVariableBindings(datas,type);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//用户快速登录
-(void)loginWithPhone:(NSString *)telphone password:(NSString *)password success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"login/login";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *dataDict = NSDictionaryOfVariableBindings(telphone,password);
    NSString *datas = [NSString dictionaryToJson:dataDict];
    NSString *type = @"ios";
    NSDictionary *parameters = NSDictionaryOfVariableBindings(datas,type);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
       response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//快速登录
-(void)quickLoginWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"login/quick";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//用户退出
-(void)loginOutWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"user/register";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//修改密码
-(void)modifyPasswordWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"login/modifyPassword";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *dataDict = NSDictionaryOfVariableBindings(oldPwd,newPwd);
    NSString *datas = [NSString dictionaryToJson:dataDict];
    NSString *type = @"ios";
    NSDictionary *parameters = NSDictionaryOfVariableBindings(datas,type,sessionId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//忘记密码
-(void)forgetPasswordWithPhone:(NSString *)telphone password:(NSString *)password code:(NSString *)smsCode success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"login/forgetPassword";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *dataDict = NSDictionaryOfVariableBindings(telphone,password,smsCode);
    NSString *datas = [NSString dictionaryToJson:dataDict];
    NSString *type = @"ios";
    NSDictionary *parameters = NSDictionaryOfVariableBindings(datas,type);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//添加搜索记录
-(void)addSearchRecordWIthKey:(NSString *)keywords success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"searchLog/insert";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(keywords,sessionId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}

//搜索结果
-(void)searchResultListWithKeywords:(NSString *)keywords page:(NSNumber *)page limit:(NSNumber *)limit type:(NSString *)type success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"searchLog/resultList";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters;
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    if (sessionId.length>0) {
        parameters = NSDictionaryOfVariableBindings(sessionId,keywords,page,limit,type);
    }else{
        parameters = NSDictionaryOfVariableBindings(keywords,page,limit,type);
    }
    
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

-(void)addShareOrZanWithSession:(NSString *)sessionId type:(NSString *)type identifier:(NSInteger)ArId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"infomation/insertInfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters;
    sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSNumber *easyArId = [NSNumber numberWithInteger:ArId];
    if (sessionId.length>1) {
         parameters = NSDictionaryOfVariableBindings(sessionId,type,easyArId);
    }else{
         parameters = NSDictionaryOfVariableBindings(type,easyArId);
    }
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
    
}

//AR列表
-(void)getARListWithCity:(NSString *)lat longitude:(NSString *)lng page:(NSString *)page limit:(NSString *)limit orderType:(NSString *)order success:(responseBlock)response faiure:(failBlock)fail{
    limit =limit.length>0?limit:@"20";
    NSString *path  = @"ar/list";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters;
    if (sessionId.length<1) {
        parameters = NSDictionaryOfVariableBindings(lat,lng,page,limit,order);
    }else{
      parameters = NSDictionaryOfVariableBindings(lat,lng,page,limit,order,sessionId);
    }
    
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        DLog(@"Res = %@",responobject);
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//扫描成功
-(void)scanCountWithSession:(NSString *)sessionId video:(NSString *)videoUrl phone:(NSString *)phoneType city:(NSString *)address success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"scanCount/insert";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    address = address.length>0?address:@"石家庄市";
    NSDictionary *parameters;
    if (sessionId.length<1) {
         parameters= NSDictionaryOfVariableBindings(videoUrl,phoneType,address);
    }else{
         parameters= NSDictionaryOfVariableBindings(sessionId,videoUrl,phoneType,address);
    }
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//ar详情
-(void)arDetailWithSessionIdAndEasyArId:(NSInteger)arid success:(responseBlock)response failure:(failBlock)fail{
    NSString *path  = @"ar/getDetail";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSString *telphoneUuid = [NSString getUUID];
    NSNumber *easyArId = [NSNumber numberWithInteger:arid];
    NSDictionary *parameters;
    if (sessionId.length<1) {
        parameters= NSDictionaryOfVariableBindings(easyArId,telphoneUuid);
    }else{
        parameters= NSDictionaryOfVariableBindings(sessionId,easyArId,telphoneUuid);
    }
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
-(void)postBannerssuccess:(responseBlock)response failure:(failBlock)fail{
    NSString *urlStr = @"https://ar.zhyell.com/api/ar/recommendList";
    [HttpManager postDataWithUrl:urlStr andParameters:nil success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
         fail(task,error);
    }];

}
// 评论接口
-(void)arCommentWithSessionIdAndContent:(NSString *)content arid:(NSNumber *)easyArId commentId:(NSNumber *)commendId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"arComment/insert";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters;
    if (commendId) {
         parameters = NSDictionaryOfVariableBindings(sessionId,content,easyArId,commendId);
    }else{
     parameters = NSDictionaryOfVariableBindings(sessionId,content,easyArId);
    }
    
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}
 //获取AR评论
-(void)arCommentWithARId:(NSNumber *)easyArId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"arComment/getComment";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(easyArId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

-(void)arCommentGiveWithSessionIdAndCommentId:(NSNumber *)commentId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"arComment/give";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId,commentId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//删除AR
-(void)deleteARWithSessionIdAndARId:(NSString *)easyArId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"infomation/delMyMake";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId,easyArId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
    
}


//资料修改提交
-(void)updateInfoWithSessionIdAndName:(NSString *)username info:(NSString *)infomation birth:(NSString *)birthday sex:(NSString *)sex success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"admin/updateInfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    username = username.length>0?username:@"";
    infomation = infomation.length>0?infomation:@"";
    birthday   = birthday.length>0?birthday:@"";
    sex  = sex.length>0?sex:@"";
      NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId,username,infomation,birthday,sex);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}


//QQ登录绑定
-(void)qqLoginBindingWithSessionAndOpenId:(NSString *)qqOpenId phone:(NSString *)telphone pwd:(NSString *)password success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"login/qqBinding";
     NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
     NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId,qqOpenId,telphone,password);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

-(void)weChatLoginBindingWithSessionAndOpenId:(NSString *)wechatOpenId phone:(NSString *)telphone pwd:(NSString *)password success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"login/wechatBinding";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(wechatOpenId,telphone,password);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//QQ登录
-(void)qqLoginWithOpenId:(NSString *)qqOpenId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"login/qqLogin";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(qqOpenId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//微信登录
-(void)weChatLoginWithOpenId:(NSString *)wechatOpenId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"login/wechatLogin";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(wechatOpenId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        fail(task,error);
    }];
    
}
//QQ绑定注册
-(void)qqRegisterWithPhone:(NSString *)telphone pwd:(NSString *)password sms:(NSString *)smsCode openId:(NSString *)qqOpenId success:(responseBlock)response failure:(failBlock)fail {
    NSString *path = @"register/qqRegister";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(telphone,password,smsCode,qqOpenId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        fail(task,error);
    }];
}
//微信绑定注册
-(void)wechatRegisterWithPhone:(NSString *)telphone pwd:(NSString *)password sms:(NSString *)smsCode openId:(NSString *)wechatOpenId success:(responseBlock)response failure:(failBlock)fail {
    NSString *path = @"register/wechatRegister";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(telphone,password,smsCode,wechatOpenId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        fail(task,error);
    }];
}
//QQ微信注销绑定
-(void)qqOrWeChatCancelWithSessionPath:(NSString *)path success:(responseBlock)response failure:(failBlock)fail{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//折线图
-(void)getScanCountWithARId:(NSString *)easyArId success:(responseBlock)response failure:(failBlock)fail {
    NSString *path = @"scanCount/insert";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(easyArId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}

//举报
-(void)arReportInsertWithSessionAndReportType:(NSString *)reportTypeId contentId:(NSString *)contentId type:(NSString *)type success:(responseBlock)response failure:(failBlock)fail {
    NSString *path = @"report/insert";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters =NSDictionaryOfVariableBindings(sessionId,reportTypeId,type,contentId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//不喜欢拉黑不感兴趣

-(void)dislikeArWithSessionIdAndEasyArId:(NSString *)easyArId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"report/defriend";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters =NSDictionaryOfVariableBindings(sessionId,easyArId);
    [HttpManager postDataWithUrl:urlStr andParameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
    
    
}




#pragma mark GET
//个人信息
-(void)getAdminInfoWithSessionId:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail{
    NSString *path = @"admin/getInfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?sessionId=%@",HOST,path,sessionId];
    [HttpManager getDataWithUr:urlStr parameters:nil success:^(id responobject) {
        Response *res = [[Response alloc]init];
        
        [res setValuesForKeysWithDictionary:responobject];
        if (res.msg.status==2) {
            [USER_DEFAULT removeObjectForKey:@"sessionId"];
            [AppDel goLoginViewController];
        }
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    //NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
}
//点赞过的
-(void)getMyGiveWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"infomation/getMyGive";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//分享过的
-(void)getShareWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"infomation/getMyShare";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//制作过的
-(void)getHaveMakeWithSession:(NSString *)sessionId success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"infomation/getMyMake";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}

//热搜历史
-(void)getWebSearchWithType:(NSString *)type success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"searchLog/getWebSearch";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(type);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//历史搜索
-(void)getMySearchWithSessionIdAndType:(NSString *)type success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"searchLog/getMySearch";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    if (sessionId.length<1) {
        return;
    }
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId,type);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}

//点赞评论
-(void)getARCommentGiveWithSessionAndCommentId:(NSNumber *)commentId success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"arComment/give";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId,commentId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
}

-(void)getAdminDataWithSessionIdSuccess:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"admin/adminData";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
}
//获取评论类型
-(void)getArReportTypeWithType:(NSString *)type success:(responseBlock)response failure:(failBlock)fail{
    NSString*path =  @"report/type";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(type);
    [HttpManager getDataWithUr:urlStr parameters:parameters success:^(id responobject) {
        Response *res = [[Response alloc]init];
        [res setValuesForKeysWithDictionary:responobject];
        response(res);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(task,error);
    }];
    
    
}

@end
