//
//  NAnnotationImageView.h
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class NAnnotationImageView;

@protocol NAnnotationDelegate

- (void)annotationView:(NAnnotationImageView *)annotationView didFinishDrawingWithRect:(CGRect)rect;

@end

@interface NAnnotationImageView : UIImageView

@property (nonatomic, weak) id<NAnnotationDelegate> delegate;
@property (nonatomic) BOOL annotationMode;
@property (nonatomic) CGFloat brushSize;

@end