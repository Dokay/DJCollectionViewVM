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
#import "DJCollectionViewVM+FlowLayout.h"
#import "DJPrefetchManager.h"

@interface DJCollectionViewVM()<DJCollectionViewDataSourcePrefetching>

@property (nonatomic, strong) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableDictionary *registeredCaculateSizeCells;
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, strong) DJPrefetchManager *prefetchManager;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation DJCollectionViewVM

- (id)init
{
    NSAssert(NO, @"please use other init methods instead");
    return nil;
}

- (id)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<DJCollectionViewVMDelegate>)delegate
{
    self = [self initWithCollectionView:collectionView];
    if (self){
        
    }
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
        //TODO:Dokay cell init improve
        //        self.registeredCaculateSizeCells = [[NSMutableDictionary alloc] init];
        [self.collectionView addGestureRecognizer:self.longPressGesture];
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
    
    [self registerForReuseHeadViewWithReuseIdentifier:kHeadReuseIdentifier];
    [self registerForReuseFootViewWithReuseIdentifier:kFootReuseIdentifier];
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
        //        NSAssert(section.headReuseIdentifier.length > 0, @"section.headReuseIdentifier can not be empty");
        
        if (section.headerView) {
            [section.headerView removeFromSuperview];
            //                [view.subviews performSelector:@selector(removeFromSuperview)];
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeadReuseIdentifier forIndexPath:indexPath];
            [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [view addSubview:section.headerView];
            section.headerView.frame = view.bounds;
            return view;
        }else{
            
        }
        //            if ([section respondsToSelector:@selector(setConfigResuseHeadViewHandler:)]){
        //                DJCollectionViewVMSection *headSection = (DJCollectionViewVMSection *)section;
        //                if (headSection.configResuseHeadViewHandler) {
        //                    headSection.configResuseHeadViewHandler(view,headSection);
        //                }
        //            }
        return nil;
        
    }else{
        DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.row];
        //        NSAssert(section.footReuseIdentifier.length > 0, @"section.footReuseIdentifier can not be empty");
        
        if (section.footerView) {
            [section.footerView removeFromSuperview];
            //                [view.subviews performSelector:@selector(removeFromSuperview)];
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFootReuseIdentifier forIndexPath:indexPath];
            [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [view addSubview:section.footerView];
            section.footerView.frame = view.bounds;
            return view;
        }
        //            if ([section respondsToSelector:@selector(setConfigResuseFootViewHandler:)]){
        //                DJCollectionViewVMSection *headSection = (DJCollectionViewVMSection *)section;
        //                if (headSection.configResuseFootViewHandler) {
        //                    headSection.configResuseFootViewHandler(view,headSection);
        //                }
        //            }
        return nil;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
{
    if (self.mutableSections.count <= indexPath.section) {
        return NO;
    }
    DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *rowVM = [section.rows objectAtIndex:indexPath.row];
    return rowVM.moveCellHandler != nil && rowVM.moveCellHandler(rowVM,indexPath,nil);
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0)
{
    DJCollectionViewVMSection *sourceSection = [self.mutableSections objectAtIndex:sourceIndexPath.section];
    DJCollectionViewVMRow *rowVM = [sourceSection.rows objectAtIndex:sourceIndexPath.row];
    [sourceSection removeRowAtIndex:sourceIndexPath.row];
    
    DJCollectionViewVMSection *destinationSection = [self.mutableSections objectAtIndex:destinationIndexPath.section];
    [destinationSection insertRow:rowVM atIndex:destinationIndexPath.row];
    
    if (rowVM.moveCellCompletionHandler){
        rowVM.moveCellCompletionHandler(rowVM, sourceIndexPath, destinationIndexPath);
    }
    [collectionView reloadData];
}

#pragma mark - DJTableViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
        DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
        if (rowVM.prefetchHander) {
            rowVM.prefetchHander(rowVM);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
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
        self.collectionView.prefetchDataSource = (id<DJCollectionViewDataSourcePrefetching>)self;
        self.collectionView.prefetchingEnabled = YES;
    }else{
        self.collectionView.prefetchDataSource = nil;
        self.collectionView.prefetchingEnabled = NO;
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

#pragma mark - auto size caculate
- (UICollectionViewCell<DJCollectionViewVMCellDelegate> *)collectionViewCellForCaculateSizeWithIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<DJCollectionViewVMCellDelegate> *cell;
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    NSString *cellClassName = NSStringFromClass(cellClass);
    if (self.registeredXIBs[NSStringFromClass(cellClass)]) {
        cell = [self.registeredCaculateSizeCells objectForKey:cellClassName];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:cellClassName owner:self options:nil][0];
            [self.registeredCaculateSizeCells setObject:cell forKey:cellClassName];
        }
    }else{
        cell = [self.registeredCaculateSizeCells objectForKey:cellClassName];
        if (cell == nil) {
            cell = [[cellClass alloc] init];
            [self.registeredCaculateSizeCells setObject:cell forKey:cellClassName];
        }
    }
    
    DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    cell.rowVM = row;
    
    return cell;
}

- (CGSize)sizeWithAutoLayoutCellWithIndexPath:(NSIndexPath *)indexPath
{
    DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if (row.heightCaculateType == DJCellHeightCaculateAutoFrameLayout
        || row.heightCaculateType == DJCellHeightCaculateAutoLayout) {
        UICollectionViewCell<DJCollectionViewVMCellDelegate> *templateLayoutCell = [self collectionViewCellForCaculateSizeWithIndexPath:indexPath];
        [templateLayoutCell prepareForReuse];
        if (templateLayoutCell) {
            if (!templateLayoutCell.loaded) {
                [templateLayoutCell cellDidLoad];
            }
            [templateLayoutCell cellWillAppear];
        }
        
        CGSize fittingSize = CGSizeZero;
        if (row.heightCaculateType == DJCellHeightCaculateAutoFrameLayout) {
            SEL selector = @selector(sizeThatFits:);
            BOOL inherited = ![templateLayoutCell isMemberOfClass:UITableViewCell.class];
            BOOL overrided = [templateLayoutCell.class instanceMethodForSelector:selector] != [UITableViewCell instanceMethodForSelector:selector];
            if (!inherited || !overrided) {
                NSAssert(NO, @"Customized cell must override '-sizeThatFits:' method if not using auto layout.");
            }
            fittingSize = [templateLayoutCell sizeThatFits:CGSizeMake(0, 0)];
        } else {
            fittingSize = [templateLayoutCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        }
        
        return fittingSize;
    }else{
        NSAssert(FALSE, @"heightCaculateType is no ,please set it yes and implement cell height auto");
        return CGSizeZero;
    }
}

#pragma mark - long tap gesture
- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture
{
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self.collectionView];
            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (selectedIndexPath == nil) {
                return;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.collectionView];
            [self.collectionView updateInteractiveMovementTargetPosition:point];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
        {
            [self.collectionView cancelInteractiveMovement];
        }
            break;
    }
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

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (_longPressGesture == nil) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    }
    return _longPressGesture;
}

@end
