//
//  CustomCell.swift
//  PortfolioApp
//
//  Created by Alexander Altman on 01.08.2023.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    weak var delegate: ViewControllerDelegate?
    
    var cellViewModel: SkillsCellViewModel? {
        didSet {
            guard let cellViewModel else { return }
            skillLabel.text = cellViewModel.skillName
            setViews()
            layout()
        }
    }
    
    //MARK: - Elements
    private lazy var cellBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 245/255, alpha: 1)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var skillLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var crossButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(deleteSkillCell), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Methods
    private func setViews() {
        contentView.addSubview(cellBackground)
        contentView.addSubview(skillLabel)
        
        guard let cellViewModel else { return }
        if cellViewModel.isEditing {
            contentView.addSubview(crossButton)
        }
    }
    
    //MARK: - Constraints
    func layout() {
        guard let cellViewModel else { return }
        NSLayoutConstraint.activate([
            cellBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        if cellViewModel.isEditing {
            NSLayoutConstraint.activate([
                crossButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                crossButton.widthAnchor.constraint(equalToConstant: 14),
                crossButton.heightAnchor.constraint(equalToConstant: 14),
                crossButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                
                skillLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                skillLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
            ])
        } else {
            NSLayoutConstraint.activate([
                skillLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                skillLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                skillLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                skillLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
        }
    }
}

extension CustomCell {
    @objc func deleteSkillCell() {
        guard let cellViewModel else { return }
        delegate?.delete(at: cellViewModel.cellIndex)
    }
}
