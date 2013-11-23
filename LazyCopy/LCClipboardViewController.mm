//
//  LCViewController.m
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import "LCClipboardViewController.h"
#import "LCImageEditorViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString * const CellIdentifier = @"ClipboardItem";

@interface LCClipboardViewController ()

@property (nonatomic, strong) UIImagePickerController *cameraPickerController;
@property (nonatomic, strong) UINavigationController *appNavigationController;

@end

@implementation LCClipboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // HACK: Preload the camera.
    [self cameraPickerController];
}

#pragma mark - Lazy loaders

- (UIImagePickerController *)cameraPickerController
{
    if (_cameraPickerController == nil) {
        _cameraPickerController = [[UIImagePickerController alloc] init];
        _cameraPickerController.delegate = self;
        _cameraPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _cameraPickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    return _cameraPickerController;
}

- (UINavigationController *)appNavigationController
{
    if (_appNavigationController == nil) {
        _appNavigationController = (UINavigationController *)[(LCAppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController;
    }
    return _appNavigationController;
}

#pragma mark - Camera

- (IBAction)showCamera:(id)sender
{
    [self presentViewController:self.cameraPickerController animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (image) {
            // Present image editor.
            UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LCImageEditorViewController *imageEditorViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageEditorViewController"];
            imageEditorViewController.image = image;
            
            [self.appNavigationController pushViewController:imageEditorViewController animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"An error occurred. No image found."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
