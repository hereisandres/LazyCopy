//
//  LCPlistManager.m
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import "LCPlistManager.h"

@interface LCPlistManager ()

@property (nonatomic, strong) NSArray *history;
@property (nonatomic, strong) NSString *filepath;
@property (nonatomic, strong) NSURL *applicationDocumentsDirectory;

@end

@implementation LCPlistManager

- (id)init
{
    self = [super init];
    if (self) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self filepath]]) {
            self.history = [[NSArray alloc] initWithContentsOfFile:[self filepath]];
        } else {
            self.history = [NSArray array];
        }
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory
{
    if (_applicationDocumentsDirectory == nil) {
        _applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                                 inDomains:NSUserDomainMask] lastObject];
    }
    
    return _applicationDocumentsDirectory;
}

- (NSString *)filepath
{
    if (_filepath == nil) {
        _filepath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"history.plist"];
    }
    
    return _filepath;
}

- (void)addHistoryItem:(NSString *)text
{
    NSMutableArray *temp = self.history.mutableCopy;
    [temp insertObject:text atIndex:0];
    self.history = temp;
}

- (void)refreshData
{
    self.history = [[NSArray alloc] initWithContentsOfFile:[self filepath]];
}

- (void)save
{
    [self.history writeToFile:[self filepath] atomically:YES];
}

@end
