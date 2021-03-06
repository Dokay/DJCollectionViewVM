//
//  DJCollectionViewVM+UICollectionViewDelegate.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVM+UICollectionViewDelegate.h"
#import "DJCollectionViewVMCell.h"

@implementation DJCollectionViewVM (UICollectionViewDelegate)

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: shouldHighlightItemAtIndexPath:)]){
        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didHighlightItemAtIndexPath:)]){
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didUnhighlightItemAtIndexPath:)]){
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: shouldSelectItemAtIndexPath:)]){
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath // called when the user taps on an already-selected item in multi-select mode
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: shouldDeselectItemAtIndexPath:)]){
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didSelectItemAtIndexPath:)]){
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    DJCollectionViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if ([row respondsToSelector:@selector(setSelectionHandler:)]){
        DJCollectionViewVMRow *actionRow = (DJCollectionViewVMRow *)row;
        if (actionRow.selectionHandler) {
            actionRow.selectionHandler(actionRow);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didDeselectItemAtIndexPath:)]){
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: willDisplayCell: forItemAtIndexPath:)]){
        [self.delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
    
    if([self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]){
        //cellWillAppear called in method: collectionView:cellForItemAtIndexPath: below iOS 10
        if([cell respondsToSelector:@selector(cellWillAppear)]){
            [cell performSelector:@selector(cellWillAppear)];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: willDisplaySupplementaryView: forElementKind: atIndexPath:)]){
        [self.delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didEndDisplayingCell: forItemAtIndexPath:)]){
        [self.delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    
    if ([cell respondsToSelector:@selector(cellDidDisappear)]){
        [(UICollectionViewCell<DJCollectionViewVMCellDelegate> *)cell cellDidDisappear];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didEndDisplayingSupplementaryView: forElementOfKind: atIndexPath:)]){
        [self.delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: shouldShowMenuForItemAtIndexPath:)]){
        return [self.delegate collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
    }
    DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    return (rowVM.copyHandler || rowVM.pasteHandler);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: canPerformAction: forItemAtIndexPath: withSender:)]){
        return [self.delegate collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    
    DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    if (rowVM.copyHandler && action == @selector(copy:)){
        return YES;
    }
    if (rowVM.pasteHandler && action == @selector(paste:)){
        return YES;
    }
    if (rowVM.cutHandler && action == @selector(cut:)){
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: canPerformAction: forItemAtIndexPath: withSender:)]){
        [self.delegate collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    
    DJCollectionViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJCollectionViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    if (action == @selector(copy:) && rowVM.copyHandler) {
        rowVM.copyHandler(rowVM);
    }
    if (action == @selector(paste:) && rowVM.pasteHandler) {
        rowVM.pasteHandler(rowVM);
    }
    if (action == @selector(cut:) && rowVM.cutHandler) {
        rowVM.cutHandler(rowVM);
    }
}

// support for custom transition layout
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: transitionLayoutForOldLayout: newLayout:)]){
        return [self.delegate collectionView:collectionView transitionLayoutForOldLayout:fromLayout newLayout:toLayout];
    }
    return nil;
}

// Focus
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: canFocusItemAtIndexPath:)]){
        return [self.delegate collectionView:collectionView canFocusItemAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: shouldUpdateFocusInContext:)]){
        return [self.delegate collectionView:collectionView shouldUpdateFocusInContext:context];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: didUpdateFocusInContext: withAnimationCoordinator:)]){
        [self.delegate collectionView:collectionView didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    }
}

- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(indexPathForPreferredFocusedViewInCollectionView:)]){
        return [self.delegate indexPathForPreferredFocusedViewInCollectionView:collectionView];
    }
    return nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: targetIndexPathForMoveFromItemAtIndexPath: toProposedIndexPath:)]){
        return [self.delegate collectionView:collectionView targetIndexPathForMoveFromItemAtIndexPath:originalIndexPath toProposedIndexPath:proposedIndexPath];
    }
    DJCollectionViewVMSection *sourceSection = [self.sections objectAtIndex:originalIndexPath.section];
    DJCollectionViewVMRow *rowVM = [sourceSection.rows objectAtIndex:originalIndexPath.row];
    if (rowVM.moveCellHandler) {
        BOOL allowed = rowVM.moveCellHandler(rowVM, originalIndexPath, proposedIndexPath);
        if (!allowed){
            return originalIndexPath;
        }
    }
    
    return proposedIndexPath;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(9_0) // customize the content offset to be applied during transition or update animations
{
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView: targetContentOffsetForProposedContentOffset:)]){
        return [self.delegate collectionView:collectionView targetContentOffsetForProposedContentOffset:proposedContentOffset];
    }
    return proposedContentOffset;
}


@end
