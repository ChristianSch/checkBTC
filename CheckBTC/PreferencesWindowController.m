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
- (void)windowMakeKeyAndOrderFront:(id)sender
{
	NSNumber *rate = [userDefaultsDelegate userDefaultForKey:refreshRateKey];
	NSString *curr = [userDefaultsDelegate userDefaultForKey:currencyKey];
	self.startAtLogin = (BOOL) [userDefaultsDelegate userDefaultForKey:startAtLoginKey];
	NSString *bundle = [pluginControllerDelegate bundleInUse];
	
	if (rate != nil)
		[_refreshRate setStringValue:[rate stringValue]];
	
	if (curr != nil)
		[_currencies selectItemWithTitle:curr];
	
	/* fill pop up button with available marketplaces */
	if (pluginControllerDelegate)
	{
		NSArray *availableBundles = [pluginControllerDelegate availableBundles];
		
		if ([availableBundles count] > 0)
		{
			[_currencies setEnabled:YES];
			[_bundlePopup setEnabled:YES];
			
			for (int i = 0; i < [availableBundles count]; i++)
			{
				if (![[_arrayController content] containsObject:availableBundles[i]])
				{
					[_arrayController addObject:availableBundles[i]];
				}
			}
			
			/* select the bundle set in the user defaults */
			if (bundle != nil)
				[_bundlePopup selectItemWithTitle:bundle];
			
		} else {
			[_currencies setEnabled:NO];
			[_bundlePopup setEnabled:NO];
		}
		
	} else {
		NSLog(@"no such plugin delegate!");
	}
	
	[[self window] makeKeyAndOrderFront:sender];
}

#pragma mark - API to user defaults

- (IBAction)savePrefs:(id)sender
{
	if (userDefaultsDelegate != nil)
	{
		NSString *currency = [[[self currencies] selectedItem] title];
		NSNumber *rRate = @([[self refreshRate] doubleValue]);
		
		/* Make up the dictionary */
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		
		[dict setValue:currency forKey:currencyKey];
		[dict setValue:rRate forKey:refreshRateKey];
		[dict setValue:[[NSNumber alloc] initWithBool:[self startAtLogin]]
				forKey:startAtLoginKey];
		[dict setValue:[[NSNumber alloc] initWithBool:[self animatePriceChanges]]
				forKey:animationKey];
		
		[userDefaultsDelegate userDefaultsWithDict:dict];
		
	} else {
		NSLog(@"No user defaults delegate! No settings saved.");
	}
	
	/* Hide window */
	[[self window] orderOut:self];
}

- (IBAction)showOpenFileDialog:(id)sender
{
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
	
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
	
	NSArray* fileTypes = @[@"bundle"];
	[openDlg setAllowedFileTypes:fileTypes];
	
	// Change "Open" dialog button to "Add"
	[openDlg setPrompt:@"Add"];
	
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
		
        // Loop through all the files and process them.
        for( int i = 0; i < [files count]; i++ )
        {
            NSURL* fileName = [files objectAtIndex:i];
			
			if ([pluginControllerDelegate fileIsValidBundle:[fileName path]])
			{
				NSError *error = nil;
				BOOL success = [pluginControllerDelegate
								addBundleToResourcesDirectory:[fileName path]
								withError:&error];
				
				if (success != YES)
					[NSApp presentError:error];
			}
        }
    }
}

@end
