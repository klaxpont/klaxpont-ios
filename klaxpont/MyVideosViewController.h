//
//  MyVideosViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface MyVideosViewController : UITableViewController<NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
