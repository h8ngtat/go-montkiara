//
//  PlayersTableViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 30/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "PlayersTableViewController.h"
#import "Player.h"
@interface PlayersTableViewController ()

@end

@implementation PlayersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _players = [[NSMutableArray alloc] initWithObjects:
                [[Player alloc] initWithName:@"Hiew Hoong Tat" withGame:@"Pokemon Go" withRating:5],
                [[Player alloc] initWithName:@"Tan Lu Ping" withGame:@"Rocket Mania" withRating:3],
                [[Player alloc] initWithName:@"Tan Lu Think" withGame:@"Final Fantasy" withRating:4]
                , nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _players.count;
}

- (UIImage*)imageForRating: (int)rating {
    //let imageName = "\(rating)Stars"
    return [UIImage imageNamed:[NSString stringWithFormat:@"\%dstars", rating]];
    //return UIImage(named: imageName)
}




- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
    
    Player *player = [_players objectAtIndex:indexPath.row];
    UILabel *lblName = [cell viewWithTag:100];
    UILabel *lblGame = [cell viewWithTag:101];
    UIImageView * imgRating = [cell viewWithTag:102];

    //[cell viewWithTag:102] as? UIImageView
    
    lblName.text = player.name;
    lblGame.text = player.game;
    imgRating.image = [self imageForRating:player.rating];
    
   
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
