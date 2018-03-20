//
//  RegViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 09/12/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "RegViewController.h"
#import "MBProgressHUD.h"

@interface RegViewController ()


@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txtUsername.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_txtUsername resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_txtUsername resignFirstResponder];
    return NO;
}

- (IBAction)clickRegister:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [NSThread sleepForTimeInterval:5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
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
