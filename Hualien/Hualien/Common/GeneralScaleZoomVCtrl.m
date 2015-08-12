//
//  GeneralScaleZoomVCtrl.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/22.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "GeneralScaleZoomVCtrl.h"
#import "SingleImageScrollView.h"

@interface GeneralScaleZoomVCtrl ()<UIScrollViewDelegate>
{
    BOOL iZoomEnable;
}
@property(nonatomic, weak)IBOutlet SingleImageScrollView* uiSclView;
@property(nonatomic, weak)IBOutlet UIButton* uiCross;
@end

@implementation GeneralScaleZoomVCtrl
-(id)initWithNibName:(NSString*)xibfile bundle:(NSBundle*)bundle Image:(UIImage*)image
{
    self = [super initWithNibName:xibfile bundle:bundle];
    if (self)
    {
        self.displayImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.displayImage)
    {
        self.uiSclView.image = self.displayImage;
        self.uiSclView.maximumZoomCoefficient = 10;
        self->iZoomEnable = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setZoomEnable:(BOOL)enable
{
    self.uiSclView.userInteractionEnabled = enable;
}
-(void)turnGreenCross
{
    UIImage* img = [UIImage imageNamed:@"common_cross_green.png"];
    [self.uiCross setImage:img forState:UIControlStateNormal];
}
-(void)turnWhiteCross
{
    UIImage* img = [UIImage imageNamed:@"common_cross_white.png"];
    [self.uiCross setImage:img forState:UIControlStateNormal];
}
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {

    CGRect zoomRect;

    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;

    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}

@end
