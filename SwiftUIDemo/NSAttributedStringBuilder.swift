//
//  NSAttributedStringBuilder.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/9.
//

#if canImport(UIKit)
    import UIKit
    public typealias Font = UIFont
//    public typealias Color = UIColor
    public typealias Size = CGSize
#elseif canImport(AppKit)
    import AppKit
    public typealias Font = NSFont
//    public typealias Color = NSColor
    public typealias Size = NSSize
#endif

public typealias Attributes = [NSAttributedString.Key: Any]
public typealias AText = NSAttributedString.AttrText

public enum Ligature: Int {
    case none = 0
    case `default` = 1

    #if canImport(AppKit)
        case all = 2 // Value 2 is unsupported on iOS
    #endif
}

@resultBuilder public struct AttributedStringBuilder {
    public static func buildBlock(_ components: Component...) -> NSAttributedString {
        let mas = NSMutableAttributedString(string: "")
        for component in components {
            mas.append(component.attributedString)
        }
        return mas
    }
}

public extension NSAttributedString {
    convenience init(@AttributedStringBuilder _ builder: () -> NSAttributedString) {
        self.init(attributedString: builder())
    }
}

public protocol Component {
    var string: String { get }
    var attributes: Attributes { get }
    var attributedString: NSAttributedString { get }
}

public extension Component {
    var attributedString: NSAttributedString {
        NSAttributedString(string: string, attributes: attributes)
    }
    
    private func build(_ string: String, attributes: Attributes) -> Component {
        AText(string, attributes: attributes)
    }
    
    func attribute(_ newAttribute: NSAttributedString.Key, value: Any) -> Component {
        attributes([newAttribute: value])
    }
    
    func attributes(_ newAttributes: Attributes) -> Component {
        var attributes = self.attributes
        for attribute in newAttributes {
            attributes[attribute.key] = attribute.value
        }
        return build(string, attributes: attributes)
    }
}

public extension NSAttributedString {
    struct AttrText: Component {
        public let string: String
        public let attributes: Attributes
        public init(_ string: String, attributes: Attributes = [:]) {
            self.string = string
            self.attributes = attributes
        }
    }
    
    struct ImageAttachment: Component {
        public let string: String = ""
        public let attributes: Attributes = [:]
        public var attributedString: NSAttributedString {
            NSAttributedString(attachment: attachment)
        }
        private let attachment: NSTextAttachment
        
        public init(_ image: UIImage, size: Size? = nil) {
            let attachment = NSTextAttachment()
            attachment.image = image
            if let size = size {
                attachment.bounds.size = size
            }
            self.attachment = attachment
        }
    }
    
    struct Link: Component {
        public let string: String
        public let attributes: Attributes
        public var attributedString: NSAttributedString {
            NSAttributedString(string: string, attributes: attributes)
        }
        public let url: URL

        public init(_ string: String, url: URL, attributes: Attributes = [:]) {
            self.string = string
            self.url = url
            var attributes = attributes
            attributes[.link] = url
            self.attributes = attributes
        }
    }
    
    struct Empty: Component {
        public let string: String = ""
        public let attributes: Attributes = [:]
        public init() {}
    }
    
    struct Space: Component {
        public let string: String = " "
        public let attributes: Attributes = [:]
        public init() {}
    }
    
    struct LineBreak: Component {
        public let string: String = "\n"
        public let attributes: Attributes = [:]
        public init() {}
    }
}

public extension Component {
    func backgroundColor(_ color: UIColor) -> Component {
        attributes([.backgroundColor: color])
    }
    
    func baselineOffset(_ baselineOffset: CGFloat) -> Component {
        attributes([.baselineOffset: baselineOffset])
    }
    
    func font(_ font: Font) -> Component {
        attributes([.font: font])
    }

    func foregroundColor(_ color: UIColor) -> Component {
        attributes([.foregroundColor: color])
    }

    func expansion(_ expansion: CGFloat) -> Component {
        attributes([.expansion: expansion])
    }

    func kerning(_ kern: CGFloat) -> Component {
        attributes([.kern: kern])
    }

    func ligature(_ ligature: Ligature) -> Component {
        attributes([.ligature: ligature.rawValue])
    }

    func obliqueness(_ obliqueness: Float) -> Component {
        attributes([.obliqueness: obliqueness])
    }

    func shadow(color: UIColor? = nil, radius: CGFloat, x: CGFloat, y: CGFloat) -> Component {
        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowBlurRadius = radius
        shadow.shadowOffset = .init(width: x, height: y)
        return attributes([.shadow: shadow])
    }

    func strikethrough(style: NSUnderlineStyle, color: UIColor? = nil) -> Component {
        if let color = color {
            return attributes([.strikethroughStyle: style.rawValue,
                               .strikethroughColor: color])
        } else {
            return attributes([.strikethroughStyle: style.rawValue])
        }
    }

    func stroke(width: CGFloat, color: UIColor? = nil) -> Component {
        if let color = color {
            return attributes([.strokeWidth: width,
                               .strokeColor: color])
        } else {
            return attributes([.strokeWidth: width])
        }
    }

    func textEffect(_ textEffect: NSAttributedString.TextEffectStyle) -> Component {
        attributes([.textEffect: textEffect])
    }

    func underline(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Component {
        if let color = color {
            return attributes([.underlineStyle: style.rawValue,
                               .underlineColor: color])
        } else {
            return attributes([.underlineStyle: style.rawValue])
        }
    }

    func writingDirection(_ writingDirection: NSWritingDirection) -> Component {
        attributes([.writingDirection: writingDirection.rawValue])
    }

    #if canImport(AppKit)
        func vertical() -> Component {
            attributes([.verticalGlyphForm: 1])
        }
    #endif
}

public extension Component {
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> Component {
        attributes([.paragraphStyle: paragraphStyle])
    }

    func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> Component {
        attributes([.paragraphStyle: paragraphStyle])
    }

    private func getMutableParagraphStyle() -> NSMutableParagraphStyle {
        if let mps = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            return mps
        } else if let ps = attributes[.paragraphStyle] as? NSParagraphStyle,
                  let mps = ps.mutableCopy() as? NSMutableParagraphStyle
        {
            return mps
        } else {
            return NSMutableParagraphStyle()
        }
    }

    func alignment(_ alignment: NSTextAlignment) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return self.paragraphStyle(paragraphStyle)
    }

    func firstLineHeadIndent(_ indent: CGFloat) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return self.paragraphStyle(paragraphStyle)
    }

    func headIndent(_ indent: CGFloat) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.headIndent = indent
        return self.paragraphStyle(paragraphStyle)
    }

    func tailIndent(_ indent: CGFloat) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.tailIndent = indent
        return self.paragraphStyle(paragraphStyle)
    }

    func lineBreakeMode(_ lineBreakMode: NSLineBreakMode) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        return self.paragraphStyle(paragraphStyle)
    }

    func lineHeight(multiple: CGFloat = 0, maximum: CGFloat = 0, minimum: CGFloat) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = multiple
        paragraphStyle.maximumLineHeight = maximum
        paragraphStyle.minimumLineHeight = minimum
        return self.paragraphStyle(paragraphStyle)
    }

    func lineSpacing(_ spacing: CGFloat) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        return self.paragraphStyle(paragraphStyle)
    }

    func paragraphSpacing(_ spacing: CGFloat, before: CGFloat = 0) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        paragraphStyle.paragraphSpacingBefore = before
        return self.paragraphStyle(paragraphStyle)
    }

    func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.baseWritingDirection = baseWritingDirection
        return self.paragraphStyle(paragraphStyle)
    }

    func hyphenationFactor(_ hyphenationFactor: Float) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = hyphenationFactor
        return self.paragraphStyle(paragraphStyle)
    }

    @available(iOS 9.0, tvOS 9.0, watchOS 2.0, OSX 10.11, *)
    func allowsDefaultTighteningForTruncation() -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        return self.paragraphStyle(paragraphStyle)
    }

    func tabsStops(_ tabStops: [NSTextTab], defaultInterval: CGFloat = 0) -> Component {
        let paragraphStyle = getMutableParagraphStyle()
        paragraphStyle.tabStops = tabStops
        paragraphStyle.defaultTabInterval = defaultInterval
        return self.paragraphStyle(paragraphStyle)
    }

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        func textBlocks(_ textBlocks: [NSTextBlock]) -> Component {
            let paragraphStyle = getMutableParagraphStyle()
            paragraphStyle.textBlocks = textBlocks
            return self.paragraphStyle(paragraphStyle)
        }

        func textLists(_ textLists: [NSTextList]) -> Component {
            let paragraphStyle = getMutableParagraphStyle()
            paragraphStyle.textLists = textLists
            return self.paragraphStyle(paragraphStyle)
        }

        func tighteningFactorForTruncation(_ tighteningFactorForTruncation: Float) -> Component {
            let paragraphStyle = getMutableParagraphStyle()
            paragraphStyle.tighteningFactorForTruncation = tighteningFactorForTruncation
            return self.paragraphStyle(paragraphStyle)
        }

        func headerLevel(_ headerLevel: Int) -> Component {
            let paragraphStyle = getMutableParagraphStyle()
            paragraphStyle.headerLevel = headerLevel
            return self.paragraphStyle(paragraphStyle)
        }
    #endif
}
