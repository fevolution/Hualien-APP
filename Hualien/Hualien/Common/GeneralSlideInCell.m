//
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "GeneralSlideInCell.h"
#import "UIImage+ImageFile.h"

#import "UIImageSrcMng.h"
#define CORNER_BTN_W 16
#define CORNER_BTN_H 9
#define CORNER_BTN_MARGIN 9

#define DES_WIDTH 400.0
#define DES_DOWN_DURATION 1
#define DES_DOWN_DELAY 1

#define MASK_DEFAULT_H 60

#define DOWN_BTN_BOTMARGIN 18
#define UP_BTN_BOTMARGIN 28
@interface GeneralSlideInCell()
{
    __weak id<IGeneralSlideInCell> iDelegate;
    BOOL iInit;
    CGRect iFixRect;
    int iDesOffsetY;
}
@property(nonatomic, weak)IBOutlet UIImageView* uiBgImgView;
@property(nonatomic, weak)IBOutlet UIImageView* uiCapImgView;
@property(nonatomic, weak)IBOutlet UIImageView* uiDesImgView;
@property(nonatomic, strong) UIButton* uiUpBtn;
@property(nonatomic, strong) UIButton* uiDownBtn;
@property(nonatomic, copy)NSString* iBgFileName;
@property(nonatomic, copy)NSString* iDepFileName;
@end

@implementation GeneralSlideInCell
@synthesize uiUpBtn, uiDownBtn;
-(id)initWithDesFile:(NSString*)des Bg:(NSString*)bg Delegate:(id<IGeneralSlideInCell>)del FixRect:(CGRect)fixrect DesY:(int)offsetY
{
    if(self=[super init])
    {
        iDelegate = del;
        if (des)
        {
            self.iDepFileName = des;
        }
        if (bg)
        {
            self.iBgFileName = bg;
        }
        self->iDesOffsetY = offsetY;
        self->iFixRect = fixrect;
    }
    return self;
}
-(void)loadBsImg
{
    if (self.uiBgImgView.image==nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            @autoreleasepool {
                UIImage* uiBsImg = [UIImage imageNamed:self.iBgFileName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.uiBgImgView setImage:uiBsImg];
                    self.uiBgImgView.frame = self->iFixRect;
                });
            }
        });
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.iBgFileName)
    {
   
#ifdef IMGLOAD_USE_MAINTHREAD
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
        //UIImage* uiBsImg =  [[UIImageSrcMng sharedManager] requestImage:self.iBgFileName];
        //NSString *fileName = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@", self.iBgFileName]];
        //UIImage  *uiBsImg    = [UIImage imageWithContentsOfFile:fileName];
        UIImage* uiBsImg = [UIImage imageNamed:self.iBgFileName];
        [self.uiBgImgView setImage:uiBsImg];
        self.uiBgImgView.frame = self->iFixRect;
            uiBsImg = nil;
        });
        */
#else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            @autoreleasepool {
                //UIImage* uiBsImg = [UIImage imageNamed:self.iBgFileName];
                UIImage* uiBsImg =  [[UIImageSrcMng sharedManager] requestImage:self.iBgFileName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.uiBgImgView setImage:uiBsImg];
                    self.uiBgImgView.frame = self->iFixRect;
                });
            }
        });
#endif
         
    }
    
    if (self.iDepFileName)
    {
#ifdef IMGLOAD_USE_MAINTHREAD
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint imgorg = self.uiDesImgView.frame.origin;
            
            //Des Image
            UIImage* desimg = [UIImage imageNamed:self.iDepFileName];
            
            //Cap Image
            NSString* theCapFileName = [[[self.iDepFileName lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"_cap.png"];
            UIImage* capimg = [UIImage imageNamed:theCapFileName];
     
                self.uiDesImgView.contentMode = UIViewContentModeScaleAspectFit;
                self.uiDesImgView.frame = CGRectMake(imgorg.x, self->iDesOffsetY, desimg.size.width, desimg.size.height);
                [self.uiDesImgView setImage:desimg];
                
                self.uiCapImgView.contentMode = UIViewContentModeScaleAspectFit;
                self.uiCapImgView.frame = CGRectMake(imgorg.x, self->iDesOffsetY, capimg.size.width, capimg.size.height);
                [self.uiCapImgView setImage:capimg];
                
                // Mask animation
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathAddRect(path, NULL, CGRectMake(0, -self.uiDesImgView.frame.size.height+MASK_DEFAULT_H,
                                                     self.uiCapImgView.frame.size.width, self.uiDesImgView.frame.size.height));
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                [shapeLayer setPath:path];
                [shapeLayer setFrame:self.uiCapImgView.bounds];
                CGPathRelease(path);
                [[self.uiDesImgView layer] setMask:shapeLayer];
                
                UIImage *downimg = [UIImage imageNamed:@"slimarrow_down.png"];
                uiDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                       self->iDesOffsetY+capimg.size.height-DOWN_BTN_BOTMARGIN,
                                                                       CORNER_BTN_W,
                                                                       CORNER_BTN_H)];
                uiDownBtn.userInteractionEnabled = NO;
                [uiDownBtn setImage:downimg forState:UIControlStateNormal];
                [self.view addSubview:uiDownBtn];
                
                
                UIImage *upimg = [UIImage imageNamed:@"slimarrow_up.png"];
                uiUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                     self->iDesOffsetY+self.uiDesImgView.frame.size.height-UP_BTN_BOTMARGIN,
                                                                     CORNER_BTN_W,
                                                                     CORNER_BTN_H)];
                uiUpBtn.userInteractionEnabled = NO;
                [uiUpBtn setImage:upimg forState:UIControlStateNormal];
                [self.view addSubview:uiUpBtn];
                
                uiUpBtn.hidden = YES;
                self.uiDesImgView.hidden = YES;
                
                downimg = nil;
                upimg = nil;
        });
#else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            CGPoint imgorg = self.uiDesImgView.frame.origin;
            
            //Des Image
            UIImage* desimg = [UIImage imageNamed:self.iDepFileName];
            
            //Cap Image
            NSString* theCapFileName = [[[self.iDepFileName lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"_cap.png"];
            UIImage* capimg = [UIImage imageNamed:theCapFileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uiDesImgView.contentMode = UIViewContentModeScaleAspectFit;
                self.uiDesImgView.frame = CGRectMake(imgorg.x, self->iDesOffsetY, desimg.size.width, desimg.size.height);
                [self.uiDesImgView setImage:desimg];
                
                self.uiCapImgView.contentMode = UIViewContentModeScaleAspectFit;
                self.uiCapImgView.frame = CGRectMake(imgorg.x, self->iDesOffsetY, capimg.size.width, capimg.size.height);
                [self.uiCapImgView setImage:capimg];
                
                // Mask animation
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathAddRect(path, NULL, CGRectMake(0, -self.uiDesImgView.frame.size.height+MASK_DEFAULT_H,
                                                     self.uiCapImgView.frame.size.width, self.uiDesImgView.frame.size.height));
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                [shapeLayer setPath:path];
                [shapeLayer setFrame:self.uiCapImgView.bounds];
                CGPathRelease(path);
                [[self.uiDesImgView layer] setMask:shapeLayer];
                
                UIImage *downimg = [UIImage imageNamed:@"slimarrow_down.png"];
                uiDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                       self->iDesOffsetY+capimg.size.height-DOWN_BTN_BOTMARGIN,
                                                                       CORNER_BTN_W,
                                                                       CORNER_BTN_H)];
                uiDownBtn.userInteractionEnabled = NO;
                [uiDownBtn setImage:downimg forState:UIControlStateNormal];
                [self.view addSubview:uiDownBtn];
                
                
                UIImage *upimg = [UIImage imageNamed:@"slimarrow_up.png"];
                uiUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                     self->iDesOffsetY+self.uiDesImgView.frame.size.height-UP_BTN_BOTMARGIN,
                                                                     CORNER_BTN_W,
                                                                     CORNER_BTN_H)];
                uiUpBtn.userInteractionEnabled = NO;
                [uiUpBtn setImage:upimg forState:UIControlStateNormal];
                [self.view addSubview:uiUpBtn];
                
                uiUpBtn.hidden = YES;
                self.uiDesImgView.hidden = YES;
                
                downimg = nil;
                upimg = nil;
                //desimg = nil;
                //capimg = nil;
            });
        });
#endif
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"remove view");
        NSLog(@"%@",self.iBgFileName);
        self.view = nil;
    }
}

-(void)turnDepOff
{
    //[self onUpClick:nil];
}
-(void)animationDesDown:(int)delay
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CATransform3D tr = CATransform3DIdentity;
    tr = CATransform3DTranslate(tr, 0, self.uiDesImgView.frame.size.height-MASK_DEFAULT_H, 0);
    scale.duration = DES_DOWN_DURATION;
    [scale setBeginTime:CACurrentMediaTime()+delay];
    scale.toValue = [NSValue valueWithCATransform3D:tr];
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    [self.uiDesImgView.layer.mask addAnimation:scale forKey:@"gotoPage1"];
}
-(void)showDesIfPossible
{
    if (self.uiDesImgView.hidden==YES)
    {
        uiDownBtn.hidden = YES;
        //uiUpBtn.hidden = NO;
        self.uiCapImgView.hidden = YES;
        self.uiDesImgView.hidden = NO;

        [self animationDesDown:DES_DOWN_DELAY];
    }
    if (self->iDelegate)
    {
        [self->iDelegate bcellOnShowDes:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    }
}
-(void)setDesY:(int)offsetY
{
    NSLog(@"%d", offsetY);
}
-(CGPoint)getDesImgOrg
{
    return self.uiDesImgView.frame.origin;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* d = [touches anyObject];
    CGPoint p = [d locationInView:self.view];
    CGRect prect = CGRectMake(p.x-20, p.y-20, 40, 40);
    CGRect downrect = self.uiCapImgView.frame;
    if (CGRectIntersectsRect(prect, downrect))
    {
        if (self.uiDesImgView.hidden==YES)
        {
            [self onDownClick:nil];
        }
    }
    CGRect uprect = CGRectMake(self.uiDesImgView.frame.origin.x, self.uiDesImgView.frame.origin.y+self.uiDesImgView.frame.size.height-30,
                               self.uiDesImgView.frame.size.width, 30);
    if (CGRectIntersectsRect(prect, uprect))
    {
        NSLog(@"up click");
        if (self.uiDesImgView.hidden==NO)
        {
            [self onUpClick:nil];
        }
    }
}

- (void)onDownClick:(id)sender
{
    uiDownBtn.hidden = YES;
    self.uiCapImgView.hidden = YES;
    self.uiDesImgView.hidden = NO;
    if (self->iDelegate)
    {
        NSLog(@"%f %f", self.view.frame.size.width, self.view.frame.size.height);
        [self->iDelegate bcellOnShowDes:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    }
    [self animationDesDown:0];
}

- (void)onUpClick:(id)sender
{
    uiDownBtn.hidden = NO;
    self.uiCapImgView.hidden = NO;
    self.uiDesImgView.hidden = YES;
    if (self->iDelegate)
    {
        [self->iDelegate bcellOnHideDes:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    }
}

- (IBAction)onNext:(id)sender
{
    [iDelegate bscellNext];
}

- (IBAction)onPrev:(id)sender
{
    [iDelegate bscellPrev];
}


-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}
@end