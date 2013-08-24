//
//  TFlickrAlbumsViewController.m
//  TFlickr
//
//  Created by Praveen on 8/24/13.
//  Copyright (c) 2013 Praveen. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the
//     purpose of any concept relating to diary/journal keeping.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TFlickrAlbumsViewController.h"
#import "TFlickrPhotosetsModel.h"
#import "TFlickrPhotosetModel.h"
#import "UIViewController+LoadingView.h"

@interface TFlickrAlbumsViewController ()

@end

@implementation TFlickrAlbumsViewController

@synthesize mFlickrAlbums = _mFlickrAlbums;
@synthesize mFlickrPhotoSet = _mFlickrPhotoSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoadingView];
    
    // Fetch Photosets
    [TConnectionManager getPhotoAlbumList:^(NSArray *aFlickerAlbums) {
        self.mFlickrAlbums = aFlickerAlbums;
        [self.tableView reloadData];
        [self hideLoadingView];
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

#pragma mark -- UITableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mFlickrAlbums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TFlickrPhotosetsModel *lModel = [_mFlickrAlbums objectAtIndex:indexPath.row];
    cell.textLabel.text = lModel.mTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showLoadingView];
    
    // Get Photoset for Album
    [TConnectionManager getAlubmPicsWithAlbum:[self.mFlickrAlbums objectAtIndex:indexPath.row] successBlock:^(NSArray *lFlickerPhotoset) {
        self.mFlickrPhotoSet = lFlickerPhotoset;
        [self hideLoadingView];
        FGalleryViewController *lFlickerGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        UINavigationController *lFlickerGalleryNavigation = [[UINavigationController alloc]initWithRootViewController:lFlickerGallery];
        lFlickerGalleryNavigation.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self presentViewController:lFlickerGalleryNavigation animated:YES completion:^{
            
        }];
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    num = [self.mFlickrPhotoSet count];
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    caption = ((TFlickrPhotosetModel*)[self.mFlickrPhotoSet objectAtIndex:index]).mTitle;
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return ((TFlickrPhotosetModel*)[self.mFlickrPhotoSet objectAtIndex:index]).mPhotoUrl;
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
