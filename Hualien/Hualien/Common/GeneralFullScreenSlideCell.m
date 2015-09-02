//
//  SpxLionSlide.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/9.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "GeneralFullScreenSlideCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageSrcMng.h"
#define DES_Y 30
#define DES_WIDTH 400.0
#define DELAY_HITTEST 0.2
#define DES_DOWN_DURATION 0.8
#define TOUCH_ENHANCEMENT_WH 45

#define CORNER_BTN_W 16
#define CORNER_BTN_H 9
#define CORNER_BTN_MARGIN 9

#define DOWN_BTN_BOTMARGIN 24
#define UP_BTN_BOTMARGIN 28

@interface GeneralFullScreenSlideCell()
{
    __weak id<IGeneralFullScreenSlideCell> iDelegate;
    BOOL iInit;
    BOOL iReadyToPlay;
    MPMoviePlayerController* iPlayer;
    NSString* videopath;
    double iHitTestDelay;
}
@property(nonatomic, weak)IBOutlet UIImageView* uiBgImgView;
@property(nonatomic, weak)IBOutlet UIImageView* uiCapImgView;
@property(nonatomic, weak)IBOutlet UIImageView* uiDesImgView;
@property(nonatomic, strong)IBOutlet UIButton* uiUpBtn;
@property(nonatomic, strong)IBOutlet UIButton* uiDownBtn;
@property(nonatomic, weak)IBOutlet UIActivityIndicatorView* uiActView;
@property(nonatomic, copy)NSString* iBgFileName;
@property(nonatomic, copy)NSString* iDepFileName;
@end

@implementation GeneralFullScreenSlideCell
@synthesize uiDownBtn, uiUpBtn;
-(NSString*)getBgName
{
  return self.iBgFileName;
}
-(id)initWithDesFile:(NSString*)des Bg:(NSString*)bg Delegate:(id<IGeneralFullScreenSlideCell>)del
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"GeneralFullScreenSlideCell" owner:nil options:nil] lastObject];
    if (self)
    {
        self->iDelegate = del;
        if (des)
        {
            self.iDepFileName = des;
        }
        if (bg)
        {
            self.iBgFileName = bg;
        }
    }
    return self;
}
-(void)dealloc
{
    if (iPlayer)
    {
        [iPlayer stop];
        iPlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)animationDesDown:(int)delay
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CATransform3D tr = CATransform3DIdentity;
    tr = CATransform3DTranslate(tr, 0, self.uiDesImgView.frame.size.height-self.uiCapImgView.frame.size.height, 0);
    scale.duration = DES_DOWN_DURATION;
    [scale setBeginTime:CACurrentMediaTime()+delay];
    scale.toValue = [NSValue valueWithCATransform3D:tr];
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    [self.uiDesImgView.layer.mask addAnimation:scale forKey:@"gotoPage1"];
}
-(void)didMoveToSuperview
{
    if (iInit==NO)
    {
        if (self.iBgFileName)
        {
#ifdef IMGLOAD_USE_MAINTHREAD
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage* uiBsImg = [UIImage imageNamed:self.iBgFileName];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.uiBgImgView setImage:uiBsImg];
              [self.uiActView stopAnimating];
              [iDelegate didLoadImage];
            });
          });
#else
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSString *myImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:self.iBgFileName];
                __block UIImage* img = [[UIImage alloc] initWithContentsOfFile:myImagePath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.uiBgImgView setImage:img];
                        [self.uiActView stopAnimating];
                        img = nil;
                        [UIView animateWithDuration:0.5 animations:^{
                            self.uiBgImgView.alpha = 1;
                        } completion:^(BOOL finished) {

                        }];
                    });
            });
#endif
        }
        if (self.iDepFileName)
        {

#ifdef IMGLOAD_USE_MAINTHREAD
            //Des Image
            UIImage* desimg = [UIImage imageNamed:self.iDepFileName];
            //Cap Image
            NSString* theCapFileName = [[[self.iDepFileName lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"_cap.png"];
            UIImage* capimg = [UIImage imageNamed:theCapFileName];
            CGPoint imgorg = self.uiDesImgView.frame.origin;
            self.uiDesImgView.contentMode = UIViewContentModeScaleAspectFit;
            self.uiDesImgView.frame = CGRectMake(imgorg.x, DES_Y, desimg.size.width, desimg.size.height);
            [self.uiDesImgView setImage:desimg];
            
            self.uiCapImgView.contentMode = UIViewContentModeScaleAspectFit;
            self.uiCapImgView.frame = CGRectMake(imgorg.x, DES_Y, capimg.size.width, capimg.size.height);
            [self.uiCapImgView setImage:capimg];
            
            // Mask animation
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, CGRectMake(0, -self.uiDesImgView.frame.size.height+self.uiCapImgView.frame.size.height,
                                                 self.uiCapImgView.frame.size.width, self.uiDesImgView.frame.size.height));
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            [shapeLayer setPath:path];
            [shapeLayer setFrame:self.uiCapImgView.bounds];
            [[self.uiDesImgView layer] setMask:shapeLayer];
            CGPathRelease(path);
            
            UIImage *downimg = [UIImage imageNamed:@"slimarrow_down.png"];
            uiDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                   DES_Y+capimg.size.height-DOWN_BTN_BOTMARGIN,
                                                                   CORNER_BTN_W,
                                                                   CORNER_BTN_H)];
            [uiDownBtn setImage:downimg forState:UIControlStateNormal];
            [uiDownBtn addTarget:self action:@selector(onDownClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:uiDownBtn];
            uiDownBtn.hidden = YES;
            
            UIImage *upimg = [UIImage imageNamed:@"slimarrow_up.png"];
            uiUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                 DES_Y+self.uiDesImgView.frame.size.height-UP_BTN_BOTMARGIN,
                                                                 CORNER_BTN_W,
                                                                 CORNER_BTN_H)];
            [uiUpBtn addTarget:self action:@selector(onUpClick:) forControlEvents:UIControlEventTouchUpInside];
            [uiUpBtn setImage:upimg forState:UIControlStateNormal];
            [self addSubview:uiUpBtn];
            uiUpBtn.hidden = YES;
            self.uiDesImgView.hidden = YES;
#else
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                //Des Image
                NSString *myImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:self.iDepFileName];
                UIImage* desimg = [[UIImage alloc] initWithContentsOfFile:myImagePath];
                //Cap Image
                NSString* theCapFileName = [[[self.iDepFileName lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"_cap.png"];
                NSString *myCapImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:theCapFileName];
                UIImage* capimg = [[UIImage alloc] initWithContentsOfFile:myCapImagePath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGPoint imgorg = self.uiDesImgView.frame.origin;
                    self.uiDesImgView.contentMode = UIViewContentModeScaleAspectFit;
                    self.uiDesImgView.frame = CGRectMake(imgorg.x, DES_Y, desimg.size.width, desimg.size.height);
                    [self.uiDesImgView setImage:desimg];
                    
                    self.uiCapImgView.contentMode = UIViewContentModeScaleAspectFit;
                    self.uiCapImgView.frame = CGRectMake(imgorg.x, DES_Y, capimg.size.width, capimg.size.height);
                    [self.uiCapImgView setImage:capimg];
                    
                    // Mask animation
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathAddRect(path, NULL, CGRectMake(0, -self.uiDesImgView.frame.size.height+self.uiCapImgView.frame.size.height,
                                                         self.uiCapImgView.frame.size.width, self.uiDesImgView.frame.size.height));
                    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                    [shapeLayer setPath:path];
                    [shapeLayer setFrame:self.uiCapImgView.bounds];
                    [[self.uiDesImgView layer] setMask:shapeLayer];
                    CGPathRelease(path);
                    
                    UIImage *downimg = [UIImage imageNamed:@"slimarrow_down.png"];
                    uiDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                           DES_Y+capimg.size.height-DOWN_BTN_BOTMARGIN,
                                                                           CORNER_BTN_W,
                                                                           CORNER_BTN_H)];
                    [uiDownBtn setImage:downimg forState:UIControlStateNormal];
                    [uiDownBtn addTarget:self action:@selector(onDownClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:uiDownBtn];
                    uiDownBtn.hidden = YES;
                    
                    UIImage *upimg = [UIImage imageNamed:@"slimarrow_up.png"];
                    uiUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+20,
                                                                         DES_Y+self.uiDesImgView.frame.size.height-UP_BTN_BOTMARGIN,
                                                                         CORNER_BTN_W,
                                                                         CORNER_BTN_H)];
                    [uiUpBtn addTarget:self action:@selector(onUpClick:) forControlEvents:UIControlEventTouchUpInside];
                    [uiUpBtn setImage:upimg forState:UIControlStateNormal];
                    [self addSubview:uiUpBtn];
                    uiUpBtn.hidden = YES;
                    self.uiDesImgView.hidden = YES;
                });
            });
#endif

        }
        iInit = YES;
    }else
    {
   
    }
    
}
- (void)onDownClick:(id)sender
{
    uiDownBtn.hidden = YES;
    self.uiCapImgView.hidden = YES;
    self.uiDesImgView.hidden = NO;
    
    if (self->iDelegate)
    {
        [self->iDelegate bcellOnShowDes];
    }
    [self animationDesDown:0.1];
}

- (void)onUpClick:(id)sender
{
    uiDownBtn.hidden = NO;
    self.uiCapImgView.hidden = NO;
    self.uiDesImgView.hidden = YES;

    if (self->iDelegate)
    {
        [self->iDelegate bcellOnHideDes];
    }
}
-(void)turnDepOn
{
    if (self.uiDesImgView.hidden==YES)
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self onDownClick:nil];
        });
    }
    [self touchesBegan:nil withEvent:nil];
    [self->iDelegate bcellOnShowDes];
}
-(void)loadImg
{
    if (self.uiBgImgView.image==nil)
    {
        NSLog(@"loading...");
#ifdef IMGLOAD_USE_MAINTHREAD
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage* img = [UIImage imageNamed:self.iBgFileName];
//            [self.uiBgImgView setImage:img];
//            [self.uiActView stopAnimating];
//        });        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            @autoreleasepool {
                UIImage* uiBsImg = [UIImage imageNamed:self.iBgFileName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.uiBgImgView setImage:uiBsImg];
                    [self.uiActView stopAnimating];
                });
            }
        });
#else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString *myImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:self.iBgFileName];
            __block UIImage* img = [[UIImage alloc] initWithContentsOfFile:myImagePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.uiBgImgView setImage:img];
                [self.uiActView stopAnimating];
                img = nil;
                [UIView animateWithDuration:0.5 animations:^{
                    self.uiBgImgView.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            });
        });
#endif
        
    }
}
-(void)turnDepOff
{
    [self->iDelegate bcellOnHideDes];
}
-(BOOL)isDesWindowOverlay:(CGRect)rect
{
    CGRect expand = CGRectMake(self.uiDesImgView.frame.origin.x,
                               self.uiDesImgView.frame.origin.y,
                               self.uiDesImgView.frame.size.width,
                               self.uiDesImgView.frame.size.height+25);
    return CGRectIntersectsRect(expand, rect);
}

#pragma mark - Touch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* d = [touches anyObject];
    CGPoint p = [d locationInView:self];
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
        if (self.uiDesImgView.hidden==NO)
        {
            [self onUpClick:nil];
        }
    }
}

#pragma mark - VideoPlayer Delegate
-(void)moviePlayerLoadStateChanged:(NSNotification*)notif
{
    /*
    if( MPMoviePlaybackStateStopped == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateStopped");
    }
    if (MPMoviePlaybackStatePlaying == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStatePlaying");
    }
    if (MPMoviePlaybackStatePaused == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStatePaused");
    }
    if (MPMoviePlaybackStateInterrupted == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateInterrupted");
    }
    if (MPMoviePlaybackStateSeekingForward == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateSeekingForward");
    }
    if (MPMoviePlaybackStateSeekingBackward == iPlayer.playbackState )
    {
        NSLog(@"MPMoviePlaybackStateSeekingBackward");
    }
    */
    if((iPlayer.loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
    {
        //if load state is ready to play
        iReadyToPlay = YES;
    }
}
- (void)setupVideoPlayer:(NSString*)videofile
{
    if (iPlayer==nil)
    {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:videofile ofType:@"mov" inDirectory:nil];
        videopath = [filePath copy];
        iPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
        iPlayer.movieSourceType = MPMovieSourceTypeFile;
        iPlayer.view.frame = self.bounds;
        [iPlayer setScalingMode:MPMovieScalingModeAspectFill];
        iPlayer.controlStyle = MPMovieControlStyleEmbedded;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

        [self insertSubview:iPlayer.view belowSubview:self.uiBgImgView];
        [iPlayer prepareToPlay];
        iPlayer.shouldAutoplay = NO;
    }else
    {
        [iPlayer prepareToPlay];
    }
}
-(void)stopVideo
{
    if (iPlayer)
    {
        [iPlayer pause];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((CACurrentMediaTime()-iHitTestDelay)>=DELAY_HITTEST)
    {
        if (iPlayer&&iReadyToPlay)
        {
            [self bringSubviewToFront:iPlayer.view];
            [iPlayer play];
            iHitTestDelay = CACurrentMediaTime();
        }
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    CGRect prect = CGRectMake(p.x-TOUCH_ENHANCEMENT_WH/2, p.y-TOUCH_ENHANCEMENT_WH/2, TOUCH_ENHANCEMENT_WH, TOUCH_ENHANCEMENT_WH);
    if ( self.uiDesImgView.hidden==NO && CGRectIntersectsRect(prect, uiUpBtn.frame) )
    {
        [self onUpClick:nil];
    }
    else if ( self.uiCapImgView.hidden==NO && CGRectIntersectsRect(prect, uiDownBtn.frame))
    {
        [self onDownClick:nil];
    }
}
@end
