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
    [iSlideShow createCellByIndex:((int)btn.tag-1)];
  }
}
@end
