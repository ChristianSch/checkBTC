//
//  StatusBarItemController.h
//  CheckBTC
//
//  Created by Christian Schulze on 26.01.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusBarItemController : NSObject
{
	NSMenu *menu;
	NSStatusItem *menuItem;
	
	NSColor *defaultColor;
	
	// Values for animation
	NSUInteger execCount;
	NSTimeInterval frameRate;
	NSArray *frames;
	NSTimer *animationTimer;
}

- (StatusBarItemController *) init;

/*!
 @abstract Initiate the status bar item without any text
 */
- (void) initStatusBarItem:(NSMenu *)appMenu;

/*!
 @abstract Initiate the status bar item with the given text using the default color
 @param text Text to set
 */
- (void) initStatusBarItemWithNSString:(NSMenu*)appMenu textToSet:(NSString *)text;

/*!
 @abstract Initiate status bar item with text and color
 @param text Text to set
 @param color Color to set the text in
 */
- (void) initStatusBarItemWithNSStringAndNSColor:(NSMenu*)appMenu textToSet:(NSString *)text colorToSet:(NSColor *)color;

/*!
 @abstract Set the text displayed in the status bar. The used color is the default color
 @param newText text to display
 */
- (void)setText:(NSString *)text;

/*!
 @abstract Set text with specific color
 @param text Text to set
 @param color Color to set the text in
 */
- (void) setTextWithNSColorAndNSString:(NSString *)text setToColor:(NSColor *)color;

/*!
 @abstract Set tool tip of statusBarItem
 @param toolTip Tool tip to display
 */
- (void) setToolTip:(NSString *)toolTip;

/*
 @abstract Set color of text
 @param color Color to set the text in
 */
- (void) setColor:(NSColor *)color;

/*!
 @abstract Retrieve the color of the statusItem if set with NSAttributedString
 @return color
 @discussion returns Nil if there is no color set. (Could happen if the string is set with MenuItem.setText())
 */
- (NSColor *) getColor;

/*!
 @abstract Fade the color of the statusItem to targetColor
 @param target Color color to fade to
 @param steps Number of steps the animation does (framerate)
 @param duration Duration of animation
 */
- (void) animateTransitionFromToNSColor:(NSColor *)targetColor animSteps:(int)steps animDuration:(float)duration;

/*
 @abstract Execute animation
 @param colorFrames NSColor to set for every step
 @param frameRate Time to wait untill the next change of color
 @discussion frameRate should be something like 0.15s to look smooth. After $frameRate seconds have elapsed, the next color (or frame) will be set.
 */
- (void) doAnimation:(NSArray *)colorFrames animFrameRate:(NSTimeInterval)aFrameRate;

/*
 @abstract Fade the color of the statusItem from the default red to black
 */
- (void) defaultRedToBlackAnimation;

/*
 @abstract Set the statusItem text to `text` and call [self defaultRedToBlackAnimation];
 @param text Text to set the statusItem to
 */
- (void) defaultRedToBlackAnimationWithNSString:(NSString *)text;

/*
 @abstract Fade the color of the statusItem from the default green to black
 */
- (void) defaultGreenToBlackAnimation;

/*
 @abstract Set the statusItem text to `text` and call [self defaultGreenToBlackAnimation];
 @param text Text to set the statusItem to
 */
- (void) defaultGreenToBlackAnimationWithNSString:(NSString *)text;

@end
