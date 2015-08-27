//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgBird.h"
#import "GeneralScaleZoomVCtrl.h"
@interface VlgBird()<UIScrollViewDelegate>
{

}

@end

//35 1236 Gap 400.333
@implementation VlgBird
+(id)VlgBird
{
    VlgBird *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgBird" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgBird class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    
    UIImage* image = [UIImage imageNamed:@"bird_01.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl setZoomEnable:NO];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl setBackgroundColor:[UIColor orangeColor] Opacity:0.5];
    [singleImgCtrl turnGreenCross];
  });
}

-(void)dealloc
{
    NSLog(@"%s", __func__);
}
@end
