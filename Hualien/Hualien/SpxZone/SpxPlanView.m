//
//  PlanView.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/7.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "SpxPlanView.h"
#import "SpxLifeVlg.h"
#import "ISpxHome.h"
#import "SpxNewDu.h"
#import "SpxLifeVlg.h"
#import "SpxCulcreate.h"
#import "SpxGreenTie.h"

#define MASK_DEFAULT_H 75
#define BOT_HIT_H 50
#define DES_SLIDE_DURATION 0.6
@interface SpxPlanView()<ISpxHome>
{
    NSArray* iLineList;
    NSArray* iDotList;
    NSArray* iCircleList;
    NSArray* iRbNameList;
    NSArray* iBtnList;
    NSArray* iClassNameList;
    UIImage* iGreenImg;
    UIImage* iOrangeImg;
    UIView* iActiveView;
}

@property(nonatomic, weak)IBOutlet UIButton* uiGreenDownBtn;
@property(nonatomic, weak)IBOutlet UIButton* uiGreenUpBtn;
@property(nonatomic, weak)IBOutlet UIImageView* uiDesBody;
@property(nonatomic, weak)IBOutlet UIImageView* uiDesCap;

//Btn Line Dot
@property(nonatomic, weak)IBOutlet UIButton* uiLifeBtn;
@property(nonatomic, weak)IBOutlet UIImageView* uiLifeDot;
@property(nonatomic, weak)IBOutlet UIImageView* uiLifeCircle;
@property(nonatomic, weak)IBOutlet UIView* uiLifeLine;

@property(nonatomic, weak)IBOutlet UIButton* uiNewDuBtn;
@property(nonatomic, weak)IBOutlet UIImageView* uiNewDuDot;
@property(nonatomic, weak)IBOutlet UIImageView* uiNewDuCircle;
@property(nonatomic, weak)IBOutlet UIView* uiNewDuLine;

@property(nonatomic, weak)IBOutlet UIButton* uiCulceateBtn;
@property(nonatomic, weak)IBOutlet UIImageView* uiCulcreateDot;
@property(nonatomic, weak)IBOutlet UIImageView* uiCulcreateCircle;
@property(nonatomic, weak)IBOutlet UIView* uiCulcreateLine;

@property(nonatomic, weak)IBOutlet UIButton* uiGreenTieBtn;
@property(nonatomic, weak)IBOutlet UIImageView* uiGreenTieDot;
@property(nonatomic, weak)IBOutlet UIImageView* uiGreenTieCircle;
@property(nonatomic, weak)IBOutlet UIView* uiGreenTieLine;

@property(nonatomic, weak)IBOutlet UIButton* uiLionBtn;
@property(nonatomic, weak)IBOutlet UIImageView* uiLionDot;
@property(nonatomic, weak)IBOutlet UIImageView* uiLionCircle;
@property(nonatomic, weak)IBOutlet UIView* uiLionLine;
@end

@implementation SpxPlanView
+(id)SpxPlanView
{
    SpxPlanView *instance = [[[NSBundle mainBundle] loadNibNamed:@"SpxPlanView" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[SpxPlanView class]] )
    {
        return instance;
    }
    else
        return nil;
}
-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

-(void)awakeFromNib
{
    iLineList = [[NSArray alloc] initWithObjects:self.uiNewDuLine, self.uiCulcreateLine, self.uiGreenTieLine, self.uiLifeLine, self.uiLionLine, nil];
    iDotList = [[NSArray alloc] initWithObjects:self.uiNewDuDot, self.uiCulcreateDot, self.uiGreenTieDot, self.uiLifeDot, self.uiLionDot, nil];
    iCircleList = [[NSArray alloc] initWithObjects:self.uiNewDuCircle, self.uiCulcreateCircle, self.uiGreenTieCircle, self.uiLifeCircle, self.uiLionCircle, nil];
    iRbNameList = [[NSArray alloc] initWithObjects:
                   @"spx_plan_map_rb_newdu",
                   @"spx_plan_map_rb_culcreate",
                   @"spx_plan_map_rb_greentie",
                   @"spx_plan_map_rb_life",
                   @"spx_plan_map_rb_lion", nil];
    iBtnList = [[NSArray alloc] initWithObjects:self.uiNewDuBtn, self.uiCulceateBtn, self.uiGreenTieBtn, self.uiLifeBtn, self.uiLionBtn, nil];
    iGreenImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green_dot" ofType:@"png"]];
    iOrangeImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orange_dot" ofType:@"png"]];
    
    // Mask animation
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, -self.uiDesBody.frame.size.height+MASK_DEFAULT_H, self.uiDesBody.frame.size.width, self.uiDesBody.frame.size.height));
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath:path];
    [shapeLayer setFrame:self.uiDesCap.bounds];
    CGPathRelease(path);
    [[self.uiDesBody layer] setMask:shapeLayer];
    self.uiDesCap.hidden = NO;
    self.uiDesBody.hidden = YES;
    
    [self onDes:nil];
}

-(IBAction)onDes:(id)sender
{
    [self animationDesDown:0];
    self.uiDesCap.hidden = YES;
    self.uiDesBody.hidden = NO;
    self.uiGreenDownBtn.hidden = YES;
}

-(IBAction)onDesWrap:(id)sender
{
    self.uiDesCap.hidden = NO;
    self.uiDesBody.hidden = YES;
    self.uiGreenDownBtn.hidden = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    CGRect trect = CGRectMake(p.x-20, p.y-20, 40, 40);
    if (self.uiDesBody.hidden == NO)
    {
        CGRect bot = CGRectMake(self.uiDesBody.frame.origin.x, self.uiDesBody.frame.origin.y+self.uiDesBody.frame.size.height-BOT_HIT_H, self.uiDesBody.frame.size.width, BOT_HIT_H);
        if (CGRectIntersectsRect(trect, bot))
        {
            [self onDesWrap:nil];
        }
    }else
    {

    }
}

-(void)animationDesDown:(int)delay
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CATransform3D tr = CATransform3DIdentity;
    tr = CATransform3DTranslate(tr, 0, self.uiDesBody.frame.size.height-MASK_DEFAULT_H, 0);
    scale.duration = DES_SLIDE_DURATION;
    [scale setBeginTime:CACurrentMediaTime()+delay];
    scale.toValue = [NSValue valueWithCATransform3D:tr];
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    [self.uiDesBody.layer.mask addAnimation:scale forKey:@"gotoPage1"];
}

-(void)turnOffAllBtnSelected
{
    for (int i =0; i < [iBtnList count]; i++)
    {
        UIButton* btn = [iBtnList objectAtIndex:i];
        btn.selected = NO;

        UIView* line = [iLineList objectAtIndex:i];
        line.backgroundColor = [UIColor colorWithRed:0 green:196/255.0 blue:150/255.0 alpha:1];

        UIImageView* circle = [iCircleList objectAtIndex:i];
        [circle setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[iRbNameList objectAtIndex:i]]]];

        UIImageView* view = [iDotList objectAtIndex:i];
        [view setImage:iGreenImg];
    }
}
-(void)switchToViewByTag:(long)tag
{

}
-(IBAction)onBtnClickUp:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    long tag = btn.tag;
    btn.selected = YES;

    UIView<ISpxView>* instance = nil;
    if(tag==0)
    {
        instance = [SpxNewDu SpxNewDu];
    }else if (tag==1)
    {
        instance = [SpxCulcreate SpxCulcreate];
    }else if (tag==2)
    {
        instance = [SpxGreenTie SpxGreenTie];
    }else if (tag==3)
    {
        instance = [SpxLifeVlg SpxLifeVlg];
    }
    
    if (instance)
    {
        [instance setDelegate:self];
        iActiveView = instance;
        [self addSubview:iActiveView];
    }
}
-(IBAction)onBtnClickDown:(id)sender
{
    NSLog(@"down");
    [self turnOffAllBtnSelected];
    UIButton* btn = (UIButton*)sender;
    btn.highlighted = YES;
    long tag = btn.tag;

    UIView* line = [iLineList objectAtIndex:tag];
    line.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:91/255.0 alpha:1];
    UIImageView* view = [iDotList objectAtIndex:tag];
    [view setImage:iOrangeImg];
    UIImageView* circle = [iCircleList objectAtIndex:tag];
    [circle setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlit.png",[iRbNameList objectAtIndex:tag]]]];
}
-(IBAction)onBtnDragOutside:(id)sender
{
    NSLog(@"outside");
    [self turnOffAllBtnSelected];
}
-(void)gotoMap
{
    if (iActiveView)
    {
        [iActiveView removeFromSuperview];
        iActiveView = nil;
        [self turnOffAllBtnSelected];
    }
}
#pragma mark - ISpxHome
-(void)spxGoPlanHome
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (iActiveView)
    {
        [iActiveView removeFromSuperview];
        iActiveView = nil;
    }
    [self turnOffAllBtnSelected];
  });
}
@end
