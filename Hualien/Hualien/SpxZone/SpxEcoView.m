//
//  SpxBtnShackView.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "SpxEcoView.h"
#import "GeneralFullScreenSlideShow.h"
#import <CoreMotion/CoreMotion.h>
#define CELL_NUM 10
#define TILT_VOLUME 80
#define RANDOM_VOL 100
@interface SpxEcoView()<IGeneralFullScreenSlideShow>
{
    CGPoint* iOrgPosList;
    NSMutableArray* iBtnList;
    NSMutableArray* iNameList;
    NSMutableArray* iDesList;
}
@property(nonatomic, strong)GeneralFullScreenSlideShow* iSlideShow;
@end

@implementation SpxEcoView
@synthesize iSlideShow;
+(id)SpxEcoView
{
    SpxEcoView *instance = [[[NSBundle mainBundle] loadNibNamed:@"SpxEcoView" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[SpxEcoView class]] )
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

//    [UIView animateKeyframesWithDuration:1 delay:1 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
//        self.uiLionSplash.alpha = 0;
//    } completion:^(BOOL finished) {
//        self.uiLionSplash.hidden = YES;
//    }];
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
 
}
@end
