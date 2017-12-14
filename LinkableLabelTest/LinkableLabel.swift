//
//  LinkableLabel.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit

protocol LinkableLabelDelegate: class {
    func linkableLabel(_ label: LinkableLabel, didPressURL url: URL)
}

class LinkableLabel: UILabel {
    fileprivate struct Link {
        let range: NSRange
        let url: URL
    }
    
    fileprivate struct ActiveLinkAttributeKey {
        static let backgroundColor = "backgroundColor"
        static let cornerRadius = "cornerRadius"
    }
    
    fileprivate var layoutManager = NSLayoutManager()
    fileprivate let textContainer = NSTextContainer()
    fileprivate var textStorage = NSTextStorage()
    
    fileprivate var linkAttributes = [
        NSAttributedStringKey.foregroundColor: UIColor.green
    ]
    fileprivate var activeLinkAttributes: [String : Any] = [
        ActiveLinkAttributeKey.backgroundColor: UIColor(white: 0, alpha: 0.15),
        ActiveLinkAttributeKey.cornerRadius: CGFloat(4)
    ]
    
    fileprivate var links: [Link] = []
    fileprivate var activeLink: Link?
    fileprivate var activeLinkBackgroundLayers: [CAShapeLayer] = []
    
    weak var delegate: LinkableLabelDelegate?
    
    // Link detection only makes sense with attributed strings.
    // You can set LinkableLabel's 'text' property, but internally
    // only 'attributedText' are being used
    override var text: String? {
        didSet {
            attributedText = attributedString(with: text)
        }
    }
    
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            !links.isEmpty,
            let touch = touches.first,
            let link = touchedLink(at: touch.location(in: self))
            else {
                super.touchesBegan(touches, with: event)
                return
        }
        
        markLinkAsActive(at: link.range)
        activeLink = link
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        markLinkAsInactive()
        activeLink = nil
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let link = activeLink else {
            super.touchesEnded(touches, with: event)
            return
        }
        markLinkAsInactive()
        delegate?.linkableLabel(self, didPressURL: link.url)
        activeLink = nil
    }
    
    func enableLinks() {
        self.links.removeAll()
        self.convertExistingLinks()
        guard let attributedText = self.attributedText else {
            print("⚠️ LinkableLabel: Please set 'text' or 'attributedText' before calling 'enableLinks()'")
            return
        }
        
        DispatchQueue.global().async {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matchedLinks = detector.matches(in: attributedText.string, options: [], range: NSRange(location: 0, length: attributedText.string.count))
            
            guard self.links.count + matchedLinks.count > 0 else { return }
            
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            matchedLinks.forEach { link in
                guard let url = link.url else { return }
                attributedString.addAttributes(self.linkAttributes, range: link.range)
                self.links.append(Link(range: link.range, url: url))
            }
            
            DispatchQueue.main.async {
                self.textContainer.lineFragmentPadding = 0
                self.textContainer.lineBreakMode = self.lineBreakMode
                self.textContainer.maximumNumberOfLines = self.numberOfLines
                
                self.layoutManager = NSLayoutManager()
                self.layoutManager.addTextContainer(self.textContainer)
                
                self.textStorage = NSTextStorage()
                self.textStorage.setAttributedString(attributedString)
                self.textStorage.addLayoutManager(self.layoutManager)
                
                self.attributedText = attributedString
            }
        }
    }
}

fileprivate extension LinkableLabel {
    
    func convertExistingLinks() {
        guard let attributedText = attributedText else { return }
        
        let cleanAttributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length), options: .reverse) { (value, range, _) in
            if let url = value as? URL {
                self.links.append(Link(range: range, url: url))
                cleanAttributedString.removeAttribute(.link, range: range)
                cleanAttributedString.addAttributes(self.linkAttributes, range: range)
            }
        }
        self.attributedText = cleanAttributedString
    }
    
    func attributedString(with string: String?) -> NSAttributedString? {
        guard let string = string else { return nil }
        return NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: textColor
            ])
    }
    
    func touchedLink(at touchLocation: CGPoint) -> Link? {
        let characterIndex = touchedCharacterIndex(for: touchLocation)
        return links.filter({ $0.range.contains(characterIndex) }).first
    }
    
    func touchedCharacterIndex(for touchLocation: CGPoint) -> Int {
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
            y: (bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY)
        let textContainerTouchLocation = CGPoint(x: touchLocation.x - textContainerOffset.x, y: touchLocation.y - textContainerOffset.y)
        
        return layoutManager.characterIndex(for: textContainerTouchLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    }
    
    func markLinkAsActive(at range: NSRange) {
        var glyphRange: NSRange = NSRange(location: 0, length: 0)
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        let linkRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        let firstGlyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphRange.location, length: 1), in: textContainer)
        
        let numberOfLines = linkRect.height / firstGlyphRect.height
        
        // if the link has only 1 line we can use the linkRect for the background layer
        guard numberOfLines > 1 else {
            addBackgroundLayers(for: [linkRect])
            return
        }
        
        // if the link has more than 1 line we need to split it into line fragments
        // and use 1 background layer for each line
        var index: Int = glyphRange.location
        var lineRange: NSRange = glyphRange
        var lineFragments: [CGRect] = []
        while index < glyphRange.location + glyphRange.length {
            lineFragments.append(layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: &lineRange))
            index = NSMaxRange(lineRange)
        }
        
        let lastGlyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphRange.location + glyphRange.length - 1, length: 1), in: textContainer)
        
        // in the first line the background should start a the link's first glyph and
        // not at the line's first glyph (a line fragment is always the whole line)
        let fullFirstLineRect = lineFragments.first ?? .zero
        let linkFirstLineRect = CGRect(
            x: firstGlyphRect.minX,
            y: fullFirstLineRect.minY,
            width: fullFirstLineRect.maxX - firstGlyphRect.minX,
            height: fullFirstLineRect.height)
        
        // in the last line the background should stop a the link's last glyph and
        // not at the line's last glyph (a line fragment is always the whole line)
        let fullLastLineRect = lineFragments.last ?? .zero
        let linkLastLineRect = CGRect(
            x: fullLastLineRect.minX,
            y: fullLastLineRect.minY,
            width: lastGlyphRect.maxX,
            height: fullLastLineRect.height)
        
        lineFragments[0] = linkFirstLineRect
        lineFragments[lineFragments.count - 1] = linkLastLineRect
        
        addBackgroundLayers(for: lineFragments)
    }
    
    func addBackgroundLayers(for lineRects: [CGRect]) {
        let backgroundColor = (activeLinkAttributes[ActiveLinkAttributeKey.backgroundColor] as? UIColor) ?? UIColor.clear
        let cornerRadius = (activeLinkAttributes[ActiveLinkAttributeKey.cornerRadius] as? CGFloat) ?? CGFloat(0)
        for rect in lineRects {
            let backgroundLayer = CAShapeLayer()
            backgroundLayer.frame = rect
            backgroundLayer.cornerRadius = cornerRadius
            backgroundLayer.backgroundColor = backgroundColor.cgColor
            layer.insertSublayer(backgroundLayer, at: 0)
            activeLinkBackgroundLayers.append(backgroundLayer)
        }
    }
    
    func markLinkAsInactive() {
        activeLinkBackgroundLayers.forEach { $0.removeFromSuperlayer() }
    }
}
