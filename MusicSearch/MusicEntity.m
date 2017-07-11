//
//  MusicEntity.m
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import "MusicEntity.h"

@implementation MusicEntity

-(instancetype)initWith:(NSString *)trackName
                  album:(NSString *)albumName
                 artist:(NSString *)artistName
                artwork:(NSString *)urlString{
    
    if (self = [super init]){
        _name = trackName;
        _albumName = albumName;
        _artistName = artistName;
        _albumArtworkURLString = urlString;
        
        // Create the url string for the lyrics page
        _lyricsURLString = [NSString stringWithFormat:@"http://lyrics.wikia.com/api.php?func=getSong&artist=%@&song=%@&fmt=json", [artistName stringByReplacingOccurrencesOfString:@" " withString:@"+"], [trackName stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    }
    return self;
}

@end
