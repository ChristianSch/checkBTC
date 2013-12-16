//
//  AppDelegate.m
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "AppDelegate.h"
#import "MtgoxAPI.h"
#import "PreferencesController.h"

#define CURRENCYDEF @"EUR"
#define REFRESHRATEDEF @90.0

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	@autoreleasepool {
		debug = FALSE;
		
		/* Get the last saved user defaults */
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		/* Check if currency and refreshRate were set. If not set defaults. */
		currency = [defaults objectForKey:@"currency"];
		
		if (currency == nil && [currency length] <= 2) {
			currency = CURRENCYDEF;
			if (debug) NSLog(@"set default rate: %@", currency);
		} else {
			if (debug) NSLog(@"set saved currency: %@", currency);
		}
		
		refreshRate = [defaults objectForKey:@"refreshRate"];
		if (refreshRate == nil && [refreshRate doubleValue] < 10.0) {
			refreshRate = REFRESHRATEDEF;
			if (debug) NSLog(@"set default rate: %f", [refreshRate doubleValue]);
		} else {
			if (debug) NSLog(@"set saved rate: %f", [refreshRate doubleValue]);
		}
		
		menuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
		[menuItem setMenu:_appMenu];
		[menuItem setTitle:APP_TITLE];
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
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self.window orderFrontRegardless];

}

- (IBAction)showPreferences:(id)sender {
	if (debug) NSLog(@"showPreferences");
	
	if (preferencesController == nil) {
		preferencesController = [[PreferencesController alloc] init];
	}
	
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self.window orderFrontRegardless];
	[[preferencesController window] makeKeyAndOrderFront:self];
}

- (void)savePreferences:(NSNotification *)notif
{
	BOOL changed = FALSE;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *curr = [notif userInfo][@"currency"];
	NSString *rate = [notif userInfo][@"refreshRate"];

	if (![curr isEqualToString:[defaults stringForKey:@"currency"]]) {
		[defaults removeObjectForKey:@"currency"];
		[defaults setObject:curr forKey:@"currency"];
		
		changed = TRUE;
		if (debug) NSLog(@"updated currency: %@", curr);
	} else if ([rate doubleValue] != [[defaults objectForKey:@"refreshRate"] doubleValue]) {
		[defaults removeObjectForKey:@"refreshRate"];
		[defaults setObject:rate forKey:@"refreshRate"];
		
		changed = TRUE;
		if (debug) NSLog(@"updated rate: %f", [rate doubleValue]);
	}
	
	if (changed) [self refreshTimer:[rate doubleValue]];
}

- (void)refreshTimer:(double)rate
{
	if (debug) NSLog(@"invalidate old timer and install new one");
	
	/* invalidate "old" timer */
	[theTimer invalidate];
	
	/* install new timer */
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
	NSTimer *newTimer = [[NSTimer alloc] initWithFireDate:fireDate
										interval:rate
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
	NSNumber *avg = [MtgoxAPI getAvgForCurrency:[[NSUserDefaults standardUserDefaults] stringForKey:@"currency"]];
	NSString *sym = [MtgoxAPI getCurrencySymbol:[[NSUserDefaults standardUserDefaults] stringForKey:@"currency"]];
	
	if (avg != nil) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setPositiveFormat:@"####.####"];
		
		NSLog(@"Avg: %@", avg);
		NSString *formattedAvg = [numberFormatter stringFromNumber:avg];
		[self refreshMenuItemText:[NSString stringWithFormat:@"BTC: %@ %@", formattedAvg,  sym]];
		
		/* Set tooltip with refresh time */
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"HH:mm:ss";
		
		[menuItem setToolTip:[@"Refreshed exchange rate on " stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]]];
	} else {
		if (debug) NSLog(@"No data recieved!");
	}
}
@end
