//
//  assert.m
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "assert.h"

@implementation Assert : NSObject

- (void) __debugbreak {
    __asm__ ("int $3");
}

@end
