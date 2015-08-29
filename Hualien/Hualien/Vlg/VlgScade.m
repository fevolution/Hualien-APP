//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgScade.h"
#import "GeneralSingleSlideShow.h"
#import "HLIntroScnCell.h"
#define DES_DOWN_DURATION 0.8
#define MASKMOVE_DURATION 0.45
#define MOVE_DURATION 0.47
#define TOPBAR_BOTTOM_Y 110
#define CORNER_BTN_W 16
#define CORNER_BTN_H 9
@interface VlgScade()<IGeneralSingleSlideShow, UIScrollViewDelegate>
{
    CGRect soft01Rect;
    CGRect soft02Rect;
    CGRect soft03Rect;
    CGRect soft04Rect;
    CGRect soft05Rect;
    CGRect soft06Rect;
    CGRect soft07Rect;
    CGRect soft08Rect;
    
    CGRect soft01RectExpand;
    CGRect soft02RectExpand;
    CGRect soft03RectExpand;
    CGRect soft04RectExpand;
    CGRect soft05RectExpand;
    CGRect soft06RectExpand;
    CGRect soft07RectExpand;
    CGRect soft08RectExpand;
    NSArray* iExpandList;
    NSArray* iSoftList;
    bool bExpand;
    GeneralSingleSlideShow* iSingleSlideShow;
}


@property(nonatomic, weak)IBOutlet UIImageView* uiSoft01;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft02;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft03;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft04;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft05;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft06;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft07;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft08;

@property(nonatomic, weak)IBOutlet UIImageView* uiSoft01Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft02Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft03Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft04Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft05Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft06Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft07Des;
@property(nonatomic, weak)IBOutlet UIImageView* uiSoft08Des;

@property(nonatomic, weak)IBOutlet UIButton* uiUp;
@property(nonatomic, weak)IBOutlet UIButton* uiDown;
@property(nonatomic, weak)IBOutlet UIImageView* uiDesCap;
@property(nonatomic, weak)IBOutlet UIScrollView* uiDes;
@property(nonatomic, weak)IBOutlet UIView* uiUpView;
@property(nonatomic, weak)IBOutlet UIView* uiSclComboView;
@end

@implementation VlgScade
+(id)VlgScade
{
    VlgScade *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgScade" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgScade class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    self.uiDes.contentSize = CGSizeMake(312, 517);
    
    soft01Rect = CGRectMake(276, 115, 413, 221);
    soft02Rect = CGRectMake(709, 100, 212, 218);
    soft03Rect = CGRectMake(-20, 334, 337, 180);
    soft04Rect = CGRectMake(217, 427, 318, 170);
    soft05Rect = CGRectMake(468, 334, 280, 372);
    soft06Rect = CGRectMake(756, 305, 252, 196);
    soft07Rect = CGRectMake(96, 629, 168, 131);
    soft08Rect = CGRectMake(729, 477, 263, 279);
    self.uiSoft01.frame = soft01Rect;
    self.uiSoft02.frame = soft02Rect;
    self.uiSoft03.frame = soft03Rect;
    self.uiSoft04.frame = soft04Rect;
    self.uiSoft05.frame = soft05Rect;
    self.uiSoft06.frame = soft06Rect;
    self.uiSoft07.frame = soft07Rect;
    self.uiSoft08.frame = soft08Rect;
    
    iSoftList = [[NSArray alloc] initWithObjects:self.uiSoft01, self.uiSoft02, self.uiSoft03, self.uiSoft04, self.uiSoft05, self.uiSoft06, self.uiSoft07, self.uiSoft08, nil];
    
    soft01RectExpand = CGRectMake(220, 86, 648, 347);
    soft02RectExpand = CGRectMake(330, 159, 385, 395);
    soft03RectExpand = CGRectMake(-18, 334, 701, 375);
    soft04RectExpand = CGRectMake(-28,330,697,373);
    soft05RectExpand = CGRectMake(339, 167, 406, 539);
    soft06RectExpand = CGRectMake(503, 305, 463, 360);
    soft07RectExpand = CGRectMake(90, 432, 390, 303);
    soft08RectExpand = CGRectMake(295, 229, 495, 527);
    
    iExpandList = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:soft01RectExpand], [NSValue valueWithCGRect:soft02RectExpand],
                                                   [NSValue valueWithCGRect:soft03RectExpand], [NSValue valueWithCGRect:soft04RectExpand],
                                                   [NSValue valueWithCGRect:soft05RectExpand],[NSValue valueWithCGRect:soft06RectExpand],
                                                   [NSValue valueWithCGRect:soft07RectExpand], [NSValue valueWithCGRect:soft08RectExpand],
                                                   nil];
    [self shrinkBackDirect:YES];
    
    
    [self onBottom:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    iSingleSlideShow = [[GeneralSingleSlideShow alloc] initWithNibName:@"GeneralSingleSlideShow" bundle:nil];
    [iSingleSlideShow setVideoContent:@"Furniture_Animation_2015_05_29"];
    [iSingleSlideShow setDelegate:self];
    [rootViewController presentViewController:iSingleSlideShow animated:YES completion:nil];
    
    // Mask animation
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, -self.uiSclComboView.frame.size.height+self.uiDesCap.frame.size.height,
                                         self.uiSclComboView.frame.size.width, self.uiSclComboView.frame.size.height));
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath:path];
    [shapeLayer setFrame:self.uiDesCap.bounds];
    CGPathRelease(path);
    [[self.uiSclComboView layer] setMask:shapeLayer];
    
}
-(void)onSingleSlideShowClose
{
    [iSingleSlideShow dismissViewControllerAnimated:YES completion:nil];
    [self onTop:nil];
    [self animationDesDown:0.44];
}
-(void)animationDesDown:(int)delay
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CATransform3D tr = CATransform3DIdentity;
    tr = CATransform3DTranslate(tr, 0, self.uiSclComboView.frame.size.height-self.uiDesCap.frame.size.height, 0);
    scale.duration = DES_DOWN_DURATION;
    [scale setBeginTime:CACurrentMediaTime()+delay];
    scale.toValue = [NSValue valueWithCATransform3D:tr];
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    [self.uiSclComboView.layer.mask addAnimation:scale forKey:@"gotoPage1"];
}

- (void)changeScrollBarColorFor:(UIScrollView *)scrollView
{
    int iR = 0;
    int iG = 137;
    int iB = 98;
    for ( UIView *view in scrollView.subviews ) {
        
        if (view.tag == 0 && [view isKindOfClass:UIImageView.class])
        {
            UIImageView *imageView = (UIImageView *)view;
            imageView.backgroundColor = [UIColor colorWithRed:iR green:iG/255.0 blue:iB/255.0 alpha:1];
        }
    }
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeScrollBarColorFor:scrollView];
}


-(void)dealloc
{
    NSLog(@"%s", __func__);
}

-(IBAction)onTop:(id)sender
{
    self.uiDown.hidden = YES;
    self.uiDes.hidden = NO;
    self.uiUpView.hidden = NO;
    [self animationDesDown:MOVE_DURATION];
}
-(IBAction)onBottom:(id)sender
{
    self.uiDown.hidden = NO;
    self.uiDes.hidden = YES;
    self.uiUpView.hidden = YES;
}

//Move Open/Close
-(void)moveOnMenuOpen
{
    
}
-(void)moveOnMenuClose
{
    
}
//Shrink Back
-(void)shrinkBackDirect:(BOOL)direct
{
    if (!direct)
    {
    [UIView animateWithDuration:0.5 animations:^{
        self.uiSoft01.frame = soft01Rect;
        self.uiSoft02.frame = soft02Rect;
        self.uiSoft03.frame = soft03Rect;
        self.uiSoft04.frame = soft04Rect;
        self.uiSoft05.frame = soft05Rect;
        self.uiSoft06.frame = soft06Rect;
        self.uiSoft07.frame = soft07Rect;
        self.uiSoft08.frame = soft08Rect;
        
        self.uiSoft01Des.alpha = 0;
        self.uiSoft02Des.alpha = 0;
        self.uiSoft03Des.alpha = 0;
        self.uiSoft04Des.alpha = 0;
        self.uiSoft05Des.alpha = 0;
        self.uiSoft06Des.alpha = 0;
        self.uiSoft07Des.alpha = 0;
        self.uiSoft08Des.alpha = 0;
    }];
    }
    else
    {
        self.uiSoft01.frame = soft01Rect;
        self.uiSoft02.frame = soft02Rect;
        self.uiSoft03.frame = soft03Rect;
        self.uiSoft04.frame = soft04Rect;
        self.uiSoft05.frame = soft05Rect;
        self.uiSoft06.frame = soft06Rect;
        self.uiSoft07.frame = soft07Rect;
        self.uiSoft08.frame = soft08Rect;
        
        self.uiSoft01Des.alpha = 0;
        self.uiSoft02Des.alpha = 0;
        self.uiSoft03Des.alpha = 0;
        self.uiSoft04Des.alpha = 0;
        self.uiSoft05Des.alpha = 0;
        self.uiSoft06Des.alpha = 0;
        self.uiSoft07Des.alpha = 0;
        self.uiSoft08Des.alpha = 0;
    }
}

//Shrink
-(void)shrinkOthersByIndex:(int)index Target:(UIImageView*)v
{
    NSValue* expand = [iExpandList objectAtIndex:index];
    CGRect exrect = [expand CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        v.frame = exrect;
    }];
    
    if (index==0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft01Des.alpha = 1;
            self.uiSoft02.frame = CGRectMake(852, 78, 212, 218);
            self.uiSoft03.frame = CGRectMake(-90, 334, 337, 180);
            self.uiSoft04.frame = CGRectMake(165, 451, 318, 170);
            self.uiSoft05.frame = CGRectMake(471, 543, 280, 372);
            self.uiSoft06.frame = CGRectMake(892, 352, 252, 196);
            self.uiSoft07.frame = CGRectMake(96, 629, 168, 131);
            self.uiSoft08.frame = CGRectMake(739, 534, 263, 279);
        }];

    }else if (index==1)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft02Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, 1, 413, 221);
            self.uiSoft03.frame = CGRectMake(-32, 334, 337, 180);
            self.uiSoft04.frame = CGRectMake(142, 487, 318, 170);
            self.uiSoft05.frame = CGRectMake(468, 542, 280, 372);
            self.uiSoft06.frame = CGRectMake(855, 105, 252, 196);
            self.uiSoft07.frame = CGRectMake(96, 629, 168, 131);
            self.uiSoft08.frame = CGRectMake(709, 477, 263, 279);
        }];
    }else if (index==2)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft03Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, 115, 413, 221);
            self.uiSoft02.frame = CGRectMake(720, 70, 212, 218);
            self.uiSoft04.frame = CGRectMake(400, 800, 318, 170);
            self.uiSoft05.frame = CGRectMake(802, 500, 280, 372);
            self.uiSoft06.frame = CGRectMake(800, 300, 252, 196);
            self.uiSoft07.frame = CGRectMake(96, 800, 168, 131);
            self.uiSoft08.frame = CGRectMake(781, 800, 263, 279);
        }];
    }else if (index==3)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft04Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, 115, 413, 221);
            self.uiSoft02.frame = CGRectMake(720, 70, 212, 218);
            self.uiSoft03.frame = CGRectMake(-300, 334, 337, 180);
            self.uiSoft05.frame = CGRectMake(600, 770, 280, 372);
            self.uiSoft06.frame = CGRectMake(920, 305, 252, 196);
            self.uiSoft07.frame = CGRectMake(96, 800, 168, 131);
            self.uiSoft08.frame = CGRectMake(781, 800, 263, 279);
        }];
    }else if (index==4)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft05Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, -90, 413, 221);
            self.uiSoft02.frame = CGRectMake(769, 70, 212, 218);
            self.uiSoft03.frame = CGRectMake(-300, 334, 337, 180);
            self.uiSoft04.frame = CGRectMake(70, 427, 318, 170);
            self.uiSoft06.frame = CGRectMake(1000, 305, 252, 196);
            self.uiSoft07.frame = CGRectMake(96, 629, 168, 131);
            self.uiSoft08.frame = CGRectMake(890, 800, 263, 279);
        }];
    }else if (index==5)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft06Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, 70, 413, 221);
            self.uiSoft02.frame = CGRectMake(709, 50, 212, 218);
            self.uiSoft03.frame = CGRectMake(-90, 321, 337, 180);
            self.uiSoft04.frame = CGRectMake(-120, 480, 318, 170);
            self.uiSoft05.frame = CGRectMake(468, 800, 280, 372);
            self.uiSoft07.frame = CGRectMake(96, 629, 168, 131);
            self.uiSoft08.frame = CGRectMake(709, 800, 263, 279);
        }];
    }else if (index==6)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft07Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, 78, 413, 221);
            self.uiSoft02.frame = CGRectMake(709, 78, 212, 218);
            self.uiSoft03.frame = CGRectMake(-100, 300, 337, 180);
            self.uiSoft04.frame = CGRectMake(500, 280, 318, 170);
            self.uiSoft05.frame = CGRectMake(700, 800, 280, 372);
            self.uiSoft06.frame = CGRectMake(820, 305, 252, 196);
            self.uiSoft08.frame = CGRectMake(700, 477, 263, 279);
        }];
    }else if (index==7)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.uiSoft08Des.alpha = 1;
            self.uiSoft01.frame = CGRectMake(276, 115, 413, 221);
            self.uiSoft02.frame = CGRectMake(709, 7, 212, 218);
            self.uiSoft03.frame = CGRectMake(-330, 334, 337, 180);
            self.uiSoft04.frame = CGRectMake(0, 427, 318, 170);
            self.uiSoft05.frame = CGRectMake(300, 334, 280, 372);
            self.uiSoft06.frame = CGRectMake(1100, 305, 252, 196);
            self.uiSoft07.frame = CGRectMake(96, 629, 168, 131);
        }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (bExpand)
    {
        bExpand = NO;
        [self shrinkBackDirect:NO];
    }
    else
    {
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self];
        int sqrlen = INT16_MAX;
        UIImageView* target_touch = nil;
        int index = -1;
        //Check which one is closer to the touch point
        for (int i =0;i<[iSoftList count]; i++)
        {
            UIImageView* v = [iSoftList objectAtIndex:i];
            if (CGRectContainsPoint(v.frame, p))
            {
                float dx = v.center.x - p.x;
                float dy = v.center.y - p.y;
                int slen = dx*dx+dy*dy;
                if (slen<sqrlen)
                {
                    sqrlen = slen;
                    target_touch = v;
                    index = i;
                }
            }
        }
        if (target_touch)
        {
            [self onBottom:nil];
            [self shrinkOthersByIndex:index Target:target_touch];
            bExpand = YES;
        }
    }
}

//Soft01
-(IBAction)onSoft01:(id)sender
{
    if (CGRectEqualToRect(self.uiSoft01.frame, soft01RectExpand))
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
        {
            self.uiSoft01.frame = soft01Rect;
        } completion:nil];
    }
    else
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
        {
            self.uiSoft01.frame = soft01RectExpand;
        } completion:nil];
    }
}

//Soft02
-(IBAction)onSoft02:(id)sender
{
    [self onBottom:nil];
    
}

-(IBAction)onDownDes:(id)sender
{
    
}
-(IBAction)onUpDes:(id)sender
{
    
}
@end
