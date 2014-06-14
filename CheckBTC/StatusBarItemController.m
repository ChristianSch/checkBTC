//
//  StatusBarItemController.m
//  CheckBTC
//
//  Created by Christian Schulze on 26.01.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//
#define defFontSize 14.0

#import "StatusBarItemController.h"

@implementation StatusBarItemController

- (StatusBarItemController *)init
{
	self = [super init];
	
	if (self != nil) {
		defaultColor = [NSColor blackColor];
	}
	
	return self;
}

#pragma mark - Lifecycle of statusBarItem

- (void)initStatusBarItem:(NSMenu *)appMenu
{
	menu = appMenu;
	menuItem = [[NSStatusBar systemStatusBar]
					  statusItemWithLength:NSVariableStatusItemLength];
	
	[menuItem setMenu:menu];
	[menuItem setHighlightMode:YES];
}

- (void)initStatusBarItemWithNSString:(NSMenu *)appMenu textToSet:(NSString *)text
{
	menu = appMenu;
	menuItem = [[NSStatusBar systemStatusBar]
					  statusItemWithLength:NSVariableStatusItemLength];
	[menuItem setMenu:menu];

	NSMutableAttributedString *astring = [[NSMutableAttributedString alloc]
										  initWithString:text];
	
	/* set font size */
	[astring addAttribute:NSFontAttributeName
					value:[NSFont systemFontOfSize:defFontSize]
					range:NSMakeRange(0, [text length])];
	
	[menuItem setAttributedTitle:astring];
	[menuItem setHighlightMode:YES];
}

- (void)initStatusBarItemWithNSStringAndNSColor:(NSMenu *)appMenu
									   textToSet:(NSString *)text
									  colorToSet:(NSColor *)color
{
	menu = appMenu;
	menuItem = [[NSStatusBar systemStatusBar]
					  statusItemWithLength:NSVariableStatusItemLength];
	
	[menuItem setMenu:menu];
	
	NSDictionary *titleAttributes = [NSDictionary
									 dictionaryWithObject:color
									 forKey:NSForegroundColorAttributeName];
	NSMutableAttributedString *astring = [[NSMutableAttributedString alloc]
								   initWithString:text
								   attributes:titleAttributes];
	/* set font size */
	[astring addAttribute:NSFontAttributeName
					value:[NSFont systemFontOfSize:defFontSize]
					range:NSMakeRange(0, [text length])];
	
	[menuItem setAttributedTitle:astring];
	[menuItem setHighlightMode:YES];
}

#pragma mark - Setters

- (void)refreshTooltip
{
	/* Set tooltip with refresh time */
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"HH:mm:ss";
	
	[self setToolTip:[@"Refreshed on "
					  stringByAppendingString:[dateFormatter
											   stringFromDate:[NSDate date]]]];
}

- (void)setText:(NSString *)text
{
	NSDictionary *titleAttributes = [NSDictionary
									 dictionaryWithObject:self->defaultColor
									 forKey:NSForegroundColorAttributeName];
	NSMutableAttributedString *astring = [[NSMutableAttributedString alloc]
								   initWithString:text
								   attributes:titleAttributes];
	
	/* set font size */
	[astring addAttribute:NSFontAttributeName
					value:[NSFont systemFontOfSize:defFontSize]
					range:NSMakeRange(0, [text length])];
	
	[menuItem setAttributedTitle:astring];
}

- (void)setTextWithNSColorAndNSString:(NSString *)text setToColor:(NSColor *)color
{
	NSDictionary *titleAttributes = [NSDictionary
									 dictionaryWithObject:color
									 forKey:NSForegroundColorAttributeName];
	NSMutableAttributedString *astring = [[NSMutableAttributedString alloc]
										  initWithString:text attributes:titleAttributes];
	
	
	/* set font size */
	[astring addAttribute:NSFontAttributeName
					value:[NSFont systemFontOfSize:defFontSize]
					range:NSMakeRange(0, [text length])];
	
	[menuItem setAttributedTitle:astring];
	[menuItem setHighlightMode:YES];
}

- (void)setToolTip:(NSString *)toolTip
{
	[menuItem setToolTip:toolTip];
}

- (void)setColor:(NSColor *)color
{
	[self setTextWithNSColorAndNSString:[[menuItem attributedTitle] string]
							 setToColor:color];
}

#pragma mark - Getters

- (NSColor *)color
{
	NSDictionary *attributes = [[menuItem attributedTitle]
								attributesAtIndex:0
								effectiveRange:NULL];
	NSColor *col = (NSColor *)[attributes objectForKey:NSForegroundColorAttributeName];
	
	return col;
}

#pragma mark - Animation

- (void)animateTransitionFromToNSColor:(NSColor *)targetColor
							  animSteps:(int)steps
						   animDuration:(float)duration
{
	NSTimeInterval aFrameRate = duration / steps;
	
	/* Set color space to RGB to prevent exceptions */
	NSColor *fColor = [[self color] colorUsingColorSpace:[NSColorSpace
															 genericRGBColorSpace]];
	NSColor *tColor = [targetColor colorUsingColorSpace:[NSColorSpace
														 genericRGBColorSpace]];
	
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

- (void)doAnimation:(NSArray *)colorFrames animFrameRate:(NSTimeInterval)aFrameRate
{
	frames = colorFrames;
	execCount = 0;
	frameRate = aFrameRate;
	
	animationTimer = [NSTimer
					  scheduledTimerWithTimeInterval:frameRate
					  target:self
					  selector:@selector(animateFrame:) userInfo:nil repeats:NO];
}

- (void)animateFrame:(NSTimer *)timer
{
	NSUInteger frameCnt = [frames count];
	
	if (execCount < frameCnt) {
		NSColor *col = [frames objectAtIndex:self->execCount];
		[self setColor:col];
		execCount++;
		
		[timer invalidate];
		animationTimer = [NSTimer
						  scheduledTimerWithTimeInterval:frameRate
						  target:self
						  selector:@selector(animateFrame:) userInfo:nil repeats:NO];
		
	} else {
		// stop timer
		[timer invalidate];
		timer = Nil;
	}
}

#pragma mark - Default animations

- (void)defaultRedToBlackAnimation
{
	// red color by https://github.com/CaptainRedmuff/NSColor-Crayola
	[self setColor:[NSColor colorWithRed:0.933 green:0.125 blue:0.302 alpha:1.0]];
	[self animateTransitionFromToNSColor:[NSColor blackColor]
							   animSteps:32
							animDuration:5.0];
}

- (void)defaultRedToBlackAnimationWithNSString:(NSString *)text
{
	[self setText:text];
	[self defaultRedToBlackAnimation];
}

- (void)defaultGreenToBlackAnimation
{
	// green color by https://github.com/CaptainRedmuff/NSColor-Crayola
	[self setColor:[NSColor colorWithRed:0.110 green:0.675 blue:0.471 alpha:1.0]];
	[self animateTransitionFromToNSColor:[NSColor blackColor]
							   animSteps:32
							animDuration:5.0];
}

- (void)defaultGreenToBlackAnimationWithNSString:(NSString *)text
{
	[self setText:text];
	[self defaultGreenToBlackAnimation];
}

@end
