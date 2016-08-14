//
//  SofttekShareButton.m
//  LaiApp_OC
//
//  Created by clz on 16/7/18.
//  Copyright © 2016年 Softtek. All rights reserved.
//

#import "SofttekShareButton.h"

typedef void(^ShareButtonClick)();

@interface SofttekShareButton()

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *sharePlatformLabel;

@end

@implementation SofttekShareButton

- (void)showViewWithShareButtomImage:(UIImage *)shareButtomImage sharePlatform:(NSString *)sharePlatform shareButtonClick:(ShareButtonClick)shareButtonClick{
    
    [self.shareButton setImage:shareButtomImage forState:UIControlStateNormal];
    
    self.sharePlatformLabel.text = sharePlatform;
    
    self.shareButtonClick = shareButtonClick;
}

- (IBAction)shareButtonAction:(id)sender {
    
    self.shareButtonClick();
}

- (void)drawRect:(CGRect)rect {
    
}


@end
