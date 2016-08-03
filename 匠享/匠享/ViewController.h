//
//  ViewController.h
//  匠享
//
//  Created by clz on 16/7/30.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JsApiDelegate  <JSExport>

- (void)onJsLoginSuccess:(NSString *)parameter;

- (void)onJsLogoutSuccess:(NSString *)parameter;

- (void)onJsChangePwdSuccess:(NSString *)parameter;

@end

@interface ViewController : UIViewController<JsApiDelegate>

@property (nonatomic,strong) JSContext *context;


@end

