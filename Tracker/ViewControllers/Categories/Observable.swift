//
//  Observe.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 23.11.2023.
//

import UIKit

@propertyWrapper
final class Observable<Value> {
    
    private var onChange: ((Value)->Void)? = nil
    var wrappedValue: Value {
        didSet{
            onChange?(wrappedValue)
        }
    }
    
    var projectedValue: Observable<Value> {
        return self
    }
    
    init(wrappedValue: Value){
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping(Value)->Void ){
        self.onChange = action
    }
}
