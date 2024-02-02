//
//  RecordTimerListViewController.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import ModernRIBs
import UIKit

protocol RecordTimerListPresentableListener: AnyObject {
    func titleButtonDidTap()
    func timerListDidTap(timerId: UUID)
}

final class RecordTimerListViewController: UIViewController, RecordTimerListPresentable, RecordTimerListViewControllable {

    weak var listener: RecordTimerListPresentableListener?
    
    private var dataSource : UICollectionViewDiffableDataSource<Section, RecordTimerListViewModel>!
    
    private let width: CGFloat = UIDevice.frame().width / 2 - 32.0
    private var height: CGFloat{ width * 0.8 }
    private let sectionHeight: CGFloat = 54.0

    fileprivate enum Section: String , CaseIterable{
        case timerList
    }

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: RecordTimerListCell.self)
        
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.delegate = self
            
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private lazy var emptyView: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 24.0)
        label.textColor = .secondaryLabel
        label.text = "added_timer_isEmpty".localized(tableName: "Record")
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isHidden = true
        return label
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
        view.addSubview(collectionView)
        view.addSubview(emptyView)
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height + sectionHeight),
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 16.0),
        ])
    }
    
    func setTimerLists(_ viewModels: [RecordTimerListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: .timerList)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .timerList )
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    func showEmpty() {
        emptyView.isHidden = false
    }
    
    func hideEmpty() {
        emptyView.isHidden = true
    }
    
    private func setDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecordTimerListCell.self)
            cell.bindView(itemIdentifier)
            return cell
        }
        
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <RecordRoutineListHeaderView>(elementKind: UICollectionView.elementKindSectionHeader){ [weak self] (supplementaryView, string, indexPath) in
            guard let self = self else { return }
            supplementaryView.setTitle(title: "your_focus".localized(tableName: "Record"))
            supplementaryView.titleButton.addTarget(self, action: #selector(headerViewTitleButtonTap), for: .touchUpInside)
        }
        
        dataSource.supplementaryViewProvider = {  [weak self ] (view, kind, index) in
            self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == UICollectionView.elementKindSectionHeader ? headerRegistration : headerRegistration, for: index
            )
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, RecordTimerListViewModel>()
        snapShot.appendSections(Section.allCases)
        self.dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let section = getListTypeSection()
        let compositional = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        compositional.configuration = config
        
        return compositional
    }
    
    private func getListTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0.0, leading: 4.0, bottom: 0.0, trailing: 4.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        let sectionHeader = self.getListTypeHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        
        return section
    }
    
    private func getListTypeHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(sectionHeight))

        // Section Header Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        return sectionHeader
    }
    

    @objc
    private func headerViewTitleButtonTap(){
        listener?.titleButtonDidTap()
    }
    
}


extension RecordTimerListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel =  dataSource.itemIdentifier(for: indexPath){
            listener?.timerListDidTap(timerId: viewModel.timerId)
        }
    }
    
}
