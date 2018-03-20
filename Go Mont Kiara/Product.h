//
//  Product.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 11/01/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <Realm/Realm.h>

@interface Product : RLMObject
@property NSString *name;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Product *><Product>
RLM_ARRAY_TYPE(Product)
