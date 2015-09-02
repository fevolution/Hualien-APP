//
//  SpxLionSlideShow.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/9.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "GeneralFullScreenSlideShow.h"
#import "GeneralFullScreenSlideCell.h"

//#define CELL_NUM 10
#define CELL_MOVEIN_DURATION 0.5
#define TAP_DELAY_TO_FADEOUT 3
typedef enum
{
  NONE,
  RIGHT,
  LEFT
}DIR;

@interface GeneralFullScreenSlideShow()<IGeneralFullScreenSlideCell>
{
  NSMutableDictionary* iVideoFeatureList;
  __weak GeneralFullScreenSlideCell* iActiveCell;
  BOOL *iCreateList;
  BOOL iAutoRun;
  __weak id<IGeneralFullScreenSlideShow> delegate;
  int iLoadCellImgCount;
  int iIndex;
  int iPreIndex;
  long MIN_XX;
  long MAX_XX;
  double iTapTimeOut;
  NSTimer* iAutoTimer;
}
@property(nonatomic, strong)NSMutableArray* iCellList;
@property(nonatomic, strong)NSMutableArray* iBgNameList;
@property(nonatomic, strong)NSMutableArray* iDesNameList;
@property(nonatomic, weak)IBOutlet UIButton* uiCross;
@property(nonatomic, weak)IBOutlet UIButton* uiLeftArrow;
@property(nonatomic, weak)IBOutlet UIButton* uiRightArrow;
@property(nonatomic, weak)IBOutlet UIActivityIndicatorView* uiSpinner;
@property(nonatomic, strong)UISwipeGestureRecognizer* iSwipegs_left;
@property(nonatomic, strong)UISwipeGestureRecognizer* iSwipegs_right;
@end

@implementation GeneralFullScreenSlideShow
@synthesize iCellList, iSwipegs_right, iSwipegs_left, uiSpinner;
-(id)initWithNibName:(NSString*)xibfile bundle:(NSBundle*)bundle NameList:(NSMutableArray*)namelist DesList:(NSMutableArray*)deslist
{
  self = [super initWithNibName:xibfile bundle:bundle];
  if (self)
  {
    self.iBgNameList = namelist;
    self.iDesNameList = deslist;
  }
  return self;
}
-(void)dealloc
{
  NSLog(@"@@@@@ %s",__func__);
}
-(void)hideAllFunctionUI
{
  [UIView animateWithDuration:0.5 animations:^()
   {
     self.uiLeftArrow.alpha  = 0;
     self.uiRightArrow.alpha = 0;
   }];
}
-(void)showAllFunctionUI
{
  [UIView animateWithDuration:0.5 animations:^()
   {
     self.uiLeftArrow.alpha  = 1;
     self.uiRightArrow.alpha = 1;
   }];
}
- (void)onSceneSclSwipe: (UISwipeGestureRecognizer *)sender
{
  if (sender.direction & UISwipeGestureRecognizerDirectionRight)
  {
    [self onLeft:nil];
  }
  if(sender.direction & UISwipeGestureRecognizerDirectionLeft)
  {
    [self onRight:nil];
  }
}
-(void)viewDidLoad
{
  [super viewDidLoad];
  if ([self.iBgNameList count]==1)
  {
    self.uiRightArrow.frame = CGRectMake(-1000, 0, 0, 0);
    self.uiLeftArrow.frame = CGRectMake(-1000, 0, 0, 0);
  }
  else
  {
    // Gesture
    {
      iSwipegs_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
      iSwipegs_right.direction = UISwipeGestureRecognizerDirectionRight;
      [self.view addGestureRecognizer:iSwipegs_right];
    }
    {
      iSwipegs_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
      iSwipegs_left.direction = UISwipeGestureRecognizerDirectionLeft;
      [self.view addGestureRecognizer:iSwipegs_left];
    }
  }
  
}
-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  iPreIndex = -1;
  int w = self.view.frame.size.width;
  MIN_XX = -1*([self.iBgNameList count]-1)*w;
  MAX_XX =    ([self.iBgNameList count]-1)*w;
  [self resetBreathing];
}
-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self cancelBreathing];
  if (iActiveCell)
  {
    [iActiveCell removeFromSuperview];
    iActiveCell = nil;
  }
  if (iCreateList)
  {
    free(iCreateList);
    iCreateList = nil;
  }
}
-(void)resetBreathing
{
  for (CALayer* layer in [self.view.layer sublayers]) {
    [layer removeAllAnimations];
  }
  
  [UIView animateWithDuration:1.3 delay:1 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^()
   {
     self.uiLeftArrow.alpha = 1;
     self.uiRightArrow.alpha = 1;
   } completion:^(BOOL finished) {
     
   }];
}
-(void)cancelBreathing
{
  for (CALayer* layer in [self.view.layer sublayers]) {
    [layer removeAllAnimations];
  }
  self.uiLeftArrow.alpha = 0;
  self.uiRightArrow.alpha = 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self showAllFunctionUI];
  iTapTimeOut =  CACurrentMediaTime();
}
-(void)onTap:(UIGestureRecognizer*)tap
{
  
}
-(void)setDelegate:(id<IGeneralFullScreenSlideShow>)adelegate
{
  delegate = adelegate;
}
-(void)movePreCellOut
{
  if (iActiveCell)
  {
    [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
     {
       iActiveCell.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
     } completion:nil];
  }
}
-(void)trimIndex:(int*)aIndex
{
  if (*aIndex<0)
  {
    *aIndex = (int)[self.iBgNameList count]-1;
  }else if (*aIndex>=[self.iBgNameList count])
  {
    *aIndex = 0;
  }
}
-(void)moveOtherCellByActiveIndex:(int)index
{
  for (int i = 0; i < [iCellList count]; i++)
  {
    GeneralFullScreenSlideCell* cell = [iCellList objectAtIndex:i]; //[iCellList objectForKey:[NSString stringWithFormat:@"%d", i]];
    [cell stopVideo];
    if (cell)
    {
      [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
       {
         cell.frame = CGRectMake((i-index)*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
       }completion:nil];
    }
  }
}

-(void)createCellByIndex:(int)index
{
  iIndex = index;
  
  //Lazy init
  if (iCellList == nil)
  {
    iCellList = [[NSMutableArray alloc] init];
    iCreateList = malloc(sizeof(BOOL)*[self.iBgNameList count]);
    for (int i =0; i<[self.iBgNameList count]; i++)
    {
      iCreateList[i] = NO;
    }
  }
  
  // Create primary cell
  GeneralFullScreenSlideCell* cell = [[GeneralFullScreenSlideCell alloc] initWithDesFile:[self.iDesNameList objectAtIndex:index] Bg:[self.iBgNameList objectAtIndex:index] Delegate:self];
  [self.view addSubview:cell];
  [cell turnDepOn];
  [iCellList addObject:cell];
  iCreateList[index] = YES;
  iActiveCell = cell;
  NSString* videofile = [iVideoFeatureList objectForKey:[NSString stringWithFormat:@"%d", index]];
  if (videofile)
  {
    [cell setupVideoPlayer:videofile];
  }
  
  // Split left and right to create cells
  int j = 0;
  for (int i = index+1; i < [self.iBgNameList count]; i++)
  {
    //--start--
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, j++ * 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      GeneralFullScreenSlideCell* cell = [[GeneralFullScreenSlideCell alloc] initWithDesFile:[self.iDesNameList objectAtIndex:i] Bg:[self.iBgNameList objectAtIndex:i] Delegate:self];
      [self.view addSubview:cell];
      [iCellList addObject:cell];
      cell.frame = CGRectMake((i-index)*cell.frame.size.width, 0, cell.frame.size.width, cell.frame.size.height);
      iCreateList[i] = YES;
      NSString* videofile = [iVideoFeatureList objectForKey:[NSString stringWithFormat:@"%d", i]];
      if (videofile)
      {
        [cell setupVideoPlayer:videofile];
      }
      [self.view bringSubviewToFront:self.uiSpinner];
    });
    //--end--
  }
  j = 0;
  for (int i = (index-1); i>=0; i--)
  {
    //--start--
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, j++ * 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      GeneralFullScreenSlideCell* cell = [[GeneralFullScreenSlideCell alloc] initWithDesFile:[self.iDesNameList objectAtIndex:i] Bg:[self.iBgNameList objectAtIndex:i] Delegate:self];
      [self.view addSubview:cell];
      [iCellList addObject:cell];
      cell.frame = CGRectMake((i-index)*cell.frame.size.width, 0, cell.frame.size.width, cell.frame.size.height);
      iCreateList[i] = YES;
      NSString* videofile = [iVideoFeatureList objectForKey:[NSString stringWithFormat:@"%d", i]];
      if (videofile)
      {
        [cell setupVideoPlayer:videofile];
      }
      [self.view bringSubviewToFront:self.uiSpinner];
    });
    //--end--
  }
}
-(void)onAutoTick:(NSTimer *)timer
{
  [self onRightMove];
}
-(void)setupVideoPlayer:(NSString*)videofile Index:(int)index
{
  if (iVideoFeatureList==nil)
  {
    iVideoFeatureList = [[NSMutableDictionary alloc] init];
  }
  [iVideoFeatureList setObject:videofile forKey:[NSString stringWithFormat:@"%d", index]];
}
-(void)onLeftMove
{
  [self bcellOnHideDes];
  CGSize size = self.view.frame.size;
  for (int i=0;i<[iCellList count];i++)
  {
    GeneralFullScreenSlideCell* tcell = [iCellList objectAtIndex:i];
    if (tcell)
    {
      int p = tcell.frame.origin.x+size.width;
      if (p>MAX_XX)
      {
        tcell.frame = CGRectMake(-size.width, 0, size.width, size.height);
      }
      if ((tcell.frame.origin.x+size.width)==0)
      {
        iActiveCell = tcell;
      }
      [UIView animateKeyframesWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        tcell.frame = CGRectMake(tcell.frame.origin.x+size.width, 0, size.width, size.height);
        if (tcell.frame.origin.x==0)
        {
          [tcell turnDepOn];
        }
        else
        {
          [tcell stopVideo];
        }
      } completion:^(BOOL finished) {
        
      }];
    }
  }
}
-(void)onRightMove
{
  [self bcellOnHideDes];
  CGSize size = self.view.frame.size;
  for (int i=0;i<[iCellList count];i++)
  {
    GeneralFullScreenSlideCell* tcell = [iCellList objectAtIndex:i];
    if (tcell)
    {
      int p = tcell.frame.origin.x-size.width;
      if (p<MIN_XX)
      {
        NSLog(@"out of mini");
        tcell.frame = CGRectMake(size.width, 0, size.width, size.height);
      }
      if ((tcell.frame.origin.x-size.width)==0)
      {
        iActiveCell = tcell;
      }
      [UIView animateKeyframesWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        tcell.frame = CGRectMake(tcell.frame.origin.x-size.width, 0, size.width, size.height);
        if (tcell.frame.origin.x==0)
        {
          [tcell turnDepOn];
          NSLog(@"show file %@", [tcell getBgName]);
        }
        else
        {
          [tcell stopVideo];
        }
        if (tcell.frame.origin.x==0 || tcell.frame.origin.x==-size.width || tcell.frame.origin.x==size.width)
        {
          
        }
      } completion:^(BOOL finished) {
        
      }];
      
    }
  }
}
-(void)disableAllArrow
{
  self.uiLeftArrow.hidden = YES;
  self.uiRightArrow.hidden = YES;
}
-(void)enableAutoRun
{
  if (iAutoTimer)
  {
    [iAutoTimer invalidate];
    iAutoTimer = nil;
  }
  [self disableAllArrow];
  iAutoRun = YES;
  
  [uiSpinner startAnimating];
  
  //Remove gesture
  if (iSwipegs_left)
  {
    [self.view removeGestureRecognizer:iSwipegs_left];
  }
  if (iSwipegs_right)
  {
    [self.view removeGestureRecognizer:iSwipegs_right];
  }
}
-(void)disableAutoRun
{
  if (iAutoTimer)
  {
    [iAutoTimer invalidate];
    iAutoTimer = nil;
  }
}

#pragma mark - IGeneralSlideInCell
-(void)bscellNext
{
  
}
-(void)bscellPrev
{
  
}
-(void)didLoadImage
{
  iLoadCellImgCount++;
  if (iLoadCellImgCount==[self.iBgNameList count])
  {
    if (iAutoRun)
    {
      NSLog(@"auto run now");
      [uiSpinner stopAnimating];
      iAutoTimer = [NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(onRightMove) userInfo:nil repeats:YES];
    }
    [self.view bringSubviewToFront:self.uiLeftArrow];
    [self.view bringSubviewToFront:self.uiRightArrow];
    [self.view bringSubviewToFront:self.uiCross];
  }
}
-(void)bcellOnShowDes
{
  if (self.uiLeftArrow.hidden==NO && NO==iAutoRun)
  {
    if (iActiveCell && [iActiveCell isDesWindowOverlay:self.uiLeftArrow.frame])
    {
      self.uiLeftArrow.hidden = YES;
    }
  }
}
-(void)bcellOnHideDes
{
  if (NO==iAutoRun)
  {
    self.uiLeftArrow.hidden = NO;
    self.uiRightArrow.hidden = NO;
  }
}
-(IBAction)onCross:(id)sender
{
  if (delegate)
  {
    [delegate onSlideShowDismiss:self];
  }
}
-(IBAction)onLeft:(id)sender
{
  [self onLeftMove];
}
-(IBAction)onRight:(id)sender
{
  [self onRightMove];
}
@end
