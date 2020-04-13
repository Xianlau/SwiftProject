#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BayMaxCatchError.h"
#import "BayMaxCFunctions.h"
#import "BayMaxDebugView.h"
#import "BayMaxDegradeAssist.h"
#import "BayMaxKVODelegate.h"
#import "BayMaxProtector.h"
#import "BayMaxTimerSubTarget.h"
#import "BayMaxWeakProxy.h"
#import "BayMaxContainers.h"

FOUNDATION_EXPORT double BayMaxProtectorVersionNumber;
FOUNDATION_EXPORT const unsigned char BayMaxProtectorVersionString[];

