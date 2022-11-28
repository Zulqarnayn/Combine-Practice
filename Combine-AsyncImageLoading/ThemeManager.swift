//
//  ThemeManager.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 27/11/22.
//

import Foundation
import Combine

struct AppString {
    static let shouldOverrideSystemSetting = "ThemeManager.shouldOverrideSystemSetting"
    static let shouldApplyDarkMode = "ThemeManager.shouldApplyDarkMode"
}

class ThemeManager {
    enum PreferredUserInterfaceStyle {
        case dark, light, system
    }
    
    @Published var themeStyle: PreferredUserInterfaceStyle = .system
    
    var shouldOverrideSystemSetting: Bool {
        get { UserDefaults.standard.bool(forKey: AppString.shouldOverrideSystemSetting) }
        set { UserDefaults.standard.set(newValue, forKey: AppString.shouldOverrideSystemSetting)
            updateThemeStyle()
        }
    }
    
    var shouldApplyDarkMode: Bool {
        get { UserDefaults.standard.bool(forKey: AppString.shouldApplyDarkMode) }
        set { UserDefaults.standard.set(newValue, forKey: AppString.shouldApplyDarkMode)
            updateThemeStyle()
        }
    }
    
    private func updateThemeStyle() {
        themeStyle = shouldOverrideSystemSetting ? ( shouldApplyDarkMode ? .dark : .light) : .system
    }
}
