//
//  SettingAppIconViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol SettingAppIconPresentableListener: AnyObject {
    func didMove()
    func didSelectItemAt(row: Int)
}

final class SettingAppIconViewController: UIViewController, SettingAppIconPresentable, SettingAppIconViewControllable {

    weak var listener: SettingAppIconPresentableListener?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SettingAppIconViewModel>!
    
    enum Section: String{
        case appIcon
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: SettingAppIconCell.self)
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
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
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func setIcons(viewModels: [SettingAppIconViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapshot = self.dataSource.snapshot()
        snapshot.appendItems(viewModels, toSection: .appIcon)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SettingAppIconCell.self)
            cell.bindView(itemIdentifier)
            cell.backgroundColor = .red
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SettingAppIconViewModel>()
        snapshot.appendSections([Section.appIcon])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let section = getListTypeSection()
        let compositional = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        compositional.configuration = config
        
        return compositional
    }
    
    private func getListTypeSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(8.0)
                
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: 16.0, bottom: 0, trailing: 16.0)
        section.interGroupSpacing = 8.0
        
        return section
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }
}


extension SettingAppIconViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.didSelectItemAt(row: indexPath.row)
    }
}
