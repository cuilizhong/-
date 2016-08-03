//
//  ViewController.m
//  匠享
//
//  Created by clz on 16/7/30.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ViewController.h"

#define ENABLE_DEBUG


#ifdef ENABLE_DEBUG
#define NSLog(format, args...) \
NSLog(@"%s, line %d: " format "\n", \
__func__, __LINE__, ## args);
#else
#define NSLog(format, args...) do {} while(0)
#endif


static NSString *host = @"http://218.104.51.40:30003/";

/**
 *  广场
 */
static NSString *square = @"register/register!toSquare.shtml";

static NSString *Mine = @"mine/mine!toMineIndex.shtml";


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
    
    NSLog(@"parameter == %@",parameter);

}

- (void)onJsLogoutSuccess:(NSString *)parameter{
    
    NSLog(@"parameter == %@",parameter);

}

- (void)onJsChangePwdSuccess:(NSString *)parameter{
    
    NSLog(@"parameter == %@",parameter);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
