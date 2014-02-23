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
	/*
	 TODO:
	 * act on selector call of nib button "save". this should not be done in appDelegate!
	 * save defaults
	 */
	
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
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
	} else {
		NSLog(@"No user defaults delegate! No settings saved.");
	}
	
	/* Hide window */
	[[self window] orderOut:self];
}

@end
