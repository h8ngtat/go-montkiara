//
//  IBeaconViewController.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 22/09/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IBeaconViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;
@property (strong) NSArray *beacons;

@end
