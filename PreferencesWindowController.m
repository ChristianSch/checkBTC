//
//  PreferencesController.m
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

#pragma mark - Lifecycle
-(id)init
{
	debug = YES;
	
	self = [super initWithWindowNibName:@"Preferences"];
	if (self) {
		[self loadWindow];
	}
	
	return (self);
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
	
    if (self) {
        [self loadWindow];
    }
	
    return self;
}

#pragma mark - delegates
- (void)setUserDefaultsDelegate:(id<UserDefaultsControllerDelegateProtocol>)delegate
{
	userDefaultsDelegate = delegate;
}

#pragma mark - Event handling
- (void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *rate = [defaults objectForKey:@"refreshRate"];
	NSString *curr = [defaults stringForKey:@"currency"];
	self.startAtLogin = [defaults boolForKey:@"startAtLogin"];
	
	if (rate != nil) {
		if (debug) NSLog(@"rate to set: %f", [rate doubleValue]);
		[_refreshRate setStringValue:[rate stringValue]];
	}
	
	if (curr != nil) {
		if (debug) NSLog(@"curr to set: %@", curr);
		[_currencies selectItemWithTitle:curr];
	}
}

#pragma mark - API to user defaults

- (IBAction)savePrefs:(id)sender
{
	if (userDefaultsDelegate != nil)
	{
		NSString *currency = [[[self currencies] selectedItem] title];
		NSNumber *rRate = @([[self refreshRate] doubleValue]);
		// TODO: validate values
		
		/* Make up the dictionary */
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:currency forKey:@"currency"];
		[dict setValue:rRate forKey:@"refreshRate"];
		[dict setValue:[[NSNumber alloc] initWithBool:[self startAtLogin]] forKey:@"startAtLogin"];
		
		[userDefaultsDelegate setUserDefaultsWithDict:dict];
		
	} else {
		NSLog(@"No user defaults delegate! No settings saved.");
	}
	
	/* Hide window */
	[[self window] orderOut:self];
}

// just backup code from appDelegate. ignore
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
}
@end
