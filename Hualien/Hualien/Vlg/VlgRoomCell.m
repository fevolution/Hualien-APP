//
//  VlgRoomCell.m
//  Hualien
//
//  Created by Chunta chen on 7/21/15.
//  Copyright (c) 2015 Chen ChunTa. All rights reserved.
//

#import "VlgRoomCell.h"
@interface VlgRoomCell()
{
    BOOL iInit;
}
@property(nonatomic, weak)IBOutlet UIButton* uiLeftBtn;
@property(nonatomic, weak)IBOutlet UIButton* uiRightBtn;
@property(nonatomic, strong)NSString* iFrt;
@property(nonatomic, strong)NSString* iSnd;
@property(nonatomic, strong)UIImageView* iFstImgView;
@property(nonatomic, strong)UIImageView* iSndImgView;
@end

@implementation VlgRoomCell
+(id)VlgRoomCell
{
    VlgRoomCell *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgRoomCell" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgRoomCell class]] )
    {
        return instance;
    }
    else
        return nil;
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}
-(void)setFstImg:(NSString*)fstr SecImg:(NSString*)sst
{
    self.iFrt = fstr;
    self.iSnd = sst;
}
-(void)didMoveToSuperview
{
    if (iInit==NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block UIImage* topimg = [UIImage imageNamed:self.iFrt];
            __block UIImage* botimg = [UIImage imageNamed:self.iSnd];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView* topv = [[UIImageView alloc] initWithImage:topimg];
                UIImageView* botv = [[UIImageView alloc] initWithImage:botimg];
                self.iFstImgView = topv;
                self.iSndImgView = botv;
                topimg = nil;
                botimg = nil;
                [self addSubview:botv];
                [self addSubview:topv];
                topv.frame = self.bounds;
                botv.frame = self.bounds;
                [self bringSubviewToFront:self.uiLeftBtn];
                [self bringSubviewToFront:self.uiRightBtn];
            });
        });
        [self resetBreathing];
        self.uiLeftBtn.hidden = YES;
        iInit = YES;

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
    }else
    {
        [self cancelBreathing];
    }
}
-(void)resetBreathing
{
    for (CALayer* layer in [self.layer sublayers]) {
        [layer removeAllAnimations];
    }
    
    [UIView animateWithDuration:1.3 delay:1 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^()
    {
        self.uiLeftBtn.alpha = 1;
        self.uiRightBtn.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
-(void)cancelBreathing
{
    for (CALayer* layer in [self.layer sublayers]) {
        [layer removeAllAnimations];
    }
}
- (void)onSceneSclSwipe: (UISwipeGestureRecognizer *)sender
{
    if (sender.direction & UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"right");
        [self right];
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"left");
        [self left];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.iFstImgView.frame.origin.x!= 0)
    {
        [self.delegate onPlanViewClick:self.iSndImgView.image];
    }
}
-(void)left
{
    if (self.iFstImgView.frame.origin.x==0)
    {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.iFstImgView.frame = CGRectMake(-self.iFstImgView.frame.size.width, 0, self.iFstImgView.frame.size.width, self.iFstImgView.frame.size.height);
    } completion:^(BOOL finished) {
        self.uiLeftBtn.hidden = NO;
        self.uiRightBtn.hidden = YES;
        [self.delegate onPlanViewShow];
    }];
    }
}
-(void)right
{
    if (self.iFstImgView.frame.origin.x==-self.iFstImgView.frame.size.width)
    {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.iFstImgView.frame = CGRectMake(0, 0, self.iFstImgView.frame.size.width, self.iFstImgView.frame.size.height);
    } completion:^(BOOL finished) {
        self.uiLeftBtn.hidden = YES;
        self.uiRightBtn.hidden = NO;
        [self.delegate onPlanViewHide];
    }];
    }
}
-(IBAction)onLeft:(id)sender
{
    [self right];
}
-(IBAction)onRight:(id)sender
{
    [self left];
}
@end
