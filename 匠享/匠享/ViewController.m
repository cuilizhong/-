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
#import "UMSocial.h"
#import "SofttekShareView.h"


static NSString *host = @"http://218.104.51.40:30003/";

/**
 *  广场
 */
static NSString *square = @"register/register!toSquare.shtml";


@interface ViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

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
    
    
    //加背景图片
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"share_复制链接"]]];

}

#pragma mark-UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView{
    
}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"error == %@",error);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络连接" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
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
    
    NSLog(@"parameterDic == %@",parameterDic);

    [[Userinfo sharedInstance] setValueWithDic:parameterDic];

}

- (void)onJsOnShare:(NSString *)parameter{
    
    NSDictionary *parameterDic = [NSString dictionaryWithJsonString:parameter];
    
    NSLog(@"parameterDic == %@",parameterDic);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    //弹出分享菜单
    NSArray *platformsArray = @[@"微信",@"朋友圈",@"微博",@"QQ",@"QQ空间",@"复制链接"];
    
    __weak typeof(self)weakSelf = self;
    
    SofttekShareView *shareView = [[SofttekShareView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) sharePlatformsArray:platformsArray shareBlock:^(NSInteger index) {
       
        NSLog(@"index = %ld",(long)index);
        
        [weakSelf shareActionWithIndex:index parameter:parameterDic];
        
    }];
        
    [window addSubview:shareView];
    
    [shareView showBottom];

    
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
//    [UMSocialData defaultData].extConfig.title = parameterDic[@""];
//    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"507fcab25270157b37000010"
//                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
//                                     shareImage:[UIImage imageNamed:@"icon"]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
//                                       delegate:self];
    
    
    /*
     parameterDic == {
     detail = "\U5320\U4eab\U5546\U57ce\U6bcf\U65e5\U66f4\U65b0\Uff0c\U603b\U6709\U4f60\U8981\U7684\U60ca\U559c";
     href = "http://218.104.51.40:30003/worktable/sale!order.shtml";
     imageSrc = "http://218.104.51.40:30003/superTrader/images/b3.jpg";
     title = "\U5320\U4eab\U5546\U57ce\U7b49\U4f60\U6765\U8d2d";
     }
     */
}


- (void)shareActionWithIndex:(NSInteger)index parameter:(NSDictionary *)parameter{
    
    NSString *detail = parameter[@"detail"];
    
    NSString *href = parameter[@"href"];
    
    NSString *imageSrc = parameter[@"imageSrc"];
    
    NSString *title = parameter[@"title"];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:href];
    
    NSArray *platformTypes;
    
    switch (index) {
            
        case 0:{
            
            platformTypes = @[UMShareToWechatSession];
            
            [UMSocialData defaultData].extConfig.wechatSessionData.url = href;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;

            
        }
            break;
            
        case 1:{
            
            platformTypes = @[UMShareToWechatTimeline];
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = href;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            
        }
            break;
            
        case 2:{
            
            platformTypes = @[UMShareToSina];
            
            [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
            
        }
            break;
            
        case 3:{
            
            platformTypes = @[UMShareToQQ];
            
            [UMSocialData defaultData].extConfig.qqData.url = href;
            [UMSocialData defaultData].extConfig.qqData.title = title;
            
            
            NSLog(@"href = %@",href);


            
            
        }
            break;
            
        case 4:{
            
            platformTypes = @[UMShareToQzone];
            
            [UMSocialData defaultData].extConfig.qzoneData.url = href;
            [UMSocialData defaultData].extConfig.qzoneData.title = title;

        }
            break;
            
        case 5:{
        
            //复制链接
            
            NSLog(@"复制链接");
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            
            [pab setString:href];
            
            if (pab == nil) {
                
                NSLog(@"复制失败");
                
            }else{
                NSLog(@"复制成功");

            }
            
            return;
            
        }
            break;
            
        default:
            break;
    }
    
    
    NSLog(@"detail = %@",detail);
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:platformTypes content:detail image:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageSrc]] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"分享成功！");
            
        }else{
            
            NSLog(@"分享失败,errorCode：%u",response.responseCode);
        }
        
    }];    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
