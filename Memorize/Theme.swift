//
//  Theme.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 15/09/24.
//

import SwiftUI

struct Theme<Content> {
    
    let name: String
    let content: [Content]
    let color: Color
    let numberOfPairs: Int
}

