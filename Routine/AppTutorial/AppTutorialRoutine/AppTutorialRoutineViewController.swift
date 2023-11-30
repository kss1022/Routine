//
//  AppTutorialRoutineViewController.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialRoutinePresentableListener: AnyObject {
    func continueButtonDidTap()
    func tableViewDidSelectRowAt(row: Int)
    func tableViewDidDeselectRowAt(row: Int)
}

final class AppTutorialRoutineViewController: UIViewController, AppTutorialRoutinePresentable, AppTutorialRoutineViewControllable {

    weak var listener: AppTutorialRoutinePresentableListener?

    private var dataSource: UITableViewDiffableDataSource<String, TutorialRoutineListViewModel>!

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 48.0)
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        tableView.register(cellType: TutorialRoutineListCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .none
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        
        
        return tableView
    }()

    
    private lazy var continueButton: TouchesRoundButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .getFont(size: 24.0)
        button.setTitle("Continue", for: .normal)
        
                
        button.contentEdgeInsets = .init(top: 16.0, left: 32.0, bottom: 16.0, right: 32.0)
        button.addTarget(self, action: #selector(continueButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }

    private func setLayout(){
        view.backgroundColor  = .primaryColor

        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(continueButton)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16.0),
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        titleLabel.text = "Choose a habbit to start right away!"
        continueButton.isHidden = true
    }
    
    func setList(_ viewModels: [TutorialRoutineListViewModel]) {
        if self.dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: "")
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: "")
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    func showContinueButton() {
        if !continueButton.isHidden{
            return
        }
        
        self.continueButton.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.continueButton.isHidden = false
            self.continueButton.alpha = 1.0
        }
    }
    
    func hideContinueButton() {
        if continueButton.isHidden{
            return
        }
        
        self.continueButton.alpha = 1.0
        UIView.animate(withDuration: 0.2) {
            self.continueButton.isHidden = true
            self.continueButton.alpha = 0.0
        }
    }
    
    private func setDataSource(){
        dataSource = UITableViewDiffableDataSource<String, TutorialRoutineListViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TutorialRoutineListCell.self)
            cell.bindView(itemIdentifier)
            cell.selectionStyle = .none
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<String, TutorialRoutineListViewModel>()
        snapshot.appendSections([""])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc
    private func continueButtonTap(){    
        listener?.continueButtonDidTap()
    }

}



extension AppTutorialRoutineViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.tableViewDidSelectRowAt(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        listener?.tableViewDidDeselectRowAt(row: indexPath.row)
    }
}
