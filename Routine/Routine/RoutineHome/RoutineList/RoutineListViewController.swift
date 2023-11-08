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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "All time of the day"
        return label
    }()
    
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
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
        
    
    
    private func setLayout(){
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    private func setDataSource(){
        dataSource = RoutineListDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RoutineListCell.self)
            cell.bindView(itemIdentifier)
            return cell
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50.0))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8.0)
                
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: 16.0, bottom: 0, trailing: 16.0)
        section.interGroupSpacing = 8.0
        
        return section
    }
    
}


// MARK: CollectionViewDiffableDataSource
fileprivate enum RoutineListSection: String , CaseIterable{
    case routineList = "RoutineList"
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


