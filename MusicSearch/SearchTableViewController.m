//
//  SearchTableViewController.m
//  MusicSearch
//
//  Created by Maroun Abi Ramia on 7/10/17.
//  Copyright © 2017 Maroun Abi Ramia. All rights reserved.
//

#import "SearchTableViewController.h"
#import "LyricsViewController.h"
#import "MusicEntity.h"
#import "MusicSearch.h"
#import "MusicCell.h"

@interface SearchTableViewController(){
    NSArray<MusicEntity *> *musicEntities;
    MusicSearch *search;
    NSOperationQueue *queue;
}
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    search = [[MusicSearch alloc] init];
    
    // Create an operation queue
    // Given more time, I would have made sure to stop any operations
    // when scrolling and continue them when stopped
    queue = [[NSOperationQueue alloc] init];
}

- (void)search:(NSString *)term{
    // Run search in the background to avoid UI lag
    [queue addOperationWithBlock:^{
        [search searchItunesFor:term withResult:^(NSArray<MusicEntity *> * results) {
            // Update UI on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                musicEntities = results;
                
                [self.tableView reloadData];
                [self removeLoadingView];
            });
        }];
    }];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self search:searchBar.text];
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    [self showLoadingView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musicEntities == NULL ? 0 : musicEntities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell" forIndexPath:indexPath];
    
    MusicEntity *entity = musicEntities[indexPath.row];
    [cell setNameLabelText:entity.name];
    [cell setArtistLabelText:entity.artistName];
    [cell setAlbumLabelText:entity.albumName];
    
    // Download image data in background avoiding lag
    [queue addOperationWithBlock:^{
        
        NSURL *imageURL = [NSURL URLWithString:entity.albumArtworkURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        // Update UI on main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (image) {
                [cell.artwork setImage:image];
            }
            // This solved some layout constraints
            [cell layoutIfNeeded];

        }];
    }];
    
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LyricsViewController"]){
        
        MusicCell *cellClicked = (MusicCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cellClicked];
        
        LyricsViewController *lyricsView = [segue destinationViewController];
        lyricsView.entity = musicEntities[indexPath.row];
    }
}

#pragma mark - Loading View

- (void)showLoadingView{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 25, self.view.bounds.size.height/2 - 25, 50, 50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [spinner startAnimating];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.tag = 1;
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5;
    [loadingView addSubview:spinner];
    
    [self.view addSubview:loadingView];
}

- (void)removeLoadingView{
    UIView *loadingView = [self.view viewWithTag:1];
    [loadingView removeFromSuperview];
}

@end
