//
//  Created by Kateryna Gridina.
//  Copyright (c) gridNA. All rights reserved.
//  Latest version can be found at https://github.com/gridNA/GNAContextMenu
//


#import "ObjcViewController.h"
#import "GNAContextMenuExample-Swift.h"

@interface ObjcViewController() <GNAMenuItemDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GNAMenuView *menuView;

@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ObjC";
    [self setupTable];
    [self createMenuItem];
}

- (void)setupTable {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addGestureRecognizer: [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]];
}

- (void)createMenuItem {
    GNAMenuItem *item = [[GNAMenuItem alloc] initWithIcon:[UIImage imageNamed:@"shopingCart_inactive"] activeIcon:[UIImage imageNamed:@"shopingCart"] title:@"Shop It"];
    [item changeTitleWithTitle:@"ttt"];
    [item changeActiveIconWithIcon: [UIImage imageNamed: @"defaultImage"]];
    [item changeIconWithIcon: [UIImage imageNamed: @"wishlist_inacitve"]];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleView.backgroundColor = UIColor.redColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [item changeTitleViewWithView: titleView];
    [item changeTitleLabelWithLabel:titleLabel];

    GNAMenuItem *item2 = [[GNAMenuItem alloc] initWithIcon:[UIImage imageNamed: @"wishlist_inacitve"] activeIcon:[UIImage imageNamed: @"wishlist"] title:@"Wish"];
    GNAMenuItem *item3 = [[GNAMenuItem alloc] initWithIcon:[UIImage imageNamed: @"wishlist_inacitve"] activeIcon:[UIImage imageNamed: @"wishlist"] title:@"Wish"];
    self.menuView = [[GNAMenuView alloc] initWithTouchPointSize: CGSizeMake(80, 80) touchImage: [UIImage imageNamed: @"defaultImage"] menuItems:@[item, item2, item3]];
    self.menuView.delegate = self;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *) gesture {
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:point];
    if (path != NULL) {
        self.menuView.additionalInfo = @{@"cellPath": path};
    }
    [self.menuView handleGesture:gesture inView:self.tableView];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"cell"];
    cell.textLabel.text = @"Some title";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
