//
//  RecordTimerListDetailViewController.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs
import UIKit

protocol RecordTimerListDetailPresentableListener: AnyObject {
    func timerListDidTap(routineId: UUID)
    func didMove()
}

final class RecordTimerListDetailViewController: UIViewController, RecordTimerListDetailPresentable, RecordTimerListDetailViewControllable {

    weak var listener: RecordTimerListDetailPresentableListener?
    
    private var dataSource : UICollectionViewDiffableDataSource<Section, RecordTimerListViewModel>!
        
    
    fileprivate enum Section: String , CaseIterable{
        case timerList
    }

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset : CGFloat = 16.0
        //layout.sectionInset = .init(top: 0.0, left: inset, bottom: inset, right: inset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: RecordTimerListCell.self)
                
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
        title = "Your Acheive"
        
        view.addSubview(collectionView)
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
    
    private func setDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecordTimerListCell.self)
            cell.bindView(itemIdentifier)
            return cell
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
        let height = (UIDevice.frame().width - 32.0) * 0.6 * 0.3
                 
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        section.interGroupSpacing = 16.0
    
          
        return section
    }
    
 
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil{
            listener?.didMove()
        }
    }
}


extension RecordTimerListDetailViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel =  dataSource.itemIdentifier(for: indexPath){
            listener?.timerListDidTap(routineId: viewModel.timerId)
        }
    }
    
}
