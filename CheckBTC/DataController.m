//
//  DataController.m
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import "DataController.h"

@implementation DataController

@synthesize dataSource;

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		/* init controllers and delegates */
		connectionController = [[AIConnectionController alloc] init];
		[connectionController setCallbackDelegate:self];
		_userDefaultsControllerDelegate = nil;
		
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
		/* init controllers and delegates */
		connectionController = [[AIConnectionController alloc] init];
		[connectionController setCallbackDelegate:self];
		_userDefaultsControllerDelegate = delegate;
		
		/* Set up the timer that causes the refresh of the course */
		NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
		theTimer = [[NSTimer alloc] initWithFireDate:fireDate
											interval:[_userDefaultsControllerDelegate
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

#pragma mark - AIConnectionControllerDelegateProtocol implementations

- (void)didFinishLoading:(NSData *)data
{
	[dataSource handleData:data];
	[self updateDisplay];
}

- (void)didFailWithError:(NSError *)error
{
	if (_displayDataCallbackDelegate != nil)
	{
		[_displayDataCallbackDelegate setTextFromError:error];
		
	} else {
		NSLog(@"No such delegate");
	}
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
	if (_userDefaultsControllerDelegate != nil)
	{
		NSString *currency = [_userDefaultsControllerDelegate currency];
		/* TODO: this should be executed as a callback to received data */
		NSURL *url = [dataSource dataURLForCurrency:currency];
		[connectionController makeConnectionWithURL:url];
		
	} else {
		NSLog(@"No userDefaultsControllerDelegate!");
	}
}

#pragma mark - display retrieved data

- (void)updateDisplay
{
	if (_userDefaultsControllerDelegate != nil)
	{
		if (_displayDataCallbackDelegate == nil)
		{
			NSLog(@"No displayDataCallbackDelegate");
			return;
		}
		
		NSString *currency = [_userDefaultsControllerDelegate currency];
		NSNumber *avg = [dataSource avgForCurrency:currency];
		
		if (avg != nil && currency != nil)
		{
			// btc sign: B⃦
			NSString *displayTitle = [NSString stringWithFormat:@"BTC: %@ %@",
									  [self formatNumber:avg],
									  [dataSource currencySymbol:currency]];
			
			/* these needs to be checked because those selectors are declared as optional
			 in the protocol */
			if ([_displayDataCallbackDelegate
				 respondsToSelector:@selector(setTextWithAscAnimation:)]
				&&
				[_displayDataCallbackDelegate
				 respondsToSelector:@selector(setTextWithDescAnimation:)])
			{
				if ([_userDefaultsControllerDelegate animateVisualRepresentation])
				{
					if ([self->lastAvg isGreaterThan:avg])
					{
						[_displayDataCallbackDelegate
						 setTextWithAscAnimation:displayTitle];
						
					} else {
						[_displayDataCallbackDelegate
						 setTextWithDescAnimation:displayTitle];
					}
					
				} else {
					/* this one is requires, thus this is the fall back */
					[_displayDataCallbackDelegate setText:displayTitle];
				}
				
			} else {
				/* this one is requires, thus this is the fall back */
				[_displayDataCallbackDelegate setText:displayTitle];
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
	/*
	 TODO: does it work? (plugins have to be implemented)
	 */
	NSNumberFormatter * formatter =  [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:(NSNumberFormatterStyle) kCFNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:4];
	[formatter setLocale:[NSLocale currentLocale]];
	
	return [formatter stringFromNumber:number];
}
@end
