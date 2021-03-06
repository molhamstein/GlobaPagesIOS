//
// AppFonts.swift
// BrainSocket Code Base
//
//  Created by Molham Mahmoud on 26/04/17.
//  Copyright © 2017. All rights reserved.
//
import UIKit

struct AppFonts {
    // MARK: fonts names
    private static let fontNameBoldEN = "Cairo-Bold"
    private static let fontNameBoldAR = "Cairo-Bold"
    private static let fontNameSemiBoldEN = "Cairo-SemiBold"
    private static let fontNameSemiBoldAR = "Cairo-SemiBold"
    private static let fontNameRegularEN = "Cairo-Regular"
    private static let fontNameRegularAR = "Cairo-Regular"

    // MARK: font sizes
    private static var sizeXBig:Double {
        if AppConfig.currentLanguage == .arabic{
            return 18
        }
        return 24
    }
    private static var sizeBig:Double {
        if AppConfig.currentLanguage == .arabic{
            return 14
        }
        return 18
    }
    private static var sizeNormal:Double{
        if AppConfig.currentLanguage == .arabic{
            return 12
        }
        return 16
    }
    private static var sizeSmall:Double{
        if AppConfig.currentLanguage == .arabic{
            return 9
        }
        return 11
    }
    private static var sizeXSmall:Double{
        if AppConfig.currentLanguage == .arabic{
            return 7
        }
        return 11
    }

    private enum FontWeight {
        case bold
        case semiBold
        case regular
    }

    // MARK: fonts getters
    // font to be used in the app
    static var xBig: UIFont {
        let fontName = getFontName(weight:.regular)
        return UIFont(name: fontName, size: CGFloat(sizeXBig * fontScale))!
    }

    static var xBigBold: UIFont {
        let fontName = getFontName(weight:.bold)
        return UIFont(name: fontName, size: CGFloat(sizeXBig * fontScale))!
    }

    static var xBigSemiBold: UIFont {
        let fontName = getFontName(weight:.semiBold)
        return UIFont(name: fontName, size: CGFloat(sizeXBig * fontScale))!
    }

    static var big: UIFont {
        let fontName = getFontName(weight:.regular)
        return UIFont(name: fontName, size: CGFloat(sizeBig * fontScale))!
    }

    static var bigBold: UIFont {
        let fontName = getFontName(weight:.bold)
        return UIFont(name: fontName, size: CGFloat(sizeBig * fontScale))!
    }

    static var bigSemiBold: UIFont {
        let fontName = getFontName(weight:.semiBold)
        return UIFont(name: fontName, size: CGFloat(sizeBig * fontScale))!
    }

    static var normal: UIFont {
        let fontName = getFontName(weight:.regular)
        return UIFont(name: fontName, size: CGFloat(sizeNormal * fontScale))!
    }

    static var normalBold: UIFont {
        let fontName = getFontName(weight:.bold)
        return UIFont(name: fontName, size: CGFloat(sizeNormal * fontScale))!
    }

    static var normalSemiBold: UIFont {
        let fontName = getFontName(weight:.semiBold)
        return UIFont(name: fontName, size: CGFloat(sizeNormal * fontScale))!
    }

    static var small: UIFont {
        let fontName = getFontName(weight:.regular)
        return UIFont(name: fontName, size: CGFloat(sizeSmall * fontScale))!
    }

    static var smallBold: UIFont {
        let fontName = getFontName(weight:.bold)
        return UIFont(name: fontName, size: CGFloat(sizeSmall * fontScale))!
    }

    static var smallSemiBold: UIFont {
        let fontName = getFontName(weight:.semiBold)
        return UIFont(name: fontName, size: CGFloat(sizeSmall * fontScale))!
    }

    static var xSmall: UIFont {
        let fontName = getFontName(weight:.regular)
        return UIFont(name: fontName, size: CGFloat(sizeXSmall * fontScale))!
    }

    static var xSmallBold: UIFont {
        let fontName = getFontName(weight:.bold)
        return UIFont(name: fontName, size: CGFloat(sizeXSmall * fontScale))!
    }

    static var xSmallSemiBold: UIFont {
        let fontName = getFontName(weight:.semiBold)
        return UIFont(name: fontName, size: CGFloat(sizeXSmall * fontScale))!
    }

    // Font scale
    private static var fontScale:Double {
        var scale : Double = 1.0;
        if (ScreenSize.isSmallScreen) {    // iPhone 4 & 5 (480 - 568)
            scale = 0.8;
        } else if (ScreenSize.isMidScreen){ // iPhone 6 & 7 (667)
            scale = 0.95;
        } else {                    // iPhone 6+ & 7+ (736)
            scale = 1.0;
        }

        if AppConfig.currentLanguage == .arabic {
            scale *= 0.9
        }

        return scale;
    }

    private static func getFontName(weight: FontWeight) -> String {
        if (AppConfig.currentLanguage == .arabic) {
            switch weight {
            case .bold:
                return fontNameBoldAR
            case .semiBold:
                return fontNameSemiBoldAR
            default:
                return fontNameRegularAR
            }
        } else {
            switch weight {
            case .bold:
                return fontNameBoldEN
            case .semiBold:
                return fontNameSemiBoldEN
            default:
                return fontNameRegularEN
            }
        }
    }
}
