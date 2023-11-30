//
//  SettingAppNotificationViewController.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs
import UIKit

protocol SettingAppNotificationPresentableListener: AnyObject {
    func didMove()
}

final class SettingAppNotificationViewController: UIViewController, SettingAppNotificationPresentable, SettingAppNotificationViewControllable {

    weak var listener: SettingAppNotificationPresentableListener?
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: UITableViewCell.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
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
        title = "Setting Alarm"
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
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }
}

extension SettingAppNotificationViewController: UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UITableViewCell.self)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "Alarm"
        content.textProperties.font = .getFont(style: .callout)
        
        content.image = UIImage(systemName: "app.badge")
        
        cell.contentConfiguration = content
        cell.accessoryView = UISwitch()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") else{
            fatalError("Failed to dequeue reusable cell")
        }
                
        var content = headerView.defaultContentConfiguration()
        content.text = "OnOff"
        Log.v("\(content.textProperties.font)")
        content.textProperties.font = .getFont(style: .caption1)
        
        headerView.contentConfiguration = content
        
        return headerView
    }

}


extension SettingAppNotificationViewController: UITableViewDelegate{
    
}
