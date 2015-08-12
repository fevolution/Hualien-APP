//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//
#import "VlgSmart.h"
#import "GeneralFullScreenSlideShow.h"
#import "GeneralSingleSlideShow.h"
#import "GeneralScaleZoomVCtrl.h"
#import "VlgDesignConcept.h"
#import "GeneralFullScreenSlideShow.h"
@interface VlgSmart()<UIScrollViewDelegate, IGeneralFullScreenSlideShow, IGeneralSingleSlideShow>
{
    NSMutableArray* iCellList;
    int iR;
    int iG;
    int iB;
    GeneralSingleSlideShow* iSingleSlideShow;
    NSMutableArray* iNameList;
}
@property(nonatomic, weak)IBOutlet UIScrollView* uiArchiSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiSmartSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiGreenSclView;
@end

//35 1236 Gap 400.333
@implementation VlgSmart
@synthesize uiArchiSclView, uiGreenSclView, uiSmartSclView;
+(id)VlgSmart
{
    VlgSmart *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgSmart" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgSmart class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    self.uiArchiSclView.contentSize = CGSizeMake(308, 1807);
    self.uiArchiSclView.delegate = self;
    
    self.uiSmartSclView.contentSize = CGSizeMake(308, 2013);
    self.uiSmartSclView.delegate = self;
    
    self.uiGreenSclView.contentSize = CGSizeMake(308, 1658);
    self.uiGreenSclView.delegate = self;
    iR = 0;
    iG = 137;
    iB = 98;
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}
-(void)onSlideShowDismiss:(id)theslideshow
{
    
}
-(void)onSingleSlideShowClose
{
    [iSingleSlideShow dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeScrollBarColorFor:(UIScrollView *)scrollView
{
    for ( UIView *view in scrollView.subviews ) {
        
        if (view.tag == 0 && [view isKindOfClass:UIImageView.class])
        {
            UIImageView *imageView = (UIImageView *)view;
            imageView.backgroundColor = [UIColor colorWithRed:iR green:iG/255.0 blue:iB/255.0 alpha:1];
        }
    }
}
//vlg_arch_smart_topbar_architect.png   
#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeScrollBarColorFor:scrollView];
}

#pragma mark - Action
-(IBAction)onTrack2FirstHit:(id)sender
{
    UIImage* image = [UIImage imageNamed:@"vlg_02_02_green_zoom01.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl setZoomEnable:NO];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl turnWhiteCross];
}
-(IBAction)onTrack2SecondHit:(id)sender
{
    UIImage* image = [UIImage imageNamed:@"vlg_02_02_green_zoom02.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl setZoomEnable:NO];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl turnGreenCross];
}
-(IBAction)onTrack3FirstHit:(id)sender
{
    UIImage* image = [UIImage imageNamed:@"vlg_02_03_green_zoom01.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl setZoomEnable:NO];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl turnGreenCross];
}
-(IBAction)onTrack3SecondHit:(id)sender
{
    UIImage* image = [UIImage imageNamed:@"vlg_02_03_green_zoom02.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl setZoomEnable:NO];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl turnWhiteCross];
}
@end
