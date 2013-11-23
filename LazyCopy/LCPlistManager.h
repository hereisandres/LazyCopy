//
//  LCPlistManager.h
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPlistManager : NSObject

@property (strong, nonatomic, readonly) NSArray *history;

- (void)addHistoryItem:(NSString *)text;
- (void)refreshData;
- (void)save;

@end
