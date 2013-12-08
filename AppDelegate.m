//
//  AppDelegate.m
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "AppDelegate.h"
#import "BlockChainAPI.h"
#import "UserDefs.h"
#import "PreferencesController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	@autoreleasepool {
		debug = TRUE;
		
		/* Get the last saved user defaults */
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		defaultPrefs = [NSMutableDictionary new];
		[defaultPrefs setValue:@"30.0" forKey:@"refreshRate"];
		[defaultPrefs setValue:@"EUR" forKey:@"currency"];
		
		userDefs = [[UserDefs alloc] initWithDefaultPreferences:defaultPrefs];
		
		refreshRate = [userDefs getPreferencesForKey:@"refreshRate"];
		
		menuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
		[menuItem setMenu:_appMenu];
		[menuItem setTitle:@APP_TITLE];
		[menuItem setHighlightMode:YES];
		
		/* Set up the timer that calls causes the refresh of the course */
		NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
		theTimer = [[NSTimer alloc] initWithFireDate:fireDate
											interval:[refreshRate doubleValue]
											  target:self
											selector:@selector(workerMethod:)
											userInfo:nil
											 repeats:YES];
		
		runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:theTimer forMode:NSDefaultRunLoopMode];
		
		/*
		 Register notification observer.
		
		 Bind the "savePreferences" message (name) to the selector "savePreferences"
		 from any object (object:nil).
		 */
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(savePreferences:)
													 name:@"savePreferences"
												   object:nil];
	}
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)terminate:(id)sender {
	if (debug) NSLog(@"terminate");
	[theTimer invalidate];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	exit(EXIT_SUCCESS);
}

- (IBAction)showAbout:(id)sender
{
	[NSApp orderFrontStandardAboutPanel:self];
}

- (IBAction)showPreferences:(id)sender {
	if (debug) NSLog(@"showPreferences");
	
	if (preferencesController == nil) {
		preferencesController = [[PreferencesController alloc] init];
	}
	
	[[preferencesController window] makeKeyAndOrderFront:self];
}

- (void)savePreferences:(NSNotification *)notif
{
	/* TODO: validate dict */
	// [notif userInfo][@"currency"] equals
	// [[notif userInfo] objectForKey:@"currency"]
	if (debug && [userDefs getPreferencesForKey:@"currency"] != [notif userInfo][@"currency"]) {
		NSLog(@"Another currency is being used in the future: %@", [notif userInfo][@"currency"]);
	}
	
	[userDefs setPreferences:[notif userInfo]];
	
	[self refreshTimer];
}

- (void)refreshTimer
{
	if (debug) NSLog(@"invalidate old timer and install new one");
	
	/* invalidate "old" timer */
	[theTimer invalidate];
	
	/* install new timer */
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
	NSTimer *newTimer = [[NSTimer alloc] initWithFireDate:fireDate
										interval:[refreshRate doubleValue]
										  target:self
										selector:@selector(workerMethod:)
										userInfo:nil
										 repeats:YES];
	[runLoop addTimer:newTimer forMode:NSDefaultRunLoopMode];
	theTimer = newTimer;
}

- (void)refreshMenuItemText:(NSString *)newText
{
	[menuItem setTitle:newText];
}

- (void)workerMethod:(NSTimer*)theTimer
{
	NSString *currPref = [userDefs getPreferencesForKey:@"currency"];
	trackerData = [BlockChainAPI getTicker];
	
	// trackerData[currPref] equals
	// [trackerData objectForKey:currPref]
	NSDictionary *curr = trackerData[currPref];
	[self refreshMenuItemText:[NSString stringWithFormat:@"BTC: %@ %@", curr[@"15m"],  curr[@"symbol"]]];
}
@end
