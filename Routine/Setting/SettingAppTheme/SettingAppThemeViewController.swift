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
    func tableViewDidDeSelectedRow(row: Int)
}

final class SettingAppThemeViewController: UIViewController, SettingAppThemePresentable, SettingAppThemeViewControllable {

    weak var listener: SettingAppThemePresentableListener?
        
    private var selectedIndex: Int = 0
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: UITableViewCell.self)
        
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
        self.selectedIndex = row
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        UIView.animate(withDuration: 0.5, animations: {
            AppThemeManager.share.updateTheme()
        })
    }
    
    func setDeSelectedRow(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UITableViewCell.self)
        
        var content = cell.defaultContentConfiguration()
        
        content.textProperties.font = .getFont(style: .callout)
        
        switch indexPath.row{
        case 0:
            content.text = "System"
            content.image = UIImage(systemName: "gearshape")
            selectedIndex == 0 ? ( cell.accessoryType = .checkmark ) : ( cell.accessoryType = .none )
        case 1:
            content.text = "Light"
            content.image = UIImage(systemName: "sun.max")
            selectedIndex == 1 ? ( cell.accessoryType = .checkmark ) : ( cell.accessoryType = .none )
        case 2:
            content.text = "Dark"
            content.image = UIImage(systemName: "moon")
            selectedIndex == 2 ? ( cell.accessoryType = .checkmark ) : ( cell.accessoryType = .none )
        default: fatalError("Invalid IndexPath.row")
        }
        
        cell.contentConfiguration = content
        
        
        return cell
    }
    
}

extension SettingAppThemeViewController: UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {                
        listener?.tableViewDidSelectedRow(row: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        listener?.tableViewDidDeSelectedRow(row: indexPath.row)
    }
}
