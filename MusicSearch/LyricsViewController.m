//
//  LyricsViewController.m
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import "LyricsViewController.h"
#import "MusicSearch.h"

@interface LyricsViewController (){
    MusicSearch *search;
    NSOperationQueue *queue;
}

@end

@implementation LyricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    search = [[MusicSearch alloc] init];
    
    self.title = @"Lyrics View";
    self.nameLabel.text = self.entity.name;
    self.albumLabel.text = self.entity.albumName;
    self.artistLabel.text = self.entity.artistName;
    self.lyricsTextView.text = @"Loading Lyrics...";

    queue = [[NSOperationQueue alloc] init];
    
    // Download image data in background avoiding lag
    [queue addOperationWithBlock:^{
        NSURL *imageUrl = [NSURL URLWithString:self.entity.albumArtworkURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [UIImage imageWithData:imageData];
        
        // Update UI on main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (image){
                self.artwork.image = image;
            }
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // This is in view did appear so the UI doesn't lag as soon as the user enters the screen
    [queue addOperationWithBlock:^{
        [search searchForSongLyrics:self.entity.lyricsURLString withResult:^(NSString * lyrics) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lyricsTextView.text = lyrics;
            });
        }];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [queue cancelAllOperations];
}
@end
