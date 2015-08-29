//
//  HomeVCtrl.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HomeVCtrl.h"

// Fun Life
#import "FunLifeVCtrl.h"

// Spx Zone
#import "SpxZoneVCtrl.h"

// Vlg
#import "VlgVCtrl.h"


// VlgFtr
#import "VlgFtrVCtrl.h"

@interface HomeVCtrl ()
@property(nonatomic, weak)IBOutlet UIButton* uiHL;
@property(nonatomic, weak)IBOutlet UIButton* uiSpx;
@property(nonatomic, weak)IBOutlet UIButton* uiVlg;
@property(nonatomic, weak)IBOutlet UIButton* uiVlgFtr;
@property(nonatomic, weak)IBOutlet UIImageView* uiSplashView;
@end

@implementation HomeVCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.uiHL imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [[self.uiSpx imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [[self.uiVlg imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [[self.uiVlgFtr imageView] setContentMode: UIViewContentModeScaleAspectFill];
  
    [UIView animateWithDuration:1.5 delay:3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
      self.uiSplashView.alpha = 0;
    } completion:^(BOOL finished) {
      self.uiSplashView.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onHF:(id)sender
{
    FunLifeVCtrl* v = [[FunLifeVCtrl alloc] init];
    [self.navigationController pushViewController:v animated:YES];
    v= nil;
}

- (IBAction)onSPX:(id)sender
{
    [self.navigationController pushViewController:[[SpxZoneVCtrl alloc] init] animated:YES];
}

- (IBAction)onVLG:(id)sender
{
    [self.navigationController pushViewController:[[VlgVCtrl alloc] init] animated:YES];
}

- (IBAction)onVLGFtr:(id)sender
{
    [self.navigationController pushViewController:[[VlgFtrVCtrl alloc] init] animated:YES];
}


@end
