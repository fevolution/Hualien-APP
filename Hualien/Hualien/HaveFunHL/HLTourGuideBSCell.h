//
//  HLTourGuideBSCell.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IHLTourGuideBSCell
-(void)bscellNext;
-(void)bscellPrev;
@end
@interface HLTourGuideBSCell : UIView
-(id)initWithDesFile:(NSString*)des Bg:(NSString*)bg Delegate:(id<IHLTourGuideBSCell>)del FixRect:(CGRect)fixrect;
-(void)turnDepOff;
@end
