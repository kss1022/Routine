//
//  RecordTimerListDetailViewController.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs
import UIKit

protocol RecordTimerListDetailPresentableListener: AnyObject {
    func timerListDidTap(timerId: UUID)
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
    
    private let emptyView: UIView = {
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
        title = "your_focus".localized(tableName: "Record")
        
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        let width = UIDevice.frame().width / 2 - (16.0)
        let height = width * 0.8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        
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
            listener?.timerListDidTap(timerId: viewModel.timerId)
        }
    }
    
}
