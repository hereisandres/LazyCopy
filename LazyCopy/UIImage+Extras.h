//
//  UIImage+Extras.h
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extras)

- (UIImage *)maskedImageWithMask:(UIImage *)maskImage;

- (UIImage *)imageByCroppingRect:(CGRect)rect;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)imageByRotatingImageByRadians:(float)angleInRadians;

- (UIImage *)imageByOverlayingImage:(UIImage *)overlay withRect:(CGRect)rect;

- (UIImage *)fixOrientation;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;
- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;

@end
