//
//  DataController.m
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import "DataController.h"
#import "AIConnectionController.h"
#import "DataSourceProtocol.h"
#import "DisplayDataCallbackProtocol.h"
#import "UserDefaultsControllerDelegateProtocol.h"

@implementation DataController

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
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

- (void)setUserDefaultsControllerDelegate:
(id<UserDefaultsControllerDelegateProtocol>)delegate
{
	self->userDefaultsControllerDelegate = delegate;
}

- (void)setDisplayDataCallbackDelegate:(id<DisplayDataCallbackProtocol>)delegate
{
	displayDataCallbackDelegate = delegate;
}

- (void)didFinishLoading:(NSData *)data
{
	[api handleData:data];
}

- (void)didFailWithError:(NSError *)error
{
	if (displayDataCallbackDelegate != nil)
		[displayDataCallbackDelegate setTextFromError:error];
	
	else
		NSLog(@"No such delegate");
}

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
	NSString *currency = nil;
	NSNumber *avg = nil;
	
	if (userDefaultsControllerDelegate != nil)
	{
		currency = [userDefaultsControllerDelegate currency];
		avg = [dataSource getAvgForCurrency:currency];
		
	} else {
		NSLog(@"No such delegate");
		return;
	}
	
	if (avg != nil)
	{
		// btc sign: B⃦
		NSString *displayTitle = [NSString stringWithFormat:@"BTC: %@ %@",
								  [self formatNumber:avg],
								  [dataSource getCurrencySymbol:currency]];
		
		if (displayDataCallbackDelegate != nil)
		{
			if ([displayDataCallbackDelegate respondsToSelector:@selector(setTextWithAscAnimation:)]
				&&
				[displayDataCallbackDelegate respondsToSelector:@selector(setTextWithDescAnimation:)])
			{
				if ([userDefaultsControllerDelegate animateVisualRepresentation])
				{
					if ([self->lastAvg isGreaterThan:avg])
					{
						[displayDataCallbackDelegate setTextWithAscAnimation:displayTitle];
						
					} else {
						[displayDataCallbackDelegate setTextWithDescAnimation:displayTitle];
					}
				}
				
			} else {
				[displayDataCallbackDelegate setText:displayTitle];
			}
		} else {
			NSLog(@"No such delegate");
		}
		
		self->lastAvg = avg;
		
	} else {
		NSLog(@"No data recieved!");
	}
}

- (NSString*)formatNumber:(NSNumber*)number
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setPositiveFormat:@"####.####"];
	return [numberFormatter stringFromNumber:number];
}
@end
