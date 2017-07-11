//
//  MusicCell.m
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)setNameLabelText:(NSString *)text{
    _nameLabel.text = [NSString stringWithFormat:@"Song: %@", text];
}

- (void)setAlbumLabelText:(NSString *)text{
    _albumLabel.text = [NSString stringWithFormat:@"Album: %@", text];
}

- (void)setArtistLabelText:(NSString *)text{
    _artistLabel.text = [NSString stringWithFormat:@"Artist: %@", text];
}

@end
