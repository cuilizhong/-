//
//  NetWorkJudge.m
//  intelRetailstore
//
//  Created by clz on 15/3/8.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "NetWorkJudge.h"
#import "Reachability.h"
@implementation NetWorkJudge


+ (NetWorkJudge *)sharedInstance
{
    static NetWorkJudge *netWorkJudge = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netWorkJudge = [[self alloc] init];
    });
    return netWorkJudge;
}

- (BOOL)isConnecNetWork{
  
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
            
        default:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}
@end
