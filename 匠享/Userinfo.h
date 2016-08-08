//
//  Userinfo.h
//  匠享
//
//  Created by clz on 16/8/3.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userinfo : NSObject

@property(nonatomic,copy)NSString *hxName;

@property(nonatomic,copy)NSString *hxPsw;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *password;

@property(nonatomic,copy)NSString *rememberMe;

+ (instancetype)sharedInstance;

- (void)setValueWithDic:(NSDictionary *)dic;

- (void)removeUserinfo;


- (NSString *)getRememberMe;
- (NSString *)getPassword;
- (NSString *)getName;
- (NSString *)getHxPsw;
- (NSString *)getHxName;
@end
