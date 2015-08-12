//
//  SingleImageScrollView.m
//  SingleImageScrollView
//
//  Some code from http://idevzilla.com/2010/10/04/uiscrollview-and-zoom/
//
//  Created by Denis Chaschin on 22.05.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import "SingleImageScrollView.h"


@interface SingleImageScrollView () <UIScrollViewDelegate>
@property (assign, nonatomic) CGFloat privateMinimumZoomScale;
@property (assign, nonatomic) CGFloat privateMaximumZoomScale;
@property (assign, nonatomic, readonly) CGFloat zoomScaleCoefficient;
@end

@implementation SingleImageScrollView {
    UIImageView *_imageView;
    CGSize _previousSize;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    self.contentSize = _imageView.frame.size;
    [self addSubview:_imageView];
    [self updateMinAndMaxScale];
    [self setZoomScale:self.privateMinimumZoomScale];
    [self _setDelegate:self];
    _maximumZoomCoefficient = 1;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(_previousSize, self.bounds.size)) {
        [self sizeDidChange];
        _previousSize = self.bounds.size;
    }
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;;
    _imageView.frame = (CGRect){CGPointZero, image.size};
    [self updateMinAndMaxScale];
    [self updateImageCenter];
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {}
- (void)_setDelegate:(id<UIScrollViewDelegate>)delegate {
    [super setDelegate:delegate];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    const CGFloat rasterizationScale = scale / [self computeMinZoomScale];
    _imageView.layer.rasterizationScale = rasterizationScale;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateImageCenter];
}

#pragma mark - ZoomS scale
- (void)setMaximumZoomCoefficient:(CGFloat)maximumZoomCoefficient {
    _maximumZoomCoefficient = maximumZoomCoefficient;
    [self updateMinAndMaxScale];
    [self updateImageCenter];
}

#pragma mark - Private Zoom scale
- (void)setPrivateMaximumZoomScale:(CGFloat)privateMaximumZoomScale {
    [super setMaximumZoomScale:privateMaximumZoomScale];
}

- (CGFloat)privateMaximumZoomScale {
    return [super minimumZoomScale];
}

- (void)setPrivateMinimumZoomScale:(CGFloat)privateMinimumZoomScale {
    [super setMinimumZoomScale:privateMinimumZoomScale];
}

- (CGFloat)privateMinimumZoomScale {
    return [super minimumZoomScale];
}

#pragma mark - Private
- (void)sizeDidChange {
    [self updateMinAndMaxScale];
    [self updateImageCenter];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

- (void)updateMinAndMaxScale {
    if (_imageView.image == nil) {
        return;
    }
    
    const CGFloat minZoomScale = [self computeMinZoomScale];
    BOOL needToUpdateImageCenter = self.privateMinimumZoomScale == self.zoomScale;
    self.privateMinimumZoomScale = minZoomScale;
    self.privateMaximumZoomScale = minZoomScale * self.maximumZoomCoefficient;
    if (self.zoomScale < self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    }
    if (self.zoomScale > self.maximumZoomScale) {
        self.zoomScale = self.maximumZoomScale;
    }
    if (needToUpdateImageCenter) {
        self.zoomScale = self.minimumZoomScale;
        [self updateImageCenter];
    }
}

- (CGFloat)zoomScaleCoefficient {
    return [self computeMinZoomScale];
}

- (CGFloat)computeMinZoomScale {
    if (_imageView.image == 0) {
        return 1;
    }
    
    CGSize sizeAfterTransform =  CGSizeApplyAffineTransform(self.frame.size, self.transform);
    sizeAfterTransform.width = ABS(sizeAfterTransform.width);
    sizeAfterTransform.height = ABS(sizeAfterTransform.height);
    
    const CGFloat selfAspectRatio = sizeAfterTransform.width / sizeAfterTransform.height;
    const CGFloat imageAspectRatio = _imageView.image.size.width / _imageView.image.size.height;
    CGFloat minZoomScale;
    if (selfAspectRatio > imageAspectRatio) {
        //scale by height
        minZoomScale = sizeAfterTransform.height / _imageView.image.size.height;
    } else {
        //scale by width
        minZoomScale= sizeAfterTransform.width / _imageView.image.size.width;
    }
    return minZoomScale;
}

- (void)updateImageCenter {
    if (_imageView.image == nil) {
        return;
    }
    _imageView.frame = [self centeredFrameForScrollView:self andUIView:_imageView];
}

@end
