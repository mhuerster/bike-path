//
//  URLCacheConnection.m
//  bikepath
//
//  Created by Molly Huerster on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "URLCacheConnection.h"

@implementation URLCacheConnection

@synthesize delegate;
@synthesize receivedData;
@synthesize lastModified;
@synthesize connection;

- (id) initWithURL:(NSURL *)theURL delegate:(id<URLCacheConnectionDelegate>)theDelegate
{
	if (self = [super init]) {
        
		self.delegate = theDelegate;
		NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL
													cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
												timeoutInterval:60];
		self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
	}
	return self;
}


#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    long long contentLength = [response expectedContentLength];
	if (contentLength == NSURLResponseUnknownLength) {
		contentLength = 500000;
	}
	self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	URLCacheAlertWithError(error);
	[self.delegate connectionDidFail:self];
}


- (NSCachedURLResponse *) connection:(NSURLConnection *)connection
				   willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	/* this application does not use a NSURLCache disk or memory cache */
    return nil;
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self.delegate connectionDidFinish:self];
}


@end
