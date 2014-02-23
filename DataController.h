//
//  DataController.h
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIConnectionController.h"
#import "StatusBarController.h"
#import "DataSourceProtocol.h"
#import "DisplayDataCallbackProtocol.h"
#import "UserDefaultsControllerDelegateProtocol.h"
#import "MtgoxAPI.h"

/*!
 @header DataController
 This controller handles data retrieval, evaluation and handling of the results.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.1
 @updated 23.02.14
 */
@interface DataController : NSObject<AIConnectionControllerDelegateProtocol>
{
	NSTimer *theTimer;
	NSRunLoop *runLoop;
	NSNumber *lastAvg;
	
	/* modells */
	MtgoxAPI *api;
	
	/* controllers */
	AIConnectionController *connectionController;
	StatusBarController *statusBarController;
	id<DataSourceProtocol> dataSource;
	
	/* delegates */
	id<UserDefaultsControllerDelegateProtocol> userDefaultsControllerDelegate;
}

- (id)initWithUserDefaultsControllerDelegate:
(id<UserDefaultsControllerDelegateProtocol>)delegate;

/*!
 @abstract Set delegate to handle setting and getting of user defaults
 @param delegate actual handler
 */
- (void)setUserDefaultsControllerDelegate:(id)delegate;

@end
