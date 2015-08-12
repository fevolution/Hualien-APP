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
    int MIN_XX;
    int MAX_XX;
}
@end

@implementation GeneralSlideInView
-(void)awakeFromNib
{
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
    
    self.uiBreathArrow.alpha = 0;
    [UIView animateWithDuration:1.3 delay:1 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^()
     {
         self.uiBreathArrow.alpha = 1;
     } completion:^(BOOL finished) {
     }];
}
-(void)cancelBreathing
{
    for (CALayer* layer in [self.layer sublayers]) {
        [layer removeAllAnimations];
    }
    self.uiBreathArrow.alpha = 0;
}
-(void)moveCellContainerIn
{
    NSLog(@"move in %d", iCurIndex);
    if(iPreIndex==iCurIndex)return;
    int xoffset = -XOFFSET_VALUE;
    if (self.frame.origin.x!=xoffset)
    {
       [UIView animateWithDuration:CELL_MOVEIN_DURATION delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^()
             {
                 self.frame = CGRectMake(xoffset, 0, self.frame.size.width, self.frame.size.height);
                 
                 self.uiLeftArrow.frame = CGRectMake(PAGEARROW_BTN_MARGIN, self.uiLeftArrow.frame.origin.y, PAGEARROW_BTN_WH, PAGEARROW_BTN_WH);
                 self.uiRightArrow.frame = CGRectMake(abs(xoffset)-PAGEARROW_BTN_WH-PAGEARROW_BTN_MARGIN, self.uiRightArrow.frame.origin.y,
                                                      PAGEARROW_BTN_WH, PAGEARROW_BTN_WH);
                 
             } completion:nil];
    }
    GeneralSlideInCell* targetcell = [self.iCellList objectAtIndex:iCurIndex]; //[self.iCellList objectForKey:[NSString stringWithFormat:@"%d", iCurIndex]];
    if (targetcell)
    {
        NSLog(@"try to show des");
        [targetcell showDesIfPossible];
    }
    if (iCurIndex==(iCellNum-1))
    {
        [self cancelBreathing];
        NSLog(@"cancel");
    }
    else
    {
        if (iPreIndex!=0)
        {
            [self resetBreathing];
        }
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
         self.uiRightArrow.frame = CGRectMake(self.uiCellView.frame.size.width-PAGEARROW_BTN_WH-PAGEARROW_BTN_MARGIN, self.uiRightArrow.frame.origin.y,
                                              PAGEARROW_BTN_WH, PAGEARROW_BTN_WH);
         self.uiCanvasView.frame = CGRectMake(0, self.uiCanvasView.frame.origin.y, self.uiCanvasView.frame.size.width, self.uiCanvasView.frame.size.height);
     } completion:nil];
}
/*
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
                    targetcell.frame = CGRectMake(cell.frame.origin.x-cell.frame.size.width, self.uiCellView.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                    return;
                }else if ((i-index)==-1)
                {
                    targetcell.frame = CGRectMake(cell.frame.origin.x+cell.frame.size.width, self.uiCellView.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
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
                 cell.frame = CGRectMake((i-index)*self.uiCellView.frame.size.width, 0, self.uiCellView.frame.size.width, self.uiCellView.frame.size.height);
             }completion:nil];
        }
    }
}
*/
-(void)createCellByIndex:(int)index WithContainerIn:(BOOL)cellIn DesOffsetY:(int)offsetY
{
    int w = self.uiCellView.frame.size.width;
    MIN_XX = -1*([self.iBSNameList count]-1)*w;
    MAX_XX =    ([self.iBSNameList count]-1)*w;
    
  
    iDesOffsetY = offsetY;
    if (iCreateList[index]==NO)
    {
        NSString* des = [self.iDesNameList objectAtIndex:index];
        NSString* bs = [self.iBSNameList objectAtIndex:index];
        CGRect offsettect = ((NSValue*)[self.iFixRectList objectAtIndex:index]).CGRectValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              NSLog(@"%d", index);
            GeneralSlideInCell* cell = [[GeneralSlideInCell alloc] initWithDesFile:des Bg:bs Delegate:self FixRect:offsettect DesY:offsetY];
            [self.iCellList addObject:cell];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.frame = CGRectMake(0, 0, self.uiCellView.frame.size.width, self.uiCellView.frame.size.height);
                [self.uiCellView addSubview:cell];
                
                //[self.iCellList setValue:cell forKey:[NSString stringWithFormat:@"%d", index]];
                //[self layoutSlideViewByActiveIndex:index];
                //[self moveOtherCellByActiveIndex:index];
                iCreateList[index] = YES;
                iActiveCell = cell;
                
                [self.uiCellView bringSubviewToFront:self.uiLeftArrow];
                [self.uiCellView bringSubviewToFront:self.uiRightArrow];
                [self.uiCellView bringSubviewToFront:self.uiBreathArrow];
                
            });
        });
    }
    /*
    else
    {
        GeneralSlideInCell* cell = [self.iCellList objectForKey:[NSString stringWithFormat:@"%d", index]];
        [self.uiCellView bringSubviewToFront:cell];
        [self moveOtherCellByActiveIndex:index];
        iActiveCell = cell;

        [self.uiCellView bringSubviewToFront:self.uiLeftArrow];
        [self.uiCellView bringSubviewToFront:self.uiRightArrow];
        [self.uiCellView bringSubviewToFront:self.uiBreathArrow];
    }
    */
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
    for (int i =0; i<[self.iCellList count]; i++)
    {
        GeneralSlideInCell* cell = [self.iCellList objectAtIndex:i];
        if (cell)
        {
            [cell turnDepOff];
        }
    }
    /*
    for (NSString* key in self.iCellList)
    {
        GeneralSlideInCell* cell = [self.iCellList objectForKey:key];
        if (cell)
        {
            [cell turnDepOff];
        }
    }
    */
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
    free(iCreateList);
}

-(void)turnOnOffArrowByIndex:(unsigned int)index
{
    /*
    self.uiRightArrow.hidden = NO;
    self.uiLeftArrow.hidden = NO;
    if (iCurIndex==(iCellNum-1))
    {
        self.uiRightArrow.hidden = YES;
    }else if (iCurIndex==0)
    {
        self.uiLeftArrow.hidden = YES;
    }
    */
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
-(void)bcellOnShowDes
{
    /*
    if (self.uiLeftArrow.hidden==NO)
    {
        self.uiLeftArrow.hidden = YES;
    }
    */
}
-(void)bcellOnHideDes
{
    [self turnOnOffArrowByIndex:iCurIndex];
}

#pragma mark - IHLTourGuideBSCell
-(IBAction)bscellNext:(id)sender
{
    NSLog(@"Next");
    if (iActiveCell)
    {
        [iActiveCell turnDepOff];
    }
    iCurIndex++;
    if (iCurIndex>=iCellNum)
    {
        iCurIndex = iCellNum-1;
    }
    [self turnOnOffArrowByIndex:iCurIndex];
    [self createCellByIndex:iCurIndex WithContainerIn:YES DesOffsetY:iDesOffsetY];
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
    for (int i=0;i<[self.iCellList count];i++)
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
    
    
    
    [self turnOnOffArrowByIndex:iCurIndex];
    [self createCellByIndex:iCurIndex WithContainerIn:YES DesOffsetY:iDesOffsetY];
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
    [self turnOnOffArrowByIndex:iCurIndex];
    [self createCellByIndex:iCurIndex WithContainerIn:YES DesOffsetY:iDesOffsetY];
    [self moveCanvasWhenBtnClick:btn];
}
-(IBAction)onBtnDragOutside:(id)sender
{
    [self unselectAllDotLine];
}


@end
