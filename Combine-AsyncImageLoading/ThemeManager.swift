//
//  ThemeManager.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 27/11/22.
//

import Foundation
import Combine

class ThemeManager {
    enum PreferredUserInterfaceStyle {
        case dark, light, system
    }
    
    lazy private(set) var themeSubject: CurrentValueSubject<PreferredUserInterfaceStyle, Never> = {
        var preferredStyle = PreferredUserInterfaceStyle.system
        
        if shouldOverrideSystemSetting {
            preferredStyle = shouldApplyDarkMode ? .dark : .light
        }
        return CurrentValueSubject<PreferredUserInterfaceStyle, Never>(preferredStyle)
    }()
    
    var shouldOverrideSystemSetting: Bool {
        get { UserDefaults.standard.bool(forKey: "ThemeManager.shouldOverrideSystemSetting") }
        set { UserDefaults.standard.set(newValue, forKey: "ThemeManager.shouldOverrideSystemSetting")
            updateThemeSubject()
        }
    }
    
    var shouldApplyDarkMode: Bool {
        get { UserDefaults.standard.bool(forKey: "ThemeManager.shouldApplyDarkMode") }
        set { UserDefaults.standard.set(newValue, forKey: "ThemeManager.shouldApplyDarkMode")
            updateThemeSubject()
        }
    }
    
    private func updateThemeSubject() {
        if shouldOverrideSystemSetting {
            themeSubject.value = shouldApplyDarkMode ? .dark : .light
        } else {
            themeSubject.value = .system
        }
    }
}
