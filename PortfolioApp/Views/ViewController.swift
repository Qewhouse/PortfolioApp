//
//  ViewController.swift
//  PortfolioApp
//
//  Created by Alexander Altman on 01.08.2023.
//

import UIKit
// #F3F3F5

protocol ViewControllerDelegate: AnyObject {
    func delete(at index: Int)
}

class ViewController: UIViewController {
    
    //MARK: - Constants
    private var width: CGFloat = 16
    private var countRow = 0
    var viewModel = MainViewModel()
    
    //MARK: - Elements
    private lazy var skillsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 245/255, alpha: 1)
        return scrollView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        imageView.layer.borderWidth = 2
        imageView.image = UIImage(named: "ProfilePhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Альтман Александр Михайлович"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS developer, Swift Marathon Team lead"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLogo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Location"), for: .normal)
        button.setTitle("Санкт-Петербург", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var skilsLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои навыки"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var skillEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Pencil"), for: .normal)
        button.addTarget(self, action: #selector(editSkillSet), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "О себе"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionAboutLabel: UILabel = {
        let label = UILabel()
        label.text = "Тимлид и ментор на проекте Swift Marathon"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionID = "collectionCell"
    
    private lazy var SkillsCollectionView: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collection = CustomCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.register(CustomCell.self, forCellWithReuseIdentifier: collectionID)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    //MARK: - Add views
    private func setViews() {
        title = "Профиль"
        
        view.addSubview(skillsScrollView)
        
        skillsScrollView.addSubview(profileImageView)
        skillsScrollView.addSubview(profileNameLabel)
        skillsScrollView.addSubview(profileInfoLabel)
        skillsScrollView.addSubview(locationLogo)
        skillsScrollView.addSubview(backgroundView)
        skillsScrollView.addSubview(skilsLabel)
        skillsScrollView.addSubview(skillEditButton)
        skillsScrollView.addSubview(SkillsCollectionView)
        skillsScrollView.addSubview(aboutLabel)
        skillsScrollView.addSubview(descriptionAboutLabel)
    }
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionID, for: indexPath) as? CustomCell else { return UICollectionViewCell()}
        let cellViewModel = viewModel.getCustomCellViewModel(for: indexPath)
        cellViewModel.cellIndex = indexPath.row
        if viewModel.isEditing {
            if viewModel.isLast(at: indexPath) {
                cellViewModel.isEditing.toggle()
                cell.cellViewModel = cellViewModel
            } else {
                cell.cellViewModel = cellViewModel
            }
        } else {
            cell.cellViewModel = cellViewModel
        }
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = viewModel.getSkill(for: indexPath)
        label.sizeToFit()
        if viewModel.isEditing {
            if viewModel.isLast(at: indexPath) {
                let count = label.frame.width + 48
                if isWidthLessSelfViewWidth(count: count) {
                    countRow += 1
                    width = 16
                    width += count
                } else {
                    width += count
                }
                return CGSize(width: count, height: 44)
            } else {
                let count = label.frame.width + 48 + 24
                if isWidthLessSelfViewWidth(count: count) {
                    countRow += 1
                    width = 16
                    width += count
                } else {
                    width += count
                }
                return CGSize(width: count, height: 44)
            }
        } else {
            let count = label.frame.width + 48
            if isWidthLessSelfViewWidth(count: count) {
                countRow += 1
                width = 16
                width += count
            } else {
                width += count
            }
            return CGSize(width: count, height: 44)
        }
    }
}

extension ViewController {
    @objc private func editSkillSet() {
        if viewModel.isEditing {
            viewModel.isEditing.toggle()
            SkillsCollectionView.reloadData()
            SkillsCollectionView.layoutIfNeeded()
            updateScrollView()
            skillEditButton.setImage(UIImage(named: "Pencil"), for: .normal)
        } else {
            viewModel.isEditing.toggle()
            print(viewModel.isEditing)
            SkillsCollectionView.reloadData()
            SkillsCollectionView.layoutIfNeeded()
            updateScrollView()
            skillEditButton.setImage(UIImage(named:"Check"), for: .normal)
        }
    }
}

//MARK: - MainViewControllerDelegate
extension ViewController: ViewControllerDelegate {
    func delete(at index: Int) {
        viewModel.deleteSkill(for: index)
        SkillsCollectionView.reloadData()
        SkillsCollectionView.layoutIfNeeded()
        updateScrollView()
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.isEditing {
            if viewModel.isLast(at: indexPath) {
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Добавление навыка", message: "Введите название навыка которым Вы владеете", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        alert.addAction(cancelAction)
        let addAction = UIAlertAction(title: "Добавить", style: .default) {[weak self] _ in
            guard let self, let text = alert.textFields?[0].text else { return }
            self.viewModel.addSkill(skil: text)
            self.SkillsCollectionView.reloadData()
            self.SkillsCollectionView.layoutIfNeeded()
            updateScrollView()
        }
        alert.addAction(addAction)
        present(alert, animated: true)
    }
}

extension ViewController {
    private func updateScrollView() {
        var height:CGFloat = 0
        for view in skillsScrollView.subviews {
            if view != SkillsCollectionView {
                height += view.bounds.height
            }
        }
        height += CGFloat(countRow * 44)
        height += CGFloat(12 * (countRow - 1))
        skillsScrollView.contentSize = CGSize(width: view.bounds.width, height: height)
    }
    
    func isWidthLessSelfViewWidth(count: CGFloat) -> Bool {
        return (width + count) > view.frame.width
    }
}

//MARK: - Constraints
extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            skillsScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            skillsScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            skillsScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            skillsScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            skillsScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
    
            profileImageView.centerXAnchor.constraint(equalTo: skillsScrollView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: skillsScrollView.topAnchor, constant: 24),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
 
            profileNameLabel.centerXAnchor.constraint(equalTo: skillsScrollView.centerXAnchor),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            profileNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
      
            profileInfoLabel.centerXAnchor.constraint(equalTo: skillsScrollView.centerXAnchor),
            profileInfoLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 4),
            profileInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
            locationLogo.centerXAnchor.constraint(equalTo: skillsScrollView.centerXAnchor),
            locationLogo.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: 10),
            locationLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: locationLogo.bottomAnchor, constant: 19),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
       
            skilsLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 21),
            skilsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        
            skillEditButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 21),
            skillEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            skillEditButton.widthAnchor.constraint(equalToConstant: 24),
            skillEditButton.heightAnchor.constraint(equalToConstant: 24),
       
            self.SkillsCollectionView.leadingAnchor.constraint(equalTo: skilsLabel.leadingAnchor),
            self.SkillsCollectionView.trailingAnchor.constraint(equalTo: skillEditButton.trailingAnchor),
            self.SkillsCollectionView.topAnchor.constraint(equalTo: skilsLabel.bottomAnchor, constant: 16),

            aboutLabel.topAnchor.constraint(equalTo: SkillsCollectionView.bottomAnchor, constant: 24),
            aboutLabel.leadingAnchor.constraint(equalTo: SkillsCollectionView.leadingAnchor),
   
            descriptionAboutLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            descriptionAboutLabel.leadingAnchor.constraint(equalTo: SkillsCollectionView.leadingAnchor),
            descriptionAboutLabel.trailingAnchor.constraint(equalTo: SkillsCollectionView.trailingAnchor),
            descriptionAboutLabel.bottomAnchor.constraint(equalTo: skillsScrollView.bottomAnchor)
        ])
    }
}
