//
//  AppDelegate.m
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	@autoreleasepool
	{
		// >>> set up controllers <<<
		userDefaultsController = [[UserDefaultsController alloc] init];
		preferencesWindowController = [[PreferencesWindowController alloc] init];
		statusBarController = [[StatusBarController alloc] initWithMenu:self->appMenu];
		
		dataController = [[DataController alloc]
						  initWithUserDefaultsControllerDelegate:userDefaultsController];
		pluginController = [[PluginController alloc] init];
		
		// >>> set up delegation <<<
		[dataController setDisplayDataCallbackDelegate:statusBarController];
		[preferencesWindowController setUserDefaultsDelegate:userDefaultsController];
		[preferencesWindowController setPluginControllerDelegate:pluginController];
		
		// NSString *bundlePath = [pluginController pathForBundleName:[pluginController availableBundles][1]];
		// [pluginController loadBundleAsPluginWithPath:bundlePath];
		// [dataController setDataSource:[pluginController pluginInstance]];
	}
}

#pragma mark - window management
- (IBAction)showAbout:(id)sender
{
	[NSApp orderFrontStandardAboutPanel:self];
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[window orderFrontRegardless];
}

- (IBAction)showPreferences:(id)sender
{
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[window orderFrontRegardless];
	[preferencesWindowController windowMakeKeyAndOrderFront:self];
}

@end