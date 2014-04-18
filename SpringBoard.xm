//
//  SpringBoard.xm
//  AppEx
//
//
//  Originally from MessageBox (github.com/b3ll/MessageBox)
//
//  SpringBoard.xm
//  MessageBox
//
//  Created by Adam Bell on 2014-02-04.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "appex.h"

/**
 * SpringBoard Hooks
 *
 */

static BKSProcessAssertion *_keepAlive;

%group SpringBoardHooks

static void appLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [[%c(SBUIController) sharedInstance] appex_stopBackgrounding];
}

%hook SBWorkspace

- (void)workspace:(id)arg1 applicationSuspended:(NSString *)bundleIdentifier withSettings:(id)arg3 {
    if ([bundleIdentifier isEqualToString:@"jp.pioneer.mbg.cargateway.carhome"]) {
        [[%c(SBUIController) sharedInstance] appex_startBackgrounding];
    }
    
    %orig;
}

%end

%hook SBUIController

%new
- (void)appex_startBackgrounding {
    int appradioPID = PIDForProcessNamed(@"AppRadio");
    if (appradioPID == 0)
        return;
    
    if (_keepAlive != nil)
        [_keepAlive invalidate];
    
    _keepAlive = [[%c(BKSProcessAssertion) alloc] initWithPID:appradioPID
                                                               flags:(ProcessAssertionFlagPreventSuspend |
                                                                      ProcessAssertionFlagAllowIdleSleep |
                                                                      ProcessAssertionFlagPreventThrottleDownCPU |
                                                                      ProcessAssertionFlagWantsForegroundResourcePriority)
                                                              reason:kProcessAssertionReasonBackgroundUI
                                                                name:@"epichax"
                                                         withHandler:^void (void)
                  {
                      DebugLog(@"APPRADIO PID: %d kept alive: %@", appradioPID, [_keepAlive valid] > 0 ? @"TRUE" : @"FALSE");
                  }];
}

%new
- (void)appex_stopBackgrounding {
    if (_keepAlive != nil) {
        // Kill the BKSProcessAssertion because it isn't needed anymore
        // Not sure if creating / removing it is necessary but I'd like to keep it as stock as possible when in app)
        
        [_keepAlive invalidate];
        _keepAlive = nil;
    }
}

%end

%end
