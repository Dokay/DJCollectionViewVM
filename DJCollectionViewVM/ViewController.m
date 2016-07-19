//
//  ViewController.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "ViewController.h"
#import "DJCollectionViewVM.h"
#import "DJCollectionViewImageRow.h"
#import "DJCollectionViewTitleCell.h"

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DJCollectionViewVM *collectionVM;

@property (nonatomic, strong) UIView *testHeadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:views]];
    
    switch (self.type) {
        case 0:
        {
            [self testCollection];
        }
            break;
        case 1:
        {
            [self testNormal];
        }
            break;
        case 2:
        {
            [self testHead];
        }
            break;
        case 3:
        {
            [self testConfigHead];
        }
            break;
        case 6:
        {
            [self testPrefetch];
        }
            break;
        default:
            break;
    }
}

- (void)testCollection
{
    NSArray *testDataSource = @[@{@"title":@"SimpleDemo",
                                  @"jumpID":@(1)},
                                @{@"title":@"AutoLayoutWithNibDemo",
                                  @"jumpID":@(2)},
                                @{@"title":@"AutoLayoutWithOutNibNibDemo",
                                  @"jumpID":@(3)},
                                @{@"title":@"FrameLayoutDemo",
                                  @"jumpID":@(4)},
                                @{@"title":@"MoveRowDemo",
                                  @"jumpID":@(5)},
                                @{@"title":@"PrefetchDemo",
                                  @"jumpID":@(6)},
                                @{@"title":@"DeleteDemo",
                                  @"jumpID":@(7)},
                                @{@"title":@"EditAction",
                                  @"jumpID":@(8)},
                                @{@"title":@"InsertDemo",
                                  @"jumpID":@(9)},
                                @{@"title":@"IndexTitle",
                                  @"jumpID":@(10)},];
    
    __weak ViewController *weakSelf = self;
    
    self.collectionVM[@"DJCollectionViewTitleCellRow"] = @"DJCollectionViewTitleCell";
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:20];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    
    for (NSDictionary *testDic in testDataSource) {
        DJCollectionViewTitleCellRow *testRowVM = [DJCollectionViewTitleCellRow new];
        testRowVM.title = [testDic valueForKey:@"title"];
        [testRowVM setSelectionHandler:^(DJCollectionViewTitleCellRow *rowVM) {
            ViewController *aViewController = [ViewController new];
            aViewController.title = rowVM.title;
            aViewController.type = [[testDic objectForKey:@"jumpID"] integerValue];
            [weakSelf.navigationController pushViewController:aViewController animated:YES];
        }];
        [contentSection addRow:testRowVM];
    }
    
    [self.collectionView reloadData];
}

- (void)testNormal
{
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 100; i ++) {
        NSInteger random = arc4random() % 10;
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(random * 20, 40);
        row.backgroundColor = [UIColor redColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *row) {
            NSLog(@"tap %@",row.indexPath);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testHead
{
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderView:self.testHeadView];
    contentSection.sectionInset = UIEdgeInsetsMake(30, 0, 60, 0);
    contentSection.minimumLineSpacing = 6.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 20; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(100, 100);
        row.backgroundColor = [UIColor blueColor];
        [contentSection addRow:row];
    }
    
    [self.collectionView reloadData];
}

- (void)testConfigHead
{
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:20];
    [contentSection setConfigResuseHeadViewHandler:^(UICollectionReusableView *view, DJCollectionViewVMSection *section) {
        view.backgroundColor = [UIColor blueColor];
    }];
    contentSection.minimumLineSpacing = 6.0f;
    contentSection.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 60);
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 200; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(40, 40);
        row.backgroundColor = [UIColor redColor];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testCustomCell
{
    self.collectionVM[@"DJCollectionViewImageRow"] = @"DJCollectionViewImageCell";
    
    [self.collectionVM removeAllSections];
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderView:self.testHeadView];
    contentSection.sectionInset = UIEdgeInsetsMake(30, 0, 30, 0);
    contentSection.minimumLineSpacing = 6.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 100; i ++) {
        DJCollectionViewImageRow *row = [DJCollectionViewImageRow new];
        row.itemSize = CGSizeMake(100, 100);
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testPrefetch
{
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 1000; i ++) {
        NSInteger random = arc4random() % 10;
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(random * 20, 40);
        row.backgroundColor = [UIColor redColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *row) {
            NSLog(@"tap %@",row.indexPath);
        }];
        [row setPrefetchHander:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"PrefetchHander->%ld",i);
        }];
        [row setPrefetchCancelHander:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"PrefetchCancelHander->%ld",i);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
    
    
}

#pragma mark - getter
- (UICollectionView  *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _collectionView;
}

- (DJCollectionViewVM *)collectionVM
{
    if (_collectionVM == nil) {
        _collectionVM = [[DJCollectionViewVM alloc] initWithCollectionView:self.collectionView];
    }
    return _collectionVM;
}

- (UIView *)testHeadView
{
    if (_testHeadView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        view.backgroundColor = [UIColor purpleColor];
        _testHeadView = view;
    }
    return _testHeadView;
}

@end
