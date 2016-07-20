//
//  ViewController.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "ViewController.h"
#import "DJCollectionViewVM.h"
#import "DJCollectionViewImageCell.h"
#import "DJCollectionViewTitleCell.h"
#import "DJCollectionViewLongTitleCell.h"
#import "DJCollectionViewReusableTitleView.h"

static const NSString *kConstContent = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do";

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DJCollectionViewVM *collectionVM;

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
            [self testAutoLayoutWithNib];
        }
            break;
        case 3:
        {
            [self testAutoLayoutWithoutNib];
        }
            break;
        case 4:
        {
            [self testFrameLayout];
        }
            break;
        case 5:
        {
            [self testMoveRow];
        }
            break;
        case 6:
        {
            [self testPrefetch];
        }
            break;
        case 7:
        {
            [self testCustomNormalHeadView];
        }
            break;
        case 8:
        {
            [self testCustomResuseHeadView];
        }
            break;
        case 9:
        {
            [self testCustomResuseHeadViewWithNib];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tests
- (void)testCollection
{
    NSArray *testDataSource = @[@{@"title":@"SimpleDemo",
                                  @"jumpID":@(1)},
                                @{@"title":@"AutoLayoutCellWithNibDemo",
                                  @"jumpID":@(2)},
                                @{@"title":@"AutoLayoutCellWithoutNibDemo",
                                  @"jumpID":@(3)},
                                @{@"title":@"FrameLayoutDemo",
                                  @"jumpID":@(4)},
                                @{@"title":@"MoveRowDemo",
                                  @"jumpID":@(5)},
                                @{@"title":@"PrefetchDemo",
                                  @"jumpID":@(6)},
                                @{@"title":@"CustomNormalHeadViewDemo",
                                  @"jumpID":@(7)},
                                @{@"title":@"CustomResuseHeadViewDemo",
                                  @"jumpID":@(8)},
                                @{@"title":@"AutoLayoutReusableWithNibDemo",
                                  @"jumpID":@(9)},];
    
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
    for (NSInteger i = 0; i < 15; i ++) {
        NSInteger random = arc4random() % 10;
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.rowSize = CGSizeMake(random * 20, 40);
        row.backgroundColor = [UIColor redColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    
    DJCollectionViewVMSection *contentBigSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentBigSection.minimumLineSpacing = 10.0f;
    contentBigSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentBigSection];
    for (NSInteger i = 0; i < 20; i ++) {
        NSInteger random = arc4random() % 5;
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.rowSize = CGSizeMake(random * 20, random * 10);
        row.backgroundColor = [UIColor purpleColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentBigSection addRow:row];
    }
    
    [self.collectionView reloadData];
}

- (void)testAutoLayoutWithNib
{
    self.collectionVM[@"DJCollectionViewTitleCellRow"] = @"DJCollectionViewLongTitleCell";
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    
    NSArray *wordsArray = [kConstContent componentsSeparatedByString:@" "];
    for (NSInteger i = 0; i < wordsArray.count; i ++) {
        DJCollectionViewTitleCellRow *row = [DJCollectionViewTitleCellRow new];
        row.title = wordsArray[i];
        row.sizeCaculateType = DJCellSizeCaculateAutoLayout;
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testAutoLayoutWithoutNib
{
    self.collectionVM[@"DJCollectionViewImageRow"] = @"DJCollectionViewImageCell";
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 100; i ++) {
        DJCollectionViewImageRow *row = [DJCollectionViewImageRow new];
        row.image = [UIImage imageNamed:@"test_head"];
        row.sizeCaculateType = DJCellSizeCaculateAutoLayout;
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testFrameLayout
{
    self.collectionVM[@"DJCollectionViewTitleCellRow"] = @"DJCollectionViewTextFrameCell";
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 5.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    
    NSArray *wordsArray = [kConstContent componentsSeparatedByString:@" "];
    for (NSInteger i = 0; i < wordsArray.count; i ++) {
        DJCollectionViewTitleCellRow *row = [DJCollectionViewTitleCellRow new];
        row.title = wordsArray[i];
        row.sizeCaculateType = DJCellSizeCaculateAutoFrameLayout;
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testMoveRow
{
    self.collectionVM[@"DJCollectionViewTitleCellRow"] = @"DJCollectionViewTextFrameCell";
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 5.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    
    NSArray *wordsArray = [kConstContent componentsSeparatedByString:@" "];
    for (NSInteger i = 0; i < wordsArray.count; i ++) {
        DJCollectionViewTitleCellRow *row = [DJCollectionViewTitleCellRow new];
        row.title = wordsArray[i];
        row.sizeCaculateType = DJCellSizeCaculateAutoFrameLayout;
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [row setMoveCellHandler:^BOOL(DJCollectionViewVMRow *rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destIndexPath) {
            return YES;
        }];
        [row setMoveCellCompletionHandler:^(DJCollectionViewVMRow *rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destIndexPath) {
            
        }];
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
        row.rowSize = CGSizeMake(random * 20, 40);
        row.backgroundColor = [UIColor redColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *row) {
            NSLog(@"tap %@",row.indexPath);
        }];
        [row setPrefetchHander:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"PrefetchHander->%ld",(long)i);
        }];
        [row setPrefetchCancelHander:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"PrefetchCancelHander->%ld",(long)i);
        }];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testCustomNormalHeadView
{
    [self.collectionVM removeAllSections];
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    firstView.backgroundColor = [UIColor purpleColor];
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderView:firstView];
    contentSection.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0);
    contentSection.minimumLineSpacing = 6.0f;
    contentSection.headerReferenceSize = firstView.frame.size;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 15; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.rowSize = CGSizeMake(100, 100);
        row.backgroundColor = [UIColor blueColor];
        [contentSection addRow:row];
    }
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    secondView.backgroundColor = [UIColor yellowColor];
    DJCollectionViewVMSection *contentSecondSection = [DJCollectionViewVMSection sectionWithHeaderView:secondView];
    contentSecondSection.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0);
    contentSecondSection.minimumLineSpacing = 6.0f;
    contentSecondSection.headerReferenceSize = secondView.frame.size;
    [self.collectionVM addSection:contentSecondSection];
    for (NSInteger i = 0; i < 10; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.rowSize = CGSizeMake(100, 100);
        row.backgroundColor = [UIColor redColor];
        [contentSecondSection addRow:row];
    }
    
    [self.collectionView reloadData];
}

- (void)testCustomResuseHeadView
{
    [self.collectionVM removeAllSections];
    
    [self.collectionVM registReusableViewClassName:@"DJCollectionViewReusableTitleView" forReusableVMClassName:@"DJCollectionViewReusableTitle"];
    
    DJCollectionViewReusableTitle *reusableHeadVM = [DJCollectionViewReusableTitle new];
    reusableHeadVM.title = @"HeadView";
    reusableHeadVM.resuableSize = CGSizeMake(self.view.bounds.size.width, 60);
    
    DJCollectionViewReusableTitle *reusableFootVM = [DJCollectionViewReusableTitle new];
    reusableFootVM.title = @"FootView";
    reusableFootVM.resuableSize = CGSizeMake(self.view.bounds.size.width, 40);
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:0];
    contentSection.headerReusabelVM = reusableHeadVM;
    contentSection.footerReusableVM = reusableFootVM;
    contentSection.minimumLineSpacing = 6.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 150; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.rowSize = CGSizeMake(40, 40);
        row.backgroundColor = [UIColor redColor];
        [contentSection addRow:row];
    }
    [self.collectionView reloadData];
}

- (void)testCustomResuseHeadViewWithNib
{
    [self.collectionVM removeAllSections];
    
    [self.collectionVM registReusableViewClassName:@"DJCollectionViewReusableTitleWithNibView" forReusableVMClassName:@"DJCollectionViewReusableTitle"];
    
    DJCollectionViewReusableTitle *reusableHeadVM = [DJCollectionViewReusableTitle new];
    reusableHeadVM.backgroundColor = [UIColor brownColor];
    reusableHeadVM.title = [@"HeaderView:" stringByAppendingString:[kConstContent substringToIndex:150]];
    reusableHeadVM.sizeCaculateType = DJReusableSizeCaculateTypeAutoLayout;
    
    DJCollectionViewReusableTitle *reusableFootVM = [DJCollectionViewReusableTitle new];
    reusableFootVM.backgroundColor = [UIColor yellowColor];
    reusableFootVM.title = [@"FooterView:" stringByAppendingString:[kConstContent substringToIndex:100]];
    reusableFootVM.sizeCaculateType = DJReusableSizeCaculateTypeAutoLayout;
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:0];
    contentSection.headerReusabelVM = reusableHeadVM;
    contentSection.footerReusableVM = reusableFootVM;
    contentSection.minimumLineSpacing = 6.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 150; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.rowSize = CGSizeMake(40, 40);
        row.backgroundColor = [UIColor redColor];
        [contentSection addRow:row];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - getter
- (UICollectionView  *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
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

@end
