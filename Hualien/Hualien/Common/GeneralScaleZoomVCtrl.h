//
//  GeneralScaleZoomVCtrl.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/22.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralScaleZoomVCtrl : UIViewController
-(id)initWithNibName:(NSString*)xibfile bundle:(NSBundle*)bundle Image:(UIImage*)image;
-(void)setZoomEnable:(BOOL)enable;
-(void)turnGreenCross;
-(void)turnWhiteCross;
-(void)setBackgroundColor:(UIColor*)color Opacity:(float)opacity;
@property(nonatomic, strong)UIImage* displayImage;
@end
