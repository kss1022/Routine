//
//  AppFontListViewController.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs
import UIKit

protocol AppFontListPresentableListener: AnyObject {
    func closeButtonDidTap()

    func tableViewdidSelectRowAt(viewModel: AppFontViewModel)
    func searchBarCancelButtonTap()
    func searchTextDidChange(text: String)
}

final class AppFontListViewController: UIViewController, AppFontListPresentable, AppFontListViewControllable {

    weak var listener: AppFontListPresentableListener?
    
    private var dataSource: AppFontTabeViewDiffableDataSource!
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 36.0
        tableView.register(cellType: UITableViewCell.self)
        tableView.delegate = self
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
        title = "SelectFont"

        view.backgroundColor = .secondarySystemBackground
                
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.searchController = searchController
                        
        view.addSubview(tableView)


        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor , constant: 60.0),
            //tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])        
    }
    
    
    
    func setFonts(_ viewModels: [AppFontListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
                
        var snapShot = NSDiffableDataSourceSnapshot<String, AppFontViewModel>()
        snapShot.appendSections(viewModels.map{ $0.section} )
        
        viewModels.forEach {
            snapShot.appendItems($0.fonts , toSection: $0.section)
        }
                
        self.dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    
    func filterFonts(_ viewModels: [AppFontViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<String, AppFontViewModel>()
        snapShot.appendSections([""])
        snapShot.appendItems(viewModels)
        self.dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func setDataSource(){
        dataSource = AppFontTabeViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UITableViewCell.self)
            
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.fontName
            content.textProperties.font = itemIdentifier.font
            cell.contentConfiguration = content
            return cell
        })
    }
    
    @objc
    private func closeBarButtonTap(){
        self.listener?.closeButtonDidTap()
    }
}


fileprivate final class AppFontTabeViewDiffableDataSource : UITableViewDiffableDataSource<String, AppFontViewModel>{
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let firstItem = self.itemIdentifier(for: IndexPath(item: 0, section: section)) else { return nil }
        return self.snapshot().sectionIdentifier(containingItem: firstItem)
    }
}

extension AppFontListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = dataSource.itemIdentifier(for: indexPath) else { return }
        listener?.tableViewdidSelectRowAt(viewModel: viewModel)
    }
}

extension AppFontListViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        listener?.searchBarCancelButtonTap()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listener?.searchTextDidChange(text: searchText)        
    }
}
