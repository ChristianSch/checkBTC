//
//  StatusBarController.m
//  CheckBTC
//
//  Created by X on 20.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#define APP_TITLE @"CheckBTC"

#import "StatusBarController.h"

@implementation StatusBarController

- (id)init:(NSMenu *)appMenu
{
	self = [super init];
	
	if (self != nil) {
		lastUsedValue = [NSNumber numberWithInt:0];
		_appMenu = appMenu;
		itemController = [[StatusBarItemController alloc] init];
		
		[itemController initStatusBarItemWithNSString:self->_appMenu textToSet:APP_TITLE];
		
		warningItem = nil;
	}
	
	return self;
}

- (void)showWarningWithMessage:(NSString *)message
{
	/* Set up the image */
	NSImage *warningImage = [NSImage imageNamed:NSImageNameCaution];
	[warningImage setScalesWhenResized: YES];
    [warningImage setSize: NSMakeSize(16, 16)];

	if (warningItem == nil)
		warningItem = [[NSMenuItem alloc] init];

	/* add to menu */
	[warningItem setImage:warningImage];
	[warningItem setTitle:message];
	[_appMenu insertItem:warningItem atIndex:0];
}

- (void)clearWarning
{
	if (warningItem != nil && [_appMenu itemAtIndex:0] == warningItem)
		[_appMenu removeItem:warningItem];
}

#pragma mark - update contents of the status item

- (void)setTextWithDescAnimation:(NSString *)text
{
	[itemController defaultRedToBlackAnimationWithNSString:text];
}

- (void)setTextWithAscAnimation:(NSString *)text
{
	[itemController defaultGreenToBlackAnimationWithNSString:text];
}

- (void)setText:(NSString *)text
{
	[itemController setText:text];
}


@end
