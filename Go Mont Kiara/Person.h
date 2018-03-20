//
//  Person.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 11/01/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@class Person;

// Dog model
@interface Dog : RLMObject
@property NSString *name;
@property Person   *owner;
@end
RLM_ARRAY_TYPE(Dog) // define RLMArray<Dog>

// Person model
@interface Person : RLMObject
@property NSString             *name;
@property NSString             *email;
@property NSString             *phoneno;
@property NSDate               *birthdate;
@property RLMArray<Dog *><Dog> *dogs;
@end
RLM_ARRAY_TYPE(Person) // define RLMArray<Person>
