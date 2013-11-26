
//
//  NAnnotationImageView.m
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import "NAnnotationImageView.h"

@interface NAnnotationImageView () {
    CGPoint _prevPoint;
    NSMutableArray *_pathArray;
    UIImageView *_pathImageView;
}

@end

@implementation NAnnotationImageView

- (void)setAnnotationMode:(BOOL)annotationMode
{
    _annotationMode = annotationMode;
    [self cleanup];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    self.annotationMode = NO;
    self.brushSize = 30;
}

- (UIImage *)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint image:(UIImage *)image
{
    CGSize screenSize = self.image.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, self.brushSize);
    CGContextSetRGBStrokeColor(currentContext, 1, 0.69, 0.2, 0.65);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(currentContext, toPoint.x, toPoint.y);
    CGContextStrokePath(currentContext);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.annotationMode) {
        // retrieve touch point
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        
        // record touch points to use as input to our line smoothing algorithm
        _pathArray = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:currentPoint]];
        
        _prevPoint = currentPoint;
        
        // new image
        _pathImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
        [self addSubview:_pathImageView];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.annotationMode) {
        // retrieve touch point
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        
        // record touch points to use as input to our line smoothing algorithm
        [_pathArray addObject:[NSValue valueWithCGPoint:currentPoint]];
        
        // draw line from the current point to the previous point
        _pathImageView.image = [self drawLineFromPoint:_prevPoint toPoint:currentPoint image:_pathImageView.image];
        
        _prevPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.annotationMode) {
        // find smallest and largest points
        CGPoint p1 = CGPointMake(self.image.size.width, self.image.size.height);
        CGPoint p2 = CGPointMake(0, 0);
        for (NSValue *value in _pathArray) {
            CGPoint point = [value CGPointValue];
            
            // grab the smallest point for p1 and largest for p2
            if (point.x < p1.x)
                p1.x = point.x;
            
            if (point.x > p2.x)
                p2.x = point.x;
            
            if (point.y < p1.y)
                p1.y = point.y;
            
            if (point.y > p2.y)
                p2.y = point.y;
        }
        
        // make a rect from the points
        CGRect rect = CGRectMake(p1.x-25, p1.y-25, p2.x - p1.x + 50, p2.y - p1.y + 50);
        
        // call delegate
        [self.delegate annotationView:self didFinishDrawingWithRect:rect];
    }
    
    // clean up
    [self cleanup];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cleanup];
}

- (void)cleanup
{
    [_pathImageView removeFromSuperview];
    _pathImageView = nil;
    _pathArray = nil;
    _prevPoint = CGPointZero;
}

@end