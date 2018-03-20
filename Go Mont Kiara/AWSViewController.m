//
//  AWSViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 14/09/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import "AWSViewController.h"

#import "HTAaMicroservicesAccountClient.h"
#import "HTAaMicroservicesEshopClient.h"


@interface AWSViewController ()


@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextView *txtResponse;

@end






@implementation AWSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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




- (IBAction)queryProtectedResource:(UIButton *)sender {
    HTAaMicroservicesAccountClient *serviceClient = [HTAaMicroservicesAccountClient defaultClient];
    
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       };
    NSDictionary *queryParameters = @{
                                      @"email": @"testing19@gmail.com",
                                      @"customerGuid": @"2ca8fe53-d806-4f1e-a3da-8b170f663e13",
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    
    AWSAPIGatewayRequest *req = [[AWSAPIGatewayRequest alloc] initWithHTTPMethod:@"GET" URLString:@"/Internal/api/account/getcustomerprofile" queryParameters:queryParameters headerParameters:headerParameters HTTPBody:nil];
    
    
    AWSTask *awsTask = [serviceClient invoke:req];
    [awsTask continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if(task.error != nil){
            NSLog(@"Error: %@", task.error);
        } else {
            NSData* data = [((AWSAPIGatewayResponse *)task.result) responseData];
            
            NSString *responseStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"dataAsString: %@", responseStr);
            NSError *error1;
            NSMutableDictionary * innerJson = [NSJSONSerialization
                                               JSONObjectWithData:data options:kNilOptions error:&error1
                                               ];
            
            NSMutableDictionary * dataObject = innerJson[@"data"];
            NSString *firstName = dataObject[@"firstName"];
            NSString *lastName = dataObject[@"lastName"];
            //write a class to model the response
            
            NSLog(@"First Name: %@, Last Name: %@", firstName, lastName);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _txtFirstName.text = firstName;
                _txtLastName.text = lastName;
                //[_txtFirstName setText:firstName];
                //[_txtLastName setText:lastName];
                [_txtResponse setText:responseStr];

            });
            
        }
        return nil;
    }];
    
    
    
    
    
    
    
    
}








- (IBAction)queryEshop:(UIButton *)sender {
    HTAaMicroservicesEshopClient *serviceClient = [HTAaMicroservicesEshopClient defaultClient];
    
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       };
    NSDictionary *queryParameters = @{
                                      @"languageId": @"53",
                                      @"sort": @"desc",
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    
    AWSAPIGatewayRequest *req = [[AWSAPIGatewayRequest alloc] initWithHTTPMethod:@"GET" URLString:@"/api/eshop/GetEShopCountryByLanguage" queryParameters:queryParameters headerParameters:headerParameters HTTPBody:nil];
    
    
    AWSTask *awsTask = [serviceClient invoke:req];
    [awsTask continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if(task.error != nil){
            NSLog(@"Error: %@", task.error);
        } else {
            NSData* data = [((AWSAPIGatewayResponse *)task.result) responseData];
            
            NSString *responseStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"dataAsString: %@", responseStr);
            NSError *error1;
            NSMutableDictionary * innerJson = [NSJSONSerialization
                                               JSONObjectWithData:data options:kNilOptions error:&error1
                                               ];
            
            
            /**
            NSMutableDictionary * dataObject = innerJson[@"data"];
            NSString *firstName = dataObject[@"firstName"];
            NSString *lastName = dataObject[@"lastName"];
            //write a class to model the response
            
            NSLog(@"First Name: %@, Last Name: %@", firstName, lastName);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _txtFirstName.text = firstName;
                _txtLastName.text = lastName;
                [_txtResponse setText:responseStr];
                
            });
            **/
        }
        return nil;
    }];
    
    
    
    
    
    
    
    
}










- (IBAction)updateProfile:(UIButton *)sender {
    HTAaMicroservicesAccountClient *serviceClient = [HTAaMicroservicesAccountClient defaultClient];
    
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       };
    NSDictionary *queryParameters = @{
                                                                          };
    
   
    
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    NSMutableDictionary
    *dict  = [[NSMutableDictionary alloc] init];
    [dict setValue:@"testing19@gmail.com" forKey:@"Email"];
    [dict setValue:@"123" forKey:@"Password"];
    [dict setValue:@"hoong tat" forKey:@"FirstName"];
    [dict setValue:@"hiew" forKey:@"LastName"];
    [dict setValue:@"X" forKey:@"Gender"];
    [dict setValue:@"1" forKey:@"countryid"];
    [dict setValue:@"811115105187" forKey:@"identityNo"];
    [dict setValue:@"6" forKey:@"countryofresidenceid"];
    [dict setValue:@"3322" forKey:@"MobileNumber"];
    [dict setValue:@"1111-11-11" forKey:@"DateOfBirth"];
    [dict setValue:@"2" forKey:@"usertypeid"];
    [dict setValue:@"1" forKey:@"languageid"];
    [dict setValue:@"2" forKey:@"identitytypeid"];
    [dict setValue:@"2" forKey:@"phonenumbercountrycodeid"];
    [dict setValue:@"2" forKey:@"nationalityId"];
    
    AWSAPIGatewayRequest *req = [[AWSAPIGatewayRequest alloc] initWithHTTPMethod:@"POST" URLString:@"/Internal/api/account/editcustomerprofile" queryParameters:queryParameters headerParameters:headerParameters HTTPBody:dict];
    
    
    AWSTask *awsTask = [serviceClient invoke:req];
    [awsTask continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if(task.error != nil){
            NSLog(@"Error: %@", task.error);
        } else {
            NSData* data = [((AWSAPIGatewayResponse *)task.result) responseData];
            
            NSString *responseStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"EditCustomerProfile response string==> %@", responseStr);
            NSError *error1;
            NSMutableDictionary * innerJson = [NSJSONSerialization
                                               JSONObjectWithData:data options:kNilOptions error:&error1
                                               ];
            
            NSMutableDictionary * dataObject = innerJson[@"data"];
         //   NSLog(@"First Name: %@, Last Name: %@", firstName, lastName);
            
            /**
            dispatch_async(dispatch_get_main_queue(), ^{
                _txtFirstName.text = firstName;
                _txtLastName.text = lastName;
                           [_txtResponse setText:responseStr];
                
            });
            **/
        }
        return nil;
    }];
}



@end
