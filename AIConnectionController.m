//
//  AIConnectionController.m
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import "AIConnectionController.h"

@implementation AIConnectionController

#pragma mark - callback delegate handling

- (void)setDelegate:(id)delegate
{
	if ([[delegate class]
		 conformsToProtocol:@protocol(AIConnectionControllerDelegateProtocol)]) {
		_callbackDelegate = delegate;
		
	} else {
		NSLog(@"Cannot set delegate: needs to conform to \
			  AIConnectionControllerDelegateProtocol!");
	}
	
}

#pragma mark - interface selectors

- (void)makeConnectionWithReqest:(NSURLRequest *)request
{
	NSURLConnection* connection = [[NSURLConnection alloc]
								   initWithRequest:request
								   delegate:self];
	[connection start];
}

- (void)makeRequestWithURL:(NSURL *)url
{
	[self makeConnectionWithReqest:[[NSURLRequest alloc] initWithURL:url]];
}

# pragma mark - connection handling

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _data = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [_data appendData:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if (_callbackDelegate != nil) {
		[_callbackDelegate didFailWithError:error];
		
	} else {
		NSLog(@"No callback delegate! (didFailWithError)");
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	if (_callbackDelegate != nil) {
		[_callbackDelegate didFinishLoading:_data];
		
	} else {
		NSLog(@"No callback delegate! (didFinishLoading)");
	}
}
@end
