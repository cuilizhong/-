//
//  SofttekShareButton.h
//  LaiApp_OC
//
//  Created by clz on 16/7/18.
//  Copyright © 2016年 Softtek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareButtonClick)();

@interface SofttekShareButton : UIView

@property(nonatomic,strong)ShareButtonClick shareButtonClick;


- (void)showViewWithShareButtomImage:(UIImage *)shareButtomImage sharePlatform:(NSString *)sharePlatform shareButtonClick:(ShareButtonClick)shareButtonClick;

@end
