//
//  GeneralSingleSlideShow.h
//  Hualien
//
//  Created by Chunta chen on 6/24/15.
//  Copyright (c) 2015 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IGeneralSingleSlideShow
    -(void)onSingleSlideShowClose;
@end

@interface GeneralSingleSlideShow : UIViewController
- (void)setImageContent:(NSString*)file;
- (void)setVideoContent:(NSString*)file;
-(void)setDelegate:(id<IGeneralSingleSlideShow>)del;
@end
