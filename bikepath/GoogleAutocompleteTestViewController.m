//
//  GoogleAutocompleteTestViewController.m
//  bikepath
//
//  Created by Apprentice on 8/17/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "GoogleAutocompleteTestViewController.h"
#import "SPGooglePlacesAutocomplete.h"
#import <UIKit/UIKit.h>
#import "SearchItem.h"
#import "ResultsMapViewController.h"
#import "AddressGeocoderFactory.h"
#import "ErrorMessage.h"

@interface GoogleAutocompleteTestViewController ()

@end

@implementation GoogleAutocompleteTestViewController

@synthesize mapView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAxaqfMyyc-WSrvsWP_jF2IUaTZVjkMlFo"];
        shouldBeginEditing = YES;
    }
    return self;
}

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {}

- (void)viewDidLoad {
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.searchDisplayController.searchBar.placeholder = @"Where would you like to go?";
    
    GMSCameraPosition *nyc = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:12
                                                           bearing:30
                                                        viewingAngle:45];
    self.mapView.mapType = kGMSTypeNormal;
    [self.mapView setCamera:nyc];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.zoomGestures = YES;
    
}


- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return searchResultPlaces[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)dismissSearchControllerWhileStayingActive {
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (error) {
            [ErrorMessage renderErrorMessage:@"Could not map selected place" cancelButtonTitle:@"OK" error:error];
        } else if (placemark) {
            SearchItem *selectedItem   = [[SearchItem alloc] init];
            NSString *addressForJson = [AddressGeocoderFactory translateAddresstoUrl:addressString];

            NSMutableDictionary *geocode = [AddressGeocoderFactory translateUrlToGeocodedObject:addressForJson];
            selectedItem.searchQuery   = place.name;
             CLLocation *location = [[CLLocation alloc] initWithLatitude:[[geocode objectForKey:@"latitude"] doubleValue] longitude:[[geocode objectForKey:@"longitude"] doubleValue]];
            selectedItem.lati = location.coordinate.latitude;
            selectedItem.longi = location.coordinate.longitude;
            selectedItem.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
           selectedItem.address = [geocode objectForKey:@"address"];
            [self performSegueWithIdentifier: @"showResults" sender: selectedItem];
            [self dismissSearchControllerWhileStayingActive];
            [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }];
};

#pragma mark - UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            [ErrorMessage renderErrorMessage:@"Could not fetch places." cancelButtonTitle:@"OK" error:error];
        } else {
            searchResultPlaces = places;
            
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
        shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    return YES;
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 0.75;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showResults"]) {
        ResultsMapViewController *destViewController = segue.destinationViewController;
        SearchItem *item = sender;
        destViewController.item = item;
    }
}

@end