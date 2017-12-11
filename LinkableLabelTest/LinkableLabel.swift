//
//  LinkableLabel.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit

protocol LinkableLabelDelegate: class {
    func linkableLabel(_ label: LinkableLabel, didPressLink url: URL)
}

class LinkableLabel: UIView {
    fileprivate let label = UILabel()
    
    fileprivate var layoutManager = NSLayoutManager()
    fileprivate let textContainer = NSTextContainer()
    fileprivate var textStorage = NSTextStorage()
    
    fileprivate var activeLinkAttributes: [ActiveLinkAttributeKey: Any] = [:]
    fileprivate var activeLinkBackgroundLayers: [CAShapeLayer] = []
    
    weak var delegate: LinkableLabelDelegate?
    
    fileprivate struct Link {
        let range: NSRange
        let url: URL
    }
    
    enum ActiveLinkAttributeKey {
        case backgroundColor
        case cornerRadius
    }
    
    fileprivate var links: [Link] = []
    
    // Link detection only makes sense with attributed strings.
    // You can set LinkableLabel's 'text' property, but internally
    // only 'attributedText' are being used
    var text: String? {
        get {
            return label.attributedText?.string
        }
        set {
            // this creates an attributed string that preserves the
            // values of 'font' and 'textColor'
            label.attributedText = attributedString(with: newValue)
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.attributedText = newValue
        }
    }
    
    var numberOfLines: Int {
        get {
            return label.numberOfLines
        }
        set {
            label.numberOfLines = newValue
        }
    }
    
    var textColor: UIColor? {
        get {
            return label.textColor
        }
        set {
            label.textColor = newValue
        }
    }
    
    var font: UIFont {
        get {
            return label.font
        }
        set {
            label.font = newValue
        }
    }
    
    var lineBreakMode: NSLineBreakMode {
        get {
            return label.lineBreakMode
        }
        set {
            label.lineBreakMode = newValue
            textContainer.lineBreakMode = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        if let link = touchedLink(at: touch.location(in: self)) {
            markLinkAsActive(at: link.range)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        markLinkAsInactiveIfNeeded()
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        markLinkAsInactiveIfNeeded()
        super.touchesEnded(touches, with: event)
    }
    
    func enableLinks(withLinkAttributes linkAttributes: [NSAttributedStringKey : Any], activeLinkAttributes: [ActiveLinkAttributeKey: Any] = [:]) {
        guard let attributedText = label.attributedText else {
            print("⚠️ LinkableLabel: Please set 'text' or 'attributedText' before calling 'enableLinks()'")
            return
        }
        self.activeLinkAttributes = activeLinkAttributes
        
        DispatchQueue.global().async {
            self.links.removeAll()
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matchedLinks = detector.matches(in: attributedText.string, options: [], range: NSRange(location: 0, length: attributedText.string.count))
            
            guard matchedLinks.count > 0 else { return }
            
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            matchedLinks.forEach { link in
                guard let url = link.url else { return }
                attributedString.addAttributes(linkAttributes, range: link.range)
                self.links.append(Link(range: link.range, url: url))
            }
            
            DispatchQueue.main.async {
                self.textContainer.lineFragmentPadding = 0
                self.textContainer.lineBreakMode = self.label.lineBreakMode
                self.textContainer.maximumNumberOfLines = self.numberOfLines
                
                self.layoutManager = NSLayoutManager()
                self.layoutManager.addTextContainer(self.textContainer)
                
                self.textStorage = NSTextStorage()
                self.textStorage.setAttributedString(attributedString)
                self.textStorage.addLayoutManager(self.layoutManager)
                
                self.attributedText = attributedString
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                self.addGestureRecognizer(recognizer)
                self.isUserInteractionEnabled = true
            }
        }
    }
}

fileprivate extension LinkableLabel {
    
    func setupView() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
    
    func attributedString(with string: String?) -> NSAttributedString? {
        guard let string = string else { return nil }
        return NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: label.font,
            NSAttributedStringKey.foregroundColor: label.textColor
            ])
    }
    
    @objc func didTap(recognizer: UITapGestureRecognizer) {
        if let link = touchedLink(at: recognizer.location(in: self)) {
            delegate?.linkableLabel(self, didPressLink: link.url)
        }
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
        let cornerRadius = activeLinkCornerRadius()
        for rect in lineRects {
            let backgroundLayer = CAShapeLayer()
            backgroundLayer.frame = rect
            backgroundLayer.cornerRadius = cornerRadius
            backgroundLayer.backgroundColor = backgroundColor.cgColor
            layer.insertSublayer(backgroundLayer, at: 0)
            self.activeLinkBackgroundLayers.append(backgroundLayer)
        }
    }
    
    func markLinkAsInactiveIfNeeded() {
        activeLinkBackgroundLayers.forEach { $0.removeFromSuperlayer() }
    }
    
    func activeLinkCornerRadius() -> CGFloat {
        guard let cornerRadiusAttribute = activeLinkAttributes[ActiveLinkAttributeKey.cornerRadius] else { return 0 }
        
        switch cornerRadiusAttribute {
        case let cornerRadius as CGFloat:
            return cornerRadius
        case let cornerRadius as Int:
            return CGFloat(cornerRadius)
        case let cornerRadius as Double:
            return CGFloat(cornerRadius)
        default:
            return 0
        }
    }
}
