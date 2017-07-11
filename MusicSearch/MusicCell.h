//
//  MusicCell.h
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

- (void)setNameLabelText:(NSString *)text;
- (void)setAlbumLabelText:(NSString *)text;
- (void)setArtistLabelText:(NSString *)text;
@end
