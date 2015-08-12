//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//
#import "VlgService.h"
#import "GeneralFullScreenSlideShow.h"
#import "GeneralScaleZoomVCtrl.h"
#import "GeneralFullScreenSlideShow.h"
@interface VlgService()<UIScrollViewDelegate, IGeneralFullScreenSlideShow>
{
    NSMutableArray* iCellList;
    int iR;
    int iG;
    int iB;
    NSMutableArray* iNameList;
}
@property(nonatomic, weak)IBOutlet UIScrollView* uiArchiSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiSmartSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiGreenSclView;
@end

//35 1236 Gap 400.333
@implementation VlgService
+(id)VlgService
{
    VlgService *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgService" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgService class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    self.uiArchiSclView.contentSize = CGSizeMake(230, 1539);
    self.uiArchiSclView.delegate = self;
    
    self.uiSmartSclView.contentSize = CGSizeMake(230, 1684);
    self.uiSmartSclView.delegate = self;
    
    self.uiGreenSclView.contentSize = CGSizeMake(230, 1408);
    self.uiGreenSclView.delegate = self;
    iR = 0;
    iG = 137;
    iB = 98;
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
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

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeScrollBarColorFor:scrollView];
}

-(void)onSlideShowDismiss:(id)theslideshow
{

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
    [singleImgCtrl turnGreenCross];
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
    [singleImgCtrl turnWhiteCross];
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
