//
//  HLScnCell.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HLIntroScnCell.h"
#define LEFTSPACE_RATIO 0.0
#define IMGSWAP_DURATION 0.2

#define AUTOSLIDE_DURATION 1.7
#define AUTOSLIDE_DELAY 1
#define SWIPE_DURATION 1
#define SWIPE_DELAY 0
typedef enum : NSUInteger {
    SWIPE_NONE,
    SWIPE_RIGHT,
    SWIPE_LEFT,
} HLSWIPE;

@interface HLIntroScnCell()
{
    UIButton* uiLRArrow;
    UIImageView* uiDecoLine;
    UIImageView* iFstIV;
    UIImageView* iScnIV;
    UIImageView* iPageIndicatorImg;
    UIPageControl* iPageCtrl;
    BOOL iSwapToSnd;
    BOOL iAnimating;
    BOOL iInit;
    BOOL iShowArrow;
    BOOL iHidePage;
    BOOL iFadeIn;
    BOOL iInterrupt;
    HLSWIPE iSwipeDir;
    __weak id<IHLIntroScnCellDelegate> iFirstDelegate;
    __weak id<IHLIntroScnCellDelegate> iSecondDelegate;
    NSMutableArray* iSwipeList;
}
@property(nonatomic, copy)NSString* fstTxt;
@property(nonatomic, copy)NSString* sndTxt;
@property(nonatomic, assign)CGSize iSize;
@property(nonatomic, assign)BOOL iPageEnable;
@end

@implementation HLIntroScnCell

-(id)initWithSclSize:(CGSize)ssize FstImg:(NSString*)fstr SecImg:(NSString*)sstr Page:(BOOL)enablePage AutoSlide:(BOOL)autoslide
{
    self = [super init];
    if (self)
    {
        self.iSize = ssize;
        self.iPageEnable = enablePage;
        if (fstr)
        {
            self.fstTxt = fstr;
        }
        if (sstr)
        {
            self.sndTxt = sstr;
        }
    }
    return self;
}
-(void)animateToPage:(int)num
{
    if (num==0)
    {
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D tr = CATransform3DIdentity;
        tr = CATransform3DTranslate(tr, 0, 0, 0);
        scale.duration = 1;
        [scale setBeginTime:CACurrentMediaTime()+0.5];
        scale.toValue = [NSValue valueWithCATransform3D:tr];
        scale.fillMode = kCAFillModeForwards;
        scale.removedOnCompletion = NO;
        
        [iPageIndicatorImg.layer.mask addAnimation:scale forKey:@"gotoPage0"];
    }else
    {
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D tr = CATransform3DIdentity;
        tr = CATransform3DTranslate(tr, 14, 0, 0);
        scale.duration = 1;
        [scale setBeginTime:CACurrentMediaTime()+0.5];
        scale.toValue = [NSValue valueWithCATransform3D:tr];
        scale.fillMode = kCAFillModeForwards;
        scale.removedOnCompletion = NO;
        [iPageIndicatorImg.layer.mask addAnimation:scale forKey:@"gotoPage1"];
    }
}
-(void)didMoveToSuperview
{
    if (iInit==NO)
    {
        if(self.sndTxt==nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* fstimg = [UIImage imageNamed:self.fstTxt];
                dispatch_async(dispatch_get_main_queue(), ^{
                    iFstIV = [[UIImageView alloc] initWithImage:fstimg];
                    iFstIV.frame = CGRectMake(self.iSize.width*LEFTSPACE_RATIO, 0, self.iSize.width-self.iSize.width*LEFTSPACE_RATIO, self.iSize.height);
                    [self addSubview:iFstIV];
                });
            });
        }else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* fstimg = [UIImage imageNamed:self.fstTxt];
                UIImage* sndimg = [UIImage imageNamed:self.sndTxt];
                dispatch_async(dispatch_get_main_queue(), ^{
                    iFstIV = [[UIImageView alloc] initWithImage:fstimg];
                    iScnIV = [[UIImageView alloc] initWithImage:sndimg];
                    iFstIV.contentMode = UIViewContentModeScaleToFill;
                    iScnIV.contentMode = UIViewContentModeScaleToFill;
                    iFstIV.clipsToBounds = YES;
                    iScnIV.clipsToBounds = YES;
                    [self addSubview:iScnIV];
                    [self addSubview:iFstIV];

                    iFstIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
                    iScnIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
                    
                    //[self bringSubviewToFront:uiLRArrow];
                    if (self.iPageEnable)
                    {
                        uiLRArrow.hidden = YES;
                        uiDecoLine.hidden = YES;
                        iPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, iFstIV.frame.size.height-30, iFstIV.frame.size.width, 30)];
                        iPageCtrl.numberOfPages = 2;
                        iPageCtrl.currentPage = 0;
                        iPageCtrl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:195/255.0 blue:148/255.0 alpha:1];
                        iPageCtrl.hidden = iHidePage;
                        iPageCtrl.hidden = YES;
                        [self addSubview:iPageCtrl];
#ifdef USE_SWIPE
                        // Gesture
                        {
                            UISwipeGestureRecognizer* swipegs_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
                            swipegs_right.direction = UISwipeGestureRecognizerDirectionRight;
                            [self addGestureRecognizer:swipegs_right];
                        }
                        {
                            UISwipeGestureRecognizer* swipegs_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
                            swipegs_left.direction = UISwipeGestureRecognizerDirectionLeft;
                            [self addGestureRecognizer:swipegs_left];
                        }
#endif
                        //Mask Indicator
                        iPageIndicatorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"custom_page_indicator_mask.png"]];
                        iPageIndicatorImg.frame = CGRectMake(272, 544, iPageIndicatorImg.frame.size.width, iPageIndicatorImg.frame.size.height);
                        [self addSubview:iPageIndicatorImg];
                        
                        CGMutablePathRef path = CGPathCreateMutable();
                        CGPathAddArc(path, NULL, 14/2, 5.5, 7, 0, M_PI*2, NO);
                        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                        [shapeLayer setPath:path];
                        [shapeLayer setFillColor:[[UIColor blackColor] CGColor]];
                        [shapeLayer setFrame:iPageIndicatorImg.bounds];
                        [[iPageIndicatorImg layer] setMask:shapeLayer];
                        CGPathRelease(path);
                        
                        //Mask Cover
                        UIImageView* mask_cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"custom_page_indicator_mask_cover.png"]];
                        mask_cover.frame = CGRectMake(272, 544, mask_cover.frame.size.width, mask_cover.frame.size.height);
                        [self addSubview:mask_cover];
                        
                    }
                    //uiLRArrow.hidden = !iShowArrow;
                    
                    //Auto FadeInOut
                    [self enableAudoFadeInOutDuration:AUTOSLIDE_DURATION Delay:AUTOSLIDE_DELAY];
                });
            });
        }
        iInit = YES;
    }else
    {
        iInterrupt = YES;
        for (CALayer* layer in [iFstIV.layer sublayers]) {
            [layer removeAllAnimations];
        }
    }
}
-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}
- (void)enableAudoFadeInOutDuration:(int)duration Delay:(int)delay
{
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionAllowUserInteraction animations:^(){
        if (iSwipeDir==SWIPE_RIGHT)
        {
            NSLog(@"Swipe Right");
            iFstIV.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
            iPageCtrl.currentPage = 0;
            [self animateToPage:0];
        }
        else if (iSwipeDir==SWIPE_LEFT)
        {
            NSLog(@"Swipe Left");
            iFstIV.alpha = 1;
            iFstIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
            iPageCtrl.currentPage = 1;
            [self animateToPage:1];
        }else
        {
            if (iFadeIn)
            {
                iFstIV.alpha = 1;
                iFstIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
                iPageCtrl.currentPage = 0;
                [self animateToPage:0];
            }else
            {
                iFstIV.alpha = 0;
                iPageCtrl.currentPage = 1;
                [self animateToPage:1];
            }
        }
        
    } completion:^(BOOL finished) {
        
        if ([iSwipeList count])
        {
            iSwipeDir = [[iSwipeList objectAtIndex:0] integerValue];
            [iSwipeList removeObjectAtIndex:0];
            
            if (iSwipeDir==SWIPE_LEFT)
            {
                if (iFstIV.frame.origin.x==0)
                {
                    iSwipeDir = SWIPE_NONE;
                    NSLog(@"swipe left X");
                }else if (iFstIV.frame.origin.x==self.iSize.width)
                {
                 
                }
            }
            if (iSwipeDir==SWIPE_RIGHT)
            {
                if (iFstIV.frame.origin.x==self.iSize.width)
                {
                    iSwipeDir = SWIPE_NONE;
                    NSLog(@"swipe right X");
                }
                if (iFstIV.alpha==0)
                {
                    iSwipeDir = SWIPE_NONE;
                    NSLog(@"swipe right X");
                }
            }
        }
        else
        {
            iSwipeDir = SWIPE_NONE;
        }
        
        if (iSwipeDir==SWIPE_NONE)
        {
            iFadeIn = !iFadeIn;
            if (iInterrupt==NO)
            {
                [self enableAudoFadeInOutDuration:AUTOSLIDE_DURATION Delay:AUTOSLIDE_DELAY];
            }
        }else if (iSwipeDir==SWIPE_RIGHT)
        {
            if (iInterrupt==NO)
            {
                NSLog(@"Swipe Right");
                [self enableAudoFadeInOutDuration:SWIPE_DURATION Delay:SWIPE_DELAY];
            }
        }else if (iSwipeDir==SWIPE_LEFT)
        {
            if (iInterrupt==NO)
            {
                NSLog(@"Swipe Left");
                [self enableAudoFadeInOutDuration:SWIPE_DURATION Delay:SWIPE_DELAY];
            }
        }

    }];
}

- (void)onSceneSclSwipe: (UISwipeGestureRecognizer *)sender
{
    if (iSwipeList==nil)
    {
        iSwipeList = [[NSMutableArray alloc] init];
    }
    if (sender.direction & UISwipeGestureRecognizerDirectionRight)
    {
        //[self moveRight];
        NSLog(@"swipe right");
        [iSwipeList addObject:[NSNumber numberWithInt:SWIPE_RIGHT]];
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionLeft)
    {
        //[self moveLeft];
        NSLog(@"swipe left");
        [iSwipeList addObject:[NSNumber numberWithInt:SWIPE_LEFT]];
    }
}

-(void)onPageSwipe:(UIPageControl *) sender
{
    NSLog(@"swipe");
    
}
-(void)showArrow
{
    iShowArrow = YES;
}
-(void)hidePageCtrl
{
    iHidePage = YES;
}
-(void)onArrowClick:(id)sender
{
    if (iAnimating==NO)
    {
        if (iSwapToSnd==NO)
        {
            // Swap to second view
            iAnimating = YES;
            [UIView animateWithDuration:IMGSWAP_DURATION animations:^{
                uiLRArrow.frame = CGRectMake(0,
                                             uiLRArrow.frame.origin.y,
                                             uiLRArrow.frame.size.width,
                                             uiLRArrow.frame.size.height);
                
                iFstIV.frame = CGRectMake(iFstIV.frame.origin.x+iFstIV.frame.size.width, 0, iFstIV.frame.size.width, iFstIV.frame.size.height);
                if (uiDecoLine)
                {
                    uiDecoLine.center = uiLRArrow.center;
                }
            } completion:^(BOOL finished) {
                iAnimating = NO;
                iSwapToSnd = YES;
            }];
        }else
        {
            // Swap to first view
            iAnimating = YES;
            [UIView animateWithDuration:IMGSWAP_DURATION animations:^{
                
                uiLRArrow.frame = CGRectMake(self.frame.size.width-uiLRArrow.frame.size.width,
                                             uiLRArrow.frame.origin.y,
                                             uiLRArrow.frame.size.width,
                                             uiLRArrow.frame.size.height);
                iFstIV.frame = CGRectMake(0, 0, iFstIV.frame.size.width, iFstIV.frame.size.height);
                if (uiDecoLine)
                {
                    uiDecoLine.center = uiLRArrow.center;
                }
            } completion:^(BOOL finished) {
                iAnimating = NO;
                iSwapToSnd = NO;
            }];
        }
    }
}
-(void)enableFullScreen:(IMG_OPTION)option Delegate:(id<IHLIntroScnCellDelegate>)del
{
    if (option==FIRST_IMG)
    {
        if (del!=iFirstDelegate)
        {
            iFirstDelegate = del;
        }
    }else
    {
        if (del!=iSecondDelegate)
        {
            iSecondDelegate = del;
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (iSecondDelegate)
    {
        if (iFstIV.frame.origin.x>iScnIV.frame.origin.x)
        {
            [iSecondDelegate ScnCellClickToFullScreen:iScnIV.image];
        }
    }
}

@end