//
//  TimerSelectViewController.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import ModernRIBs
import UIKit

protocol TimerSelectPresentableListener: AnyObject {
    func closeButtonDidTap()
    func creatTimerButtonDidTap()
    func collectionViewDidSelectItemAt(timerId: UUID)
}

final class TimerSelectViewController: UIViewController, TimerSelectPresentable, TimerSelectViewControllable {

    weak var listener: TimerSelectPresentableListener?
    
    private var dataSource: TimerListDiffableDataSource!
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
    private lazy var createTimerBarButtonItem : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(createTimerBarButtonTap)
        )
        return barButtonItem
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset : CGFloat = 16.0
        layout.sectionInset = .init(top: 0.0, left: inset, bottom: inset, right: inset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: TimerListCell.self)
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
        title = "Choose your timer"
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = createTimerBarButtonItem
        
        view.addSubview(collectionView)
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func setTimerList(_ viewModels : [TimerListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: .timerList)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .timerList )
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    
    private func setDataSource(){
        dataSource = TimerListDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimerListCell.self)
            cell.bindView(itemIdentifier)
            return cell
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<TimerListSection, TimerListViewModel>()
        snapShot.appendSections(TimerListSection.allCases)
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
    
    
    @objc
    private func closeBarButtonTap(){
        self.listener?.closeButtonDidTap()
    }
    
    @objc
    private func createTimerBarButtonTap(){
        listener?.creatTimerButtonDidTap()
    }
}



// MARK: CollectionViewDiffableDataSource
fileprivate enum TimerListSection: String , CaseIterable{
    case timerList = "TimerList"
}

fileprivate final class TimerListDiffableDataSource: UICollectionViewDiffableDataSource<TimerListSection, TimerListViewModel>{
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }

    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
}

extension TimerSelectViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel =  dataSource.itemIdentifier(for: indexPath){
            listener?.collectionViewDidSelectItemAt(timerId: viewModel.timerId)
        }
    }
    
}


extension TimerSelectViewController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }

    
    // To only select needed view as preview instead of whole cell
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        return previewParameters
    }
}



extension TimerSelectViewController: UICollectionViewDropDelegate{
        
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


