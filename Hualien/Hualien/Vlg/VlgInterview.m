//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgInterview.h"
#import "GeneralFullScreenSlideShow.h"
#define SCL_PAGE_MAX 11
@interface VlgInterview()<UIScrollViewDelegate>
{
    int iPage;
    NSMutableArray* iPageList;
    int iR;
    int iG;
    int iB;
}
@property(nonatomic, weak)IBOutlet UIImageView* uiBjarkImg;
@property(nonatomic, weak)IBOutlet UIScrollView* uiArchiSclView;
@property(nonatomic, weak)IBOutlet UIButton* uiDown;
@property(nonatomic, weak)IBOutlet UIButton* uiUp;

@end

//35 1236 Gap 400.333
@implementation VlgInterview
+(id)VlgInterview
{
    VlgInterview *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgInterview" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgInterview class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    self.uiUp.hidden = YES;
    self.uiUp.transform = CGAffineTransformMakeRotation(M_PI);
    
    self.uiArchiSclView.contentSize = CGSizeMake(230, 6980);
    self.uiArchiSclView.delegate = self;
    iR = 0;
    iG = 137;
    iB = 98;
    self.uiBjarkImg.bounds = CGRectMake(0, -10, self.uiBjarkImg.frame.size.width, self.uiBjarkImg.frame.size.height);
    
    iPageList = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:672], [NSNumber numberWithInt:1276],
                 [NSNumber numberWithInt:1900], [NSNumber numberWithInt:2500], [NSNumber numberWithInt:3105], [NSNumber numberWithInt:3705],
                 [NSNumber numberWithInt:4302], [NSNumber numberWithInt:4904], [NSNumber numberWithInt:5502], [NSNumber numberWithInt:6102], [NSNumber numberWithInt:6305], nil];
    
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)changeScrollBarColorFor:(UIScrollView *)scrollView
{
    for ( UIView *view in scrollView.subviews )
    {
        if (view.tag == 0 && [view isKindOfClass:UIImageView.class])
        {
            UIImageView *imageView = (UIImageView *)view;
            imageView.backgroundColor = [UIColor colorWithRed:iR green:iG/255.0 blue:iB/255.0 alpha:1];
        }
    }
}

- (void)toUp
{
    self.uiDown.hidden = YES;
    self.uiUp.hidden = NO;
}

- (void)toDown
{
    self.uiDown.hidden = NO;
    self.uiUp.hidden = YES;
}

- (IBAction)onDown:(id)sender
{
    ++iPage;
    if (iPage>=SCL_PAGE_MAX)
    {
        [self toUp];
        iPage = SCL_PAGE_MAX;
    }
    NSNumber* num = [iPageList objectAtIndex:iPage];
    [self.uiArchiSclView scrollRectToVisible:CGRectMake(0, [num integerValue], self.uiArchiSclView.frame.size.width, self.uiArchiSclView.frame.size.height) animated:YES];
}

- (IBAction)onUp:(id)sender
{
    --iPage;
    if (iPage<=0)
    {
        [self toDown];
        iPage = 0;
    }
    NSNumber* num = [iPageList objectAtIndex:iPage];
    [self.uiArchiSclView scrollRectToVisible:CGRectMake(0, [num integerValue], self.uiArchiSclView.frame.size.width, self.uiArchiSclView.frame.size.height) animated:YES];
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",  self.uiArchiSclView.contentOffset.y);
    static int def = 0;
    //move down or up
    if (self.uiArchiSclView.contentOffset.y>def)
    {
        NSLog(@"move down");
        [self toDown];
    }else
    {
        NSLog(@"move up");
        [self toUp];
    }
    def = self.uiArchiSclView.contentOffset.y;
    [self changeScrollBarColorFor:scrollView];
    
    //Check current page
    int maxdef = INT16_MAX;
    for (int i = 0; i <[iPageList count]; i++)
    {
        NSNumber* num = [iPageList objectAtIndex:i];
        int iabs = fabs(self.uiArchiSclView.contentOffset.y - [num integerValue]);
        if (iabs<maxdef)
        {
            maxdef = iabs;
            iPage = i;
        }
    }
}
@end
