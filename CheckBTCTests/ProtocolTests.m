//
//  ProtocolTests.m
//  CheckBTC
//
//  Created by X on 23.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MtgoxAPI.h"
#import "DataSourceProtocol.h"

#import "StatusBarController.h"
#import "DisplayDataCallbackProtocol.h"

#import "UserDefaultsController.h"
#import "UserDefaultsControllerDelegateProtocol.h"

#import "DataController.h"
#import "AIConnectionControllerDelegateProtocol.h"

@interface ProtocolTests : XCTestCase

@end

@implementation ProtocolTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDataSourceProtocol
{
	XCTAssertTrue([MtgoxAPI conformsToProtocol:@protocol(DataSourceProtocol)],
				  @"MtgoxAPI does not conform to the DataSourceProtocol");
}

- (void)testDisplayDataCallbackProtocol
{
	XCTAssertTrue([StatusBarController
				   conformsToProtocol:@protocol(DisplayDataCallbackProtocol)],
				  @"StatusBarController does not conform to the \
				  DisplayDataCallbackProtocol!");
}

- (void)testUserDefaultsControllerDelegateProtocol
{
	XCTAssertTrue([UserDefaultsController
				   conformsToProtocol:@protocol(UserDefaultsControllerDelegateProtocol)],
				  @"UserDefaultsController does not conform to the \
				  UserDefaultsControllerDelegateProtocol");
}

- (void)testAIConnectionControllerDelegateProtocol
{
	XCTAssertTrue([DataController
				   conformsToProtocol:@protocol(AIConnectionControllerDelegateProtocol)],
				  @"DataController does not conform to the \
				  AIConnectionControllerDelegateProtocol!");
}

@end
