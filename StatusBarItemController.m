//
//  StatusBarItemController.m
//  CheckBTC
//
//  Created by X on 26.01.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import "StatusBarItemController.h"

/*
 TODO: make names consistent: setTextOfStatusBarItem etc.
 */
@implementation StatusBarItemController

- (StatusBarItemController *) init
{
	self = [super init];
	
	if (self != nil) {
		defaultColor = [NSColor blackColor];
	}
	
	return self;
}

#pragma mark - Lifecycle of statusBarItem

- (void) initStatusBarItem:(NSMenu*)appMenu
{
	self->menu = appMenu;
	self->menuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	
	[menuItem setMenu:self->menu];
	[menuItem setHighlightMode:YES];
}

- (void) initStatusBarItemWithNSString:(NSMenu*)appMenu textToSet:(NSString *)text
{
	self->menu = appMenu;
	self->menuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	
	[menuItem setMenu:self->menu];
	[menuItem setAttributedTitle:[[NSAttributedString alloc] initWithString:text]];
	[menuItem setHighlightMode:YES];
}

- (void) initStatusBarItemWithNSStringAndNSColor:(NSMenu*)appMenu textToSet:(NSString *)text colorToSet:(NSColor *)color
{
	self->menu = appMenu;
	self->menuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	
	[menuItem setMenu:self->menu];
	
	NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
	NSAttributedString *astring = [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
	
	[menuItem setAttributedTitle:astring];
	[menuItem setHighlightMode:YES];
}

#pragma mark - Setters

- (void) setText:(NSString *)text
{
	NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:self->defaultColor forKey:NSForegroundColorAttributeName];
	NSAttributedString *astring = [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
	
	[menuItem setAttributedTitle:astring];
}

- (void) setTextWithNSColorAndNSString:(NSString *)text setToColor:(NSColor *)color
{
	NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
	NSMutableAttributedString *astring = [[NSMutableAttributedString alloc] initWithString:text attributes:titleAttributes];
	
	
	[astring addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14.0] range:NSMakeRange(0, [text length])];
	[menuItem setAttributedTitle:astring];
	[menuItem setHighlightMode:YES];
}

- (void) setToolTip:(NSString *)toolTip
{
	[menuItem setToolTip:toolTip];
}

- (void) setColor:(NSColor *)color
{
	[self setTextWithNSColorAndNSString:[[menuItem attributedTitle] string] setToColor:color];
}

#pragma mark - Getters
- (NSColor *) getColor
{
	NSDictionary *attributes = [[menuItem attributedTitle] attributesAtIndex:0 effectiveRange:NULL];
	NSColor *col = (NSColor *)[attributes objectForKey:NSForegroundColorAttributeName];
	
	return col;
}

#pragma mark - Animation
- (void) animateColorToNSColor:(NSColor *)targetColor animSteps:(int)steps animDuration:(float)duration
{
	NSTimeInterval aFrameRate = duration/steps;
	
	/* Set color space to RGB to prevent exceptions */
	NSColor *fColor = [[self getColor] colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
	NSColor *tColor = [targetColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
	
	/* Set up a color for each step */
	NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:steps];
	
	float redDiff = [tColor redComponent] - [fColor redComponent];
	float greenDiff = [tColor greenComponent] - [fColor greenComponent];
	float blueDiff = [tColor blueComponent] - [fColor blueComponent];
	
	float redStep = redDiff / steps;
	float greenStep = greenDiff / steps;
	float blueStep = blueDiff / steps;
	
	int i = 0;
	while (i < steps) {
		[frameArray addObject:[NSColor
						   colorWithCalibratedRed:[fColor redComponent] + i * redStep
						   green:[fColor greenComponent] + i * greenStep
						   blue:[fColor blueComponent] + i * blueStep
						   alpha:1.0]];
		i++;
	}
	
	/* Call animation */
	[self doAnimation:frameArray animFrameRate:aFrameRate];
}

- (void) doAnimation:(NSArray *)colorFrames animFrameRate:(NSTimeInterval)aFrameRate
{
	self->frames = colorFrames;
	self->execCount = 0;
	self->frameRate = aFrameRate;
	
	animationTimer = [NSTimer scheduledTimerWithTimeInterval:frameRate target:self selector:
					  @selector(animateFrame:) userInfo:nil repeats:NO];
}

- (void) animateFrame:(NSTimer *)timer
{
	NSUInteger frameCnt = [self->frames count];
	
	if (self->execCount < frameCnt) {
		NSColor *col = [self->frames objectAtIndex:self->execCount];
		[self setColor:col];
		self->execCount++;
		
		[timer invalidate];
		self->animationTimer = [NSTimer scheduledTimerWithTimeInterval:frameRate target:self selector:
		@selector(animateFrame:) userInfo:nil repeats:NO];
		
	} else {
		// stop timer
		[timer invalidate];
		timer = Nil;
	}
}

#pragma mark - Default animations

- (void) defaultRedToBlackAnimation
{
	// red color by https://github.com/CaptainRedmuff/NSColor-Crayola
	[self setColor:[NSColor colorWithRed:0.933 green:0.125 blue:0.302 alpha:1.0]];
	[self animateColorToNSColor:[NSColor blackColor] animSteps:32 animDuration:5.0];
}

- (void) defaultRedToBlackAnimationWithNSString:(NSString *)text
{
	[self setText:text];
	[self defaultRedToBlackAnimation];
}

- (void) defaultGreenToBlackAnimation
{
	// green color by https://github.com/CaptainRedmuff/NSColor-Crayola
	[self setColor:[NSColor colorWithRed:0.110 green:0.675 blue:0.471 alpha:1.0]];
	[self animateColorToNSColor:[NSColor blackColor] animSteps:32 animDuration:5.0];
}

- (void) defaultGreenToBlackAnimationWithNSString:(NSString *)text
{
	[self setText:text];
	[self defaultGreenToBlackAnimation];
}
@end
