//
//  TimerSectionListViewController.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs
import UIKit

protocol TimerSectionListPresentableListener: AnyObject {
    func tableViewDidTap(row: Int)
}

final class TimerSectionListViewController: UIViewController, TimerSectionListPresentable, TimerSectionListViewControllable {

    weak var listener: TimerSectionListPresentableListener?
    
    private var dataSource : UITableViewDiffableDataSource<Section , TimerSectionListViewModel>!
    enum Section : String , CaseIterable{
        case section
    }
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: TimerSectionListCell.self)
//        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
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
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setSections(_ viewModels: [TimerSectionListViewModel]) {
        if self.dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: .section)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .section)
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    
    private func setDataSource(){
        dataSource = UITableViewDiffableDataSource<Section , TimerSectionListViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(for: indexPath ,cellType:  TimerSectionListCell.self)
            cell.selectionStyle = .none
            cell.bindView(viewModel)
            return cell
        } )

        var snapShot = NSDiffableDataSourceSnapshot<Section , TimerSectionListViewModel>()
        snapShot.appendSections(Section.allCases)
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
  

}


extension TimerSectionListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.tableViewDidTap(row: indexPath.row)
    }
}
