//
//  MyVideosViewController.m
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import "MyVideosViewController.h"
#import "Video.h"
#import "VideoCell.h"
#import "VideoPickerController.h"
#import "DatabaseHelper.h"

@interface MyVideosViewController ()
{
    VideoPickerController *_videoPickerController;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MyVideosViewController

@synthesize fetchedResultsController=_fetchedResultsController, managedObjectContext=_managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Mes Vidéos";       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // custom top bar
    [[self navigationController].navigationBar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVideo)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    
    // 
    _videoPickerController = [[VideoPickerController alloc] init];
    [_videoPickerController setDelegate:self];

    // custom table cell
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
    UITableViewCell *cell = [nib objectAtIndex:0];
    self.tableView.rowHeight = cell.frame.size.height;
    
    // populate table
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    [_videoPickerController setDelegate:nil];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void) addVideo
{
    [self presentModalViewController:_videoPickerController animated:YES];

}
#pragma mark - Delegates

#pragma mark VideoPickerController

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker setDelegate:nil];
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    [picker setDelegate:nil];
    NSLog(@"infos from dictionary : %@", info);
    
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    NSString *moviePath = [mediaUrl path];
    if ([DatabaseHelper saveLocalVideo:moviePath] != nil)
        NSLog(@"Video successfully saved!");
    else
        NSLog(@"Video was not saved in db!");
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[(VideoCell*)cell titleLabel] setText:video.title];
    [[(VideoCell*)cell thumbnailView] setImage:[video thumbnail]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoCellIdentifier";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // have to do this because of not using storyboard or xib, or is it something else?
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // open Video
}

#pragma mark NSFetchedResults Controller delegate

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
//    NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
//    NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] init];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"my_videos_cache"];
    _fetchedResultsController.delegate = self;
    
    // Memory management.
    
    return _fetchedResultsController;
}


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
