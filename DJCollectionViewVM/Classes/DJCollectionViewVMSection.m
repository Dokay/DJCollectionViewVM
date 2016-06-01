//
//  DJCollectionViewVMSection.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMSection.h"
#import "DJCollectionViewVMRow.h"
#import "DJCollectionViewVM.h"

@interface DJCollectionViewVMSection()

@property (strong, nonatomic) NSMutableArray *mutableRows;

@end

@implementation DJCollectionViewVMSection


+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle
{
    return [[self alloc ] initWithHeaderTitle:headerTitle];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle
{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

+ (instancetype)sectionWithHeaderHeight:(CGFloat)hheight andFooterHeight:(CGFloat)fheight
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(hheight, 0, fheight, 0);
    DJCollectionViewVMSection *section = [[self class] sectionWithHeaderView:nil footerView:nil];
    section.sectionInset = edgeInsets;
    return section;
}

+ (instancetype)sectionWithHeaderHeight:(CGFloat)hheight
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(hheight, 0, 0, 0);
    DJCollectionViewVMSection *section = [[self class] sectionWithHeaderView:nil footerView:nil];
    section.sectionInset = edgeInsets;
    return section;
}

- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    self = [self init];
    if (!self){
        return nil;
    }
    _mutableRows = [[NSMutableArray alloc] init];
    
    return self;
}

- (id)initWithHeaderView:(UICollectionReusableView *)headerView
{
    return [self initWithHeaderView:headerView footerView:nil];
}

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    self = [self init];
    if (self){
        self.headerView = headerView;
        self.headerView.translatesAutoresizingMaskIntoConstraints = YES;
        self.footerView = footerView;
        self.footerView.translatesAutoresizingMaskIntoConstraints = YES;
        _mutableRows = [[NSMutableArray alloc] init];
        
        //TODO:Dokay support UIView
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.headReuseIdentifier = @"UICollectionReusableView";
        self.footReuseIdentifier = @"UICollectionReusableView";
    }
    return self;
}

- (NSUInteger)index
{
    DJCollectionViewVM *collectionViewVM = self.collectionViewVM;
    return [collectionViewVM.sections indexOfObject:self];
}

- (void)reloadSection;
{
    [self.collectionViewVM.collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.index]];
}

#pragma mark - rows manage
- (NSArray *)rows
{
    return self.mutableRows;
}

- (void)addRow:(id)row
{
    if ([row isKindOfClass:[DJCollectionViewVMRow class]]){
        ((DJCollectionViewVMRow *)row).section = self;
    }
    
    [self.mutableRows addObject:row];
}

- (void)addRowsFromArray:(NSArray *)array
{
    for (DJCollectionViewVMRow *Row in array)
    {
        if ([Row isKindOfClass:[DJCollectionViewVMRow class]]){
            ((DJCollectionViewVMRow *)Row).section = self;
        }
    }
    
    [self.mutableRows addObjectsFromArray:array];
}

- (void)insertRow:(id)row atIndex:(NSUInteger)index
{
    if ([row isKindOfClass:[DJCollectionViewVMRow class]]){
        ((DJCollectionViewVMRow *)row).section = self;
    }
    
    [self.mutableRows insertObject:row atIndex:index];
}

- (void)removeRowAtIndex:(NSUInteger)index
{
    [self.mutableRows removeObjectAtIndex:index];
}

- (void)removeRow:(id)row
{
    [self.mutableRows removeObject:row];
}

- (void)removeAllRows
{
    [self.mutableRows removeAllObjects];
}

@end
