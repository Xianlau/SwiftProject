//
//  AppPreferences.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

final class AppPreferences {
    static let shared = AppPreferences()
    
    enum Keys: String {
        case firstLanuch = "IsFirstLanuch"
        case showGuide = "ShouldShowGuide"
        case hasUserLoginBefore = "HasUserLoginBefore"
    }
    
    fileprivate let PreferencesKey = "AppPreferences"
    fileprivate var preferences = [String: Any]()
    
    init() {
        loadPrefernces()
        observeApplicationState()
    }
   
    /// 用户是否第一次运行App
    var isFirstLaunch: Bool {
        get { return preferences[Keys.firstLanuch.rawValue] as! Bool }
        set { preferences[Keys.firstLanuch.rawValue] = newValue }
    }
    
    /// 是否显示指引界面，比如App第一次启动，或者更新。
    var shouldShowGuide: Bool {
        get { return preferences[Keys.showGuide.rawValue] as! Bool }
        set { preferences[Keys.showGuide.rawValue] = newValue }
    }
    
    /// 用户之前是否登陆过
    var hasUserLoginBefore: Bool {
        get { return preferences[Keys.hasUserLoginBefore.rawValue] as! Bool }
        set { preferences[Keys.hasUserLoginBefore.rawValue] = newValue }
    }
}


fileprivate extension AppPreferences {
    
    func loadPrefernces() {
        if let infoDic = UserDefaults.standard.dictionary(forKey: PreferencesKey) {
            preferences = infoDic
        } else {
            resetDefaultPreference()
        }
    }
    
    func resetDefaultPreference() {
        
        var defaultInfo = Dictionary<String, Any>()
        defaultInfo[Keys.firstLanuch.rawValue] = true
        
        //FIXME: Demo阶段暂且采用默认实现。
        defaultInfo[Keys.showGuide.rawValue] = false
        
        //FIXME: Demo阶段暂且采用默认实现。
        defaultInfo[Keys.hasUserLoginBefore.rawValue] = true
        
        preferences = defaultInfo
        UserDefaults.standard.set(defaultInfo, forKey: PreferencesKey)
    }
    
    func observeApplicationState() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncToUserDefaults), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(syncToUserDefaults), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func syncToUserDefaults() {
        UserDefaults.standard.set(preferences, forKey: PreferencesKey)
    }
}
