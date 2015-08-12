//
//  SpxZoneVCtrl.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/7.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//
#import "SpxZoneVCtrl.h"
#import "SpxPlanView.h"
#import "SpxLionShackView.h"

static NSString *const classPlanView = @"SpxPlanView";
static NSString *const classLionShackView = @"SpxLionShackView";

@interface SpxZoneVCtrl ()
{
    __weak UIView* iActiveView;
}
@property(nonatomic, weak)IBOutlet UIView* uiTopBar;
@property(nonatomic, weak)IBOutlet UIView* uiMenu;
@property(nonatomic, weak)IBOutlet UIView* uiSplash;
@property(nonatomic, weak)IBOutlet UIButton* uiPlan;
@property(nonatomic, weak)IBOutlet UIButton* uiLion;
@property(nonatomic, weak)IBOutlet UIImageView* uiBackHome;
@end

@implementation SpxZoneVCtrl
- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Title
    [UIView animateKeyframesWithDuration:1.2 delay:1.2 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiSplash.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    iActiveView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)openMenu
{
    if (self.uiMenu.alpha==0)
    {
        self.uiMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
        [UIView animateWithDuration:TOPMENU_ANIM_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.uiMenu.frame = CGRectMake(0, TOPBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
            self.uiMenu.alpha = 1;
            [self.uiMenu layoutIfNeeded];
        }
                         completion:^(BOOL a)
         {

         }];
    }else
    {
        self.uiMenu.frame = CGRectMake(0, TOPMENU_HEIGHT, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
        [UIView animateWithDuration:TOPMENU_ANIM_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.uiMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
            self.uiMenu.alpha = 0;
            [self.uiMenu layoutIfNeeded];
        }
                         completion:^(BOOL a)
         {
             self.uiMenu.frame = CGRectMake(0, -TOPMENU_HEIGHT, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
         }];
    }
}

-(void)switchToViewByString:(NSString*)viewstr
{
    if (iActiveView && YES==[iActiveView isKindOfClass:NSClassFromString(viewstr)])
    {
        NSLog(@"Already has same name");
        if ([viewstr isEqualToString:@"SpxPlanView"])
        {
            [(SpxPlanView*)iActiveView gotoMap];
        }
        return;
    }
    if (iActiveView)
    {
        [iActiveView removeFromSuperview];
        iActiveView = nil;
    }
    SEL selector     = NSSelectorFromString(viewstr);
    Class arrayClass = NSClassFromString (viewstr);
    UIView* instance = [arrayClass performSelector:selector];
    [self.view addSubview:instance];
    [self.view bringSubviewToFront:self.uiMenu];
    [self.view bringSubviewToFront:self.uiTopBar];
    iActiveView = instance;
}

- (IBAction)onHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)onTitle:(id)sender
{
    [self openMenu];
}

- (IBAction)onPlan:(id)sender
{
    self.uiBackHome.hidden = NO;
    self.uiPlan.selected = YES;
    self.uiLion.selected = NO;
    [self switchToViewByString:classPlanView];
    //[self openMenu];
}

- (IBAction)onLion:(id)sender
{
    self.uiBackHome.hidden = NO;
    self.uiLion.selected = YES;
    self.uiPlan.selected = NO;
    [self switchToViewByString:classLionShackView];
    //[self openMenu];
}

@end
