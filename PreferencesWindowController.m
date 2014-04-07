//
//  PreferencesController.m
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

@synthesize PluginHelpPopoverController;

#pragma mark - Lifecycle
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

#pragma mark - delegates
- (void)setUserDefaultsDelegate:(id<UserDefaultsControllerDelegateProtocol>)delegate
{
	userDefaultsDelegate = delegate;
}

- (void)setPluginControllerDelegate:(id<PluginControllerDelegateProtocol>)delegate
{
	pluginControllerDelegate = delegate;
}

#pragma mark - Event handling
- (void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *rate = [defaults objectForKey:@"refreshRate"];
	NSString *curr = [defaults stringForKey:@"currency"];
	self.startAtLogin = [defaults boolForKey:@"startAtLogin"];
	
	if (rate != nil)
		[_refreshRate setStringValue:[rate stringValue]];
	
	if (curr != nil)
		[_currencies selectItemWithTitle:curr];
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
		[dict setValue:[[NSNumber alloc] initWithBool:[self startAtLogin]]
				forKey:@"startAtLogin"];
		
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
	
	if (![curr isEqualToString:[defaults stringForKey:@"currency"]])
	{
		[defaults removeObjectForKey:@"currency"];
		[defaults setObject:curr forKey:@"currency"];
		
		changed = YES;
		
	} else if ([rate doubleValue] != [[defaults objectForKey:@"refreshRate"] doubleValue])
	{
		[defaults removeObjectForKey:@"refreshRate"];
		[defaults setObject:rate forKey:@"refreshRate"];
		
		changed = YES;
		
	} else if (startAtLogin) {
		[defaults setBool:YES forKey:@"startAtLogin"];
	}
	
	/* TODO: really save them */
	// placeholder:
	if (changed) NSLog(@"New preferences will be ignored due to missing implementaitons");
}

- (IBAction)showPluginHelp:(id)sender
{
	[[self popover] showRelativeToRect:[sender bounds]
								ofView:sender
						 preferredEdge:NSMaxYEdge];
}

- (IBAction)showPluginFolderInFinder:(id)sender
{
	NSURL * dirURL = [[NSURL alloc] initFileURLWithPath:@"/Applications"];
	[[NSWorkspace sharedWorkspace] openURL: dirURL];
}
@end
