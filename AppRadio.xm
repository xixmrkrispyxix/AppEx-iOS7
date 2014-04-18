//
//  AppRadio.xm
//  AppEx
//
//
//  Originally from MessageBox (github.com/b3ll/MessageBox)
//
//  Facebook.xm
//  MessageBox
//
//  Created by Adam Bell on 2014-03-29.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "appex.h"

%group AppRadioHooks

%hook PLWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (UIWindow *window in application.windows) {
        [window setKeepContextInBackground:YES];
    }
    
    return %orig;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    notify_post("com.decaro.appradioextensions.appLaunching");
    DebugLog(@"APPRADIO OPENING");
    
    // TODO: fix the menu on the head unit after coming out of the background

    %orig();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Don't let the AppRadio app close its connection with the head unit
    // TODO: This should be done in a better way
    DebugLog(@"APPRADIO BACKGROUNDED");
}

%end

%end
