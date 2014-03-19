//
//  AIKrakenExchangeAPIController.h
//  AIKrakenExchangeAPIController
//
//  Created by X on 19.03.14.
//  Copyright (c) 2014 andinfinity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSourceProtocol.h"

@interface AIKrakenExchangeAPIController : NSObject<DataSourceProtocol>
{
	NSDictionary *json;
}

@property NSNumber *protocolVersion;

@end
