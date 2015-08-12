//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgInterDeco.h"
#import "GeneralFullScreenSlideShow.h"
#import "HLIntroScnCell.h"
#define MASKMOVE_DURATION 0.45
#define MOVE_DURATION 0.4
#define TOPBAR_BOTTOM_Y 110
@interface VlgInterDeco()
{
    NSMutableArray* iCellList;
    NSMutableArray* iTopBtnList;
    NSMutableArray* iBedImgList;
    NSMutableArray* iBathImgList;
    NSMutableArray* iBedTextList;
    NSMutableArray* iBathTextList;
    NSMutableArray* iCellImagePairList;
    int prevTagForBed;
    int prevTagForBath;
    int maskW;
    int maskW1_3;
    int maskH;
    BOOL iBedPressToSee;
    BOOL iBathPressToSee;
}

@property(nonatomic, weak)IBOutlet UIButton* uiTop01;
@property(nonatomic, weak)IBOutlet UIButton* uiTop02;
@property(nonatomic, weak)IBOutlet UIView* uiBedContainer;
@property(nonatomic, weak)IBOutlet UIView* uiBathContainer;

@property(nonatomic, weak)IBOutlet UIView* uiTextContainer;

@property(nonatomic, weak)IBOutlet UIButton* uiBedText01;
@property(nonatomic, weak)IBOutlet UIButton* uiBedText02;
@property(nonatomic, weak)IBOutlet UIButton* uiBedText03;
@property(nonatomic, weak)IBOutlet UIImageView* uiBed_01;
@property(nonatomic, weak)IBOutlet UIImageView* uiBed_02;
@property(nonatomic, weak)IBOutlet UIImageView* uiBed_03;

@property(nonatomic, weak)IBOutlet UIButton* uiBathText01;
@property(nonatomic, weak)IBOutlet UIButton* uiBathText02;
@property(nonatomic, weak)IBOutlet UIButton* uiBathText03;
@property(nonatomic, weak)IBOutlet UIImageView* uiBath_01;
@property(nonatomic, weak)IBOutlet UIImageView* uiBath_02;
@property(nonatomic, weak)IBOutlet UIImageView* uiBath_03;
@end

//35 1236 Gap 400.333
@implementation VlgInterDeco
+(id)VlgInterDeco
{
    VlgInterDeco *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgInterDeco" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgInterDeco class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    iTopBtnList = [[NSMutableArray alloc] initWithObjects:self.uiTop01, self.uiTop02, nil];
    iBedImgList = [[NSMutableArray alloc] initWithObjects:self.uiBed_01, self.uiBed_02, self.uiBed_03, nil];
    iBathImgList = [[NSMutableArray alloc] initWithObjects:self.uiBath_01, self.uiBath_02, self.uiBath_03, nil];
    iBedTextList = [[NSMutableArray alloc] initWithObjects:@"vlg_arch_01_05_interiordeco_bedroom01_text.png",
                    @"vlg_arch_01_05_interiordeco_bedroom02_text.png", @"vlg_arch_01_05_interiordeco_bedroom03_text.png", nil];
    iBathTextList = [[NSMutableArray alloc] initWithObjects:@"vlg_arch_01_05_interiordeco_bathroom01_text.png",
                    @"vlg_arch_01_05_interiordeco_bathroom02_text.png", @"vlg_arch_01_05_interiordeco_bathroom03_text.png", nil];
    //Mask imageview
    maskW = self.uiBedContainer.frame.size.width;
    maskW1_3 = self.uiBedContainer.frame.size.width/3;
    maskH = self.uiBedContainer.frame.size.height;


    dispatch_queue_t serialQueue = dispatch_queue_create("com.unique.name.queue", DISPATCH_QUEUE_SERIAL);

    dispatch_async(serialQueue, ^{
        __block UIImage* image = [UIImage imageNamed:@"vlg_arch_01_05_interiordeco_bedroom01.png"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.uiBed_01 setImage:image];
            image = nil;
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
            {
                 self.uiBed_01.alpha = 1;
            } completion:nil];
        });
        dispatch_async(serialQueue, ^{
            __block  UIImage* image = [UIImage imageNamed:@"vlg_arch_01_05_interiordeco_bedroom02.png"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.uiBed_02 setImage:image];
                image = nil;
                [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
                {
                     self.uiBed_02.alpha = 1;
                } completion:nil];
            });
            dispatch_async(serialQueue, ^{
                __block  UIImage* image = [UIImage imageNamed:@"vlg_arch_01_05_interiordeco_bedroom03.png"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.uiBed_03 setImage:image];
                    image= nil;
                    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
                    {
                         self.uiBed_03.alpha = 1;
                    } completion:nil];
                });
                dispatch_async(serialQueue, ^{
                    __block  UIImage* image = [UIImage imageNamed:@"vlg_arch_01_05_interiordeco_bathroom01.png"];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.uiBath_01 setImage:image];
                        image = nil;
                        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
                        {
                             self.uiBath_01.alpha = 1;
                        } completion:nil];
                    });
                    dispatch_async(serialQueue, ^{
                        __block  UIImage* image = [UIImage imageNamed:@"vlg_arch_01_05_interiordeco_bathroom02.png"];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.uiBath_02 setImage:image];
                            image = nil;
                            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
                            {
                                 self.uiBath_02.alpha = 1;
                            } completion:nil];
                        });
                        dispatch_async(serialQueue, ^{
                            __block  UIImage* image = [UIImage imageNamed:@"vlg_arch_01_05_interiordeco_bathroom03.png"];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.uiBath_03 setImage:image];
                                image = nil;
                                [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^
                                {
                                     self.uiBath_03.alpha = 1;
                                } completion:nil];
                            });
                        });
                    });
                });
            });
        });
    });


    [self resetAll];


    self.uiTop01.selected = YES;
    self.uiBathContainer.hidden = YES;
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}
-(void)moveLayer:(CALayer*)layer to:(CGPoint)point
{
    // Prepare the animation from the current position to the new position
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [layer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:point];
    animation.duration = .3;
    layer.position = point;
    [layer addAnimation:animation forKey:@"position"];
}
-(void)resizeLayer:(CALayer*)layer toPath:(CGRect)toRect
{
    CAShapeLayer* shape_layer = (CAShapeLayer*)layer;
    CGPathRef oldPath = shape_layer.path;
    CGPathRef newPath = CGPathCreateWithRect(toRect, NULL);
    CABasicAnimation* a = [CABasicAnimation animationWithKeyPath:@"path"];
    [a setDuration:MASKMOVE_DURATION];
    [a setFromValue:(__bridge id)(oldPath)];
    [a setToValue:(__bridge id)(newPath)];
    shape_layer.path = newPath;
    [shape_layer addAnimation:a forKey:@"path"];
    CGPathRelease(newPath);
}

-(void)resizeLayer:(CALayer*)layer FromPath:(CGRect)fromRect toPath:(CGRect)toRect Duration:(float)duration
{
    CAShapeLayer* shape_layer = (CAShapeLayer*)layer;
    CGPathRef oldPath = CGPathCreateWithRect(fromRect, NULL);
    CGPathRef newPath = CGPathCreateWithRect(toRect, NULL);
    CABasicAnimation* a = [CABasicAnimation animationWithKeyPath:@"path"];
    [a setDuration:duration];

    [a setFromValue:(__bridge id)(oldPath)];

    [a setToValue:(__bridge id)(newPath)];

    shape_layer.path = newPath;
    [shape_layer addAnimation:a forKey:@"path"];
    CGPathRelease(oldPath);
    CGPathRelease(newPath);
}
- (void)removeSubViewFromTextContainer
{
    if ([self.uiTextContainer.subviews count] && [self.uiTextContainer.subviews objectAtIndex:0])
    {
        [[self.uiTextContainer.subviews objectAtIndex:0] removeFromSuperview];
    }
}
-(void)resetAll
{
    [self removeSubViewFromTextContainer];
    iBedPressToSee = NO;
    iBathPressToSee = NO;

    //Bed
    for (int i =0; i < [iBedImgList count]; i++)
    {
        // Create a mask layer and the frame to determine what will be visible in the view.
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(maskW1_3*i, 0, maskW1_3, maskH);

        // Create a path with the rectangle in it.
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);

        // Set the path to the mask layer.
        maskLayer.path = path;

        // Release the path since it's not covered by ARC.
        CGPathRelease(path);

        // Set the mask of the view.
        ((UIImageView*)[iBedImgList objectAtIndex:i]).layer.mask = maskLayer;
    }
    //Bath
    for (int i =0; i < [iBathImgList count]; i++)
    {
        // Create a mask layer and the frame to determine what will be visible in the view.
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(maskW1_3*i, 0, maskW1_3, maskH);

        // Create a path with the rectangle in it.
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);

        // Set the path to the mask layer.
        maskLayer.path = path;

        // Release the path since it's not covered by ARC.
        CGPathRelease(path);

        // Set the mask of the view.
        ((UIImageView*)[iBathImgList objectAtIndex:i]).layer.mask = maskLayer;
    }
    [self.uiBedContainer bringSubviewToFront:self.uiBedText01];
    [self.uiBedContainer bringSubviewToFront:self.uiBedText02];
    [self.uiBedContainer bringSubviewToFront:self.uiBedText03];
    [self.uiBathContainer bringSubviewToFront:self.uiBathText01];
    [self.uiBathContainer bringSubviewToFront:self.uiBathText02];
    [self.uiBathContainer bringSubviewToFront:self.uiBathText03];
}
- (void)showBedTextByTag:(int)tag
{
    [self removeSubViewFromTextContainer];
    NSString* filename = [iBedTextList objectAtIndex:tag];
    UIImage* img = [UIImage imageNamed:filename];
    UIImageView* view = [[UIImageView alloc] initWithImage:img];
    view.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.uiTextContainer addSubview:view];
}
- (void)showBathTextByTag:(int)tag
{
    [self removeSubViewFromTextContainer];
    NSString* filename = [iBathTextList objectAtIndex:tag];
    UIImage* img = [UIImage imageNamed:filename];
    UIImageView* view = [[UIImageView alloc] initWithImage:img];
    view.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.uiTextContainer addSubview:view];
}
- (IBAction)onTop01:(id)sender
{
    [self resetAll];
    self.uiTop01.selected = YES;
    self.uiTop02.selected = NO;
    self.uiBedContainer.hidden = NO;
    self.uiBathContainer.hidden = YES;
}
- (IBAction)onTop02:(id)sender
{
    [self resetAll];
    self.uiTop01.selected = NO;
    self.uiTop02.selected = YES;
    self.uiBedContainer.hidden = YES;
    self.uiBathContainer.hidden = NO;
}
- (IBAction)onBedClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    UIImageView* image = [iBedImgList objectAtIndex:tag];
    [self.uiBedContainer bringSubviewToFront:self.uiBed_01];
    [self.uiBedContainer bringSubviewToFront:self.uiBed_02];
    [self.uiBedContainer bringSubviewToFront:self.uiBed_03];
    [self.uiBedContainer bringSubviewToFront:image];
    if (iBedPressToSee==NO)
    {
        [self resizeLayer:image.layer.mask toPath:CGRectMake(0, 0, maskW, maskH)];
        prevTagForBed = tag;
        [self showBedTextByTag:tag];
    }else{
        [self removeSubViewFromTextContainer];
        //Reset all
        for (int i = 0; i < [iBedImgList count]; i++)
        {
            UIImageView* image = [iBedImgList objectAtIndex:i];
            CGRect fromRect = CGRectMake(i*maskW1_3, 0, maskW1_3, maskH);
            if (prevTagForBed==0)
            {
                //all from right
                if (i==1)
                {
                    fromRect = CGRectMake(2*maskW1_3, 0, 0, maskH);
                }else if (i==2)
                {
                    fromRect = CGRectMake(maskW, 0, 0, maskH);
                }
            }
            if (prevTagForBed==1)
            {
                if (i==0)
                {
                    //from left
                    fromRect = CGRectMake(0, 0, 0, maskH);
                }else if (i==2)
                {
                    //from right
                    fromRect = CGRectMake(maskW, 0, 0, maskH);
                }
            }
            if (prevTagForBed==2)
            {
                if (i==0)
                {
                    //from left
                    fromRect = CGRectMake(0, 0, 0, maskH);
                }else if (i==1)
                {
                    //from 1/3 W
                    fromRect = CGRectMake(maskW1_3, 0, 0, maskH);
                }
            }
            if (i==prevTagForBed)
            {
                [self resizeLayer:image.layer.mask toPath:CGRectMake(i*maskW1_3, 0, maskW1_3, maskH)];
            }else
            {
                [self resizeLayer:image.layer.mask FromPath:fromRect toPath:CGRectMake(i*maskW1_3, 0, maskW1_3, maskH) Duration:MASKMOVE_DURATION/2.0];
            }
        }
        [self.uiBedContainer bringSubviewToFront:self.uiBedText01];
        [self.uiBedContainer bringSubviewToFront:self.uiBedText02];
        [self.uiBedContainer bringSubviewToFront:self.uiBedText03];
    }
    iBedPressToSee =!iBedPressToSee;
}
- (IBAction)onBathClick:(id)sender
{
    self.uiTop01.selected = NO;
    self.uiTop02.selected = YES;
    self.uiBedContainer.hidden = YES;
    self.uiBathContainer.hidden = NO;

    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    UIImageView* image = [iBathImgList objectAtIndex:tag];
    [self.uiBathContainer bringSubviewToFront:self.uiBed_01];
    [self.uiBathContainer bringSubviewToFront:self.uiBed_02];
    [self.uiBathContainer bringSubviewToFront:self.uiBed_03];
    [self.uiBathContainer bringSubviewToFront:image];
    if (iBathPressToSee==NO)
    {
        [self resizeLayer:image.layer.mask toPath:CGRectMake(0, 0, maskW, maskH)];
        prevTagForBath = tag;
        [self showBathTextByTag:tag];
    }else{
        [self removeSubViewFromTextContainer];
        //Reset all
        for (int i = 0; i < [iBathImgList count]; i++)
        {
            UIImageView* image = [iBathImgList objectAtIndex:i];
            CGRect fromRect = CGRectMake(i*maskW1_3, 0, maskW1_3, maskH);
            if (prevTagForBath==0)
            {
                //all from right
                if (i==1)
                {
                    fromRect = CGRectMake(2*maskW1_3, 0, 0, maskH);
                }else if (i==2)
                {
                    fromRect = CGRectMake(maskW, 0, 0, maskH);
                }
            }
            if (prevTagForBath==1)
            {
                if (i==0)
                {
                    //from left
                    fromRect = CGRectMake(0, 0, 0, maskH);
                }else if (i==2)
                {
                    //from right
                    fromRect = CGRectMake(maskW, 0, 0, maskH);
                }
            }
            if (prevTagForBath==2)
            {
                if (i==0)
                {
                    //from left
                    fromRect = CGRectMake(0, 0, 0, maskH);
                }else if (i==1)
                {
                    //from 1/3 W
                    fromRect = CGRectMake(maskW1_3, 0, 0, maskH);
                }
            }
            if (i==prevTagForBath)
            {
                [self resizeLayer:image.layer.mask toPath:CGRectMake(i*maskW1_3, 0, maskW1_3, maskH)];
            }else
            {
                [self resizeLayer:image.layer.mask FromPath:fromRect toPath:CGRectMake(i*maskW1_3, 0, maskW1_3, maskH) Duration:MASKMOVE_DURATION/2.0];
            }
        }
        [self.uiBathContainer bringSubviewToFront:self.uiBathText01];
        [self.uiBathContainer bringSubviewToFront:self.uiBathText02];
        [self.uiBathContainer bringSubviewToFront:self.uiBathText03];
    }
    iBathPressToSee =!iBathPressToSee;
}
@end
