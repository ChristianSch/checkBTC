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
#import "StatusBarItemController.h"

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
		
		/* If the user deleted the app from the login list, then this should not be checked in preferences. Check whether this changed or not. Update the user defaults accordingly. */
		[defaults setBool:[self isLoginItem] forKey:@"startAtLogin"];
		if (debug) NSLog(@"startAtLogin initial: %hhd", [defaults boolForKey:@"startAtLogin"]);
		
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
		
		/* set up the statusBarItemController and set displayed text to the title of the app */
		statusBarItemController = [[StatusBarItemController alloc] init];
		[statusBarItemController initStatusBarItemWithNSString:self->_appMenu textToSet:APP_TITLE];
		
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
		
		/* init last average */
		last = [NSNumber numberWithInt:0];
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
	BOOL changed = NO;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *curr = [notif userInfo][@"currency"];
	NSString *rate = [notif userInfo][@"refreshRate"];
	BOOL startAtLogin = [[[notif userInfo] objectForKey:@"startAtLogin"] boolValue];
	
	if (![curr isEqualToString:[defaults stringForKey:@"currency"]]) {
		[defaults removeObjectForKey:@"currency"];
		[defaults setObject:curr forKey:@"currency"];
		
		changed = YES;
		if (debug) NSLog(@"updated currency: %@", curr);
		
	} else if ([rate doubleValue] != [[defaults objectForKey:@"refreshRate"] doubleValue]) {
		[defaults removeObjectForKey:@"refreshRate"];
		[defaults setObject:rate forKey:@"refreshRate"];
		
		changed = YES;
		if (debug) NSLog(@"updated rate: %f", [rate doubleValue]);
		
	} else if (startAtLogin) {
		[defaults setBool:YES forKey:@"startAtLogin"];
		if (debug) NSLog(@"start at login");
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

- (void)workerMethod:(NSTimer*)theTimer
{
	NSNumber *avg = [MtgoxAPI getAvgForCurrency:[[NSUserDefaults standardUserDefaults] stringForKey:@"currency"]];
	NSString *sym = [MtgoxAPI getCurrencySymbol:[[NSUserDefaults standardUserDefaults] stringForKey:@"currency"]];
	
	if (avg != nil) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setPositiveFormat:@"####.####"];
		
		NSString *formattedAvg = [numberFormatter stringFromNumber:avg];

		// animate if the course changed
		if ([self->last isGreaterThan:avg]) {
			[statusBarItemController defaultRedToBlackAnimationWithNSString:[NSString stringWithFormat:@"BTC: %@ %@", formattedAvg,  sym]];
		} else if ([self->last isLessThan:avg]) {
			[statusBarItemController defaultGreenToBlackAnimationWithNSString:[NSString stringWithFormat:@"BTC: %@ %@", formattedAvg,  sym]];
		}
		
		self->last = avg;
		
		/* Set tooltip with refresh time */
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"HH:mm:ss";
		
		[statusBarItemController setToolTip:[@"Refreshed exchange rate on " stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]]];
		
	} else {
		if (debug) NSLog(@"No data recieved!");
	}
}

-(BOOL)isLoginItem
{
	NSString *itemURL = [[NSBundle mainBundle] bundlePath];
	CFURLRef url = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:itemURL]);
	
	/* Add the login item to the current users login */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
															kLSSharedFileListSessionLoginItems,
															NULL);
	if (loginItems) {
		UInt32 seedValue;
		//Retrieve the list of Login Items and cast them to
		// a NSArray so that it will be easier to iterate.
		NSArray  *loginItemsArray = (NSArray *)CFBridgingRelease(LSSharedFileListCopySnapshot(loginItems, &seedValue));
		int i;
		for(i = 0 ; i < [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)CFBridgingRetain([loginItemsArray
																						 objectAtIndex:i]);
			//Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(NSURL*)CFBridgingRelease(url) path];
				if ([urlPath isEqualToString:itemURL]){
					/* release core foundation object */
					CFRelease(url);
					
					if (debug) NSLog(@"isLoginitem");
					return YES;
				}
			}
		}
	}
	/* release core foundation object */
	CFRelease(url);
	return NO;
}
@end
