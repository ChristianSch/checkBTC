//
//  AppDelegate.m
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "AppDelegate.h"
#import "MtgoxAPI.h"

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	@autoreleasepool
	{
		debug = FALSE;
		
		// >>> set up controllers <<<
		dataController = [[DataController alloc] init];
		userDefaultsController = [[UserDefaultsController alloc] init];
		preferencesWindowController = [[PreferencesWindowController alloc] init];
		
		// >>> set up delegation <<<
		[preferencesWindowController setUserDefaultsDelegate:userDefaultsController];
		[dataController setUserDefaultsControllerDelegate:userDefaultsController];
		
		/* testing */
		// TODO: display warning
	}
}

- (IBAction)terminate:(id)sende
{
	if (debug) NSLog(@"terminate");
	[theTimer invalidate];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	exit(EXIT_SUCCESS);
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
