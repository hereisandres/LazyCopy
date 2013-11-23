//
//  LCImageEditorViewController.h
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAnnotationImageView.h"

@interface LCImageEditorViewController : UIViewController <NAnnotationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)getText:(id)sender;
- (IBAction)toggleEditMode:(id)sender;

@end
