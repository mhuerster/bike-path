//
//  URLCacheConnection.h
//  bikepath
//
//  Created by Molly Huerster on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol URLCacheConnectionDelegate;

@interface URLCacheConnection : NSObject
{
    id <URLCacheConnectionDelegate> delegate;
    NSMutableData *receivedData;
    NSDate *lastModified;
    NSURLConnection *connection;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSDate *lastModified;

//will ultimately use this for url:
//NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
- (id) initWithURL:(NSURL *)url delegate:(id<URLCacheConnectionDelegate>)theDelegate;

@end

@protocol URLCacheConnectionDelegate<NSObject>

- (void) connectionDidFail:(URLCacheConnection *)theConnection;
- (void) connectionDidFinish:(URLCacheConnection *)theConnection;

@end