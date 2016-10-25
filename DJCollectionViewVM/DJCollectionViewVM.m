//
//  DJCollectionViewVM.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVM.h"
#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMReusableView.h"
#import "DJCollectionViewVMReusable.h"
#import "DJCollectionViewVM+UIScrollViewDelegate.h"
#import "DJCollectionViewVM+UICollectionViewDelegate.h"
#import "DJCollectionViewVM+FlowLayout.h"
#import "DJCollectionViewPrefetchManager.h"

@interface DJCollectionViewVM()<DJCollectionViewDataSourcePrefetching>

@property (nonatomic, strong) NSMutableDictionary *registeredClasses;
@property (nonatomic, strong) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableDictionary *registeredReusableClasses;
@property (nonatomic, strong) NSMutableDictionary *registeredCaculateSizeCells;
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, strong) DJCollectionViewPrefetchManager *prefetchManager;
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
        self.registeredReusableClasses = [[NSMutableDictionary alloc] init];
        
        self.registeredCaculateSizeCells = [[NSMutableDictionary alloc] init];
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
    
    [self registReusableViewClassName:NSStringFromClass([DJCollectionViewVMReusableView class]) forReusableVMClassName:kHeadReuseIdentifier];
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

- (NSString *)reusableClassNameForViewModelClassName:(NSString *)className
{
    NSString *reusableClassName = [self.registeredReusableClasses objectForKey:className];
    NSAssert(reusableClassName.length > 0, @"there is not a reusableClass for %@,please rember to resit it.",className);
    return reusableClassName;
}

- (void)registReusableViewClassName:(NSString *)reusableViewClassName forReusableVMClassName:(NSString *)reusableVMClassName
{
    self.registeredReusableClasses[reusableVMClassName] = reusableViewClassName;
    NSBundle *bundle = [NSBundle mainBundle];
    if ([bundle pathForResource:reusableViewClassName ofType:@"nib"]) {
        [self.collectionView registerNib:[UINib nibWithNibName:reusableViewClassName bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableVMClassName];
        [self.collectionView registerNib:[UINib nibWithNibName:reusableViewClassName bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusableVMClassName];
    }else{
        [self.collectionView registerClass:NSClassFromString(reusableViewClassName) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableVMClassName];
        [self.collectionView registerClass:NSClassFromString(reusableViewClassName) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusableVMClassName];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"DefaultIdentifier_%@", indexPath];
    
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
    
    if (![self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
        [cell cellWillAppear];
    }else{
        //iOS 10 +
        //if prefetchingEnabled is YES (default), cellForItemAtIndexPath will not called always when cell appears in iOS 10.cellWillAppear called in method: collectionView:willDisplayCell:forItemAtIndexPath: NS_AVAILABLE_IOS(8_0)
    }
    
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
        }
        
        if (section.headerReusabelVM) {
            NSString *reuseIdentifier = NSStringFromClass(section.headerReusabelVM.class);
            UICollectionReusableView<DJCollectionViewVMReusableViewProtocol> *reusableView;
            reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            
            reusableView.sectionIndex = indexPath.section;
            reusableView.parentCollectionView = collectionView;
            reusableView.sectionVM = section;
            reusableView.reusableVM = section.headerReusabelVM;
            
            if (!reusableView.loaded) {
                [reusableView viewDidLoad];
            }
            
            [reusableView viewWillAppear];
            return reusableView;
        }
        return nil;
        
    }else{
        DJCollectionViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.row];
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
        if (section.footerReusableVM) {
            NSString *reuseIdentifier = NSStringFromClass(section.footerReusableVM.class);
            UICollectionReusableView<DJCollectionViewVMReusableViewProtocol> *reusableView;
            reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            
            reusableView.sectionIndex = indexPath.section;
            reusableView.parentCollectionView = collectionView;
            reusableView.sectionVM = section;
            reusableView.reusableVM = section.footerReusableVM;
            
            if (!reusableView.loaded) {
                [reusableView viewDidLoad];
            }
            
            [reusableView viewWillAppear];
            return reusableView;
        }
        
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

#pragma mark - DJCollectionViewDataSourcePrefetching
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
//- (void)checkPrefetchEnabled
//{
//    for (DJCollectionViewVMSection *sectionVM in self.sections) {
//        for (DJCollectionViewVMRow *rowVM in sectionVM.rows) {
//            if (rowVM.prefetchHander || rowVM.prefetchCancelHander) {
//                self.bPreetchEnabled = YES;
//                return;
//            }
//        }
//    }
//    self.bPreetchEnabled = NO;
//}

- (void)setPrefetchingEnabled:(BOOL)prefetchingEnabled
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.collectionView respondsToSelector:@selector(setPrefetchDataSource:)]) {
        if (prefetchingEnabled) {
            [self.collectionView performSelector:@selector(setPrefetchDataSource:) withObject:(id<DJCollectionViewDataSourcePrefetching>)self];
        }else{
            [self.collectionView performSelector:@selector(setPrefetchDataSource:) withObject:nil];
        }
        [self setiOS10PrefetchEnable:prefetchingEnabled];
    }else{
        self.prefetchManager.bPreetchEnabled = prefetchingEnabled;
    }
#pragma clang diagnostic pop
}

- (void)setiOS10PrefetchEnable:(BOOL)bEnable
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UICollectionView *targetCollectionView = self.collectionView;
    NSMethodSignature *signature = [[UICollectionView class] instanceMethodSignatureForSelector: @selector(setPrefetchingEnabled:)];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
    [invocation setTarget:targetCollectionView];
    [invocation setSelector:@selector(setPrefetchingEnabled:)];
    [invocation setArgument:&bEnable atIndex: 2];
    [invocation invoke];
#pragma clang diagnostic pop
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
    if (row.sizeCaculateType == DJCellSizeCaculateAutoFrameLayout
        || row.sizeCaculateType == DJCellSizeCaculateAutoLayout) {
        UICollectionViewCell<DJCollectionViewVMCellDelegate> *templateLayoutCell = [self collectionViewCellForCaculateSizeWithIndexPath:indexPath];
        [templateLayoutCell prepareForReuse];
        if (templateLayoutCell) {
            if (!templateLayoutCell.loaded) {
                [templateLayoutCell cellDidLoad];
            }
            [templateLayoutCell cellWillAppear];
        }
        
        CGSize fittingSize = CGSizeZero;
        if (row.sizeCaculateType == DJCellSizeCaculateAutoFrameLayout) {
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
        NSAssert(FALSE, @"SizeCaculateType is no ,please set it yes and implement cell Size auto");
        return CGSizeZero;
    }
}

- (CGSize)sizeWithAutoLayoutReusableViewWithSection:(NSInteger)section isHead:(BOOL)bHead
{
    DJCollectionViewVMSection *sectionVM = [self.mutableSections objectAtIndex:section];
    UICollectionReusableView<DJCollectionViewVMReusableViewProtocol> *templateLayoutView;
    
    if (bHead) {
        NSString *reusableViewClassName = self.registeredReusableClasses[NSStringFromClass(sectionVM.headerReusabelVM.class)];
        NSBundle *bundle = [NSBundle mainBundle];
        if ([bundle pathForResource:reusableViewClassName ofType:@"nib"]) {
            templateLayoutView = [bundle loadNibNamed:reusableViewClassName owner:self options:nil][0];
        }else{
            templateLayoutView = [NSClassFromString(reusableViewClassName) new];
        }
        
        templateLayoutView.reusableVM = sectionVM.headerReusabelVM;
    }else if(sectionVM.footerReusableVM){
        NSString *reusableViewClassName = self.registeredReusableClasses[NSStringFromClass(sectionVM.footerReusableVM.class)];
        NSBundle *bundle = [NSBundle mainBundle];
        if ([bundle pathForResource:reusableViewClassName ofType:@"nib"]) {
            templateLayoutView = [bundle loadNibNamed:reusableViewClassName owner:self options:nil][0];
        }else{
            templateLayoutView = [NSClassFromString(reusableViewClassName) new];
        }
        templateLayoutView.reusableVM = sectionVM.footerReusableVM;
    }
    
    [templateLayoutView prepareForReuse];
    
    if (!templateLayoutView.loaded) {
        [templateLayoutView viewDidLoad];
    }
    [templateLayoutView viewWillAppear];
    
    CGFloat contentViewWidth = CGRectGetWidth(self.collectionView.frame);
    CGSize fittingSize = CGSizeZero;
    if (contentViewWidth > 0) {
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:templateLayoutView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        [templateLayoutView addConstraint:widthFenceConstraint];
        // Auto layout engine does its math
        fittingSize = [templateLayoutView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [templateLayoutView removeConstraint:widthFenceConstraint];
    }
    
    return fittingSize;
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
- (DJCollectionViewPrefetchManager *)prefetchManager
{
    if (_prefetchManager == nil) {
        _prefetchManager = [[DJCollectionViewPrefetchManager alloc] initWithScrollView:self.collectionView];
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
