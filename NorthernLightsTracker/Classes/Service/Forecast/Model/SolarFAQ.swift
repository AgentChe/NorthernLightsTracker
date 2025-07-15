//
//  SolarFAQ.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct SolarFAQ {
    let question: String
    let answer: String
    
    init?(json: [String: Any]) {
        guard
            let question = json["question"] as? String,
            let answer = json["answer"] as? String
        else { return nil }
        
        self.question = question
        self.answer = answer
    }
}
