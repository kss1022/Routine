//
//  RoutineListViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import ModernRIBs
import UIKit

protocol RoutineListPresentableListener: AnyObject {
    func routineListDidTap(_ routineId: UUID)
}


final class RoutineListViewController: UIViewController, RoutineListPresentable, RoutineListViewControllable {
    
    
    weak var listener: RoutineListPresentableListener?
    
    
    private var dataSource : RoutineListDiffableDataSource!

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset : CGFloat = 16.0
        layout.sectionInset = .init(top: 0.0, left: inset, bottom: inset, right: inset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: RoutineListCell.self)
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let emptyView: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 24.0)
        label.textColor = .secondaryLabel
        label.text = "no_tasks".localized(tableName: "Routine")
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    func setRoutineLists(viewModels: [RoutineListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        
        let beforeItems = snapShot.itemIdentifiers(inSection: .routineList)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .routineList )
        snapShot.reloadSections([.routineList])
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    
    func showEmpty() {
        emptyView.isHidden = false
    }
    
    func hideEmpty() {
        emptyView.isHidden = true
    }
    
    
    
    private func setDataSource(){
        dataSource = RoutineListDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RoutineListCell.self)
            cell.bindView(itemIdentifier)
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <RoutineListHeaderView>(elementKind: UICollectionView.elementKindSectionHeader){ [weak self] (supplementaryView, string, indexPath) in
            if let self = self{
                supplementaryView.isHidden = !self.emptyView.isHidden
            }
            
            supplementaryView.setTitle(title: "all_time_of_the_day".localized(tableName: "Routine"))
        }
        
        dataSource.supplementaryViewProvider = {  [weak self ] (view, kind, index) in
            self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == UICollectionView.elementKindSectionHeader ? headerRegistration : headerRegistration, for: index
            )
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<RoutineListSection, RoutineListViewModel>()
        snapShot.appendSections(RoutineListSection.allCases)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120.0))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8.0)
                
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        section.interGroupSpacing = 8.0
        
        let sectionHeader = self.getListTypeHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        
        return section
    }
    
    private func getListTypeHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(35.0))

        // Section Header Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        return sectionHeader
    }
    
}


// MARK: CollectionViewDiffableDataSource
fileprivate enum RoutineListSection: String , CaseIterable{
    case routineList = "All time of the day"
}

fileprivate final class RoutineListDiffableDataSource: UICollectionViewDiffableDataSource<RoutineListSection, RoutineListViewModel>{
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }

    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
}

extension RoutineListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel =  dataSource.itemIdentifier(for: indexPath){
            listener?.routineListDidTap(viewModel.routineId)
        }
    }
    
}


extension RoutineListViewController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }

    
    // To only select needed view as preview instead of whole cell
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        return previewParameters
    }
}



extension RoutineListViewController: UICollectionViewDropDelegate{
        
    // Called when the user initiates the drop operation
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
                
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
                                
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }

    // Actual logic which perform after drop the view
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if
            let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
   
            var snapShot = dataSource.snapshot()
            
            let sourceItem = dataSource.itemIdentifier(for: sourceIndexPath)!
            let destinationItem = dataSource.itemIdentifier(for: destinationIndexPath)!

            snapShot.deleteItems([sourceItem])
            
            if destinationIndexPath.row < sourceIndexPath.row{
                //destination이 앞에 있는 경우
                snapShot.insertItems([sourceItem], beforeItem: destinationItem)
            }else{
                //destination이 뒤에 있는 경우
                snapShot.insertItems([sourceItem], afterItem: destinationItem)
            }
            self.dataSource.apply( snapShot , animatingDifferences: true )
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            
            Log.v("DragDrop RoutineLiset \(sourceIndexPath.row) to \(destinationIndexPath.row)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        return previewParameters
    }
    
}


