//
//  DJCollectionViewVM.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVM.h"
#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVM+UIScrollViewDelegate.h"
#import "DJCollectionViewVM+UICollectionViewDelegate.h"
#import "DJCollectionViewVM+UICollectionViewDelegateFlowLayout.h"
#import "DJPrefetchManager.h"

@interface DJCollectionViewVM()

@property (strong, nonatomic) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableDictionary *registeredReuseViewXIBs;
@property (strong, nonatomic) NSMutableArray *mutableSections;
@property (nonatomic, strong) DJPrefetchManager *prefetchManager;

@end

@implementation DJCollectionViewVM

- (id)init
{
    NSAssert(NO, @"换个别的吧");
    return nil;
}

- (id)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<DJCollectionViewVMDelegate>)delegate
{
    self = [self initWithCollectionView:collectionView];
    if (!self)
        return nil;
    
    self.delegate = delegate;
    self.dataSource = (id<DJCollectionViewVMDataSource>)delegate;
    
    return self;
}

- (id)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self){
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        self.collectionView = collectionView;
        
        self.mutableSections   = [[NSMutableArray alloc] init];
        self.registeredClasses = [[NSMutableDictionary alloc] init];
        self.registeredXIBs    = [[NSMutableDictionary alloc] init];
        
        [self registerDefaultClasses];
    }
    
    return self;
}

#pragma mark - implement dictionary key value style
- (id)objectAtKeyedSubscript:(id <NSCopying>)key
{
    return [self.registeredClasses objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    [self registerClass:(NSString *)key forCellWithReuseIdentifier:obj];
}

#pragma mark  - regist class name
- (void)registerDefaultClasses
{
    self[@"DJCollectionViewVMRow"] = @"DJCollectionViewVMCell";
}

- (void)registerClass:(NSString *)rowClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self registerClass:rowClass forCellWithReuseIdentifier:identifier bundle:nil];
}

- (void)registerClass:(NSString *)rowClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(rowClass), ([NSString stringWithFormat:@"Row class '%@' does not exist.", rowClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(rowClass)] = NSClassFromString(identifier);
    
    if (!bundle)
    {
        bundle = [NSBundle mainBundle];
    }
    
    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        self.registeredXIBs[identifier] = rowClass;
        [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellWithReuseIdentifier:rowClass];
    }else{
        [self.collectionView registerClass:NSClassFromString(identifier) forCellWithReuseIdentifier:identifier];
    }
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath
{
    DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NSObject *row = [section.rows objectAtIndex:indexPath.row];
    return [self.registeredClasses objectForKey:row.class];
}

- (void)registerForReuseHeadViewWithReuseIdentifier:(NSString *)identifier
{
    NSBundle *bundle = [NSBundle mainBundle];
    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
    }else{
        [self.collectionView registerClass:NSClassFromString(identifier) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
    }
}

- (void)registerForReuseFootViewWithReuseIdentifier:(NSString *)identifier
{
    NSBundle *bundle = [NSBundle mainBundle];
    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
    }else{
        [self.collectionView registerClass:NSClassFromString(identifier) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self checkPrefetchEnabled];
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count > sectionIndex) {
        DJCollectionViewVMSection *sections = ((DJCollectionViewVMSection *)[self.mutableSections objectAtIndex:sectionIndex]);
        return sections.rows.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"DJCollectionViewVMDefaultIdentifier_%@", [row class]];
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    if (cellClass) {
        cellIdentifier = NSStringFromClass(cellClass);
    }
    
    if (self.registeredXIBs[NSStringFromClass(cellClass)]) {
        cellIdentifier = self.registeredXIBs[NSStringFromClass(cellClass)];
    }
    
    UICollectionViewCell<DJCollectionViewVMCellDelegate> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSAssert(NO, @"UICollectionViewCell can not be nil");
    }
    
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentCollectionView = collectionView;
    cell.section = section;
    cell.rowVM = row;
    
    if ([cell conformsToProtocol:@protocol(DJCollectionViewVMCellDelegate)] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded) {
        cell.collectionViewVM = self;
        
        // DJCollectionViewVMDelegate
        if ([self.delegate conformsToProtocol:@protocol(DJCollectionViewVMDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:willLoadCell:forRowAtIndexPath:)])
            [self.delegate collectionView:collectionView willLoadCell:cell forRowAtIndexPath:indexPath];
        
        [cell cellDidLoad];
        
        // DJCollectionViewVMDelegate
        if ([self.delegate conformsToProtocol:@protocol(DJCollectionViewVMDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didLoadCell:forRowAtIndexPath:)])
            [self.delegate collectionView:collectionView didLoadCell:cell forRowAtIndexPath:indexPath];
    }
    
    [cell cellWillAppear];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section)
    {
        return nil;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
        NSAssert(section.headReuseIdentifier.length > 0, @"section.headReuseIdentifier can not be empty");
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section.headReuseIdentifier forIndexPath:indexPath];
        if (view) {
            if (section.headerView && ![section.headerView.superview isEqual:view]) {
                [view addSubview:section.headerView];
                section.headerView.frame = view.bounds;
            }
            if ([section respondsToSelector:@selector(setConfigResuseHeadViewHandler:)]){
                DJCollectionViewVMSection *headSection = (DJCollectionViewVMSection *)section;
                if (headSection.configResuseHeadViewHandler) {
                    headSection.configResuseHeadViewHandler(view,headSection);
                }
            }
        }
        return view;
    }else{
        DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.row];
        NSAssert(section.footReuseIdentifier.length > 0, @"section.footReuseIdentifier can not be empty");
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:section.footReuseIdentifier forIndexPath:indexPath];
        if (view) {
            if (section.footerView && ![section.footerView.superview isEqual:view]) {
                [view addSubview:section.footerView];
                section.footerView.frame = view.bounds;
            }
            if ([section respondsToSelector:@selector(setConfigResuseFootViewHandler:)]){
                DJCollectionViewVMSection *headSection = (DJCollectionViewVMSection *)section;
                if (headSection.configResuseFootViewHandler) {
                    headSection.configResuseFootViewHandler(view,headSection);
                }
            }
        }
        return view;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
{
    if ([self.dataSource conformsToProtocol:@protocol(DJCollectionViewVMDataSource)] && [self.dataSource respondsToSelector:@selector(collectionView: canMoveItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView canMoveItemAtIndexPath:indexPath];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0)
{
    if ([self.dataSource conformsToProtocol:@protocol(DJCollectionViewVMDataSource)] && [self.dataSource respondsToSelector:@selector(collectionView: moveItemAtIndexPath: toIndexPath:)]) {
        return [self.dataSource collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }else{
        //TODO:Dokay
        //change indexpath and reload data
    }
}

#pragma mark - DJTableViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
        DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
        if (rowVM.prefetchHander) {
            rowVM.prefetchHander(rowVM);
        }
    }
}

- (void)collectionView:(UICollectionView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
        DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
        if (rowVM.prefetchCancelHander) {
            rowVM.prefetchCancelHander(rowVM);
        }
    }
}

#pragma mark - prefetch methods
- (void)checkPrefetchEnabled
{
    for (DJCollectionViewVMSection *sectionVM in self.sections) {
        for (DJCollectionViewVMRow *rowVM in sectionVM.rows) {
            if (rowVM.prefetchHander || rowVM.prefetchCancelHander) {
                self.bPreetchEnabled = YES;
                return;
            }
        }
    }
    self.bPreetchEnabled = NO;
}

- (void)setBPreetchEnabled:(BOOL)bPreetchEnabled
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
    self.prefetchManager.bPreetchEnabled = bPreetchEnabled;
#else
    if (bPreetchEnabled) {
        collectionView.prefetchDataSource = self;
        collectionView.isPrefetchingEnabled = YES;
    }else{
        collectionView.prefetchDataSource = nil;
        collectionView.isPrefetchingEnabled = NO;
    }
#endif
}

#pragma mark - sections manage
- (NSArray *)sections
{
    return self.mutableSections;
}

- (void)addSection:(DJCollectionViewVMSection *)section
{
    section.collectionViewVM = self;
    if (section.headerReferenceSize.height > 0) {
        [self registerForReuseHeadViewWithReuseIdentifier:section.headReuseIdentifier];
    }
    if (section.footerReferenceSize.height > 0) {
        [self registerForReuseFootViewWithReuseIdentifier:section.footReuseIdentifier];
    }
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    for (DJCollectionViewVMSection *section in array)
    {
        section.collectionViewVM = self;
    }
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(DJCollectionViewVMSection *)section atIndex:(NSUInteger)index
{
    section.collectionViewVM = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)removeSection:(DJCollectionViewVMSection *)section
{
    [self.mutableSections removeObject:section];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionsInArray:(NSArray *)otherArray
{
    [self.mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.mutableSections removeObjectAtIndex:index];
}

#pragma mark - getter
- (DJPrefetchManager *)prefetchManager
{
    if (_prefetchManager == nil) {
        _prefetchManager = [[DJPrefetchManager alloc] initWithScrollView:self.collectionView];
        __weak DJCollectionViewVM *weakSelf = self;
        [_prefetchManager setPrefetchCompletion:^(NSArray *addedArray, NSArray *cancelArray) {
            for (NSIndexPath *indexPath in addedArray) {
                DJCollectionViewVMSection *sectionVM = [weakSelf.sections objectAtIndex:indexPath.section];
                DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
                if (rowVM.prefetchHander) {
                    rowVM.prefetchHander(rowVM);
                }
            }
            
            for (NSIndexPath *indexPath in cancelArray) {
                DJCollectionViewVMSection *sectionVM = [weakSelf.sections objectAtIndex:indexPath.section];
                DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
                if (rowVM.prefetchCancelHander) {
                    rowVM.prefetchCancelHander(rowVM);
                }
            }
        }];
    }
    return _prefetchManager;
}

@end
