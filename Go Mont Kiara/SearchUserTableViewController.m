//
//  SearchUserTableViewController.m
//  weddingplanner
//
//  Created by Hoong Tat Hiew on 7/20/14.
//  Copyright (c) 2014 Hoong Tat Hiew. All rights reserved.
//

#import "SearchUserTableViewController.h"
#import "PhotoCollectionViewController.h";
@interface SearchUserTableViewController ()

@end

@implementation SearchUserTableViewController
@synthesize searchResult;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 0;
    if(searchResult != nil){
        return [searchResult count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instagramSearchUserId"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"instagramSearchUserId"];
    }
    // Configure the cell...
    
    //State *stateObj = [[self.states objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    NSString *user_name = [[searchResult allKeys] objectAtIndex:indexPath.row];
    NSMutableDictionary *userDict = [searchResult objectForKey:user_name];
    NSString* first_name = [userDict valueForKey:@"first_name"];
    NSString* last_name = [userDict valueForKey:@"last_name"];
    NSString* user_id = [userDict valueForKey:@"id"];
    NSString* profile_picture = [userDict valueForKey:@"profile_picture"];
    
    NSURL* profileURL = [NSURL URLWithString:profile_picture];
    
    NSData *imageData = [NSData dataWithContentsOfURL:profileURL];
    UIImage *profileImage = [UIImage imageWithData:imageData];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", user_name];
    cell.imageView.image = profileImage;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@" %@, %@", first_name, last_name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", user_id];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
   // <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    // Pass the selected object to the new view controller.
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    NSString *user_name = [[searchResult allKeys] objectAtIndex:indexPath.row];
    NSString *user_id = [[searchResult objectForKey:user_name] valueForKey:@"id"];
    
    PhotoCollectionViewController *pcViewCv = (PhotoCollectionViewController*)[self parentViewController];
    
    NSMutableArray *photoArr = [pcViewCv.instagramQuery GetPhotoByUserID:user_id withPhotoCount:36];
   
    [pcViewCv loadNewPhoto:photoArr];
    
    self.tableView.hidden = YES;
}


@end
