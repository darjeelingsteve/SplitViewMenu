//
//  PresenterGroup.swift
//  SplitViewMenu
//
//  Created by Stephen Anthony on 14/01/2021.
//

import Foundation

/// Represents a group of MasterChef presenters.
struct PresenterGroup: Codable, Hashable {
    
    /// The name of the group.
    let name: String
    
    /// The presenters in the group.
    let presenters: [Presenter]
}
