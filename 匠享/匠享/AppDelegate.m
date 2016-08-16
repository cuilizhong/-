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
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置环信
    EMOptions *options = [EMOptions optionsWithAppkey:@"chengta#yooojung"];
    options.apnsCertName = @"dev_push";
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
    
    //配置友盟
    [UMSocialData setAppKey:@"57ad6ccd67e58eca080012a2"];
    
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx75f15d4899ee651d" appSecret:@"e93b6e0bf35aea48033473f874f39a40" url:@"http://www.umeng.com/social"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:@"1105538923" appKey:@"8FCMcGBQ9lYpSTDW" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}



- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    //退到后台断开连接环信
    [[EMClient sharedClient]asyncLogout:NO success:^{
        
        NSLog(@"环信退出成功");

    } failure:^(EMError *aError) {
        
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    //到前台连接环信
    NSString *hxName = [[Userinfo sharedInstance]getHxName];
    NSString *hxPsw = [[Userinfo sharedInstance]getHxPsw];
    
    NSLog(@"hxName = %@",hxName);
    NSLog(@"hxPaw = %@",hxPsw);
    
    [[EMClient sharedClient]asyncLoginWithUsername:hxName password:hxPsw success:^{
        
        NSLog(@"登陆成功");
        
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
    
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
