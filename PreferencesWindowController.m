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

#pragma mark - API to preferences

- (IBAction)savePrefs:(id)sender
{
	/*
	 TODO:
	 * get preferences and set TextField and PopUpButton accordingly
	 * act on selector call. this should not be done in appDelegate!
	 */
	
	NSString *currency = [[[self currencies] selectedItem] title];
	NSNumber *rRate = @([[self refreshRate] doubleValue]);
	
	/* Check refresh rate for validity. */
	if ([rRate doubleValue] < 10.0) {
		if (debug) NSLog(@"Setting refresh rate to 10.0 because of invalid input.");
		rRate = @10.0;
	}
	
	/* Make up the dictionary */
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:currency forKey:@"currency"];
	[dict setValue:rRate forKey:@"refreshRate"];
	[dict setValue:[[NSNumber alloc] initWithBool:[self startAtLogin]] forKey:@"startAtLogin"];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL oldStatus = [defaults boolForKey:@"startAtLogin"];
	
	if (debug) NSLog(@"oldStatus: %hhd", oldStatus);
	if (debug) NSLog(@"startAtLogin: %hhd", self->_startAtLogin);
	
	if (oldStatus != self->_startAtLogin) {
		if (self->_startAtLogin) {
			
		} else {
			
		}
	}
	
	/* Send notification to all objects listening to the savePreferences method (That'd be only the AppDelegate) for saving. */
	[[NSNotificationCenter defaultCenter] postNotificationName:@"savePreferences"
														object:self
													  userInfo:dict];
	/* Hide window */
	[[self window] orderOut:self];
}

@end
