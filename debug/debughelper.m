//
//  debughelper.m
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  __debugbreak() is from https://stackoverflow.com/questions/44140778/resumable-assert-breakpoint-on-ios
//

#import <Foundation/Foundation.h>

#import "debughelper.h"

#include <sys/sysctl.h>
#include <unistd.h>

#if defined(__APPLE__) && defined(__aarch64__)
#define __debugbreak() __asm__ __volatile__(            \
"   mov    x0, %x0;    \n" /* pid                */ \
"   mov    x1, #0x11;  \n" /* SIGSTOP            */ \
"   mov    x16, #0x25; \n" /* syscall 37 = kill  */ \
"   svc    #0x80       \n" /* software interrupt */ \
"   mov    x0, x0      \n" /* nop                */ \
::  "r"(getpid())                                   \
:   "x0", "x1", "x16", "memory")
#elif defined(__APPLE__) && defined(__arm__)
#define __debugbreak() __asm__ __volatile__(            \
"   mov    r0, %0;     \n" /* pid                */ \
"   mov    r1, #0x11;  \n" /* SIGSTOP            */ \
"   mov    r12, #0x25; \n" /* syscall 37 = kill  */ \
"   svc    #0x80       \n" /* software interrupt */ \
"   mov    r0, r0      \n" /* nop                */ \
::  "r"(getpid())                                   \
:   "r0", "r1", "r12", "memory")
#elif defined(__APPLE__) && (defined(__i386__) || defined(__x86_64__))
#define __debugbreak() __asm__ __volatile__("int $3; mov %eax, %eax")
#else
#error "Unsupported platform while defining __debugbreak()"
#endif


@implementation DebugHelper : NSObject

+ (void) break {
    __debugbreak();
}

+ (void) trap {
    __builtin_trap();
}

+ (bool) isDebuggerAttached {
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag = 0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );    
}

@end
