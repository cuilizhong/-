//
//  SofttekShareView.h
//  LaiApp_OC
//
//  Created by clz on 16/7/18.
//  Copyright © 2016年 Softtek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareBlock)(NSInteger index);

@interface SofttekShareView : UIView

@property(nonatomic,strong)UIView *backgroundView;

@property(nonatomic,strong)UIView *bottomView;

- (instancetype)initWithFrame:(CGRect)frame sharePlatformsArray:(NSArray <NSString *>*)sharePlatformsArray shareBlock:(ShareBlock)shareBlock;

- (void)showBottom;

- (void)hiddenBottom;

@end
