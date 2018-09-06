//
//  ARUser.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ARUser.h"
static ARUser *arUser = nil;
@implementation ARUser

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        if (!arUser) {
            arUser = [super allocWithZone:zone];
        }
    });
    return arUser;
}

+(ARUser *)shareARUser{
    return [[self alloc]init];
}


#pragma mark - Key Value Coding

- (id)valueForUndefinedKey:(NSString *)key {
     DLog(@"%@：获取键值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
       DLog(@"未定义的键：%@",key);
    // subclass implementation should set the correct key value mappings for custom keys
}




@end



//Response
@implementation Response

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"data"]) {
        self.data = [[Data alloc]init];
        [self.data setValuesForKeysWithDictionary:value];
    }
    if ([key isEqualToString:@"msg"]) {
        self.msg = [[Msg alloc]init];
        [self.msg setValuesForKeysWithDictionary:value];
    }
}

@end

//Data
@implementation Data

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arArray = [NSMutableArray arrayWithCapacity:0];
    if ([key isEqualToString:@"search"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HotSearch *hot = [[HotSearch alloc]init];
            [hot setValuesForKeysWithDictionary:obj];
            [array addObject:hot];
        }];
        self.search = array;
    }
    if ([key isEqualToString:@"ar"]||[key isEqualToString:@"arList"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ARModel *ar = [[ARModel alloc]init];
            [ar yy_modelSetWithJSON:obj];
            [arArray addObject:ar];
        }];
         self.listAR = arArray;
    }
    _resultList = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *resArray = [NSMutableArray arrayWithCapacity:0];
    if ([key isEqualToString:@"resultList"]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ARModel *ar = [[ARModel alloc]init];
            [ar yy_modelSetWithJSON:obj];
            [resArray addObject:ar];
        }];
        self.resultList = resArray;
    }
    
   
    
}
#pragma mark - Key Value Coding

- (id)valueForUndefinedKey:(NSString *)key {
    DLog(@"%@：获取键值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"未定义的键：%@",key);
    // subclass implementation should set the correct key value mappings for custom keys
}
@end

//Msg
@implementation Msg

- (id)valueForUndefinedKey:(NSString *)key {
    DLog(@"%@：获取键值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"未定义的键：%@",key);
    // subclass implementation should set the correct key value mappings for custom keys
}
@end

//热门搜索
@implementation HotSearch

- (id)valueForUndefinedKey:(NSString *)key {
    DLog(@"%@：获取键值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"未定义的键：%@",key);
    // subclass implementation should set the correct key value mappings for custom keys
}
@end

//AR
@implementation ARModel


- (id)valueForUndefinedKey:(NSString *)key {
    DLog(@"%@：获取键值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"未定义的键：%@",key);
    // subclass implementation should set the correct key value mappings for custom keys
}
@end


@implementation Comment

- (id)valueForUndefinedKey:(NSString *)key {
    DLog(@"%@：获取键值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"未定义的键：%@",key);
    // subclass implementation should set the correct key value mappings for custom keys
}

@end



