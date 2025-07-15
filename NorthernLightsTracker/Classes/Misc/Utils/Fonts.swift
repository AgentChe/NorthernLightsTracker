//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: IBMPlexSans
    struct IBMPlexSans {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "IBMPlexSans-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "IBMPlexSans-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "IBMPlexSans-Medium", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "IBMPlexSans-Bold", size: size)!
        }
    }
}
