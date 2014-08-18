//
//  URLCacheController.m
//  bikepath
//
//  Created by Molly Huerster on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "URLCacheController.h"
#import <Foundation/Foundation.h>
// #import "URLCacheAlert.h"

//refresh cache every 5 minutes
const double URLCacheInterval = 600;

@interface URLCacheController ()

@end

@implementation URLCacheController

@synthesize dataPath;
@synthesize filePath;
@synthesize fileDate;
@synthesize urlArray;
@synthesize connection;

// MEH: XCode provided automatically. Not sure we need this method.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil
                               ];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [self initCache];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLCache" ofType:@"plist"];
    if (path) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        self.urlArray = [NSMutableArray array];
        for (NSString *element in array) {
            [self.urlArray addObject:[NSURL URLWithString:element]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
