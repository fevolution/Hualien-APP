//
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IGeneralSlideInCell
-(void)bscellNext;
-(void)bscellPrev;
-(void)bcellOnShowDes:(CGSize)size;
-(void)bcellOnHideDes:(CGSize)size;
@end
@interface GeneralSlideInCell : UIViewController
-(id)initWithDesFile:(NSString*)des Bg:(NSString*)bg Delegate:(id<IGeneralSlideInCell>)del FixRect:(CGRect)fixrect DesY:(int)offsetY;
-(void)turnDepOff;
-(void)showDesIfPossible;
-(void)setDesY:(int)offsetY;
-(void)loadBsImg;
-(CGPoint)getDesImgOrg;
@end
