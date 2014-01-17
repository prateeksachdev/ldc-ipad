//
//  CoreDataOprations.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 12/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "CoreDataOprations.h"
#import "AppDelegate.h"

@implementation CoreDataOprations

+(CoreDataOprations*)initObject
{
    return [[self alloc]init];
}

-(NSArray*)fetchRequest:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                   entityForName:entityKey
                                   inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];

    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}


-(NSArray*)fetchRequestForEntity:(NSString*)entityKey withSortDecs:(NSString*)sortDescriptorKey forManagedObj:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}

-(NSArray*)fetchRequestAccordingtoCategory:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)catagoryName:(NSString*)categoryValue:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = catagoryName;
    //
    
    NSString *attributeValue=categoryValue;
    
    //    NSDate *datecurrent=[dateFormatter dateFromString:attributeValue];
    //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",attributeName,attributeValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if ([array count]<1) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",attributeName,[attributeValue uppercaseString]]; // dateInt is a unix time stamp for the current
        [fetchRequest setPredicate:pred];
        array = [managedObjectContext
                 executeFetchRequest:fetchRequest error:&error];
    }
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;

}


-(NSArray*)fetchRequestAccordingtoCategoryForEntity:(NSString*)entityKey withSortDescriptor:(NSString*)sortDescriptorKey withCategoryName:(NSString*)catagoryName withCategoryValue:(NSString*)categoryValue andManagedObject:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = catagoryName;
    //
    
    NSString *attributeValue=categoryValue;
    
    //    NSDate *datecurrent=[dateFormatter dateFromString:attributeValue];
    //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",attributeName,attributeValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if ([array count]<1) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",attributeName,[attributeValue uppercaseString]]; // dateInt is a unix time stamp for the current
        [fetchRequest setPredicate:pred];
        array = [managedObjectContext
                 executeFetchRequest:fetchRequest error:&error];
    }
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    fetchRequest = nil;
    return array;
    
}




-(NSArray*)fetchRequestAccordingtoFounderCategory:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)catagoryName:(NSString*)categoryValue:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = catagoryName;
    //
    
    NSString *attributeValue=categoryValue;
    
    //    NSDate *datecurrent=[dateFormatter dateFromString:attributeValue];
    //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",attributeName,attributeValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
    
}

-(NSArray*)fetchRequestAccordingtoFounderCategoryForEntity:(NSString*)entityKey withSortDesc:(NSString*)sortDescriptorKey withCategoryName:(NSString*)catagoryName withCategoryVal:(NSString*)categoryValue andManagedBoj:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = catagoryName;
    //
    
    NSString *attributeValue=categoryValue;
    
    //    NSDate *datecurrent=[dateFormatter dateFromString:attributeValue];
    //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@",attributeName,attributeValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
    
}

//

-(NSArray*)fetchRequestUpcoming:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)compareDateKey:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = compareDateKey;
    //
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
    NSString *attributeValue=[dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *datecurrent=[dateFormatter dateFromString:attributeValue];
    //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K >= %@",attributeName,datecurrent]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
        
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}
-(NSArray*)fetchRequestPast:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)compareDateKey:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = compareDateKey;
    //
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
    NSString *attributeValue=[dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *datecurrent=[dateFormatter dateFromString:attributeValue];
    //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K < %@",attributeName,datecurrent]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}

-(NSArray*)fetchRequestSearch:(NSString*)entityKey:(NSString*)sortDescriptorKey:(NSString*)searchAttribute:(NSString*)searchValue:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
   
    NSString *attributeName = searchAttribute;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",attributeName,searchValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}


-(NSArray*)fetchRequestSearchForEntity:(NSString*)entityKey withSortDesc:(NSString*)sortDescriptorKey forAttribute:(NSString*)searchAttribute withSearchVal:(NSString*)searchValue andWithManagedObj:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
    NSString *attributeName = searchAttribute;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",attributeName,searchValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}

-(NSArray*)fetchRequestSearchForEntity:(NSString*)entityKey withSortDesc:(NSString*)sortDescriptorKey forAttributeArray:(NSArray*)searchAttribute withSearchVal:(NSString*)searchValue andWithManagedObj:(NSManagedObjectContext*)managedObjectContext
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entityDescripter = [NSEntityDescription
                                             entityForName:entityKey
                                             inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescripter];
    
//    NSString *attributeName = searchAttribute;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K contains[cd] %@) OR (%K contains[cd] %@)",[searchAttribute objectAtIndex:0],searchValue,[searchAttribute objectAtIndex:1],searchValue]; // dateInt is a unix time stamp for the current
    [fetchRequest setPredicate:pred];
    //  [fetchRequest setFetchLimit:20];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:sortDescriptorKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return array;
}



@end
