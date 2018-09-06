//
//  NSString+AR.h
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AR)
/**
 判断是否是手机号
 * @ param mobileNumber 手机号
 *
 @ return YES是 NO不是
 */
+ (BOOL) isMobile:(NSString *)mobileNumber;
/**
 * @ brief 字典转String
 * @ param dic 需转化字典
 * @ return
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;  //字典转JSON String
/**
 * @ brief JSON转字典
 * @ param jsonString  需转化字符
 * @ return
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString; //String 转JSON

+(NSString *)arraryToJSONString:(NSArray *)array;
+(NSArray *)jsonStringToArray:(NSString *)jsonString;
/**
 根据日期格式时间戳转换日期
 @ param stamp 时间戳
 @ param formatter 日期格式
 @ return
 */
+(NSString *)getDateWithTimeStamp:(NSString *)stamp dateFormatter:(NSString *)formatter;

/**
 图片转base64字符串
 @ param
 @ return
 */
+(NSString *)UIImageToBase64Str:(UIImage *) image;


/**
 获取唯一标识
 * @ param
 *
 @ return String UUID
 */

/**
 根据内容计算宽度
 @ param
 @ return
 */
+ (CGFloat)calculateRowWidth:(NSString *)string fontSize:(CGFloat) fontSize height:(CGFloat)height;
/**
 计算高度
 @ param
 @ return
 */
+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width;
+(NSString *)getUUID ;
+(NSString *)currentDeviceType;
@end
