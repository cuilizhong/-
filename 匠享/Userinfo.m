//
//  Userinfo.m
//  匠享
//
//  Created by clz on 16/8/3.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "Userinfo.h"

static NSString *HXNAME = @"hxName";

static NSString *HXPSW = @"hxPsw";

static NSString *NAME = @"name";

static NSString *PASSWORD = @"password";

static NSString *REMEMBERME = @"rememberMe";





static Userinfo *userinfo = nil;

@implementation Userinfo

+(instancetype )sharedInstance{
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        userinfo = [[self alloc] init];
        
    });
    
    return userinfo;
}

- (void)setHxName:(NSString *)hxName{
    
    NSLog(@"调用setHxName");

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:hxName forKey:HXNAME];
    
    [userDefault synchronize];    
}

- (NSString *)getHxName{
    
    NSLog(@"调用getHxName");
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
    return [userDefault objectForKey:HXNAME];
}

- (void)setHxPsw:(NSString *)hxPsw{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:hxPsw forKey:HXPSW];
    
    [userDefault synchronize];
}

- (NSString *)getHxPsw{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    return [userDefault objectForKey:HXPSW];
}

- (void)setName:(NSString *)name{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:name forKey:NAME];
    
    [userDefault synchronize];
}

- (NSString *)getName{
       
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    return [userDefault objectForKey:NAME];
}

- (void)setPassword:(NSString *)password{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:password forKey:PASSWORD];
    
    [userDefault synchronize];
}

- (NSString *)getPassword{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    return [userDefault objectForKey:PASSWORD];
}

- (void)setRememberMe:(NSString *)rememberMe{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:rememberMe forKey:REMEMBERME];
    
    [userDefault synchronize];
}

- (NSString *)getRememberMe{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    return [userDefault objectForKey:REMEMBERME];
}

- (void)setValueWithDic:(NSDictionary *)dic{
    
    NSLog(@"dic = %@",dic);
    
    if ([dic objectForKey:@"hxName"] && ![[dic objectForKey:@"hxName"] isKindOfClass:[NSNull class]]) {
        
        self.hxName = [self numberToNsstringWithObject:[dic objectForKey:@"hxName"]];
        
        NSLog(@"self.hxName = %@",self.hxName);
    }
    
    if ([dic objectForKey:@"hxPsw"] && ![[dic objectForKey:@"hxPsw"] isKindOfClass:[NSNull class]]) {
        
        self.hxPsw = [self numberToNsstringWithObject:[dic objectForKey:@"hxPsw"]];
    }
    
    if ([dic objectForKey:@"name"] && ![[dic objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
        
        self.name = [self numberToNsstringWithObject:[dic objectForKey:@"name"]];
    }
    
    if ([dic objectForKey:@"password"] && ![[dic objectForKey:@"password"] isKindOfClass:[NSNull class]]) {
        
        self.password = [self numberToNsstringWithObject:[dic objectForKey:@"password"]];
    }
    
    if ([dic objectForKey:@"rememberMe"] && ![[dic objectForKey:@"rememberMe"] isKindOfClass:[NSNull class]]) {
        
        self.rememberMe = [self numberToNsstringWithObject:[dic objectForKey:@"rememberMe"]];
    }
}

- (void)removeUserinfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    [userDefault removeObjectForKey:HXNAME];
    [userDefault removeObjectForKey:HXPSW];
    [userDefault removeObjectForKey:NAME];
    [userDefault removeObjectForKey:PASSWORD];
    [userDefault removeObjectForKey:REMEMBERME];
    
    [userDefault synchronize];

}


- (NSString *)numberToNsstringWithObject:(id)object{
    
    NSLog(@"object = %@",object);
    
    if ([object isKindOfClass:[NSString class]]) {
        
        NSString *objectStr = (NSString *)object;
        
        NSLog(@"objectStr = %@",objectStr);
        
        return objectStr;
        
    }else if([object isKindOfClass:[NSNumber class]]){
        
        NSNumber *objectNum = (NSNumber *)object;
        
        return objectNum.stringValue;
        
    }else{
        
        NSLog(@"返回为nil");
        
        return nil;
    }
}

@end
