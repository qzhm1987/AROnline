//
//  ARUser.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARUser : NSObject

@property (nonatomic ,copy) NSString *give;
@property (nonatomic ,copy) NSString *share;
@property (nonatomic ,copy) NSString *useCount;
@property (nonatomic ,copy) NSString *makeCount;
@property (nonatomic ,copy) NSString *username;

@property (nonatomic ,copy) NSString *birthday;
@property (nonatomic ,assign) NSInteger counts;
@property (assign, nonatomic)long createdate;
@property (nonatomic ,copy) NSString *enddate;
@property (nonatomic ,assign) NSInteger id;
@property (nonatomic ,copy) NSString *image;
@property (nonatomic ,copy) NSString *modifydate;
@property (nonatomic ,copy) NSString *password;
@property (nonatomic ,copy) NSString *realname;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,assign) NSInteger roleid;
@property (nonatomic ,assign) NSInteger sex;
@property (nonatomic ,copy) NSString *telphone;
@property (nonatomic ,copy) NSString *infomation;
@property (nonatomic ,copy) NSString *qqOpenId;
@property (nonatomic ,copy) NSString *wechatOpenId;


/**
 ARUSer单例句柄
 @ return
 */
+(ARUser *)shareARUser;
@end

//data
@interface Data : NSObject

@property (nonatomic ,copy) NSString *sessionId;


@property (nonatomic ,copy) NSString *give;
@property (nonatomic ,copy) NSString *image;
@property (nonatomic ,copy) NSString *share;
@property (nonatomic ,copy) NSString *useCount;
@property (nonatomic ,copy) NSString *makeCount;
@property (nonatomic ,copy) NSString *username;
@property (nonatomic ,copy) NSString *ar;
@property (nonatomic ,copy) NSString *arList;

@property (nonatomic,assign)NSInteger restNumber;
@property (nonatomic,assign)NSInteger monthNumber;
@property (nonatomic,assign)NSInteger weekendNumber;

@property (strong, nonatomic)NSMutableArray *search;
@property (strong, nonatomic)NSMutableArray *listAR;
@property (nonatomic ,copy) NSDictionary *admin;

@property (nonatomic,assign)NSInteger listCount;
@property (strong, nonatomic)NSMutableArray *commentList;
@property (strong, nonatomic)NSMutableArray *resultList;

@property (strong, nonatomic)NSDictionary *easyAr;
@property (strong, nonatomic)NSDictionary *category;




@end
//msg
@interface Msg : NSObject

@property (nonatomic ,copy) NSString *desc;
@property (nonatomic ,assign) NSInteger status;
@end

//HotSearch
@interface HotSearch : NSObject

@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *createdAt;
@property (nonatomic ,copy) NSString *adminId;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *type;
@end

//ARModel
@interface ARModel : NSObject
@property (nonatomic ,assign) NSInteger active;
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,assign)NSInteger adminId;
@property (nonatomic ,assign) long createAt;
@property (nonatomic ,assign) NSInteger id;
@property (nonatomic ,copy) NSString *imageUrl;
@property (nonatomic ,copy) NSString *image_url;
@property (nonatomic ,copy) NSString *info;
@property (nonatomic ,copy) NSString *modifyAt;
@property (nonatomic ,copy) NSString *modifyId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *size;
@property (nonatomic ,copy) NSString *targetId;
@property (nonatomic ,copy) NSString *videoUrl;
@property (nonatomic ,copy) NSString *video_url;

@property (copy, nonatomic)NSString *image;
@property (assign, nonatomic)NSInteger counts;
@property (nonatomic ,copy) NSString *remark;

@property (nonatomic ,copy) NSString *addressLat;
@property (nonatomic ,copy) NSString *addressLng;
@property (nonatomic ,assign) NSInteger distance;
@property (nonatomic ,assign) NSInteger status;

@property (nonatomic,assign)NSInteger give;
@property (nonatomic,assign)NSInteger share;
@property (nonatomic,assign)NSInteger uploadImage;
@property (nonatomic,assign)NSInteger uploadVideo;
@property (nonatomic,assign)NSInteger interviewCount;


@end

//评论
@interface Comment : NSObject
@property (nonatomic,assign)NSInteger adminId;
@property (nonatomic ,copy) NSString *adminImage;
@property (nonatomic ,copy) NSString *adminName;
@property (strong, nonatomic)NSMutableArray *children;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *countAdminId;
@property (nonatomic,assign)NSInteger counts;
@property (nonatomic,assign)long createdAt;
@property (nonatomic,assign)NSInteger depth;
@property (nonatomic,assign)NSInteger easyArId;
@property (nonatomic,assign)NSInteger id;
@property (nonatomic,assign)NSInteger parentId;
@property (nonatomic ,copy) NSString *remark;
@end





//Response
@interface Response : NSObject

@property (strong, nonatomic)Data *data;
@property (strong, nonatomic)Msg *msg;



@end
