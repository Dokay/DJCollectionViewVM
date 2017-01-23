//
//  DJCollectionViewVM+UICollectionViewDelegateFlowLayout.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVM+FlowLayout.h"
#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMReusableView.h"

#define DJSetFlowLayoutProperties(Name,Value)\
if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {\
((UICollectionViewFlowLayout *)collectionViewLayout).Name = Value;\
}\

@implementation DJCollectionViewVM (FlowLayout)

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView: layout: sizeForItemAtIndexPath:)]){
        return [self.delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }else{
        CGSize itemSize = CGSizeZero;
        DJCollectionViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
        DJCollectionViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
        if (row.itemSize.height > 0) {
            itemSize = row.itemSize;
        }else{
            if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                if (row.itemSize.height == 0 || row.dj_caculateSizeForceRefresh) {
                    if (row.sizeCaculateType == DJCellSizeCaculateDefault) {
                        NSString *cellClassName = [self objectAtKeyedSubscript:NSStringFromClass(row.class)];
                        row.itemSize = [NSClassFromString(cellClassName) sizeWithRow:row collectionViewVM:self];
                    }else{
                        //auto size
                        row.itemSize = [self sizeWithAutoLayoutCellWithIndexPath:indexPath];
                    }
                }
                itemSize = row.itemSize;
            }
        }
        
        DJSetFlowLayoutProperties(itemSize,row.itemSize);
        return itemSize;
    }
    DJSetFlowLayoutProperties(itemSize,CGSizeZero);
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView: layout: insetForSectionAtIndex:)]){
        return [self.delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }else{
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:section];
        DJSetFlowLayoutProperties(sectionInset,sectionVM.sectionInset);
        return sectionVM.sectionInset;
    }
    DJSetFlowLayoutProperties(sectionInset,UIEdgeInsetsZero);
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView: layout: minimumLineSpacingForSectionAtIndex:)]){
        return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }else{
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:section];
       
        DJSetFlowLayoutProperties(minimumLineSpacing,sectionVM.minimumLineSpacing);
        return sectionVM.minimumLineSpacing;
    }
    DJSetFlowLayoutProperties(minimumLineSpacing,0);
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView: layout: minimumInteritemSpacingForSectionAtIndex:)]){
        return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }else{
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:section];
        DJSetFlowLayoutProperties(minimumInteritemSpacing, sectionVM.minimumInteritemSpacing);
        return sectionVM.minimumInteritemSpacing;
    }
    DJSetFlowLayoutProperties(minimumInteritemSpacing,0);
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView: layout: referenceSizeForHeaderInSection:)]){
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }else{
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:section];
        DJCollectionViewVMReusable *reusableVM = sectionVM.headerReusabelVM;
        if (reusableVM) {
            if (reusableVM.resuableSize.height > 0) {
                DJSetFlowLayoutProperties(headerReferenceSize,reusableVM.resuableSize);
                return reusableVM.resuableSize;
            }else{
                NSString *reusableViewClass = [self reusableClassNameForViewModelClassName:NSStringFromClass(sectionVM.headerReusabelVM.class)];
                if (reusableVM.sizeCaculateType == DJReusableSizeCaculateTypeDefault) {
                    reusableVM.resuableSize = [NSClassFromString(reusableViewClass) sizeWithResuableVM:sectionVM.headerReusabelVM collectionViewVM:sectionVM.collectionViewVM];
                }else{
                    //auto size
                    reusableVM.resuableSize = [self sizeWithAutoLayoutReusableViewWithSection:section isHead:YES];
                }
                DJSetFlowLayoutProperties(headerReferenceSize,sectionVM.headerReusabelVM.resuableSize);
                return sectionVM.headerReusabelVM.resuableSize;
            }
        }
        DJSetFlowLayoutProperties(headerReferenceSize,sectionVM.headerReferenceSize);
        return sectionVM.headerReferenceSize;
    }
    DJSetFlowLayoutProperties(headerReferenceSize,CGSizeZero);
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView: layout: referenceSizeForFooterInSection:)]){
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }else{
        DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:section];
        DJCollectionViewVMReusable *reusableVM = sectionVM.footerReusableVM;
        if (reusableVM) {
            if (reusableVM.resuableSize.height > 0) {
                DJSetFlowLayoutProperties(footerReferenceSize,reusableVM.resuableSize);
                return reusableVM.resuableSize;
            }else{
                NSString *reusableViewClass = [self reusableClassNameForViewModelClassName:NSStringFromClass(sectionVM.headerReusabelVM.class)];
                if (reusableVM.sizeCaculateType == DJReusableSizeCaculateTypeDefault) {
                    reusableVM.resuableSize = [NSClassFromString(reusableViewClass) sizeWithResuableVM:sectionVM.footerReusableVM collectionViewVM:sectionVM.collectionViewVM];
                }else{
                    //auto size
                    reusableVM.resuableSize = [self sizeWithAutoLayoutReusableViewWithSection:section isHead:NO];
                }
                DJSetFlowLayoutProperties(footerReferenceSize,sectionVM.footerReusableVM.resuableSize);
                return sectionVM.footerReusableVM.resuableSize;
            }
        }
        DJSetFlowLayoutProperties(footerReferenceSize,sectionVM.footerReferenceSize);
        return sectionVM.footerReferenceSize;
    }
    DJSetFlowLayoutProperties(footerReferenceSize,CGSizeZero);
    return CGSizeZero;
}

@end
