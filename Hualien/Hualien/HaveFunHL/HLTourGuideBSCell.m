//
//  HLTourGuideBSCell.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HLTourGuideBSCell.h"
#import "UIImage+Dealloc.h"
#define CORNER_BTN_WH 32
#define CORNER_BTN_MARGIN 9
#define DES_WIDTH 400.0
@interface HLTourGuideBSCell()
{
    BOOL iInit;
    UIButton* iGreenBtn;
    UIButton* iWhiteBtn;
    CGRect iFixRect;
    __weak id<IHLTourGuideBSCell> iDelegate;
}
@property(nonatomic, weak)IBOutlet UIImageView* uiBgImgView;
@property(nonatomic, weak)IBOutlet UIImageView* uiDesImgView;
@property(nonatomic, weak)IBOutlet UIButton* uiPreBtn;
@property(nonatomic, weak)IBOutlet UIButton* uiNxtBtn;
@property(nonatomic, strong)IBOutlet UIImage* uiBsImg;
@property(nonatomic, copy)NSString* iBgFileName;
@property(nonatomic, copy)NSString* iDepFileName;
@end

@implementation HLTourGuideBSCell

-(id)initWithDesFile:(NSString*)des Bg:(NSString*)bg Delegate:(id<IHLTourGuideBSCell>)del FixRect:(CGRect)fixrect
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HLTourGuideBSCell" owner:self options:nil] lastObject];
    if (self)
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
        self->iFixRect = fixrect;
    }
    return self;
}

-(void)didMoveToSuperview
{
    if (iInit==NO)
    {
        if (self.iBgFileName)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.uiBsImg =  [UIImage imageNamed:self.iBgFileName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.uiBgImgView setImage:self.uiBsImg];
                    self.uiBgImgView.frame = self->iFixRect;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.uiBgImgView.alpha = 1;
                    }];
                });
            });
        }
        if (self.iDepFileName)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString* theFileName = [[self.iDepFileName lastPathComponent] stringByDeletingPathExtension];
                NSLog(@"%@", theFileName);
                UIImage* img = [UIImage imageNamed:self.iDepFileName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGSize size = img.size;
                    CGPoint imgorg = self.uiDesImgView.frame.origin;
                    float ratio = DES_WIDTH/size.width;
                    self.uiDesImgView.contentMode = UIViewContentModeScaleAspectFit;
                    self.uiDesImgView.frame = CGRectMake(imgorg.x, imgorg.y, DES_WIDTH, ratio*size.height);
                    [self.uiDesImgView setImage:img];
                    UIImage *whiteimg = [UIImage imageNamed:@"hl_tg_des_white_corner.png"];
                    iWhiteBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x, imgorg.y, CORNER_BTN_WH, CORNER_BTN_WH)];
                    [iWhiteBtn setImage:whiteimg forState:UIControlStateNormal];
                    [iWhiteBtn addTarget:self action:@selector(onWhiteCorner:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:iWhiteBtn];
                    UIImage *greenimg = [UIImage imageNamed:@"hl_tg_des_green_corner.png"];
                    iGreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgorg.x+self.uiDesImgView.frame.size.width-CORNER_BTN_WH,
                                                                                    imgorg.y+self.uiDesImgView.frame.size.height-CORNER_BTN_WH,
                                                                                    CORNER_BTN_WH, CORNER_BTN_WH)];
                    [iGreenBtn addTarget:self action:@selector(onGreenCorner:) forControlEvents:UIControlEventTouchUpInside];
                    [iGreenBtn setImage:greenimg forState:UIControlStateNormal];
                    [self addSubview:iGreenBtn];

                    iGreenBtn.hidden = YES;
                    self.uiDesImgView.hidden = YES;
                });
            });
        }
        iInit = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* d = [touches anyObject];
    CGPoint p = [d locationInView:self];
    NSLog(@"%f", p.x);
}
-(void)turnDepOff
{
    [self onGreenCorner:nil];
}

- (void)onWhiteCorner:(id)sender
{
    iGreenBtn.hidden = NO;
    iWhiteBtn.hidden = YES;
    self.uiDesImgView.hidden = NO;
}

- (void)onGreenCorner:(id)sender
{
    iGreenBtn.hidden = YES;
    iWhiteBtn.hidden = NO;
    self.uiDesImgView.hidden = YES;
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
