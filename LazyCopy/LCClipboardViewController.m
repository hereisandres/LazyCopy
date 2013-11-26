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
#import "LCPlistManager.h"

NSString * const CellIdentifier = @"ClipboardItem";
NSInteger const ItemLabelViewTag = 1;

@interface LCClipboardViewController ()

@property (nonatomic, strong) UIImagePickerController *cameraPickerController;
@property (nonatomic, strong) UINavigationController *appNavigationController;
@property (nonatomic, strong) LCPlistManager *manager;

@end

@implementation LCClipboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // HACK: Preload the camera.
    [self cameraPickerController];
    
    // Load data.
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self reloadData];
}

- (void)reloadData
{
    [self.manager refreshData];
    [self.tableView reloadData];
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

- (LCPlistManager *)manager
{
    if (_manager == nil) {
        _manager = [[LCPlistManager alloc] init];
    }
    return _manager;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.manager.history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClipboardItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *itemLabel = (UILabel *)[cell.contentView viewWithTag:ItemLabelViewTag];
    itemLabel.text = self.manager.history[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.manager deleteObjectAtIndex:indexPath.row];
        [self.manager refreshData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Copy to clipbard
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.manager.history[indexPath.row]];
}

@end
