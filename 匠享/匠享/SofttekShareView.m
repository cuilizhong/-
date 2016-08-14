//
//  SofttekShareView.m
//  LaiApp_OC
//
//  Created by clz on 16/7/18.
//  Copyright © 2016年 Softtek. All rights reserved.
//

#import "SofttekShareView.h"
#import "SofttekShareButton.h"

static CGFloat basicBottomViewHeight = 100.0f;

@interface SofttekShareView()

@property(nonatomic,assign)CGFloat bottomViewHeight;

@property(nonatomic,assign)CGFloat bottomViewWidth;


@end

@implementation SofttekShareView

- (instancetype)initWithFrame:(CGRect)frame sharePlatformsArray:(NSArray <NSString *>*)sharePlatformsArray shareBlock:(ShareBlock)shareBlock{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.backgroundView.backgroundColor = [UIColor blackColor];
        
        self.backgroundView.alpha = 0;
        
        [self addSubview:self.backgroundView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        
        [self.backgroundView addGestureRecognizer:singleTapGestureRecognizer];
        
        //底部view
        self.bottomViewWidth = frame.size.width;
        
        if (sharePlatformsArray.count %3 == 0) {
            
            self.bottomViewHeight = basicBottomViewHeight*(sharePlatformsArray.count/3);
            
        }else{
            
            self.bottomViewHeight = basicBottomViewHeight*(sharePlatformsArray.count/3+1);

        }
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height,self.bottomViewWidth,self.bottomViewHeight)];
        
        self.bottomView.backgroundColor = UIColorFromRGB(0xf5f1eb);
        
        [self addSubview:self.bottomView];
        
        __weak typeof(self)weakSelf = self;
        
        for (int i = 0; i<sharePlatformsArray.count; i++) {
            
            //创建
            SofttekShareButton *softtekShareButton = [[NSBundle mainBundle]loadNibNamed:@"SofttekShareButton" owner:self options:nil].firstObject;
            
            softtekShareButton.frame = CGRectMake(i%3 *(frame.size.width/3.0) ,i/3*basicBottomViewHeight,frame.size.width/3.0,basicBottomViewHeight);
            
            NSLog(@"sharePlatformsArray[i] = %@",sharePlatformsArray[i]);
            
            [softtekShareButton showViewWithShareButtomImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%@",sharePlatformsArray[i]]] sharePlatform:sharePlatformsArray[i] shareButtonClick:^{
                
                [weakSelf hiddenBottom];
                
                //分享
                shareBlock(i);
                
            }];
            
            [self.bottomView addSubview:softtekShareButton];
        }
    }
    
    return self;
}

- (void)showBottom{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.frame = CGRectMake(0,self.frame.size.height-self.bottomViewHeight,self.bottomViewWidth,self.frame.size.height-self.bottomViewHeight);

        self.backgroundView.alpha = 0.5f;

        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)hiddenBottom{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.frame = CGRectMake(0,self.frame.size.height,self.bottomViewWidth,self.frame.size.height-self.bottomViewHeight);
        
        self.backgroundView.alpha = 0;

        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];

}

- (void)singleTap:(UITapGestureRecognizer*)sender{
    
    [self hiddenBottom];
}


- (void)drawRect:(CGRect)rect {
    
}


@end
