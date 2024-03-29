//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 30.11.2023.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    static var shared = AnalyticsService()
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        
        //  analyticsService.report(event: "mixes_add", params: ["mixes_count" : emojiMixes.count + 1])
    }
    
    func anal(){
        
        let params : [AnyHashable : Any] = ["key1": "value1", "key2": "value2"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    
}
