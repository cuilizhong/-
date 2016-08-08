//
//  AppDelegate.m
//  匠享
//
//  Created by clz on 16/7/30.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "AppDelegate.h"
#import "EMSDK.h"
#import "Userinfo.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置环信
    EMOptions *options = [EMOptions optionsWithAppkey:@"chengta#yooojung"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //注册推送
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    //退到后台断开连接环信
    [[EMClient sharedClient]asyncLogout:NO success:^{
        
    } failure:^(EMError *aError) {
        
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    //到前台连接环信
    [[EMClient sharedClient]asyncLoginWithUsername:[Userinfo sharedInstance].hxName password:[Userinfo sharedInstance].hxPsw success:^{
        
    } failure:^(EMError *aError) {
        
    }];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    self.deviceToken = deviceToken;
    
    [[EMClient sharedClient]asyncBindDeviceToken:deviceToken success:^{
        
        NSLog(@"绑定成功");
        
        
    } failure:^(EMError *aError) {
        
        NSLog(@"绑定失败，error.code = %d",aError.code);
        
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
