//
//  CustomCellModel.swift
//  PortfolioApp
//
//  Created by Alexander Altman on 01.08.2023.
//

import Foundation

class SkillsCellViewModel {
    var skillName: String
    var isEditing: Bool
    var cellIndex: Int = 0
    
    init(skil: String, isEditing: Bool) {
        self.skillName = skil
        self.isEditing = isEditing
    }
}
