//
//  LoginViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 11/01/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton2;
@property (weak, nonatomic) IBOutlet UIButton *signInButton3;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNo;


@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [_signInButton2 setColorScheme:kGIDSignInButtonColorSchemeDark];
 
    
    
    // Create object
    Person *author = [[Person alloc] init];
    author.name    = @"David Foster Wallace";
    
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    // You only need to do this once (per thread)
    
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    [realm addObject:author];
    [realm commitWriteTransaction];
    
    // Update an object with a transaction
    [realm beginWriteTransaction];
    author.name = @"Thomas Pynchon";
    [realm commitWriteTransaction];
    
    
    // Observe RLMResults Notifications
    __weak typeof(self) weakSelf = self;
    //[Person objectsWhere:@"age > 5"]
    weakSelf.notificationToken = [[Person allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
         //code
     }];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateSignedInUserPhoneNo:(NSString *)phoneNo{
    
    RLMResults<Person *> *persons = [Person allObjects]; // retrieves all Persons from the default Realm
    _lblPhoneNo.text = [NSString stringWithFormat: @"%@(%lu)", phoneNo, [persons count]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)googlePlusButtonTouchUpInside:(id)sender {
    
    RLMResults<Person *> *persons = [Person allObjects]; // retrieves all Persons from the default Realm
    NSLog(@"First Person in Realm is=%@", [persons firstObject].name);
    NSLog(@"Person count in Realm is=%lu", (unsigned long)[persons count]);
    
    [[GIDSignIn sharedInstance] signIn];
    
}

- (void)dealloc
{
     [self.notificationToken stop];
}

@end
