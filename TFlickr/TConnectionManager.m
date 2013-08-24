//
//  TConnectionManager.m
//  TFlickr
//
//  Created by Praveen on 8/22/13.
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

#import "TConnectionManager.h"

@implementation TConnectionManager

// Fetch Flickr Albums
// Flickr Api : flickr.photosets.getList
+(void) getPhotoAlbumList:(void(^)(NSArray *aFlickerAlbums))successBlock
               errorBlock:(void(^)(NSError *error))errorBlock{

    dispatch_queue_t downloadPhotoSetsQueue = dispatch_queue_create("Get Photo Sets", NULL);
    dispatch_async(downloadPhotoSetsQueue, ^{
        
        NSMutableArray *lFlickrAlbumCollection;
        
        // Send request
        NSData *lFlickrData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&api_key=%@&user_id=%@&format=json&nojsoncallback=1",FLICKR_REST_HOST,FLICKR_METHOD_GET_ALBUMS,FLICKR_API_KEY,FLICKR_USER_ID]]];
        
        NSError* lError;
        // Get Json Object from response
        NSDictionary* lFlickrJsonObject = [NSJSONSerialization JSONObjectWithData:lFlickrData options:kNilOptions error:&lError];
        
        if(lFlickrJsonObject!=nil){
            
            // Get Array of photosets from response
            NSArray* lFlickrPhotoset = [[lFlickrJsonObject objectForKey:TAG_PHOTOSETS] objectForKey:TAG_PHOTOSET];
            lFlickrAlbumCollection = [[NSMutableArray alloc]initWithCapacity:[lFlickrPhotoset count]];
            
            // Loop through the photosets and get title and photoset id
            for(NSDictionary *lPhotoSetDetails in lFlickrPhotoset){
                TFlickrPhotosetsModel *lFlickrModel = [[TFlickrPhotosetsModel alloc]init];
                NSString *lTitle = [[lPhotoSetDetails objectForKey:@"title"] objectForKey:@"_content"];
                NSString *lPhotoCount = [lPhotoSetDetails objectForKey:@"photos"];
                NSString *lPhotoSetId = [lPhotoSetDetails objectForKey:@"id"];

                lFlickrModel.mTitle = [NSString stringWithFormat:@"%@  (%@)",lTitle,lPhotoCount];
                lFlickrModel.mPhotosetId = lPhotoSetId;
                [lFlickrAlbumCollection addObject:lFlickrModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(lFlickrAlbumCollection);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(lError);
            });
        }
    });
}

// Fetch Flickr Photoset
// Flickr Api : flickr.photosets.getPhotos
+(void) getAlubmPicsWithAlbum:(TFlickrPhotosetsModel*)aFlickrAlbum successBlock:(void(^)(NSArray *lFlickerPhotoset))successBlock
errorBlock:(void(^)(NSError *error))errorBlock{
    
    dispatch_queue_t downloadPhotoslQueue = dispatch_queue_create("Get Photset", NULL);
    dispatch_async(downloadPhotoslQueue, ^{
        
        NSMutableArray *lFlickrAlbumCollection;
        
        // Send request
        NSData *lFlickrData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&api_key=%@&photoset_id=%@&format=json&nojsoncallback=1",FLICKR_REST_HOST,FLICKR_METHOD_GET_PHOTOS,FLICKR_API_KEY,aFlickrAlbum.mPhotosetId]]];
        
        NSError* lError;
        // Get Json Object from response
        NSDictionary* lFlickrJsonObject = [NSJSONSerialization JSONObjectWithData:lFlickrData options:kNilOptions error:&lError];
        
        if(lFlickrJsonObject!=nil){
        
            // Get Array of photos from photoset
            NSArray* lFlickrPhotosets = [[lFlickrJsonObject objectForKey:TAG_PHOTOSET] objectForKey:TAG_PHOTO];
            lFlickrAlbumCollection = [[NSMutableArray alloc]initWithCapacity:[lFlickrPhotosets count]];
            
            // Loop through the photos and get title and photourl
            for(NSDictionary *lFlickrPhotoset in lFlickrPhotosets){
                TFlickrPhotosetModel *lFlickrPhotosetModel = [[TFlickrPhotosetModel alloc]init];
                
                NSString *lPhotoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",[lFlickrPhotoset objectForKey:TAG_FARM],[lFlickrPhotoset objectForKey:TAG_SERVER],[lFlickrPhotoset objectForKey:TAG_ID],[lFlickrPhotoset objectForKey:TAG_SECRET]];
                
                lFlickrPhotosetModel.mTitle = [lFlickrPhotoset objectForKey:TAG_TITLE];
                lFlickrPhotosetModel.mPhotoUrl = lPhotoURL;
                [lFlickrAlbumCollection addObject:lFlickrPhotosetModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(lFlickrAlbumCollection);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(lError);
            });
        }
    });
}


@end
