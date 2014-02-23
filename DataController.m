//
//  DataController.m
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import "DataController.h"
#import "AIConnectionController.h"
#import "StatusBarController.h"
#import "DataSourceProtocol.h"
#import "DisplayDataCallbackProtocol.h"
#import "UserDefaultsControllerDelegateProtocol.h"

@implementation DataController

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		statusBarController = [[StatusBarController alloc] init];
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
		statusBarController = [[StatusBarController alloc] init];
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

- (void)setUserDefaultsControllerDelegate:(id)delegate
{
	if ([delegate conformsToProtocol:@protocol(UserDefaultsControllerDelegateProtocol)])
	{
		self->userDefaultsControllerDelegate = delegate;
		
	} else {
		NSLog(@"Delegate does not conform to the appropriate protocol!");
	}
}


- (void)didFinishLoading:(NSData *)data
{
	[api handleData:data];
}

- (void)didFailWithError:(NSError *)error
{
	[statusBarController setTextFromError:error];
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
	NSString *currency = [userDefaultsControllerDelegate currency];
	NSNumber *avg = [dataSource getAvgForCurrency:currency];
	
	if (avg != nil)
	{
		// btc sign: B⃦
		NSString *displayTitle = [NSString stringWithFormat:@"BTC: %@ %@",
								  [self formatNumber:avg],
								  [dataSource getCurrencySymbol:currency]];
		
		if ([statusBarController respondsToSelector:@selector(setTextWithAscAnimation:)]
			&&
			[statusBarController respondsToSelector:@selector(setTextWithDescAnimation:)])
		{
			if ([userDefaultsControllerDelegate animateVisualRepresentation])
			{
				if ([self->lastAvg isGreaterThan:avg])
				{
					[statusBarController setTextWithAscAnimation:displayTitle];
					
				} else {
					[statusBarController setTextWithDescAnimation:displayTitle];
				}
			}
			
		} else {
			[statusBarController setText:displayTitle];
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
