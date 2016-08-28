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
#import "NetWorkJudge.h"


static NSString *host = @"http://www.yooojung.com/";

/**
 *  广场
 */
static NSString *square = @"squareIndex.jsp";


@interface ViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIImageView *tipNoNetworkImageView;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,assign)BOOL isFirstRequest;

@property(nonatomic,assign)BOOL isShared;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstRequest = YES;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.webView.delegate = self;
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",host,square];
    
    NSLog(@"urlstr = %@", urlstr);
        
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlstr]
                             
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                             
                                              timeoutInterval:60];
    
    [self.webView loadRequest:request];
    [self.webView scalesPageToFit];
    [self.view addSubview:self.webView];
    
    
    
    
    self.tipNoNetworkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.tipNoNetworkImageView.image = [UIImage imageNamed:@"nonetwork"];
    
    self.tipNoNetworkImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.tipNoNetworkImageView];
    
    self.tipNoNetworkImageView.hidden = YES;
    
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    
    [self.tipNoNetworkImageView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.activityView.center = self.view.center;
    self.activityView.color = [UIColor blackColor];
    
    [self.view addSubview:self.activityView];
    
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[userDefaults objectForKey:@"isLaunched"] isEqualToString:@"1"]) {
        
        //不显示
        
    }else{
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*5, self.view.frame.size.height);
        
        for (int i = 0; i<5; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i+1]];
            
            if (i == 4) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                CALayer * layer = [button layer];
                layer.borderColor = [[UIColor blackColor] CGColor];
                layer.borderWidth = 0.5f;
                
                button.frame = CGRectMake(50, self.view.frame.size.height - 80, self.view.frame.size.width - 100, 50);
                [button setTitle:@"立即体验" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(entrySystem:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
                imageView.userInteractionEnabled = YES;
                
            }
            
            [self.scrollView addSubview:imageView];
        }
        
        
        [self.view addSubview:self.scrollView];
        
    }
    
    
}

- (void)entrySystem:(UIButton *)sender{
    
    self.scrollView.hidden = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:@"1" forKey:@"isLaunched"];
    
    [userDefaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    
    if (self.isFirstRequest) {
        
        
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",host,square];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlstr]
                                 
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                 
                                                  timeoutInterval:60];
        
        [self.webView loadRequest:request];

        
        self.isFirstRequest = NO;
        
    }else{
        [self.webView reload];

    }
    
}


#pragma mark-UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView{
    
    [self.activityView startAnimating];
    
    self.tipNoNetworkImageView.hidden = YES;
    
    
    if (![[NetWorkJudge sharedInstance]isConnecNetWork]) {
        
        [self.activityView stopAnimating];
        
        self.tipNoNetworkImageView.hidden = NO;
        
    }
    
}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    
    [self.activityView stopAnimating];

    
    NSLog(@"error == %@",error);
    
}


-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityView stopAnimating];
    self.tipNoNetworkImageView.hidden = YES;
    
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
    
    if (self.isShared) {
        return;
    }
    
    self.isShared = YES;
    
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
    
    self.isShared = NO;
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
            
            detail = [NSString stringWithFormat:@"%@%@",detail,href];
            
        }
            break;
            
        case 3:{
            
            platformTypes = @[UMShareToQQ];
            
            [UMSocialData defaultData].extConfig.qqData.url = href;
            [UMSocialData defaultData].extConfig.qqData.title = title;
            
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
