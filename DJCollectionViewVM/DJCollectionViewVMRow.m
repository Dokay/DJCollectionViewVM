//
//  DJCollectionViewVMRow.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMRow.h"
#import "DJCollectionViewVMSection.h"
#import "DJCollectionViewVM.h"

@implementation DJCollectionViewVMRow

- (id)init
{
    self = [super init];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

+ (instancetype)row
{
    return [[self alloc] init];
}

- (NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:[self.section.rows indexOfObject:self] inSection:self.section.index];
}

- (void)selectRowAnimated:(BOOL)animated
{
    [self selectRowAnimated:animated scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    [self.section.collectionViewVM.collectionView selectItemAtIndexPath:self.indexPath animated:YES scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated
{
    [self.section.collectionViewVM.collectionView deselectItemAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRow;
{
    [self.section.collectionViewVM.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
}

- (void)deleteRow
{
    DJCollectionViewVMSection *section = self.section;
    NSInteger row = self.indexPath.row;
    [section removeRowAtIndex:self.indexPath.row];
    [section.collectionViewVM.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.index]]];
}

@end
