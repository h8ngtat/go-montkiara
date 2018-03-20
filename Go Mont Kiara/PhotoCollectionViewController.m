//
//  PhotoCollectionViewController.m
//  TabbedApplication
//
//  Created by Hoong Tat Hiew on 7/4/14.
//  Copyright (c) 2014 Hoong Tat Hiew. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewLayout.h"
#import "PhotoView.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "AppDelegate.h"
#import "InstagramQuery.h";
#import "SearchUserTableViewController.h";

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface PhotoCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSMutableArray *imagesArr;

@property (nonatomic,weak) IBOutlet PhotoCollectionViewLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@property (nonatomic, strong) SearchUserTableViewController *searchTableVC;

//@property (nonatomic,weak) IBOutlet UITabBarController *tabBarController;

@end








@implementation PhotoCollectionViewController
@synthesize instagramQuery;
NSString * const keyForInstagramAccessToken2 = @"keyForInstagramAccessToken5";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init prop
    instagramQuery = [[InstagramQuery alloc] init];
    NSString *instagramKey = [[NSUserDefaults standardUserDefaults]
                              stringForKey:keyForInstagramAccessToken2];
    instagramQuery.accessToken = instagramKey;
    NSLog(@" nstagramQuery.accessToken = %@ ", instagramQuery.accessToken);
    
    //add button
    int buttonw = 100;
    int buttonh = 30;
    int textw = 200;
    int texth = 30;
    
    CGRect buttonRect = CGRectMake(2,20,buttonw, buttonh);
    CGRect textRect = CGRectMake(2+buttonw+2,20, textw, texth);
    CGRect buttonRect2 = CGRectMake(2,20+buttonh,buttonw, buttonh);
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteButton setFrame:buttonRect];
    [deleteButton setTitle:@"Search" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor greenColor];
    [deleteButton setAlpha:0.5f];
    [deleteButton addTarget:self action:@selector(changeUser:) forControlEvents:UIControlEventTouchDown];
    //[deleteButton addTarget:self action:@selector(deleteToken:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:deleteButton];

    UITextField *txt = [[UITextField alloc] initWithFrame:textRect];
    txt.backgroundColor = [UIColor yellowColor];
    txt.tag=322;
    txt.delegate=self;
    [self.view addSubview:txt];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:buttonRect2];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor blueColor];
    [backButton setAlpha:0.5f];
    [backButton addTarget:self action:@selector(resetSearch:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:backButton];
    
    //[self doInstagram:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    

    
    /**
    NSURL *urlPrefix =
    [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    //[NSURL URLWithString:@"http://wap.fingerman.my/uploads/pd/wp/"];
    
    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < 12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];
        
        //NSUInteger photoCount = 1;
        NSUInteger photoCount = arc4random()%3 + 2;
        //if(a==0)
        //    photoCount=4;
        for (NSInteger p = 0; p < photoCount; p++) {
            // there are up to 25 photos available to load from the code repository
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
            //NSString *photoFilename = [NSString stringWithFormat:@"wp_%d_240x320.jpg",photoIndex + 3807];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
     **/
    
    [self.collectionView registerClass:[PhotoView class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.collectionView addGestureRecognizer:swipeGesture];
    
}

#pragma UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


-(void) loadNewPhoto: (NSMutableArray*) newPhotoArr{
    self.albums = [NSMutableArray array];
    self.imagesArr = newPhotoArr;
    for (NSInteger p = 0; p < 12; p++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %ld", (long)p];
        [self.albums addObject:album];
    }
    
    [newPhotoArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *imageDict = (NSMutableDictionary*)obj;
        
        //NSURL *a_url = (NSURL*)obj;
        NSURL *thumbnailURL = [imageDict objectForKey:@"thumbnail"];
        BHPhoto *photo = [BHPhoto photoWithImageURL:thumbnailURL];
        
        int albumid = idx%12;
        BHAlbum* album_ =(BHAlbum*) [self.albums objectAtIndex:albumid];
        //NSLog(@" -> %@", [a_url lastPathComponent]);
        [album_ addPhoto:photo];
    }];
    
    [self.collectionView reloadData];
    //self.collectionView.hidden=NO;
}

-(void) doInstagram: (NSString*)userID{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    userID=@"luping23";
    if(userID == nil){
        return;
    }
    if(instagramQuery.accessToken != nil && [instagramQuery.accessToken length] != 0){
        NSLog(@"existing access token = %@", instagramQuery.accessToken);
        //278910519 lynette
        // nana 279789319
        //nextdoormodel 15125401
        //NSString *userid = @"278910519";
        //https://api.instagram.com/v1/users/{user-id}/media/recent/?access_token=ACCESS-TOKEN
        NSString *fullURL =  [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@&count=24", userID, instagramQuery.accessToken] ;
        
        NSURL *url = [NSURL URLWithString:fullURL];
        self.albums = [NSMutableArray array];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        if (!data) {
            NSLog(@"%s: sendSynchronousRequest error: %@", __FUNCTION__, error);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"%s: sendSynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
                return;
            }
        }
        
        
        
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary) {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }
        
        NSDictionary* photoDict = [dictionary dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"data", nil]];
        NSArray* imageArr = [photoDict objectForKey:@"data"];
        
        
        [imageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray* imageList = [obj valueForKey:@"images"];
            NSArray* standardList = [imageList valueForKey:@"standard_resolution"];
            NSString* highUrl = [standardList valueForKey:@"url"];
            
            NSURL *photoURL = [[NSURL alloc]initWithString:highUrl]; //[urlPrefix URLByAppendingPathComponent:highUrl];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            
            int albumid = idx%12;
            BHAlbum* album_ =(BHAlbum*) [self.albums objectAtIndex:albumid];
            [album_ addPhoto:photo];
            
            NSLog(@" --> %lu", (unsigned long)idx);
            
            if(idx==23){
                *stop=YES;
                [self.collectionView reloadData];
            }
        }];
        
        
    }
    else
    {
        
        NSLog(@"Start Requesting Access Token...");
        // create a webview
        
        int webTag = 321;
        UIWebView* mywebview = (UIWebView*)[self.view viewWithTag:webTag];
        if(mywebview == nil){
            mywebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            mywebview.tag = 321;
            mywebview.delegate = self;
            [self.view addSubview:mywebview];
            
        }
        
       // NSString *fullURL = @"https://instagram.com/oauth/authorize/?client_id=41be5aa5e4634ab4a5bb1c69834fc58d&redirect_uri=http://demo.8g.my&response_type=token";
        NSString *fullURL = @"https://instagram.com/oauth/authorize/?client_id=41be5aa5e4634ab4a5bb1c69834fc58d&redirect_uri=https://4vzao3s9w5.execute-api.ap-southeast-1.amazonaws.com/Stage/pets/Testing&response_type=token&scope=basic+public_content+follower_list+comments+relationships+likes";


        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [mywebview loadRequest:requestObj];
    }
    

}

-(void)changeUser:(id) sender{
    UITextField *txt = (UITextField*)[self.view viewWithTag:322];
    NSMutableDictionary *dict = [instagramQuery GetUser:txt.text];
    
    if(dict != nil && dict.count>0){
        //SearchUserTableViewController *searchTableVC = [[SearchUserTableViewController alloc] init];

        if(_searchTableVC == nil){
            _searchTableVC = [[SearchUserTableViewController alloc] init];
            //_searchTableVC.searchResult = [[NSMutableDictionary alloc] init];
            [self.view addSubview:_searchTableVC.tableView];
            [self addChildViewController:_searchTableVC];
        }
        _searchTableVC.searchResult = dict;
        [_searchTableVC.tableView reloadData];
        _searchTableVC.tableView.hidden = NO;
        //[self.view addSubview:_searchTableVC.tableView];
        //[self addChildViewController:_searchTableVC];
        //[self presentViewController:searchTableVC animated:YES completion:nil];

        [txt resignFirstResponder];
    }
    //[self doInstagram:txt.text];
}

-(void)resetSearch:(id) sender{
    //UITextField *txt = (UITextField*)[self.view viewWithTag:322];
    //NSMutableDictionary *dict = [instagramQuery GetUser:txt.text];
    
    [_searchTableVC.tableView resignFirstResponder];
    _searchTableVC.tableView.hidden = YES;
    
    
    /**
    if(_searchTableVC == nil){
        _searchTableVC = [[SearchUserTableViewController alloc] init];
        //_searchTableVC.searchResult = [[NSMutableDictionary alloc] init];
        [self.view addSubview:_searchTableVC.tableView];
        [self addChildViewController:_searchTableVC];
    }
    _searchTableVC.searchResult = dict;
    [_searchTableVC.tableView reloadData];
    _searchTableVC.tableView.hidden = NO;
    **/
    //[txt resignFirstResponder];
}

-(void)deleteToken:(id) sender{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyForInstagramAccessToken2];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self doInstagram:nil];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString* urlString = [[request URL] absoluteString];
    NSURL *Url = [request URL];
    NSArray *UrlParts = [Url pathComponents];
    // do any of the following here
    if ( UrlParts.count>=4 &&  [[UrlParts objectAtIndex:(3)] isEqualToString:@"Testing"]) {
        //if ([urlString hasPrefix: @"localhost"]) {
        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
        if (tokenParam.location != NSNotFound) {
            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            // If there are more args, don't include them in the token:
            NSRange endRange = [token rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            
            NSLog(@"Received New Access Token %@", token);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:keyForInstagramAccessToken2];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if ([token length] > 0 ) {
                // display the photos here
                //webView=nil;
                [webView removeFromSuperview];
                [self doInstagram:nil];
                /**
                 instagramTableViewController *iController = [[instagramPhotosTableViewController alloc] initWithStyle:UITableViewStylePlain];
                 NSString* redirectUrl = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", token];
                 **/
            }
            // use delegate if you want
            //[self.delegate instagramLoginSucceededWithToken: token];
            
        }
        else {
            // Handle the access rejected case here.
            NSLog(@"rejected case, user denied request");
        }
        return NO;
    }
    return YES;
}




- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture {
    NSLog(@"swipeGesture:");
    CGPoint location = [swipeGesture locationInView:self.view];
    //NSIndexPath *ip = [self.collectionView indexPathForItemAtPoint:location];
    NSIndexPath *ip = [self.collectionView indexPathForItemAtPoint:[self.collectionView.superview convertPoint:location toView:self.collectionView]];
    NSLog(@" section=%d, item=%ld", [ip section], (long)[ip item]);
    
    
    
    PhotoCollectionViewLayout *layout = (PhotoCollectionViewLayout*)self.collectionView.collectionViewLayout;
    
    

    
    
    int newInt = [[layout.lastPhoto objectAtIndex:ip.section] intValue]+1;
    [layout.lastPhoto replaceObjectAtIndex:ip.section withObject:[NSNumber numberWithInt: newInt]];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    
    /**
    NSMutableDictionary *photoLayout = (NSMutableDictionary*)layout.layoutInfo[@"PhotoCell"];
    
    UICollectionViewLayoutAttributes *itemAttributes = (UICollectionViewLayoutAttributes*)photoLayout[ip];
    UICollectionViewLayoutAttributes *itemAttributes2 = (UICollectionViewLayoutAttributes*)photoLayout[toip];
    
    
    int tempZindex = itemAttributes.zIndex;
    itemAttributes.zIndex = itemAttributes2.zIndex;
    itemAttributes2.zIndex = tempZindex;
    
    photoLayout[ip]=itemAttributes;
    photoLayout[toip]=itemAttributes2;
    
    layout.layoutInfo[@"PhotoCell"] = photoLayout;
    
**/
    
    
    //[self.collectionView.collectionViewLayout invalidateLayout];
    
    //NSArray *arr = [[NSArray alloc]initWithObjects:ip,toip, nil];
    
    //[self.collectionView reloadItemsAtIndexPaths:arr];
    
    
    //[self.collectionView ]
    /**
    self.collectionView.collectionViewLayout = layout;
     
    **/
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //return 10;
    return self.albums.count;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    //return 5;
    BHAlbum *album = self.albums[section];
    
    return album.photos.count;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoView *photoCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                              forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    //photoCell.imageView.image = [photo image];
    
    // load photo images in the background
    __weak PhotoCollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        //Get Image from Internet
        UIImage *image = [photo image];
        
        //Update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                PhotoView *cell = (PhotoView *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    
    return photoCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@" %d %d", indexPath.section, indexPath.item);
    
    //UIImageView *previewImage=[[UIImageView alloc]init];
    //UIScrollView *imageScroll=[[UIScrollView alloc]init];
    
    int pIndex = indexPath.section + (indexPath.row * 12);
    NSMutableDictionary *imgDict = [self.imagesArr objectAtIndex:pIndex];
    //NSURL *lowURL = [imgDict valueForKey:@"low_resolution"];
    NSURL *lowURL = [imgDict valueForKey:@"standard_resolution"];
    
    BHPhoto *_photo = [[BHPhoto alloc] initWithImageURL:lowURL];
    
    // load photo images in the background
    __weak PhotoCollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        UIImage *image = [_photo image];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            float width_ = CGImageGetWidth(image.CGImage);
            float height_ = CGImageGetHeight(image.CGImage);
            
            PhotoView *previewImage=
            [[PhotoView alloc]initWithFrame:CGRectMake(
                                                       0,
                                                       (weakSelf.view.superview.bounds.size.height-height_)/2,
                                                       width_, height_)];
            
            UIScrollView *imageScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height)];
            
            previewImage.imageView.image = image; //set image
            previewImage.layer.borderWidth=10.0f;
            
            previewImage.layer.shadowRadius = 6.0f;
            previewImage.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
            previewImage.layer.shadowOpacity = 0.5f;
            
            imageScroll.clipsToBounds=YES;
            imageScroll.contentSize=previewImage.bounds.size;
            
            UIViewController *imageController=[[UIViewController alloc]init];
            imageController.view.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
            [imageController.view addSubview:imageScroll];
            
            [imageScroll addSubview:previewImage];
            
            
            UITapGestureRecognizer *tapPopUpGesture = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(handleTapPopUpGesture:)];
            
            [imageController.view addGestureRecognizer:tapPopUpGesture];
            
            weakSelf.modalPresentationStyle=UIModalPresentationCurrentContext;
            
            AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UITabBarController *tab = (UITabBarController*)[[ap window] rootViewController];
            tab.modalPresentationStyle=UIModalPresentationCurrentContext;
            //imageController.modalPresentationStyle = UIModalPresentationFormSheet;
            [weakSelf presentViewController:imageController animated:YES completion:^{
                
            }];
            
        });
    }];
    
    
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];

    
}

- (void)handleTapPopUpGesture:(UITapGestureRecognizer *)tapGesture {
    
    UIViewController *imageController= (UIViewController*)self;
    
    //imageController.modalPresentationStyle=UIModalTransitionStyleCrossDissolve;
    //imageController.modalPresentationStyle = UIModalPresentationFormSheet;
    [imageController dismissViewControllerAnimated:true completion:^{
        
    }];
    
    /**
    CGPoint location = [tapGesture locationInView:self.view];
         NSIndexPath *ip = [self.collectionView indexPathForItemAtPoint:[self.collectionView.superview convertPoint:location toView:self.collectionView]];
         NSLog(@" section=%d, item=%ld", [ip section], (long)[ip item]);
         
         
         
         PhotoCollectionViewLayout *layout = (PhotoCollectionViewLayout*)self.collectionView.collectionViewLayout;
    
         int newInt = [[layout.lastPhoto objectAtIndex:ip.section] intValue]+1;
         [layout.lastPhoto replaceObjectAtIndex:ip.section withObject:[NSNumber numberWithInt: newInt]];
         
         [self.collectionView.collectionViewLayout invalidateLayout];
    **/
}
     
#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}



@end
