//
//  HLScnCell.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HLIntroScnCell.h"
#define SLIDE_DELAY 1.8
#define SLIDE_DURATION 1.2
#define LEFTSPACE_RATIO 0.0
#define IMGSWAP_DURATION 0.2

typedef enum : NSUInteger {
    SWIPE_NONE,
    SWIPE_RIGHT,
    SWIPE_LEFT,
} HLSWIPE;

@interface HLIntroScnCell()
{
    NSTimer* iSlideTimer;
    double iSlideTime;
    //UIButton* uiLRArrow;
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
    BOOL iAutoSlideFlag;
    HLSWIPE iSwipeDir;
    int iDelay;
    id<IHLIntroScnCellDelegate> iFirstDelegate;
    id<IHLIntroScnCellDelegate> iSecondDelegate;
    NSMutableArray* iSwipeList;
    UIView* iTmpSwipeLeft;
    UIView* iTmpSwipeRight;
}
@property(nonatomic, copy)NSString* fstTxt;
@property(nonatomic, copy)NSString* sndTxt;
@property(nonatomic, assign)CGSize iSize;
@property(nonatomic, assign)BOOL iPageEnable;
@property(nonatomic, assign)BOOL iAutoSlide;
@property(nonatomic, assign)BOOL iAnimationInterrupt;
@end

@implementation HLIntroScnCell

-(id)initWithSclSize:(CGSize)ssize FstImg:(NSString*)fstr SecImg:(NSString*)sstr Page:(BOOL)enablePage AutoSlide:(BOOL)autoslide
{
    self = [super init];
    if (self)
    {
        self.iSize = ssize;
        self.iPageEnable = enablePage;
        self.iAutoSlide = autoslide;
        self.clipsToBounds = YES;
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
-(void)dealloc
{
    for (CALayer* layer in [self.layer sublayers]) {
        [layer removeAllAnimations];
    }
    self.iAnimationInterrupt = YES;
}
-(void)animateToPage:(int)num
{
    if (num==0)
    {
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D tr = CATransform3DIdentity;
        tr = CATransform3DTranslate(tr, 0, 0, 0);
        scale.duration = SLIDE_DURATION;
        [scale setBeginTime:CACurrentMediaTime()+1];
        scale.toValue = [NSValue valueWithCATransform3D:tr];
        scale.fillMode = kCAFillModeForwards;
        scale.removedOnCompletion = NO;
        
        [iPageIndicatorImg.layer.mask addAnimation:scale forKey:@"gotoPage0"];
    }else
    {
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D tr = CATransform3DIdentity;
        tr = CATransform3DTranslate(tr, 14, 0, 0);
        scale.duration = SLIDE_DURATION;
        [scale setBeginTime:CACurrentMediaTime()+1];
        scale.toValue = [NSValue valueWithCATransform3D:tr];
        scale.fillMode = kCAFillModeForwards;
        scale.removedOnCompletion = NO;
        [iPageIndicatorImg.layer.mask addAnimation:scale forKey:@"gotoPage1"];
    }
}
-(void)autoSlide
{
    [UIView animateWithDuration:SLIDE_DURATION delay:self->iDelay options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^()
    {
        if (iSwipeDir==SWIPE_RIGHT)
        {
            iTmpSwipeLeft.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
            iTmpSwipeRight.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
            NSLog(@"swipe animation right");
        }
        else if (iSwipeDir==SWIPE_LEFT)
        {
            iTmpSwipeLeft.frame = CGRectMake(-self.iSize.width, 0, self.iSize.width, self.iSize.height);
            iTmpSwipeRight.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
            NSLog(@"swipe animation left");
        }else
        {
            if (!iAutoSlideFlag)
            {
                iFstIV.frame = CGRectMake(-self.iSize.width, 0, self.iSize.width, self.iSize.height);
                iScnIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
            }else
            {
                iScnIV.frame = CGRectMake(-self.iSize.width, 0, self.iSize.width, self.iSize.height);
                iFstIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
            }
        }
    } completion:^(BOOL finished) {
        
        // if previous action is swipe right, we need to play some trick.
        if (iSwipeDir==SWIPE_RIGHT)
        {
            if (iTmpSwipeLeft==iFstIV)
            {
                iAutoSlideFlag = YES;
            }else
            {
                iAutoSlideFlag = NO;
            }
        }else if (iSwipeDir==SWIPE_LEFT)
        {
            if (iTmpSwipeLeft==iFstIV)
            {
                iAutoSlideFlag = NO;
            }else
            {
                iAutoSlideFlag = YES;
            }
        }
        
        iSwipeDir = SWIPE_NONE;
        self->iDelay = SLIDE_DELAY;
        // check swipe queue
        if ([iSwipeList count])
        {
            iSwipeDir = [[iSwipeList objectAtIndex:0] integerValue];
            if (iSwipeDir==SWIPE_RIGHT)
            {
                NSLog(@"swipe right");
                
                if (iFstIV.frame.origin.x==-self.iSize.width)
                {
                    iTmpSwipeLeft = iFstIV;
                    iTmpSwipeRight = iScnIV;
                }
                else
                {
                    iTmpSwipeLeft = iScnIV;
                    iTmpSwipeRight = iFstIV;
                }
                if(iFstIV.frame.origin.x==self.iSize.width)
                {
                    iFstIV.frame = CGRectMake(-self.iSize.width, 0, self.iSize.width, self.iSize.height);
                    iTmpSwipeLeft = iFstIV;
                    iTmpSwipeRight = iScnIV;
                }else if (iScnIV.frame.origin.x==self.iSize.width)
                {
                    iScnIV.frame = CGRectMake(-self.iSize.width, 0, self.iSize.width, self.iSize.height);
                    iTmpSwipeLeft = iScnIV;
                    iTmpSwipeRight = iFstIV;
                }
            }
            else if (iSwipeDir==SWIPE_LEFT)
            {
                NSLog(@"swipe left");
                
                if (iFstIV.frame.origin.x==0)
                {
                    [self animateToPage:0];
                    iTmpSwipeLeft = iFstIV;
                    iTmpSwipeRight = iScnIV;
                    iTmpSwipeRight.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
                }
                else
                {
                    [self animateToPage:1];
                    iTmpSwipeLeft = iScnIV;
                    iTmpSwipeRight = iFstIV;
                    iTmpSwipeRight.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
                }
                
            }
            [iSwipeList removeObjectAtIndex:0];
            self->iDelay = 0.2;
        }
        if (iSwipeDir==SWIPE_NONE)
        {
            if (!iAutoSlideFlag)
            {
                iFstIV.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
                [self animateToPage:1];
            }else
            {
                iScnIV.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
                [self animateToPage:0];
            }
            iAutoSlideFlag = !iAutoSlideFlag;
        }
        if (self.iAnimationInterrupt==NO)
        {
            [self autoSlide];
        }
    }];
}

-(void)didMoveToSuperview
{
    iSwipeDir = SWIPE_NONE;
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
                    iScnIV.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
                    
                    if (self.iPageEnable)
                    {
                        iPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, iFstIV.frame.size.height-12-33, iFstIV.frame.size.width, 12)];
                        iPageCtrl.numberOfPages = 2;
                        iPageCtrl.currentPage = 0;
                        iPageCtrl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
                        iPageCtrl.hidden = iHidePage;
                        iPageCtrl.hidden = YES;//I use image mask for page indicator, so we hide this control.
                        [self addSubview:iPageCtrl];
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
                        
                        //Mask Cover
                        UIImageView* mask_cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"custom_page_indicator_mask_cover.png"]];
                        mask_cover.frame = CGRectMake(272, 544, mask_cover.frame.size.width, mask_cover.frame.size.height);
                        [self addSubview:mask_cover];
                        
                        
                        if (self.iAutoSlide)
                        {
                            iSwipeList = [[NSMutableArray alloc] init];
                            [self autoSlide];
                        }
                    }
                });
            });
        }
        iInit = YES;
    }else
    {
        self.iAnimationInterrupt = YES;
        for (CALayer* layer in [self.layer sublayers]) {
            [layer removeAllAnimations];
        }
    }
}

- (void)onSceneSclSwipe: (UISwipeGestureRecognizer *)sender
{
    if(sender.direction & UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Add swipe animation to right");
        [iSwipeList addObject:[NSNumber numberWithInt:SWIPE_RIGHT]];
        /*
        if (iFstIV.frame.origin.x == -self.iSize.width)
        {
            [UIView animateWithDuration:SLIDE_DURATION delay:SLIDE_DELAY options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^()
             {
                 iFstIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
                 iScnIV.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
             } completion:^(BOOL finished) {
                 
             }];
        }
        */
        /*
        iPageCtrl.currentPage = 1;
        [UIView animateWithDuration:SLIDE_DURATION animations:^{
         
            //uiLRArrow.frame = CGRectMake(0, uiLRArrow.frame.origin.y, uiLRArrow.frame.size.width, uiLRArrow.frame.size.height);
            iFstIV.frame = CGRectMake(0, 0, self.iSize.width, self.iSize.height);
            iScnIV.frame = CGRectMake(self.iSize.width, 0, self.iSize.width, self.iSize.height);
        } completion:^(BOOL finished) {
            self.iAnimationInterrupt = NO;
            if (self.iAutoSlide)
            {
            //    [self autoSlide];
            }
        }];
        */
        iSwapToSnd = YES;
    }
    
    
    if(sender.direction & UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"Add swipe animation to left");
        [iSwipeList addObject:[NSNumber numberWithInt:SWIPE_LEFT]];
        /*
        //[self moveLeft];
        NSLog(@"swipe left");
        iPageCtrl.currentPage = 0;
        [UIView animateWithDuration:IMGSWAP_DURATION animations:^{
            
            uiLRArrow.frame = CGRectMake(self.frame.size.width-uiLRArrow.frame.size.width,
                                         uiLRArrow.frame.origin.y,
                                         uiLRArrow.frame.size.width,
                                         uiLRArrow.frame.size.height);
            
            iFstIV.frame = CGRectMake(0, 0, iFstIV.frame.size.width, iFstIV.frame.size.height);
            
        } completion:^(BOOL finished) {
            self.iAnimationInterrupt = NO;
            if (self.iAutoSlide)
            {
                [self autoSlide];
            }
        }];
        iSwapToSnd = NO;
        */
    }
    
}

-(void)showArrow
{
    iShowArrow = YES;
}
-(void)hidePageCtrl
{
    iHidePage = YES;
}
/*
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
*/
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
