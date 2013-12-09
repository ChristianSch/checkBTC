//
//  PreferencesController.m
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

-(id)init
{
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

- (void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *rate = [defaults objectForKey:@"refreshRate"];
	NSString *curr = [defaults stringForKey:@"currency"];
	
	if (rate != nil) {
		NSLog(@"rate to set: %@", rate);
		[_refreshRate setStringValue:rate];
	}
	
	if (curr != nil) {
		NSLog(@"curr to set: %@", curr);
		[_currencies selectItemWithTitle:curr];
	}
	NSLog(@"fin.");
}

- (IBAction)savePrefs:(id)sender
{
	/*
	 TODO:
		* get preferences and set TextField and PopUpButton accordingly
	 */
	
	NSString *currency = [[[self currencies] selectedItem] title];
	// equals [[NSNumber alloc] initWithDouble:[[self refreshRate] doubleValue]]
	NSNumber *rRate = @([[self refreshRate] doubleValue]);

	/* Check refresh rate for validity. */
	if ([rRate doubleValue] < 10.0) {
		NSLog(@"Setting refresh rate to 10.0 because of invalid input.");
		
		// equals [[NSNumber alloc] initWithDouble:10.0]
		rRate = @10.0;
	}
	
	/* Make up the dictionary */
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:currency forKey:@"currency"];
	[dict setValue:rRate forKey:@"refreshRate"];
	
	/* Send notification to all objects listening to the savePreferences method (That'd be only the AppDelegate) for saving. */
	[[NSNotificationCenter defaultCenter] postNotificationName:@"savePreferences"
														object:self
													  userInfo:dict];
	
	/* Hide window */
	[[self window] orderOut:self];
}
@end
