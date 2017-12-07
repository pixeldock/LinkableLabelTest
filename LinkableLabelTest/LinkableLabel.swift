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

class LinkableLabel: UILabel {
    var layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    var textStorage = NSTextStorage()
    var attributedStringWithLinks: NSMutableAttributedString?
    
    weak var delegate: LinkableLabelDelegate?
    
    override var text: String? {
        get {
            return attributedText?.string
        }
        set {
            attributedText = attributedString(with: newValue)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    func enableLinks() {
        guard let attributedText = attributedText else {
            print("⚠️ LinkableLabel: Please set 'text' or 'attributedText' before calling 'enableLinks()'")
            return
        }
        
        DispatchQueue.global().async {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matchedLinks = detector.matches(in: attributedText.string, options: [], range: NSRange(location: 0, length: attributedText.string.count))
            
            guard !matchedLinks.isEmpty else { return }
            
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            self.attributedStringWithLinks = NSMutableAttributedString(attributedString: attributedText)
            matchedLinks.forEach { link in
                guard let url = link.url else { return }
                self.attributedStringWithLinks?.addAttribute(NSAttributedStringKey.link, value: url, range: link.range)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: link.range)
            }
            
            DispatchQueue.main.async {
                self.layoutManager = NSLayoutManager()
                self.textStorage = NSTextStorage()
                self.layoutManager.addTextContainer(self.textContainer)
                self.textStorage.setAttributedString(self.attributedStringWithLinks!)
                self.textStorage.addLayoutManager(self.layoutManager)
                
                self.textContainer.lineFragmentPadding = 0
                self.textContainer.lineBreakMode = self.lineBreakMode
                self.textContainer.maximumNumberOfLines = self.numberOfLines
                self.attributedText = attributedString
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                self.addGestureRecognizer(recognizer)
                self.isUserInteractionEnabled = true
            }
        }
    }
}

private extension LinkableLabel {
    
    @objc func didTap(recognizer: UITapGestureRecognizer) {
        let labelTouchLocation = recognizer.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
            y: (bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY)
        let textContainerTouchLocation = CGPoint(x: labelTouchLocation.x - textContainerOffset.x, y: labelTouchLocation.y - textContainerOffset.y)
        let touchedCharacterIndex = layoutManager.characterIndex(for: textContainerTouchLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let url = attributedStringWithLinks?.attributes(at: touchedCharacterIndex, effectiveRange: nil)
            .flatMap { $0.value as? URL }
            .first
        
        if let url = url {
            delegate?.linkableLabel(self, didPressLink: url)
        }
    }
    
    func attributedString(with string: String?) -> NSAttributedString? {
        guard let string = string else { return nil }
        return NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: textColor
            ])
    }
}
