//
//  DataController.m
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import "DataController.h"
#import "MtgoxAPI.h"

@implementation DataController

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		/* init models */
		mtgoxAPI = [[MtgoxAPI alloc] init];
		
		/* init controllers and delegates */
		connectionController = [[AIConnectionController alloc] init];
		[connectionController setCallbackDelegate:self];
		userDefaultsControllerDelegate = nil;
		
		/*
		 The controller does nothing until a userDefaultsControllerDelegate is provided
		 */
		theTimer = nil;
		runLoop = nil;
		lastAvg = @0;
	}
	
	return self;
}

- (id)initWithUserDefaultsControllerDelegate:(id<UserDefaultsControllerDelegateProtocol>)delegate
{
	self = [super init];
	
	if (self != nil)
	{
		/* init models */
		mtgoxAPI = [[MtgoxAPI alloc] init];
		
		/* init controllers and delegates */
		connectionController = [[AIConnectionController alloc] init];
		[connectionController setCallbackDelegate:self];
		userDefaultsControllerDelegate = delegate;
		
		/* Set up the timer that causes the refresh of the course */
		NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
		theTimer = [[NSTimer alloc] initWithFireDate:fireDate
											interval:[userDefaultsControllerDelegate
													  dataRefreshRate]
											  target:self
											selector:@selector(workerMethod:)
											userInfo:nil
											 repeats:YES];
		runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:theTimer forMode:NSDefaultRunLoopMode];
	}
	
	return self;
}

#pragma mark - delegations

- (void)setUserDefaultsControllerDelegate:
(id<UserDefaultsControllerDelegateProtocol>)delegate
{
	self->userDefaultsControllerDelegate = delegate;
}

- (void)setDisplayDataCallbackDelegate:(id<DisplayDataCallbackProtocol>)delegate
{
	displayDataCallbackDelegate = delegate;
}

#pragma mark - AIConnectionControllerDelegateProtocol implementations

- (void)didFinishLoading:(NSData *)data
{
	[mtgoxAPI handleData:data];
	[self updateDisplay];
}

- (void)didFailWithError:(NSError *)error
{
	if (displayDataCallbackDelegate != nil)
		[displayDataCallbackDelegate setTextFromError:error];
	
	else
		NSLog(@"No such delegate");
}

#pragma mark - timer methods

- (void)refreshTimer:(double)rate
{
	/* invalidate "old" timer */
	[theTimer invalidate];
	
	/* install new timer */
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
	NSTimer *newTimer = [[NSTimer alloc] initWithFireDate:fireDate
												 interval:rate
												   target:self
												 selector:@selector(workerMethod:)
												 userInfo:nil
												  repeats:YES];
	
	[runLoop addTimer:newTimer forMode:NSDefaultRunLoopMode];
	theTimer = newTimer;
}

- (void)workerMethod:(NSTimer*)theTimer
{
	if (userDefaultsControllerDelegate != nil)
	{
		NSString *currency = [userDefaultsControllerDelegate currency];
		/* TODO: this should be executed as a callback to received data */
		NSURL *url = [mtgoxAPI dataURLForCurrency:currency];
		[connectionController makeConnectionWithURL:url];
		
	} else {
		NSLog(@"No userDefaultsControllerDelegate!");
	}
}

#pragma mark - display retrieved data

- (void)updateDisplay
{
	if (userDefaultsControllerDelegate != nil)
	{
		if (displayDataCallbackDelegate == nil)
		{
			NSLog(@"No displayDataCallbackDelegate");
			return;
		}
		
		NSString *currency = [userDefaultsControllerDelegate currency];
		NSNumber *avg = [mtgoxAPI getAvgForCurrency:currency];
		
		if (avg != nil && currency != nil)
		{
			// btc sign: B⃦
			NSString *displayTitle = [NSString stringWithFormat:@"BTC: %@ %@",
									  [self formatNumber:avg],
									  [mtgoxAPI getCurrencySymbol:currency]];
			
			/* these needs to be checked because those selectors are declared as optional
			 in the protocol */
			if ([displayDataCallbackDelegate
				 respondsToSelector:@selector(setTextWithAscAnimation:)]
				&&
				[displayDataCallbackDelegate
				 respondsToSelector:@selector(setTextWithDescAnimation:)])
			{
				if ([userDefaultsControllerDelegate animateVisualRepresentation])
				{
					if ([self->lastAvg isGreaterThan:avg])
					{
						[displayDataCallbackDelegate
						 setTextWithAscAnimation:displayTitle];
						
					} else {
						[displayDataCallbackDelegate
						 setTextWithDescAnimation:displayTitle];
					}
				}
				
			} else {
				/* this one is requires, thus this is the fall back */
				[displayDataCallbackDelegate setText:displayTitle];
			}
			
			self->lastAvg = avg;
		}
	} else {
		NSLog(@"No userDefaultsControllerDelegate");
	}
}

#pragma mark - helper methods

- (NSString*)formatNumber:(NSNumber*)number
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setPositiveFormat:@"####.####"];
	return [numberFormatter stringFromNumber:number];
}
@end
