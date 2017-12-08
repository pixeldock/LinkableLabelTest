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
    
    var layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    var textStorage = NSTextStorage()
    var attributedStringWithLinks: NSMutableAttributedString?
    
    var markerLayers: [CAShapeLayer] = []
    
    weak var delegate: LinkableLabelDelegate?
    
    struct Link {
        let range: NSRange
        let url: URL
    }
    
    var links: [Link] = []
    
    var text: String? {
        get {
            return label.attributedText?.string
        }
        set {
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
            markCharacters(at: link.range)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeMarkersIfNeeded()
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeMarkersIfNeeded()
        super.touchesEnded(touches, with: event)
    }
    
    func enableLinks() {
        guard let attributedText = label.attributedText else {
            print("⚠️ LinkableLabel: Please set 'text' or 'attributedText' before calling 'enableLinks()'")
            return
        }
        
        DispatchQueue.global().async {
            self.links.removeAll()
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matchedLinks = detector.matches(in: attributedText.string, options: [], range: NSRange(location: 0, length: attributedText.string.count))
            
            guard !matchedLinks.isEmpty else { return }
            
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            self.attributedStringWithLinks = NSMutableAttributedString(attributedString: attributedText)
            matchedLinks.forEach { link in
                guard let url = link.url else { return }
                self.attributedStringWithLinks?.addAttribute(NSAttributedStringKey.link, value: url, range: link.range)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: link.range)
                self.links.append(Link(range: link.range, url: url))
            }
            
            DispatchQueue.main.async {
                self.layoutManager = NSLayoutManager()
                self.textStorage = NSTextStorage()
                self.layoutManager.addTextContainer(self.textContainer)
                self.textStorage.setAttributedString(self.attributedStringWithLinks!)
                self.textStorage.addLayoutManager(self.layoutManager)
                
                self.textContainer.lineFragmentPadding = 0
                self.textContainer.lineBreakMode = self.label.lineBreakMode
                self.textContainer.maximumNumberOfLines = self.numberOfLines
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
    
    func attributedString(with string: String?) -> NSAttributedString? {
        guard let string = string else { return nil }
        return NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: label.font,
            NSAttributedStringKey.foregroundColor: label.textColor
            ])
    }
    
    func markCharacters(at range: NSRange) {
        var glyphRange: NSRange = NSRange(location: 0, length: 0)
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        let linkRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        let firstGlyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphRange.location, length: 1), in: textContainer)
        
        let numberOfLines = linkRect.height / firstGlyphRect.height
        
        guard numberOfLines > 1 else {
            addMarkers(for: [linkRect])
            return
        }
        
        var index: Int = glyphRange.location
        var lineRange: NSRange = glyphRange
        var lineFragments: [CGRect] = []
        while index < glyphRange.location + glyphRange.length {
            lineFragments.append(layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: &lineRange))
            index = NSMaxRange(lineRange)
        }
        
        let lastGlyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphRange.location + glyphRange.length - 1, length: 1), in: textContainer)
        
        let fullFirstLineRect = lineFragments.first!
        let linkFirstLineRect = CGRect(
            x: firstGlyphRect.minX,
            y: fullFirstLineRect.minY,
            width: fullFirstLineRect.maxX - firstGlyphRect.minX,
            height: fullFirstLineRect.height)
        
        let fullLastLineRect = lineFragments.last!
        let linkLastLineRect = CGRect(
            x: fullLastLineRect.minX,
            y: fullLastLineRect.minY,
            width: lastGlyphRect.maxX,
            height: fullLastLineRect.height)
        
        lineFragments[0] = linkFirstLineRect
        lineFragments[lineFragments.count - 1] = linkLastLineRect
        
        addMarkers(for: lineFragments)
    }
    
    func addMarkers(for lineRects: [CGRect]) {
        for rect in lineRects {
            let markerLayer = CAShapeLayer()
            markerLayer.frame = rect
            markerLayer.cornerRadius = 4
            markerLayer.backgroundColor = UIColor.yellow.cgColor
            layer.insertSublayer(markerLayer, at: 0)
            self.markerLayers.append(markerLayer)
        }
    }
    
    func removeMarkersIfNeeded() {
        markerLayers.forEach { $0.removeFromSuperlayer() }
    }
}
