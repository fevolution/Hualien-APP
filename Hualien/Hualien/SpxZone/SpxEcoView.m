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
#include <time.h>       /* time */
#define CELL_NUM 10
#define TILT_VOLUME 80
#define RANDOM_VOL 100
#define NUMBER_OF_BIRD 30
@interface SpxEcoView()<IGeneralFullScreenSlideShow>
{
    CGPoint* iOrgPosList;
    NSMutableArray* iBtnList;
    NSMutableArray* iNameList;
    NSMutableArray* iDesList;
  
    NSMutableArray* iSplashNameList;
  int bSplash;
}
@property(nonatomic, strong)GeneralFullScreenSlideShow* iSlideShow;
@property(nonatomic, strong)GeneralFullScreenSlideShow* iSplashSlideShow;
@end

@implementation SpxEcoView
@synthesize iSlideShow, iSplashSlideShow;
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
  iNameList = [[NSMutableArray alloc] initWithObjects:@"spx_eco_bird_01", @"spx_eco_bird_02", @"spx_eco_bird_03", @"spx_eco_bird_04",
                 @"spx_eco_bird_05", @"spx_eco_bird_06", @"spx_eco_bird_07", @"spx_eco_bird_08", @"spx_eco_bird_09",
                 @"spx_eco_bird_10", @"spx_eco_bird_11", @"spx_eco_bird_12", @"spx_eco_bird_13", @"spx_eco_bird_14", @"spx_eco_bird_15",
                 @"spx_eco_bird_16", @"spx_eco_bird_17", @"spx_eco_bird_18", @"spx_eco_bird_19", @"spx_eco_bird_20", @"spx_eco_bird_21", @"spx_eco_bird_22",
                 @"spx_eco_bird_23", @"spx_eco_bird_24", @"spx_eco_bird_25", @"spx_eco_bird_26", nil];
  for (int i = 0; i <[iNameList count]; i++)
  {
    NSString* str = [iNameList objectAtIndex:i];
    [iNameList replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@.png", str]];
  }
  
  //Splash
  iSplashNameList = [[NSMutableArray alloc] init];
  for ( int i = 1; i <= 58; i++)
  {
    [iSplashNameList addObject:[NSString stringWithFormat:@"bird_splash_screen%d", i]];
  }
  NSMutableArray* tmp = [[NSMutableArray alloc] init];
  for (int i = 1; i <= NUMBER_OF_BIRD; i++) {
    int index = (int)(arc4random() % [iSplashNameList count]);
    id object = [iSplashNameList objectAtIndex:index];
    [tmp addObject:object];
    [iSplashNameList removeObjectAtIndex:index];
  }
  [iSplashNameList removeAllObjects];
  iSplashNameList = [tmp copy];
}
- (void)didMoveToWindow
{
  NSLog(@"__%s", __func__);
  if (NO==bSplash)
  {
    // Delay 2 seconds
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      UIWindow *window = [UIApplication sharedApplication].keyWindow;
      UIViewController *rootViewController = window.rootViewController;
      iSplashSlideShow = [[GeneralFullScreenSlideShow alloc] initWithNibName:@"GeneralFullScreenSlideShow" bundle:nil NameList:iSplashNameList DesList:nil];
      [rootViewController presentViewController:iSplashSlideShow animated:YES completion:nil];
      [iSplashSlideShow setDelegate:self];
      srand ((int)time(NULL));
      int r = rand()%NUMBER_OF_BIRD;
      NSLog(@"%d", r);
      [iSplashSlideShow createCellByIndex:r];
      [iSplashSlideShow enableAutoRun];
    //});
    
    bSplash = YES;
  }
}
-(void)onSlideShowDismiss:(id)theslideshow
{
  if (theslideshow==iSplashSlideShow)
  {
    [iSplashSlideShow disableAutoRun];
    iSplashSlideShow = nil;
  }
  [theslideshow dismissViewControllerAnimated:NO completion:nil];
  [theslideshow removeFromParentViewController];
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
    [iSlideShow createCellByIndex:((int)btn.tag-1)];
  }
}
@end
