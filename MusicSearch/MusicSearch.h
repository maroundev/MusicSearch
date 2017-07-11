//
//  MusicSearch.h
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicEntity.h"

@interface MusicSearch : NSObject

/** Initiliaze MusicSearch session */
-(instancetype)init;

/** 
 @brief This is a callback function that searches the Itunes Api for a term
 
 @discussion It accepts a string representing the term to search for. The callback function will have the returned result. NSArray<MusicEntity *> is the result receieved from the callback function.
 
 @param term The input value representing the search term

 */
-(void)searchItunesFor:(NSString *)term withResult:(void(^)(NSArray<MusicEntity *> *))callback;

/**
 @brief This is a callback function that searches for the lyrics given a string url.
 
 @discussion It accepts a string url representing the song location where the lyrics can be found. An example of the string url will look like this http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json. The callback function will have the returned result. NSArray<MusicEntity *> is the result receieved from the callback function.
 
 @param songUrl The input value representing the lyrics url as a string
 
 */
-(void)searchForSongLyrics:(NSString *)songUrl withResult:(void(^)(NSString *))callback;
@end
