//
//  SingleImageScrollView.h
//  SingleImageScrollView
//
//  Created by Denis Chaschin on 22.05.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleImageScrollView : UIScrollView
@property (strong, nonatomic) UIImage *image;
/**
 * minimumZoomScale and maximumZoomScale takes no effect
 */
@property (assign, nonatomic) CGFloat maximumZoomCoefficient;
@end
