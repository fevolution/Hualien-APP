//
//  SpxBtnShackView.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "SpxLionShackView.h"
#import "GeneralFullScreenSlideShow.h"
#import <CoreMotion/CoreMotion.h>
#define CELL_NUM 10
#define TILT_VOLUME 80
#define RANDOM_VOL 100
@interface SpxLionShackView()<IGeneralFullScreenSlideShow>
{
    CGPoint* iOrgPosList;
    NSMutableArray* iBtnList;
    NSMutableArray* iNameList;
    NSMutableArray* iDesList;
}
@property(nonatomic, strong)CMMotionManager* iMotionMng;

@property(nonatomic, weak)IBOutlet UIButton* uiAdventure;
@property(nonatomic, weak)IBOutlet UIButton* uiEco;
@property(nonatomic, weak)IBOutlet UIButton* uiArt;
@property(nonatomic, weak)IBOutlet UIButton* uiFanBoat;
@property(nonatomic, weak)IBOutlet UIButton* uiFanPeople;
@property(nonatomic, weak)IBOutlet UIButton* uiHorse;
@property(nonatomic, weak)IBOutlet UIButton* uiIronHorse;
@property(nonatomic, weak)IBOutlet UIButton* uiLitFlight;
@property(nonatomic, weak)IBOutlet UIButton* uiMotionBike;
@property(nonatomic, weak)IBOutlet UIButton* uiOrganic;
@property(nonatomic, weak)IBOutlet UIImageView* uiLionSplash;
@property(nonatomic, strong)GeneralFullScreenSlideShow* iSlideShow;
@end

@implementation SpxLionShackView
@synthesize iSlideShow;
+(id)SpxLionShackView
{
    SpxLionShackView *instance = [[[NSBundle mainBundle] loadNibNamed:@"SpxLionShackView" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[SpxLionShackView class]] )
    {
        return instance;
    }
    else
        return nil;
}
-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    free(iOrgPosList);
}
-(void)awakeFromNib
{
    iOrgPosList = malloc(CELL_NUM*sizeof(CGPoint));
    iOrgPosList[0] = self.uiAdventure.center;
    iOrgPosList[1] = self.uiEco.center;
    iOrgPosList[2] = self.uiArt.center;
    iOrgPosList[3] = self.uiFanBoat.center;
    iOrgPosList[4] = self.uiFanPeople.center;
    iOrgPosList[5] = self.uiHorse.center;
    iOrgPosList[6] = self.uiIronHorse.center;
    iOrgPosList[7] = self.uiLitFlight.center;
    iOrgPosList[8] = self.uiMotionBike.center;
    iOrgPosList[9] = self.uiOrganic.center;

    iBtnList = [[NSMutableArray alloc] init];
    [iBtnList addObject:self.uiAdventure];
    [iBtnList addObject:self.uiEco];
    [iBtnList addObject:self.uiArt];
    [iBtnList addObject:self.uiFanBoat];
    [iBtnList addObject:self.uiFanPeople];
    [iBtnList addObject:self.uiHorse];
    [iBtnList addObject:self.uiIronHorse];
    [iBtnList addObject:self.uiLitFlight];
    [iBtnList addObject:self.uiMotionBike];
    [iBtnList addObject:self.uiOrganic];
#ifndef MONKEY
    self.iMotionMng = [[CMMotionManager alloc] init];
    self.iMotionMng.accelerometerUpdateInterval = 0.6;
    if ([self.iMotionMng isAccelerometerAvailable])
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.iMotionMng startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"X-%.2f Y-%.2f Z-%.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
                //x - up down
                //y - left right
                [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^()
                 {
                     for (int i =0; i<CELL_NUM; i++)
                     {
                         UIButton* btn = [iBtnList objectAtIndex:i];
                         CGPoint org = iOrgPosList[i];
                         btn.center = CGPointMake(org.x+(TILT_VOLUME+rand()%RANDOM_VOL)*accelerometerData.acceleration.y,
                                                  org.y+(TILT_VOLUME+rand()%RANDOM_VOL)*accelerometerData.acceleration.x);
                     }
                 }completion:^(BOOL finished) {

                 }];

            });
        }];
    } else
        NSLog(@"not active");
#endif
    iNameList = [[NSMutableArray alloc] initWithObjects:@"spx_lion_adventure", @"spx_lion_eco", @"spx_lion_art", @"spx_lion_fan_boat",
                 @"spx_lion_fan_people", @"spx_lion_horse", @"spx_lion_ironhorse", @"spx_lion_litflight", @"spx_lion_motobike",
                 @"spx_lion_organic", nil];
    iDesList = [[NSMutableArray alloc] init];
    for (int i = 0; i <[iNameList count]; i++)
    {
        NSString* str = [iNameList objectAtIndex:i];
        [iDesList addObject:[NSString stringWithFormat:@"%@_des.png", str]];
        [iNameList replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@.png", str]];
    }

    [UIView animateKeyframesWithDuration:1 delay:1 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiLionSplash.alpha = 0;
    } completion:^(BOOL finished) {
        self.uiLionSplash.hidden = YES;
    }];
}
-(void)onSlideShowDismiss:(id)theslideshow
{
    if (iSlideShow)
    {
        [iSlideShow dismissViewControllerAnimated:NO completion:nil];
        [iSlideShow removeFromParentViewController];
        iSlideShow = nil; //nil is not working
    }
}
-(IBAction)onClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (iSlideShow==nil)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootViewController = window.rootViewController;
        iSlideShow = [[GeneralFullScreenSlideShow alloc] initWithNibName:@"GeneralFullScreenSlideShow" bundle:nil NameList:iNameList DesList:iDesList];
        [rootViewController presentViewController:iSlideShow animated:YES completion:nil];
        [iSlideShow setDelegate:self];
        [iSlideShow createCellByIndex:(int)btn.tag];
    }
}
@end
