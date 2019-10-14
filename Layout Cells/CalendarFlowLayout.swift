//
//  CalendarFlowLayout.swift
//  CalendarView
//
//  Created by K Saravana Kumar on 19/06/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class CalendarFlowLayout: UICollectionViewFlowLayout {
    
    
    var layoutInfo: [Int: [IndexPath:UICollectionViewLayoutAttributes]] = [Int: [IndexPath:UICollectionViewLayoutAttributes]]()
    
    
    override init() {
        super.init()
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        // setting up some inherited values
        
        
        
    }
    
    override func prepare() {
        guard let collectionview = self.collectionView else {
            return
        }
        self.itemSize = CGSize(width: (self.collectionView?.frame.size.width)!/7, height: 40)
        
        guard let sectionCount = self.collectionView?.numberOfSections else {
            return
        }
        
        for i in 0 ..< sectionCount {
            
            guard let itemCount = self.collectionView?.numberOfItems(inSection: i) else {
                return
            }
            
            var layoutInfoArray : [IndexPath:UICollectionViewLayoutAttributes] = [IndexPath:UICollectionViewLayoutAttributes]()
            
            
            for j in 0 ..< itemCount {
                
                
                
                let indexPath = IndexPath(item: j, section: i)
                
                let itemAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                
                itemAttributes.frame = self.frameForItemAtIndexPath(indexPath: indexPath, attribute: itemAttributes)
                
                layoutInfoArray[indexPath] = itemAttributes
                
            }
            
            layoutInfo[i] = layoutInfoArray
            
        }
        
    }
    
    func frameForItemAtIndexPath(indexPath: IndexPath,attribute: UICollectionViewLayoutAttributes) -> CGRect {
        
        var xCellOffset = CGFloat(attribute.indexPath.item % 7) * self.itemSize.width
        
        let yCellOffset = CGFloat(attribute.indexPath.item / 7) * self.itemSize.height
        
        let secOffSet = attribute.indexPath.section
        
        xCellOffset += CGFloat(secOffSet) * (self.collectionView?.frame.size.width)!
        
        let rect: CGRect = CGRect(x: xCellOffset, y: yCellOffset, width: self.itemSize.width, height: self.itemSize.height)
        
        return rect
        
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
//        return super.layoutAttributesForElements(in: rect)?.map { attrs in
//            let attrscp = attrs.copy() as! UICollectionViewLayoutAttributes
//            self.applyLayoutAttributes(attrscp)
//            return attrscp
//        }
        
        var allAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        
        for (_,value) in layoutInfo {
            
            for (_, attributes) in value {
                if rect.intersects(attributes.frame) {
                    allAttributes.append(attributes)
                }
            }
            
        }
        
        
        
        return allAttributes
        
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
//        if let attrs = super.layoutAttributesForItem(at: indexPath) {
//            let attrscp = attrs.copy() as! UICollectionViewLayoutAttributes
//            self.applyLayoutAttributes(attrscp)
//            return attrscp
//        }
//        return nil
        return layoutInfo[indexPath.section]?[indexPath]
    }
    
    func applyLayoutAttributes(_ attributes : UICollectionViewLayoutAttributes) {
        guard attributes.representedElementKind == nil else { return }

        guard let collectionView = self.collectionView else { return }

        var xCellOffset = CGFloat(attributes.indexPath.item % 7) * self.itemSize.width
        var yCellOffset = CGFloat(attributes.indexPath.item / 7) * self.itemSize.height

        let offset = CGFloat(attributes.indexPath.section)
        
        xCellOffset += offset * collectionView.frame.size.width 

//        switch self.scrollDirection {
//        case .horizontal:   xCellOffset += offset * collectionView.frame.size.width
//        case .vertical:     yCellOffset += offset * collectionView.frame.size.height
//        }

        // set frame
        attributes.frame = CGRect(
            x: xCellOffset,
            y: yCellOffset,
            width: self.itemSize.width,
            height: self.itemSize.height
        )
    }
    
    override var collectionViewContentSize: CGSize {
        //        let collectionViewHeight = self.collectionView!.frame.height
        let collectionViewHeight = self.collectionView!.frame.height
        //        let contentWidth: CGFloat = maxXPos + itemWidth
        let contentWidth: CGFloat = CGFloat(Int(self.collectionView!.frame.width) * (self.collectionView?.numberOfSections)!)
        
        return CGSize(width: contentWidth, height: collectionViewHeight)
    }
    
}
