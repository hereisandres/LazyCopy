//
//  main.m
//  LazyCopy
//
//  Created by Andres Lopez on 11/22/13.
//  Copyright (c) 2013 Hundred10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pixate/Pixate.h>

#import "LCAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [Pixate licenseKey:@"QGFN9-O9478-H7JKS-V93T6-I8L23-3F3O4-2LHJ4-3RMDB-8JPT0-BSOUQ-V95DO-ECB39-3A79L-5KRSS-M8GE9-50"
                   forUser:@"lopeza511@gmail.com"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([LCAppDelegate class]));
    }
}
