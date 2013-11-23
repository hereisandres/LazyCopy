//
//  LCImageEditorViewController.m
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import "LCImageEditorViewController.h"
#import <TesseractOCR/TesseractOCR.h>
#import "UIImage+Extras.h"

@interface LCImageEditorViewController ()

@property (strong, nonatomic) NAnnotationImageView *imageView;
@property (nonatomic, readonly) CGFloat scale;

@end

@implementation LCImageEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Resize and setup image.
    _image = [[self.image fixOrientation] imageWithImage:self.image scaledToMaxWidth:self.image.size.width/4 maxHeight:self.image.size.height/4];
    self.imageView = [[NAnnotationImageView alloc] initWithImage:_image];
    self.imageView.delegate = self;
    self.imageView.annotationMode = NO;
    
    // set scale
    _scale = 1.0f;
    if (self.image.size.width > self.view.frame.size.width) {
        _scale = self.view.frame.size.width / self.image.size.width;
    }
    
    [self.scrollView setContentSize:self.imageView.bounds.size];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setMaximumZoomScale:1.5f];
    [self.scrollView setMinimumZoomScale:_scale];
    [self.scrollView setZoomScale:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Transcode"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(getText:)];
}

- (IBAction)getText:(id)sender
{
    if (self.image) {
        Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        [tesseract setImage:self.image];
        [tesseract recognize];
        NSString *text = [tesseract recognizedText];
        [tesseract clear];
        
        NSLog(@"%@", text);
        // Copy to clipbard
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:text];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)toggleEditMode:(id)sender
{
    self.imageView.annotationMode = !self.imageView.annotationMode;
    self.scrollView.scrollEnabled = !self.imageView.annotationMode;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    if (self.imageView) {
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        // set scale
        _scale = 1.0f;
        if (image.size.width > self.view.frame.size.width)
            _scale = self.view.frame.size.width / image.size.width;
        
        [self.scrollView setMaximumZoomScale:1.5f];
        [self.scrollView setMinimumZoomScale:_scale];
        [self.scrollView setZoomScale:_scale];
        self.imageView.frame = [self centeredFrameForScrollView:self.scrollView andUIView:self.imageView];
    }
}

#pragma mark - NAnnotationViewDelegate

- (void)annotationView:(NAnnotationImageView *)annotationView didFinishDrawingWithRect:(CGRect)rect
{
    self.imageView.annotationMode = NO;
    self.scrollView.scrollEnabled = YES;
    
    CGFloat ratioX = self.image.size.width / self.imageView.bounds.size.width;
    CGFloat ratioY = self.image.size.height / self.imageView.bounds.size.height;
    
    rect.origin.x *= ratioX;
    rect.origin.y *= ratioY;
    rect.size.width *= ratioX;
    rect.size.height *= ratioY;
    
    self.image = [[self.image fixOrientation] imageByCroppingRect:rect];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageView.frame = [self centeredFrameForScrollView:scrollView andUIView:self.imageView];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView
{
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width <= boundsSize.width) {
        frameToCenter.origin.x = ((boundsSize.width - frameToCenter.size.width) / 2);
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height <= boundsSize.height) {
        frameToCenter.origin.y = ((boundsSize.height - frameToCenter.size.height) / 2);
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

@end
