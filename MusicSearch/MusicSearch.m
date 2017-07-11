//
//  MusicSearch.m
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import "MusicSearch.h"

#define ITUNES_SEARCH_URI @"https://itunes.apple.com/search?term="

@interface MusicSearch()
@property NSURLSession * session;
@end

@implementation MusicSearch

-(instancetype)init{
    if (self = [super init]){
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

-(void)searchItunesFor:(NSString *)term withResult:(void (^)(NSArray<MusicEntity *> *))callback{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ITUNES_SEARCH_URI, [term stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];

    NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSMutableArray<MusicEntity *> * musicResults;
        
        if (error != NULL){
            callback(musicResults);
            
        }else{
            NSError *responseError;
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&responseError][@"results"];
            
            // Check if error occured serializing the data receieved
            if (responseError != nil) callback(musicResults);
            
            musicResults = [NSMutableArray array];
            for (NSDictionary *entity in jsonResponse){
                
                // Create a music entity object out of the jsonResponse
                MusicEntity *newEntity = [[MusicEntity alloc]
                                          initWith:entity[@"trackName"]
                                          album:entity[@"collectionName"]
                                          artist:entity[@"artistName"]
                                          artwork:entity[@"artworkUrl60"]];
                [musicResults addObject:newEntity];
            }
            
            callback(musicResults);
        }
    }];
    
    [task resume];
}

-(void)searchForSongLyrics:(NSString *)songUrl withResult:(void(^)(NSString *))callback{
    NSURL *url = [NSURL URLWithString:songUrl];
    
    NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        if (error != NULL){
            callback(@"Lyrics Not Found");
        }else{
            
            // Data receieved wouldn't get serialized correctly
            // This was a quick fix solution
            // This turns the data into a string and cleans it up from any
            // html tags. Given more time, I would look for a more concrete way of doing this.
            NSString *lyrics = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange range = [lyrics rangeOfString:@"'lyrics':"];
            
            lyrics = [lyrics substringFromIndex:range.location];
            range = [lyrics rangeOfString:@"'url':"];
            lyrics = [lyrics substringToIndex:range.location];
            
            lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];
            lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            lyrics = [lyrics stringByReplacingOccurrencesOfString:@"'lyrics':" withString:@""];
            
            callback(lyrics);
        }
    }];
    
    [task resume];
}

@end
