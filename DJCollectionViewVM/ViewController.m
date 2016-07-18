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
    self.collectionVM[@"DJCollectionViewImageRow"] = @"DJCollectionViewImageCell";
    
    [self testRow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testRow
{
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *section1 = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
//    section1.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    section1.sectionInset = UIEdgeInsetsZero;
    section1.minimumLineSpacing = 0.0f;
    section1.minimumInteritemSpacing = 0.0f;
    [self.collectionVM addSection:section1];
    for (NSInteger i = 0; i < 30; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(self.view.frame.size.width/2 - 30, 40);
        row.backgroundColor = [UIColor redColor];
        [row setSelectionHandler:^(DJCollectionViewVMRow *row) {
            NSLog(@"tap %@",row.indexPath);
        }];
        [section1 addRow:row];
    }
    
    DJCollectionViewVMSection *section2 = [DJCollectionViewVMSection sectionWithHeaderHeight:20];
    [section2 setConfigResuseHeadViewHandler:^(UICollectionReusableView *view, DJCollectionViewVMSection *section) {
        view.backgroundColor = [UIColor blueColor];
    }];
    section2.minimumLineSpacing = 6.0f;
    section2.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
    [self.collectionVM addSection:section2];
    for (NSInteger i = 0; i < 1000; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
        row.itemSize = CGSizeMake(30, 30);
        row.backgroundColor = [UIColor redColor];
        [row setPrefetchHander:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"PrefetchHander->%ld",i);
        }];
        [row setPrefetchCancelHander:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"PrefetchCancelHander->%ld",i);
        }];
        [section2 addRow:row];
    }
//
//    DJCollectionViewVMSection *section3 = [DJCollectionViewVMSection sectionWithHeaderView:self.testHeadView];
//    section3.sectionInset = UIEdgeInsetsMake(30, 0, 30, 0);
//    section3.minimumLineSpacing = 6.0f;
//    section3.footerReferenceSize = self.testHeadView.bounds.size;
//    [self.collectionVM addSection:section3];
//    for (NSInteger i = 0; i < 100; i ++) {
//        DJCollectionViewVMRow *row = [DJCollectionViewVMRow new];
//        row.itemSize = CGSizeMake(100, 100);
//        row.backgroundColor = [UIColor redColor];
//        [section3 addRow:row];
//    }
//    
//    DJCollectionViewVMSection *section4 = [DJCollectionViewVMSection sectionWithHeaderView:self.testHeadView];
//    section4.sectionInset = UIEdgeInsetsMake(30, 0, 30, 0);
//    section4.minimumLineSpacing = 6.0f;
//    section4.footerReferenceSize = self.testHeadView.bounds.size;
//    [self.collectionVM addSection:section4];
//    for (NSInteger i = 0; i < 100; i ++) {
//        DJCollectionViewVMRow *row = [DJCollectionViewImageRow new];
//        row.itemSize = CGSizeMake(100, 100);
//        row.backgroundColor = [UIColor redColor];
//        [section4 addRow:row];
//    }
    
    DJCollectionViewVMSection *section4 = [DJCollectionViewVMSection sectionWithHeaderView:self.testHeadView];
    section4.sectionInset = UIEdgeInsetsMake(30, 0, 30, 0);
    section4.minimumLineSpacing = 6.0f;
    section4.footerReferenceSize = self.testHeadView.bounds.size;
    [self.collectionVM addSection:section4];
    for (NSInteger i = 0; i < 100; i ++) {
        DJCollectionViewVMRow *row = [DJCollectionViewImageRow new];
        row.itemSize = CGSizeMake(100, 100);
        row.backgroundColor = [UIColor redColor];
        [section4 addRow:row];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
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
