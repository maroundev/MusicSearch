//
//  MusicEntity.h
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicEntity : NSObject

-(instancetype)initWith:(NSString *)trackName
                  album:(NSString *)albumName
                 artist:(NSString *)artistName
                artwork:(NSString *)urlString;

@property (readonly) NSString * name;
@property (readonly) NSString * albumName;
@property (readonly) NSString * artistName;
@property (readonly) NSString * albumArtworkURLString;
@property (readonly) NSString * lyricsURLString;
@end
