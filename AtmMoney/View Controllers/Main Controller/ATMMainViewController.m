//
//  ViewController.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Updated by Dimitris C.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "ATMMainViewController.h"
#import "LocationHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Bank.h"
#import "ATMBankTableViewCell.h"
#import "ATMDetailBankViewController.h"
#import "MapViewController.h"
#import "ATMFilterView.h"
#import "ATMUserSettings.h"

@interface ATMMainViewController   ()
@property (nonatomic, strong) ATMFilterView *filterView;
@end

@implementation ATMMainViewController

static NSString *simpleTableIdentifier = @"bankItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"mainviewcontroller.title", @"Localization", nil);
    
    //adding observer to being notify when location property is changed
    self.tableView.rowHeight = 100;
    [self.tableView registerClass:[ATMBankTableViewCell class] forCellReuseIdentifier:simpleTableIdentifier];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map-icon-normal"] style:UIBarButtonItemStylePlain target:self action:@selector(openMap)];
    mapButton.imageInsets = UIEdgeInsetsMake(5, -5, -5, 5);
    self.navigationItem.rightBarButtonItem = mapButton;
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter-icon-normal"] style:UIBarButtonItemStylePlain target:self action:@selector(filterTableView)];
    filterButton.imageInsets = UIEdgeInsetsMake(5, -5, -5, 5);
    self.navigationItem.leftBarButtonItem = filterButton;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)filterTableView {
    
    // Since we are using a UITableViewController the self.view is the table view.
    // However, we need to display the filter view on top of the table view.
    if (!self.filterView) {
        CGFloat height = self.topLayoutGuide.length; // gives the height of the navigationbar and status bar...
        CGRect filterViewFrame = CGRectMake(0, height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.filterView = [[ATMFilterView alloc] initWithFrame:filterViewFrame
                                              andSelectedBanks:Eng.getNearestBanks.selectedBanksToFilter];
        self.filterView.delegate = self;
        [self.navigationController.view insertSubview:self.filterView belowSubview:self.navigationController.navigationBar];
        [self.filterView sizeToFit];
        
        [self.filterView showAnimatedWithCompletion:nil];
        
    } else {
        [self.filterView hideAnimatedWithCompletion:^{
            [self removeFilterView];
        }];
    }
    
}

- (void)removeFilterView {
    Eng.getNearestBanks.selectedBanksToFilter = [[ATMUserSettings getFavouritesBanks] mutableCopy];
    [self.filterView removeFromSuperview];
    self.filterView = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.filterView) {
        CGFloat topHeightOfNavigationBar = self.topLayoutGuide.length; // gives the height of the navigationbar and status bar...
        CGRect filterViewFrame = CGRectMake(0, topHeightOfNavigationBar, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.filterView.frame = filterViewFrame;
        [self.filterView layoutIfNeeded];
    }
}

#pragma mark - Filter View Delegate -

- (void)filterViewDidRequestToClose {
    [self removeFilterView];
}

- (void)filterViewDidRequestToFilterData {
    
    [SVProgressHUD show];
    [self.refreshControl beginRefreshing];
    
    Eng.getNearestBanks.selectedBanksToFilter = self.filterView.selectedBanks;
    
    CGFloat savedDistance = [ATMUserSettings getDistance];
    [self getBanksWithCurrentLocationAndDistance:savedDistance];
    
    [self removeFilterView];
}

- (void)refreshTableView {
    
    [Location startUpdatingLocation];
    
}

- (void)openMap {
    if([Eng.getNearestBanks.data count] == 0) return;
    
    [self.filterView hideAnimatedWithCompletion:^{
        [self removeFilterView];
    }];
    
    // Hides the back button name
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];

    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.coords = Eng.getNearestBanks.data;
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
   
    [Location addObserver:self forKeyPath:CURRENT_LOCATION_KEY options:NSKeyValueObservingOptionNew context:nil];}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [SVProgressHUD show];
    [self.refreshControl beginRefreshing];
    
    [Location startUpdatingLocation];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [Location removeObserver:self forKeyPath:CURRENT_LOCATION_KEY context:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [Eng.getNearestBanks.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ATMBankTableViewCell *cell = (ATMBankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (Eng.getNearestBanks.data.count) {
        Bank *bank = [Eng.getNearestBanks.data objectAtIndex:indexPath.row];
        [cell updateWithBank:bank];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Bank *bank = [Eng.getNearestBanks.data objectAtIndex:indexPath.row];

    [self.filterView hideAnimatedWithCompletion:^{
        [self removeFilterView];
    }];
    
    // Hides the back button name
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    ATMDetailBankViewController  *atmDetailViewController = [[ATMDetailBankViewController alloc] initWithBank:bank];
    
    [SVProgressHUD show];
    [Eng.getNearestBanks getBankHistoryWithId:bank.buid
                               withCompletion:^{
                                   [SVProgressHUD dismiss];
                                   [self.navigationController pushViewController:atmDetailViewController animated:YES];
                                   
                               }
                                   andFailure:^{
                                       [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"network.failure.title", @"Localization", nil)];
                                   
                                   }];
}

// from: http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:CURRENT_LOCATION_KEY]) {
        CGFloat savedDistance = [ATMUserSettings getDistance];
        if (!savedDistance) savedDistance = 5;
        [self getBanksWithCurrentLocationAndDistance:savedDistance];
        [Location stopUpdatingLocation];
    }
}

- (void)getBanksWithCurrentLocationAndDistance:(CGFloat)distance {
    
    CLLocation *location = Location.currentLocation;
    [Eng.getNearestBanks getNearestBanksWithLocation:location
                                         andDistance:distance
                                      withCompletion:^{
                                        [self.tableView reloadData];
                                        [self.refreshControl endRefreshing];
                                        [SVProgressHUD dismiss];
                                      }
                                          andFailure:^{
                                            [self.refreshControl endRefreshing];
                                            [self.tableView reloadData];
                                            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"network.failure.title", @"Localization", nil)];
                                          } andNoEntriesFailure:^{
                                              [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"network.failure.noentries.title", @"Localization", nil)];
                                          }];
    
}

@end
