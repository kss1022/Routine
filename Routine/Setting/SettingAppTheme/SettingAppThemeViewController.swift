//
//  SettingAppThemeViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol SettingAppThemePresentableListener: AnyObject {
    func didMove()
    func tableViewDidSelectedRow(row: Int)
}

final class SettingAppThemeViewController: UIViewController, SettingAppThemePresentable, SettingAppThemeViewControllable {

    weak var listener: SettingAppThemePresentableListener?
        
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: SettingAppThemeCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil{
            listener?.didMove()
        }
    }
    
    func setSelectedRow(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    func updateTheme() {
        UIView.animate(withDuration: 0.5, animations: {
            AppThemeManager.share.updateTheme()
        })
    }
 
}


extension SettingAppThemeViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingAppThemeCell.self)
        
        
        switch indexPath.row{
        case 0:
            cell.bindView(title: "System", imageName: "gearshape")
        case 1:
            cell.bindView(title: "Light", imageName: "sun.max")
        case 2:
            cell.bindView(title: "Dark", imageName: "moon")
        default: fatalError("Invalid IndexPath.row")
        }
                                
        return cell
    }
    
}

extension SettingAppThemeViewController: UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {                
        listener?.tableViewDidSelectedRow(row: indexPath.row)
    }

}
