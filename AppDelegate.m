//
//  AppDelegate.m
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	@autoreleasepool
	{
		// >>> set up controllers <<<
		userDefaultsController = [[UserDefaultsController alloc] init];
		preferencesWindowController = [[PreferencesWindowController alloc] init];
		statusBarController = [[StatusBarController alloc] initWithMenu:self->_appMenu];
		
		dataController = [[DataController alloc] initWithUserDefaultsControllerDelegate:userDefaultsController];
		
		// >>> set up delegation <<<
		[dataController setDisplayDataCallbackDelegate:statusBarController];
		[preferencesWindowController setUserDefaultsDelegate:userDefaultsController];
	}
}

#pragma mark - window management
- (IBAction)showAbout:(id)sender
{
	[NSApp orderFrontStandardAboutPanel:self];
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self.window orderFrontRegardless];
}

- (IBAction)showPreferences:(id)sender
{
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self.window orderFrontRegardless];
	[[preferencesWindowController window] makeKeyAndOrderFront:self];
}

@end