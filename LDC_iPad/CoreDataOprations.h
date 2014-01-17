//
//  CoreDataOprations.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 12/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;

@interface CoreDataOprations : NSObject
{
    
}

+(CoreDataOprations*)initObject;

-(NSArray*)fetchRequest:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSManagedObjectContext*)managedObjectContext;
//Added By Umesh  on 13 March 2013 to fetch member record in last name order
-(NSArray*)fetchRequestForEntity:(NSString*)entityKey withSortDecs:(NSString*)sortDescriptorKey forManagedObj:(NSManagedObjectContext*)managedObjectContext;

//----------

-(NSArray*)fetchRequestUpcoming:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)compareDateKey:(NSManagedObjectContext*)managedObjectContext;

//----
-(NSArray*)fetchRequestPast:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)compareDateKey:(NSManagedObjectContext*)managedObjectContext;

//----------

-(NSArray*)fetchRequestSearch:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)searchAttribute:(NSString*)searchValue:(NSManagedObjectContext*)managedObjectContext;
//Added By Umesh  on 13 March 2013 to fetch member record in last name order
-(NSArray*)fetchRequestSearchForEntity:(NSString*)entityKey withSortDesc:(NSString*)sortDescriptorKey forAttribute:(NSString*)searchAttribute withSearchVal:(NSString*)searchValue andWithManagedObj:(NSManagedObjectContext*)managedObjectContext;


//---------
-(NSArray*)fetchRequestAccordingtoCategory:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)catagoryName:(NSString*)categoryValue:(NSManagedObjectContext*)managedObjectContext;
//Added By Umesh  on 13 March 2013 to fetch member record in last name order
-(NSArray*)fetchRequestAccordingtoCategoryForEntity:(NSString*)entityKey withSortDescriptor:(NSString*)sortDescriptorKey withCategoryName:(NSString*)catagoryName withCategoryValue:(NSString*)categoryValue andManagedObject:(NSManagedObjectContext*)managedObjectContext;

//----

-(NSArray*)fetchRequestAccordingtoFounderCategory:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)catagoryName:(NSString*)categoryValue:(NSManagedObjectContext*)managedObjectContext;
//Added By Umesh  on 13 March 2013 to fetch member record in last name order
-(NSArray*)fetchRequestAccordingtoFounderCategoryForEntity:(NSString*)entityKey withSortDesc:(NSString*)sortDescriptorKey withCategoryName:(NSString*)catagoryName withCategoryVal:(NSString*)categoryValue andManagedBoj:(NSManagedObjectContext*)managedObjectContext;

-(NSArray*)fetchRequestSearchForEntity:(NSString*)entityKey withSortDesc:(NSString*)sortDescriptorKey forAttributeArray:(NSArray*)searchAttribute withSearchVal:(NSString*)searchValue andWithManagedObj:(NSManagedObjectContext*)managedObjectContext;

//Added By Umesh  on 13 March 2013 to fetch member record in last name order








@end
