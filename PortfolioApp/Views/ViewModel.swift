//
//  ViewModel.swift
//  PortfolioApp
//
//  Created by Alexander Altman on 01.08.2023.
//

import Foundation

class MainViewModel {
    
    private var skillSet: [String] = [
        "MVP+Coordinator/MVC/MVVM", "XCode",
        "AutoLayout", "CoreData",
        "Realm", "Git",
        "Custom UI Elements", "Foundation/UIKit",
        "OOP", "SOLID", "DRY", "KISS", "YAGNI"
    ]
    
    var isEditing = false
    
    func numberOfRow() -> Int {
        if isEditing {
            return skillSet.count + 1
        } else {
            return skillSet.count
        }
    }
    
    func deleteSkill(for index: Int) {
        skillSet.remove(at: index)
    }
    
    func addSkill(skil: String) {
        skillSet.append(skil)
    }
    
    func getCustomCellViewModel(for indexPath: IndexPath) -> SkillsCellViewModel {
        if isEditing {
            if indexPath.row == skillSet.count {
                return SkillsCellViewModel(skil: "+", isEditing: isEditing)
            } else {
                return SkillsCellViewModel(skil: skillSet[indexPath.row], isEditing: isEditing)
            }
        } else {
            return SkillsCellViewModel(skil: skillSet[indexPath.row], isEditing: isEditing)
        }
    }
    
    func getSkill(for indexPath: IndexPath) -> String {
        if isEditing {
            if indexPath.row == skillSet.count {
                return "+"
            } else {
                return skillSet[indexPath.row]
            }
        } else {
            return skillSet[indexPath.row]
        }
    }
    
    func isLast(at indexPath: IndexPath) -> Bool {
        return indexPath.row == skillSet.count
    }
}
