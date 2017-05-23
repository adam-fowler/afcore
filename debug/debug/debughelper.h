//
//  debughelper.h
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

#ifndef debughelper_h
#define debughelper_h

@interface DebugHelper : NSObject

+ (void) break;
+ (void) trap;
+ (bool) isDebuggerAttached;
@end

#endif /* debughelper_h */
