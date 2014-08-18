//
//  URLCacheController.h
//  bikepath
//
//  Created by Molly Huerster on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLCacheconnection.h"

@interface URLCacheController : UIViewController <URLCacheConnectionDelegate>

@property (strong, nonatomic) NSString *dataPath;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSDate *fileDate;
@property (strong, nonatomic) NSMutableArray *urlArray;
@property (strong, nonatomic) NSURLConnection *connection;

- (IBAction) onClearCache:(id)sender;

@end
