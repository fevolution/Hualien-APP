//
//  SpxLionSlide.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/9.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IGeneralFullScreenSlideCell
-(void)bcellOnShowDes;
-(void)bcellOnHideDes;
@optional
-(void)didLoadImage;
@end
@interface GeneralFullScreenSlideCell : UIView
-(id)initWithDesFile:(NSString*)des Bg:(NSString*)bg Delegate:(id<IGeneralFullScreenSlideCell>)del;
-(void)turnDepOff;
-(void)turnDepOn;
-(void)loadImg;
-(void)setupVideoPlayer:(NSString*)videofile;
-(void)stopVideo;
-(BOOL)isDesWindowOverlay:(CGRect)rect;
-(NSString*)getBgName;
@end
