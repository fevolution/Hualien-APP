//
//  SpxLionSlideShow.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/9.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IGeneralFullScreenSlideShow
-(void)onSlideShowDismiss:(id)theslideshow;
@optional
-(void)onSlideChange:(int)index;
@end

@interface GeneralFullScreenSlideShow : UIViewController
-(id)initWithNibName:(NSString*)xibfile bundle:(NSBundle*)bundle NameList:(NSMutableArray*)namelist DesList:(NSMutableArray*)deslist;
-(void)setDelegate:(id<IGeneralFullScreenSlideShow>)delegate;
-(void)createCellByIndex:(int)index;
-(void)setupVideoPlayer:(NSString*)videofile Index:(int)index;
-(void)disableAllArrow;
@end
