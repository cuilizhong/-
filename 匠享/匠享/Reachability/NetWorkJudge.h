//
//  NetWorkJudge.h
//  intelRetailstore
//
//  Created by clz on 15/3/8.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkJudge : NSObject

+(NetWorkJudge *)sharedInstance;

- (BOOL)isConnecNetWork;

@end

