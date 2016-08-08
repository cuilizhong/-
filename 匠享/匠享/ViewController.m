//
//  ViewController.m
//  匠享
//
//  Created by clz on 16/7/30.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FormatConvert.h"
#import "Userinfo.h"
#import "EMSDK.h"
#import "AppDelegate.h"

static NSString *host = @"http://218.104.51.40:30003/";

/**
 *  广场
 */
static NSString *square = @"register/register!toSquare.shtml";


@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.webView.delegate = self;
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",host,square];
    
    NSLog(@"urlstr = %@", urlstr);
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView scalesPageToFit];
    [self.view addSubview:self.webView];
}

#pragma mark-UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView{
    
}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"error == %@",error);
}


-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    if (self.context) {
        
        self.context = nil;
    }
    
    self.context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.context[@"jsinterface"] = self;

    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
}


#pragma mark-JsApiDelegate
- (void)onJsLoginSuccess:(NSString *)parameter{
    
    NSDictionary *parameterDic = [NSString dictionaryWithJsonString:parameter];
    
    NSLog(@"parameterDic == %@",parameterDic);
    
    //保存数据
    [[Userinfo sharedInstance] setValueWithDic:parameterDic];

    //登陆环信
    [[EMClient sharedClient]asyncLoginWithUsername:[[Userinfo sharedInstance]getHxName] password:[[Userinfo sharedInstance]getHxPsw] success:^{
        
        NSLog(@"环信登陆成功");
        NSData *deviceToken = ((AppDelegate*)[UIApplication sharedApplication].delegate).deviceToken;
        //绑定
        [[EMClient sharedClient]asyncBindDeviceToken:deviceToken success:^{
            
            NSLog(@"绑定成功");
            
            //设置环信离线消息推送样式
            [[EMClient sharedClient]asyncGetPushOptionsFromServer:^(EMPushOptions *aOptions) {
                
                NSLog(@"获取环信推送属性");
                
                aOptions.displayStyle = EMPushDisplayStyleMessageSummary;
                
                [[EMClient sharedClient]asyncUpdatePushOptionsToServer:^{
                    
                    NSLog(@"环信离线推送属性更新成功");
                    
                } failure:^(EMError *aError) {
                    
                }];
                
                
            } failure:^(EMError *aError) {
                
            }];
            
            
            
        } failure:^(EMError *aError) {
            
        }];
        
        
        
    } failure:^(EMError *aError) {
        
        NSLog(@"环信登陆失败");

    }];

}

- (void)onJsLogoutSuccess:(NSString *)parameter{
    
    NSLog(@"parameter == %@",parameter);
    
    [[Userinfo sharedInstance]removeUserinfo];
    
    [[EMClient sharedClient]asyncLogout:YES success:^{
        
    } failure:^(EMError *aError) {
        
    }];

}

- (void)onJsChangePwdSuccess:(NSString *)parameter{
    
    
    NSDictionary *parameterDic = [NSString dictionaryWithJsonString:parameter];
    
    NSLog(@"parameterDic == %@",parameter);

    [[Userinfo sharedInstance] setValueWithDic:parameterDic];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
