//
//  RecordRoutineListViewController.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import ModernRIBs
import UIKit

protocol RecordRoutineListPresentableListener: AnyObject {
    func titleButtonDidTap()
    func routineListDidTap(routineId: UUID)
}

final class RecordRoutineListViewController: UIViewController, RecordRoutineListPresentable, RecordRoutineListViewControllable {

    weak var listener: RecordRoutineListPresentableListener?
        
    private var dataSource : UICollectionViewDiffableDataSource<RecordRoutineListSection, RecordRoutineListViewModel>!
    
    
    fileprivate enum RecordRoutineListSection: String , CaseIterable{
        case routineList
    }

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset : CGFloat = 16.0
        //layout.sectionInset = .init(top: 0.0, left: inset, bottom: inset, right: inset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: RecordRoutineListCell.self)
        

        
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.delegate = self
            
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
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
        view.addSubview(collectionView)
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180.0),
        ])
    }
    
    func setRoutineLists(viewModels: [RecordRoutineListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: .routineList)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .routineList )
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    private func setDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecordRoutineListCell.self)
            cell.bindView(itemIdentifier)
            return cell
        }
        
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <RecordRoutineListHeaderView>(elementKind: UICollectionView.elementKindSectionHeader){ [weak self] (supplementaryView, string, indexPath) in
            guard let self = self else { return }
            supplementaryView.setTitle(title: "Your Achieve")
            supplementaryView.titleButton.addTarget(self, action: #selector(headerViewTitleButtonTap), for: .touchUpInside)
        }
        
        dataSource.supplementaryViewProvider = {  [weak self ] (view, kind, index) in
            self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == UICollectionView.elementKindSectionHeader ? headerRegistration : headerRegistration, for: index
            )
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<RecordRoutineListSection, RecordRoutineListViewModel>()
        snapShot.appendSections(RecordRoutineListSection.allCases)
        self.dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let section = getListTypeSection()
        let compositional = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        //config.interSectionSpacing = 16.0 // section spacing
        config.scrollDirection = .vertical
        compositional.configuration = config
        
        return compositional
    }
    
    private func getListTypeSection() -> NSCollectionLayoutSection {
        let width = UIDevice.frame().width / 2 - 32.0
        let height = width * 0.8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //item.contentInsets = .init(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 8.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0.0, leading: 4.0, bottom: 0.0, trailing: 4.0)
                
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
    
        let sectionHeader = self.getListTypeHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        
        return section
    }
    
    private func getListTypeHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(54.0))

        // Section Header Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        return sectionHeader
    }
    

    @objc
    private func headerViewTitleButtonTap(){
        listener?.titleButtonDidTap()
    }
    
}


extension RecordRoutineListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel =  dataSource.itemIdentifier(for: indexPath){
            listener?.routineListDidTap(routineId: viewModel.routineId)
        }
    }
    
}
