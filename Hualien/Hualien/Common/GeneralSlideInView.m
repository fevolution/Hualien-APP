//
//  GeneralSlideInView.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/17.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//
#import "GeneralSlideInView.h"
@interface GeneralSlideInView()
{
  int iDesOffsetY;
  int MAX_XX;
  int MIN_XX;
}
-(void)createCellByIndex:(int)index WithContainerIn:(BOOL)cellIn DesOffsetY:(int)offsetY;
@end

@implementation GeneralSlideInView
-(void)awakeFromNib
{
  [self resetBreathing];
  iPreIndex = -1;
  // Gesture
  {
    UISwipeGestureRecognizer* swipegs_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
    swipegs_right.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipegs_right];
  }
  {
    UISwipeGestureRecognizer* swipegs_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
    swipegs_left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipegs_left];
  }
}
-(void)createCellsWithContainerIn:(BOOL)cellIn DesOffsetY:(int)offsetY Number:(int)cellnum
{
  @autoreleasepool
  {
    for (int i =0; i<iCellNum; i++)
    {
      [self createCellByIndex:i WithContainerIn:NO DesOffsetY:123];
    }
  }
}
- (void)onSceneSclSwipe: (UISwipeGestureRecognizer *)sender
{
  if(sender.direction & UISwipeGestureRecognizerDirectionRight)
  {
    NSLog(@" swipe to right");
    [self bscellPrev:nil];
  }else if(sender.direction & UISwipeGestureRecognizerDirectionLeft)
  {
    NSLog(@" swipe to left");
    [self bscellNext:nil];
  }
}
-(void)resetBreathing
{
  for (CALayer* layer in [self.layer sublayers]) {
    [layer removeAllAnimations];
  }
  [UIView animateWithDuration:1.3 delay:1 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^()
   {
     self.uiBreathNextArrow.alpha = 1;
     self.uiBreathPrevArrow.alpha = 1;
   } completion:^(BOOL finished) {
   }];
}
-(void)cancelBreathing
{
  for (CALayer* layer in [self.layer sublayers]) {
    [layer removeAllAnimations];
  }
  self.uiBreathNextArrow.alpha = 0;
  self.uiBreathPrevArrow.alpha = 0;
}
-(void)moveCellContainerIn
{
  NSLog(@"move in %d", iCurIndex);
  //if(iPreIndex==iCurIndex)return;
  int xoffset = -XOFFSET_VALUE;
  if (self.frame.origin.x!=xoffset)
  {
    [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
     {
       self.frame = CGRectMake(xoffset, 0, self.frame.size.width, self.frame.size.height);
     } completion:nil];
  }
  GeneralSlideInCell* targetcell = [self.iCellList objectForKey:[NSString stringWithFormat:@"%d", iCurIndex]];
  if (targetcell)
  {
    NSLog(@"try to show des");
    [targetcell showDesIfPossible];
  }
  iPreIndex = iCurIndex;
}
-(void)moveCellContainerBack
{
  [self turnAllDesOff];
  [self turnAllButtonUnSelected];
  [self unselectAllDotLine];
  [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
   {
     self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
     self.uiCanvasView.frame = CGRectMake(0, self.uiCanvasView.frame.origin.y, self.uiCanvasView.frame.size.width, self.uiCanvasView.frame.size.height);
   } completion:nil];
}
-(void)layoutSlideViewByActiveIndex:(int)index
{
  NSLog(@"layoutSlideViewByActiveIndex:%d", index);
  GeneralSlideInCell* targetcell = [self.iCellList objectForKey:[NSString stringWithFormat:@"%d", index]];
  for (int i = 0; i < iCellNum; i++)
  {
    if ( i!=index)
    {
      GeneralSlideInCell* cell = [self.iCellList objectForKey:[NSString stringWithFormat:@"%d", i]];
      if (cell)
      {
        if ((i-index)==1)
        {
          targetcell.view.frame = CGRectMake(cell.view.frame.origin.x-cell.view.frame.size.width, self.uiCellView.frame.origin.y, cell.view.frame.size.width, cell.view.frame.size.height);
          return;
        }else if ((i-index)==-1)
        {
          targetcell.view.frame = CGRectMake(cell.view.frame.origin.x+cell.view.frame.size.width, self.uiCellView.frame.origin.y, cell.view.frame.size.width, cell.view.frame.size.height);
          return;
        }
      }
    }
  }
}
-(void)moveOtherCellByActiveIndex:(int)index
{
  for (int i = 0; i < iCellNum; i++)
  {
    GeneralSlideInCell* cell =[self.iCellList objectForKey:[NSString stringWithFormat:@"%d", i]];
    if (cell)
    {
      [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
       {
         cell.view.frame = CGRectMake((i-index)*self.uiCellView.frame.size.width, 0, self.uiCellView.frame.size.width, self.uiCellView.frame.size.height);
       }completion:nil];
    }
  }
}
-(void)createCellByIndex:(int)index WithContainerIn:(BOOL)cellIn DesOffsetY:(int)offsetY
{
  int w = self.uiCellView.frame.size.width;
  MIN_XX = -1*(int)([self.iBSNameList count]-1)*w;
  MAX_XX =    (int)([self.iBSNameList count]-1)*w;
  
  iDesOffsetY = offsetY;
  if (iCreateList[index]==NO)
  {
    NSString* des = [self.iDesNameList objectAtIndex:index];
    NSString* bs = [self.iBSNameList objectAtIndex:index];
    CGRect offsettect = ((NSValue*)[self.iFixRectList objectAtIndex:index]).CGRectValue;
    
    GeneralSlideInCell* cell = [[GeneralSlideInCell alloc] initWithDesFile:des Bg:bs Delegate:self FixRect:offsettect DesY:offsetY];
    cell.view.frame = CGRectMake(w*index, 0, self.uiCellView.frame.size.width, self.uiCellView.frame.size.height);
    cell.view.tag = index;
    [self.uiCellView addSubview:cell.view];
    [self.iCellList setValue:cell forKey:[NSString stringWithFormat:@"%d", index]];
    iCreateList[index] = YES;
    iActiveCell = cell;
    [self.uiCellView bringSubviewToFront:self.uiLeftArrow];
    [self.uiCellView bringSubviewToFront:self.uiRightArrow];
    [self.uiCellView bringSubviewToFront:self.uiBreathNextArrow];
    [self.uiCellView bringSubviewToFront:self.uiBreathPrevArrow];
  }else
  {
    GeneralSlideInCell* cell = [self.iCellList objectForKey:[NSString stringWithFormat:@"%d", index]];
    [self.uiCellView bringSubviewToFront:cell.view];
    
    [self moveCellByIndex:index];
    iActiveCell = cell;
    
    [self.uiCellView bringSubviewToFront:self.uiLeftArrow];
    [self.uiCellView bringSubviewToFront:self.uiRightArrow];
    [self.uiCellView bringSubviewToFront:self.uiBreathNextArrow];
    [self.uiCellView bringSubviewToFront:self.uiBreathPrevArrow];
  }
  if (cellIn)
  {
    // Move cell-container In
    [self moveCellContainerIn];
  }
}
-(void)unselectAllDotLine
{
  //Dot
  for (int i = 0; i<[self.iDotList count]; i++)
  {
    UIImageView* view = [self.iDotList objectAtIndex:i];
    view.highlighted = NO;
  }
  //Line
  for (int i = 0; i<[self.iLineList count]; i++)
  {
    UIView* view = [self.iLineList objectAtIndex:i];
    view.backgroundColor = [UIColor colorWithRed:0 green:196.0/255.0 blue:150.0/255.0 alpha:1];
  }
}
-(void)selectDotLineByIndex:(int)index
{
  UIImageView* dot = [self.iDotList objectAtIndex:index];
  dot.highlighted = YES;
  UIView* line = [self.iLineList objectAtIndex:index];
  line.backgroundColor = [UIColor colorWithRed:235.0/100 green:98.0/255.0 blue:89.0/255.0 alpha:1];
}
-(void)turnAllButtonUnSelected
{
  for (int i =0; i<[self.iBtnList count]; i++)
  {
    UIButton* btn = [self.iBtnList objectAtIndex:i];
    btn.selected = NO;
  }
}

-(void)turnAllDesOff
{
  for (NSString* key in self.iCellList)
  {
    GeneralSlideInCell* cell = [self.iCellList objectForKey:key];
    if (cell)
    {
      [cell turnDepOff];
    }
  }
}

-(void)moveCanvasWhenBtnClick:(UIButton*)btn
{
  // Make sure we do move canvas
  if (self.frame.origin.x<0)
  {
    // Move canvas back first
    float btncx = btn.center.x;
    float leftscreen_midx = [UIScreen mainScreen].bounds.size.width*(1-XOFFSET_RATIO)/2;
    float dif = leftscreen_midx - btncx;
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
      self.uiCanvasView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*XOFFSET_RATIO+dif, self.uiCanvasView.frame.origin.y,
                                           self.uiCanvasView.frame.size.width, self.uiCanvasView.frame.size.height);
    } completion:^(BOOL finished) {
      
    }];
  }
  [self turnAllButtonUnSelected];
  btn.selected = YES;
}
-(void)moveCellByIndex:(int)index
{
  int w = self.uiCellView.frame.size.width;
  int h = self.uiCellView.frame.size.height;
  for ( id key in self.iCellList)
  {
    GeneralSlideInCell* cell = [self.iCellList objectForKey:key];
    int i = (int)[key integerValue];
    [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
     {
       cell.view.frame = CGRectMake((i-index)*w, 0, w, h);
       if (cell.view.frame.origin.x == 0)
       {
         // [cell loadBsImg];
       }
     }completion:nil];
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint point = [[touches anyObject] locationInView:self];
  if (point.x<[UIScreen mainScreen].bounds.size.width && self.frame.origin.x<0)
  {
    [self moveCellContainerBack];
  }
}

-(void)dealloc
{
  NSLog(@"%s", __FUNCTION__);
  iActiveCell = nil;
  //[self.iCellList removeAllObjects];
  //self.iCellList = nil;
  free(iCreateList);
}

#pragma mark - IGeneralSlideInCell
-(void)bscellNext
{
  NSLog(@"NEXT");
}
-(void)bscellPrev
{
  NSLog(@"PREV");
}
-(void)bcellOnShowDes:(CGSize)size
{
  CGRect arrrect = self.uiBreathPrevArrow.frame;
  CGRect desrect = CGRectMake([iActiveCell getDesImgOrg].x, [iActiveCell getDesImgOrg].y, size.width, size.height);
  if (CGRectIntersectsRect(arrrect, desrect))
  {
    self.uiBreathPrevArrow.hidden = YES;
  }else
  {
    self.uiBreathPrevArrow.hidden = NO;
  }
}
-(void)bcellOnHideDes:(CGSize)size
{
  NSLog(@"hide des");
  self.uiBreathPrevArrow.hidden = NO;
}

#pragma mark - IHLTourGuideBSCell
-(IBAction)bscellNext:(id)sender
{
  if (iActiveCell)
  {
    [iActiveCell turnDepOff];
  }
  iCurIndex++;
  if (iCurIndex>=iCellNum)
  {
    iCurIndex = iCellNum-1;
  }
  CGSize size = self.uiCellView.frame.size;
  for (id key in self.iCellList)
  {
    GeneralSlideInCell* cell = [self.iCellList objectForKey:key];
    if (cell)
    {
      int p = cell.view.frame.origin.x-size.width;
      if (p<MIN_XX)
      {
        cell.view.frame = CGRectMake(size.width, 0, size.width, size.height);
      }
      if ((cell.view.frame.origin.x-size.width)==0)
      {
        iActiveCell = cell;
        //[iActiveCell loadBsImg];
        iCurIndex = (int)cell.view.tag;
      }
      [UIView animateKeyframesWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        cell.view.frame = CGRectMake(cell.view.frame.origin.x-size.width, 0, size.width, size.height);
        if (cell.view.frame.origin.x==0)
        {
          [cell showDesIfPossible];
        }
      } completion:^(BOOL finished) {
        
      }];
    }
  }
  [self moveCanvasWhenBtnClick:[self.iBtnList objectAtIndex:iCurIndex]];
  [self unselectAllDotLine];
  [self selectDotLineByIndex:iCurIndex];
}
-(IBAction)bscellPrev:(id)sender
{
  if (iActiveCell)
  {
    [iActiveCell turnDepOff];
  }
  iCurIndex--;
  if (iCurIndex<0)
  {
    iCurIndex = 0;
  }
  CGSize size = self.uiCellView.frame.size;
  for (id key in self.iCellList)
  {
    GeneralSlideInCell* cell = [self.iCellList objectForKey:key];
    if (cell)
    {
      int p = cell.view.frame.origin.x+size.width;
      if (p>MAX_XX)
      {
        cell.view.frame = CGRectMake(-size.width, 0, size.width, size.height);
      }
      if ((cell.view.frame.origin.x+size.width)==0)
      {
        iActiveCell = cell;
        // [iActiveCell loadBsImg];
        iCurIndex = (int)cell.view.tag;
      }
      [UIView animateKeyframesWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        cell.view.frame = CGRectMake(cell.view.frame.origin.x+size.width, 0, size.width, size.height);
        if (cell.view.frame.origin.x==0)
        {
          [cell showDesIfPossible];
        }
      } completion:^(BOOL finished) {
        
      }];
    }
  }
  [self moveCanvasWhenBtnClick:[self.iBtnList objectAtIndex:iCurIndex]];
  [self unselectAllDotLine];
  [self selectDotLineByIndex:iCurIndex];
}

#pragma mark - Button related action
-(IBAction)onClikBtnDown:(id)sender
{
  [self turnAllButtonUnSelected];
  UIButton* btn = (UIButton*)sender;
  iCurIndex = (int)btn.tag;
  [self unselectAllDotLine];
  [self selectDotLineByIndex:iCurIndex];
}
-(IBAction)onClikBtn:(id)sender
{
  UIButton* btn = (UIButton*)sender;
  iCurIndex = (int)btn.tag;
  [self createCellByIndex:iCurIndex WithContainerIn:YES DesOffsetY:iDesOffsetY];
  [self moveCanvasWhenBtnClick:btn];
}
-(IBAction)onBtnDragOutside:(id)sender
{
  [self unselectAllDotLine];
}
@end
