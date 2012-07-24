//
//  CatalogViewController.m
//  ESCatalog
//
//  Created by Chi Zhang on 7/23/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "CatalogViewController.h"

#import "DialogViewController.h"

#import "ESBlocks.h"


#define ITEM(Name, Action) [NSArray arrayWithObjects:Name, NSStringFromSelector(Action) , nil]
#define NAME(Item) [Item objectAtIndex:0]
#define ACTION(Item) NSSelectorFromString([Item objectAtIndex:1])

@interface CatalogViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (readonly, nonatomic) NSArray *catalog;
@end

@implementation CatalogViewController
@synthesize tableView = _tableView;
@synthesize catalog = _catalog;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSArray *)catalog
{
    if (_catalog == nil) {
        id alertViewWithBlocks = ITEM(@"UIAlertView+Blocks", @selector(showAlertViewWithBlocks));
        id actionSheetWithBlocks = ITEM(@"UIActionSheet + Blocks", @selector(showActionSheetWithBlocks));
        id customDialog = ITEM(@"Custom Dialog ViewController", @selector(showCustomDialog));
        id grid = ITEM(@"Grid View Controller", @selector(showGridViewController));
        id sms = ITEM(@"SMS View Controller", @selector(showSMSViewController));
        id mail = ITEM(@"Email View Controller", @selector(showMailViewController));
        _catalog = [NSArray arrayWithObjects:
                    alertViewWithBlocks,
                    actionSheetWithBlocks,
                    customDialog,
                    grid,
                    sms,
                    mail,
                    nil];
    }
    return _catalog;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.catalog count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CatalogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    id item = [self.catalog objectAtIndex:indexPath.row];
    cell.textLabel.text = NAME(item);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = [self.catalog objectAtIndex:indexPath.row];
    SEL action = ACTION(item);
    [self performSelector:action];
}

- (void)showAlertViewWithBlocks
{
    UIAlertView *av = [UIAlertView alertViewWithTitle:@"Title" 
                                              message:@"This is an alert."
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:[NSArray arrayWithObject:@"OK"]
                                            onDismiss:^(UIAlertView *av, int buttonIndex) {
                                                NSLog(@"dismissed: %d", buttonIndex);
                                            } onCancel:^{
                                                NSLog(@"canceled. "); 
                                            }];
    [av show];
}

- (void)showActionSheetWithBlocks
{
    UIActionSheet *as = [UIActionSheet actionSheetWithTitles:([NSArray arrayWithObjects:@"Option1", @"Option2", nil])
                                                   onDismiss:^(UIActionSheet *as, int buttonIndex) {
                                                       NSLog(@"dismissed: %d", buttonIndex);
                                                   }];
    [as show];
}

- (void)showCustomDialog
{
    DialogViewController *dialogViewController = [[DialogViewController alloc] init];
    [dialogViewController showAsDialog];
}

- (void)showSMSViewController
{
    [[ESViewControllerFactory sharedFactory] showMessageViewControllerWithRecipients:[NSArray arrayWithObject:@"123"]
                                                                                body:@"test"
                                                                              onSend:^(MFMessageComposeViewController *controller, MessageComposeResult result) {
                                                                                  NSLog(@"result: %d", result);
                                                                              }];
}

- (void)showMailViewController
{
    [[ESViewControllerFactory sharedFactory] showMailViewControllerWithRecipients:[NSArray arrayWithObject:@"123@abc.com"] 
                                                                            title:@"Title"
                                                                             body:@"body"
                                                                           onSend:^(MFMailComposeViewController *controller, MFMailComposeResult result) {
                                                                               NSLog(@"result: %d", result);
                                                                           }];
}

- (void)showGridViewController
{
    [self performSegueWithIdentifier:@"showGridViewController" sender:self];
}

@end
