//
//  IBeaconViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 22/09/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "IBeaconViewController.h"

@interface IBeaconViewController ()

@end

@implementation IBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CLBeacon *beacon = (CLBeacon*)[self.beacons
                                   objectAtIndex:indexPath.row];
    NSString *proximityLabel = @"";
    switch (beacon.proximity) {
        case CLProximityFar:
            proximityLabel = @"Far";
            break;
        case CLProximityNear:
            proximityLabel = @"Near";
            break;
        case CLProximityImmediate:
            proximityLabel = @"Immediate";
            break;
        case CLProximityUnknown:
            proximityLabel = @"Unknown";
            break;
    }
    
    
    UILabel *lblTitle = [cell viewWithTag:103];
    UILabel *lblDetail = [cell viewWithTag:104];
    lblTitle.text = proximityLabel;
    
    NSString *detailLabel = [NSString
                             stringWithFormat:
                             @"Major: %d, Minor: %d, RSSI: %d, UUID: %@",
                             beacon.major.intValue, beacon.minor.intValue,
                             (int)beacon.rssi, beacon.proximityUUID.UUIDString];
    lblDetail.text = detailLabel;
    
    return cell;    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
